unit UnitUpdateDBThread;

interface

uses
  ReplaceForm, Windows, Dolphin_db, Classes, UnitUpdateDB, Forms,
  SysUtils, DB, GraphicCrypt, Dialogs, DateUtils, CommonDBSupport,
  Win32crc, Jpeg, UnitUpdateDBObject, uVistaFuncs, uLogger, uFileUtils,
  UnitDBDeclare, UnitDBCommon, uMemory, uDBPopupMenuInfo, uConstants,
  CCR.Exif, uShellIntegration, uDBTypes, uRuntime, uDBUtils, uSysUtils,
  uTranslate, ActiveX, uActivationUtils, uSettings, uMemoryEx,
  UnitDBKernel, uAssociations, uDBThread;

type
  TFileProcessProcedureOfObject = procedure(var FileName : string) of object;

type
  UpdateDBThread = class(TDBThread)
  private
    { Private declarations }
    FOnDone: TNotifyEvent;
    FTerminating: PBoolean;
    FPause: PBoolean;
    StringParam: string;
    IntResult, IntIDResult: Integer;
    FCurrentImageDBRecord: TImageDBRecordA;
    FSender: TUpdaterDB;
    ResArray: TImageDBRecordAArray;
    IDParam: Integer;
    NameParam: string;
    FInfo: TDBPopupMenuInfo;
    FUseFileNameScaning: Boolean;
    FileNumber: Integer;
    Time, Date: TDateTime;
    IsTime: Boolean;
    IsDate: Boolean;
    FNoLimit: Boolean;
  protected
    procedure Execute; override;
  public
    procedure LimitError;
    Procedure DoOnDone;
    procedure ExecuteReplaceDialog;
    procedure AddAutoAnswer;
    procedure SetImages;
    procedure DoEventReplace(ID : Integer; Name : String);
    procedure DoEventReplaceSynch;
    procedure UpdateCurrent;
    procedure CryptFileWithoutPass;
    function Res : TImageDBRecordA;
    procedure FileProcessed;
    constructor Create(Sender : TUpdaterDB;
      Info : TDBPopupMenuInfo; OnDone : TNotifyEvent;
      AutoAnswer : Integer; UseFileNameScaning : Boolean; Terminating,
      Pause: PBoolean; NoLimit : boolean = false);
    destructor Destroy; override;
  end;

type
  TValueObject = class(TObject)
  private
    FTIntValue: Integer;
    FSTStrValue: TStrings;
    FTBoolValue: Boolean;
    procedure SetTIntValue(const Value: Integer);
    procedure SetTStrValue(const Value: TStrings);
    procedure SetTBoolValue(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property TIntValue: Integer read FTIntValue write SetTIntValue;
    property TStrValue: TStrings read FSTStrValue write SetTStrValue;
    property TBoolValue: Boolean read FTBoolValue write SetTBoolValue;
  end;

type
  DirectorySizeThread = class(TDBThread)
  private
    { Private declarations }
    FDirectory, StrParam: string;
    FObject: TValueObject;
    FOnDone: TNotifyEvent;
    FTerminating: PBoolean;
    IntParam: Integer;
    FOnFileFounded: TFileFoundedEvent;
    FProcessFileEvent: TFileProcessProcedureOfObject;
  protected
    procedure Execute; override;
  public
    constructor Create(Directory: string; OnDone: TNotifyEvent; Terminating: PBoolean;
      OnFileFounded: TFileFoundedEvent; ProcessFileEvent: TFileProcessProcedureOfObject = nil);
    procedure DoOnDone;
    procedure DoFileProcessed;
    procedure DoOnFileFounded;
    function GetDirectory(DirectoryName: string; var Files : TStrings; Terminating : PBoolean):integer;
  end;

var
  ShowMessageAboutLimit: Boolean = True;
  CryptFileWithoutPassChecked: Boolean = False;
  FAutoAnswer: Integer = -1;

function SQL_AddFileToDB(Path: string; Crypted: Boolean; JPEG: TJpegImage; ImTh: string; KeyWords, Comment, Password: string;
  OrWidth, OrHeight: Integer; var Date, Time: TDateTime; var IsTime: Boolean; Rating: Integer = 0;
  Rotated: Integer = DB_IMAGE_ROTATE_0; Links: string = ''; Access: Integer = 0; Groups: string = ''): Boolean;

implementation

{ UpdateDBThread }

constructor UpdateDBThread.Create(Sender : TUpdaterDB;
  Info : TDBPopupMenuInfo; OnDone: TNotifyEvent;
  AutoAnswer : Integer; UseFileNameScaning : Boolean; Terminating,
  Pause: PBoolean; NoLimit : boolean = false);
begin
  //owner is dynamic
  inherited Create(nil, False);
  FInfo := Info; //Copy pointer to self

  FOnDone := OnDone;
  FTerminating := Terminating;
  FPause := Pause;
  FAutoAnswer := AutoAnswer;
  FSender := Sender;
  FNoLimit := NoLimit;
  FUseFileNameScaning := UseFileNameScaning;
end;

procedure UpdateDBThread.DoOnDone;
begin
  if Assigned(FOnDone) then
    FOnDone(Self);
end;

function SQL_AddFileToDB(Path: string; Crypted: Boolean; JPEG: TJpegImage; ImTh: string; KeyWords, Comment, Password: string;
  OrWidth, OrHeight: Integer; var Date, Time: TDateTime; var IsTime: Boolean; Rating: Integer = 0;
  Rotated: Integer = DB_IMAGE_ROTATE_0; Links: string = ''; Access: Integer = 0; Groups: string = ''): Boolean;
var
  ExifData : TExifData;
  Sql: string;
  FQuery: TDataSet;
  M: TMemoryStream;
begin
  Result := False;
  if Settings.ReadBool('Options', 'DontAddSmallImages', True) then
  begin
    if (Settings.ReadInteger('Options', 'DontAddSmallImagesWidth', 64) > OrWidth) or (Settings.ReadInteger('Options',
        'DontAddSmallImagesHeight', 64) > OrHeight) then
      // small images - no photos
      Exit;
  end;

  FQuery := GetQuery;
  try
    Sql := 'insert into $DB$';
    Sql := Sql +
      ' (Name,FFileName,FileSize,DateToAdd,Thum,StrTh,KeyWords,Owner,Collection,Access,Width,Height,Comment,Attr,Rotated,Rating,IsDate,Include,aTime,IsTime,Links,Groups,FolderCRC,StrThCRC)';
    Sql := Sql +
      ' values (:Name,:FFileName,:FileSize,:DateToAdd,:Thum,:StrTh,:KeyWords,:Owner,:Collection,:Access,:Width,:Height,:Comment,:Attr,:Rotated,:Rating,:IsDate,:Include,:aTime,:IsTime,:Links,:Groups,:FolderCRC,:StrThCRC) ';
    SetSQL(FQuery, Sql);
    SetStrParam(FQuery, 0, ExtractFileName(Path));
    SetStrParam(FQuery, 1, AnsiLowerCase(Path));
    SetIntParam(FQuery, 2, GetFileSize(Path));
    ExifData := TExifData.Create;
    try
      Date := 0;
      try
        ExifData.LoadFromGraphic(Path);
        if not ExifData.Empty then
        begin;
          Date := DateOf(ExifData.DateTimeOriginal);
          Time := TimeOf(ExifData.DateTimeOriginal);
          Rotated := ExifOrientationToRatation(Ord(ExifData.Orientation));
        end;
      except
        on e : Exception do
          Eventlog('Reading EXIF failed: ' + e.Message);
      end;
    finally
      F(ExifData);
    end;
    SetBoolParam(FQuery, 16, True);
    if Date = 0 then
    begin
      SetDateParam(FQuery, 'DateToAdd', Now);
      SetDateParam(FQuery, 'aTime', TimeOf(Now));
      SetBoolParam(FQuery, 19, False);
    end else
    begin
      SetDateParam(FQuery, 'DateToAdd', Date);
      SetDateParam(FQuery, 'aTime', TimeOf(Time));
      SetBoolParam(FQuery, 19, True);
    end;
    IsTime := GetBoolParam(FQuery, 19);
    if Crypted then
    begin
      M := TMemoryStream.Create;
      try
        CryptGraphicImage(Jpeg, Password, M);
        LoadParamFromStream(FQuery, 4, M, FtBlob);
      finally
        F(M);
      end;
    end else
      AssignParam(FQuery, 4, Jpeg);

    SetStrParam(FQuery, 5, ImTh);
    SetStrParam(FQuery, 6, KeyWords);
    SetStrParam(FQuery, 7, GetWindowsUserName);
    SetStrParam(FQuery, 8, 'PhotoAlbum');
    SetIntparam(FQuery, 9, Access);
    SetIntparam(FQuery, 10, OrWidth);
    SetIntparam(FQuery, 11, OrHeight);
    SetStrParam(FQuery, 12, Comment);
    SetIntParam(FQuery, 13, Db_attr_norm);
    SetIntParam(FQuery, 14, Rotated);
    SetIntParam(FQuery, 15, Rating);
    SetBoolParam(FQuery, 17, True);
    SetStrParam(FQuery, 20, Links);
    SetStrParam(FQuery, 21, Groups);

  {$R-}
    SetIntParam(FQuery, 22, GetPathCRC(Path, True));
    SetIntParam(FQuery, 23, StringCRC(ImTh));
    try
      ExecSQL(FQuery);
      if LastInseredID = 0 then
      begin
        SetSQL(FQuery, 'SELECT Max(ID) as MaxID FROM $DB$');
        try
          FQuery.Open;
          if FQuery.RecordCount > 0 then
            LastInseredID := FQuery.FieldByName('MaxID').AsInteger;
        except
          on e : Exception do
            Eventlog('Error getting count of DB items: ' + e.Message);
        end;
      end else
        Inc(LastInseredID);
    except
      on e : Exception do
        Eventlog('Error adding file to DB: ' + e.Message);
    end;
  finally
    FreeDS(FQuery);
  end;
  Result := True;
end;

procedure UpdateDBThread.Execute;
var
  DemoTable: TDataSet;
  FQuery: TDataSet;
  Counter: Integer;
  AutoAnswerSetted: Boolean;

  procedure AddFileToDB;
  begin
    if SQL_AddFileToDB(FInfo[FileNumber].FileName, Res.Crypt, Res.Jpeg, Res.ImTh, FInfo[FileNumber].KeyWords,
      FInfo[FileNumber].Comment, Res.Password, Res.OrWidth, Res.OrHeight, Date, Time, IsTime, FInfo[FileNumber].Rating,
      FInfo[FileNumber].Rotation, FInfo[FileNumber].Links, FInfo[FileNumber].Access, FInfo[FileNumber].Groups) then
      SynchronizeEx(SetImages)
    else
      F(ResArray[FileNumber].Jpeg);

  end;

  function GetRecordsCount: Integer;
  begin
    DemoTable := GetQuery(Dbname);
    try
      SetSQL(DemoTable, 'Select Count(*) as RecordCount from $DB$');
      DemoTable.Open;
      Result := Demotable.FieldByName('RecordCount').AsInteger;
    finally
      FreeDS(Demotable);
    end;
  end;

begin
  FreeOnTerminate := True;
  CoInitialize(nil);
  try

    FileNumber := 0;
    AutoAnswerSetted := False;

    {$IFDEF LICENSE}
    if TActivationManager.Instance.IsDemoMode then
    begin
      if GetRecordsCount > LimitDemoRecords then
      begin
        if ShowMessageAboutLimit then
        begin
          SynchronizeEx(Limiterror);
          ShowMessageAboutLimit := False;
        end;
        EventLog(':Limit of records! --> exit updating DB');
        Exit;
      end;
    end;
    {$ENDIF}

    ResArray := GetImageIDWEx(FInfo, FUseFileNameScaning);

    for Counter := 1 to FInfo.Count do
    begin
      if Res.Jpeg <> nil then
      begin
        if (Res.Count = 1) and ((Res.Attr[0] = Db_attr_not_exists) or (Res.FileNames[0] <> FInfo[FileNumber].FileName)) and
          (AnsiLowerCase(Res.FileNames[0]) = AnsiLowerCase(FInfo[FileNumber].FileName)) then
        begin
          SynchronizeEx(FileProcessed);
          UpdateMovedDBRecord(Res.Ids[0], FInfo[FileNumber].FileName);
          DoEventReplace(Res.Ids[0], FInfo[FileNumber].FileName);
        end;

        IntResult := Result_invalid;

        if (Res.Count > 1) then
        begin
          if not((FAutoAnswer = Result_skip_all) or (FAutoAnswer = Result_add_all)) then
          begin
            FCurrentImageDBRecord := Res;
            StringParam := Res.ImTh;
            SynchronizeEx(ExecuteReplaceDialog);
            case IntResult of
              Result_Add_All:
                begin
                  FAutoAnswer := Result_Add_all;
                  SynchronizeEx(AddAutoAnswer);
                end;
              Result_skip_all:
                begin
              FAutoAnswer := Result_skip_all;
                  AutoAnswerSetted := True;
                  SynchronizeEx(AddAutoAnswer);
                end;
              Result_replace:
                begin
                  UpdateMovedDBRecord(IntIDResult, FInfo[FileNumber].FileName);
                  DoEventReplace(IntIDResult, FInfo[FileNumber].FileName);
                end;
              Result_Add:
                begin
                  Date := FInfo[FileNumber].Date;
                  IsDate := FInfo[FileNumber].IsDate;
                  Time := FInfo[FileNumber].Time;
                  IsTime := FInfo[FileNumber].IsTime;
                  AddFileToDB;
                  FQuery := GetQuery;
                  try
                    SetSQL(FQuery, 'Update $DB$ Set Attr=:Attr Where StrTh=:s');
                    SetIntParam(FQuery, 0, Db_attr_dublicate);
                    SetStrParam(FQuery, 1, Res.ImTh);
                    try
                      ExecSQL(FQuery);
                    except
                      on E: Exception do
                        EventLog(':UpdateDBThread::Execute()/Result_Add/ExecSQL throw exception: ' + E.message);
                    end;
                  finally
                    FreeDS(FQuery);
                  end;
                end;
              Result_Delete_File:
                begin
                  DeleteFile(FInfo[FileNumber].FileName);
                end;
              Result_Replace_And_Del_Dublicates:
                begin
                  UpdateMovedDBRecord(IntIDResult, FInfo[FileNumber].FileName);
                  DoEventReplace(IntIDResult, FInfo[FileNumber].FileName);
                  FQuery := GetQuery;
                  try
                    SetSQL(FQuery, 'DELETE FROM $DB$ WHERE StrTh=:s and ID<>:ID');
                    SetStrParam(FQuery, 0, Res.ImTh);
                    SetIntParam(FQuery, 1, IntIDResult);
                    try
                      ExecSQL(FQuery);
                    except
                      on E: Exception do
                        EventLog(
                          ':UpdateDBThread::Execute()/Result_Replace_And_Del_Dublicates/ExecSQL throw exception: ' +
                            E.message);
                    end;
                  finally
                    FreeDS(FQuery);
                  end;
                end;
            end;
          end else
          begin
            if FAutoAnswer = Result_replace_All then
            begin
              UpdateMovedDBRecord(IntIDResult, FInfo[FileNumber].FileName);
              DoEventReplace(IntIDResult, FInfo[FileNumber].FileName);
            end;
            if FAutoAnswer = Result_add_All then
            begin
              AddFileToDB;
              FQuery := GetQuery;
              try
                SetSQL(FQuery, 'Update $DB$ Set Attr = :Attr Where StrTh = :s');
                SetIntParam(FQuery, 0, Db_attr_dublicate);
                SetStrParam(FQuery, 1, Res.ImTh);
                try
                  ExecSQL(FQuery);
                except
                  on E: Exception do
                    EventLog(':UpdateDBThread::Execute()/Result_add_All/ExecSQL throw exception: ' + E.message);
                end;
              finally
                FreeDS(FQuery);
              end;
            end;
          end;
        end;

        if (Res.Count = 1) and (AnsiLowerCase(Res.FileNames[0]) <> AnsiLowerCase(FInfo[FileNumber].FileName)) then
        begin

          if not((FAutoAnswer = Result_skip_all) or (FAutoAnswer = Result_replace_All) or (FAutoAnswer = Result_add_all)) then
          begin
            FCurrentImageDBRecord := Res;
            StringParam := Res.ImTh;
            SynchronizeEx(ExecuteReplaceDialog);

            case IntResult of
              Result_skip_all:
                begin
                  FAutoAnswer := Result_skip_all;
                  SynchronizeEx(AddAutoAnswer);
                  AutoAnswerSetted := True;
                end;
              Result_Delete_File:
                begin
                  DeleteFile(FInfo[FileNumber].FileName);
                end;
              Result_replace_all:
                begin
                  FAutoAnswer := Result_replace_All;
                  SynchronizeEx(AddAutoAnswer);
                  AutoAnswerSetted := True;
                  UpdateMovedDBRecord(Res.Ids[0], FInfo[FileNumber].FileName);
                  DoEventReplace(Res.Ids[0], FInfo[FileNumber].FileName);
                end;
              Result_replace:
                begin
                  UpdateMovedDBRecord(Res.Ids[0], FInfo[FileNumber].FileName);
                  if Res.UsedFileNameSearch then
                  begin
                    if Res.ChangedRotate[0] then
                      SetRotate(Res.Ids[0], DB_IMAGE_ROTATE_0);
                    SynchronizeEx(UpdateCurrent);
                  end;
                  DoEventReplace(Res.Ids[0], FInfo[FileNumber].FileName);
                end;
              Result_Add:
                begin
                  AddFileToDB;
                  FQuery := GetQuery;
                  try
                    SetSQL(FQuery, 'Update $DB$ Set Attr=:Attr Where StrTh=:s');
                    SetIntParam(FQuery, 0, Db_attr_dublicate);
                    SetStrParam(FQuery, 1, Res.ImTh);
                    try
                      ExecSQL(FQuery);
                    except
                      on E: Exception do
                        Eventlog('Update attribute failed: ' + E.message);
                    end;
                  finally
                    FreeDS(FQuery);
                  end;
                end;
              Result_Add_All:
                begin
                  FAutoAnswer := Result_Add_All;
                  SynchronizeEx(AddAutoAnswer);
                  AutoAnswerSetted := True;
                  AddFileToDB;
                  FQuery := GetQuery;
                  try
                    SetSQL(FQuery, 'Update $DB$ Set Attr=:Attr Where StrTh=:s');
                    SetIntParam(FQuery, 0, Db_attr_dublicate);
                    SetStrParam(FQuery, 1, Res.ImTh);
                    try
                      ExecSQL(FQuery);
                    except
                      on E: Exception do
                        EventLog(':UpdateDBThread::Execute()/Result_Add_All2/ExecSQL throw exception: ' + E.message);
                    end;
                  finally
                    FreeDS(FQuery);
                  end;
                end;
            end;
          end;
          if not AutoAnswerSetted then
          begin
            if FAutoAnswer = Result_replace_All then
            begin
              UpdateMovedDBRecord(Res.Ids[0], FInfo[FileNumber].FileName);
              DoEventReplace(Res.Ids[0], FInfo[FileNumber].FileName);
            end;
            if FAutoAnswer = Result_skip_all then
            begin
            end;
            if FAutoAnswer = Result_Add_All then
            begin
              AddFileToDB;
              FQuery := GetQuery;
              try
                SetSQL(FQuery, 'Update $DB$ Set Attr=:Attr Where StrTh=:s');
                SetIntParam(FQuery, 0, Db_attr_dublicate);
                SetStrParam(FQuery, 1, Res.ImTh);
                try
                  ExecSQL(FQuery);
                except
                  on E: Exception do
                    EventLog(':UpdateDBThread::Execute()/Result_replace_All3/ExecSQL throw exception: ' + E.message);
                end;
              finally
                FreeDS(FQuery);
              end;
            end;
          end;
        end;
        AutoAnswerSetted := False;

        if Res.Count = 0 then
          AddFileToDB;
      end else
      begin
        SynchronizeEx(CryptFileWithoutPass);
      end;
      if Res.Jpeg <> nil then
        Res.Jpeg.Free;
      Inc(FileNumber);
    end;

  finally
    CoUninitialize;
    SynchronizeEx(DoOnDone);
  end;
end;

procedure UpdateDBThread.LimitError;
begin
  MessageBoxDB(GetActiveFormHandle, Format(TA('You are working with a non-activated program!$nl$You can only add %d items!', 'Activation'), [LimitDemoRecords]),
    TA('Requires activation of the program', 'Activation'), TD_BUTTON_OK, TD_ICON_INFORMATION);
end;

procedure UpdateDBThread.ExecuteReplaceDialog;
var
  DBReplaceForm: TDBReplaceForm;
begin
  Application.CreateForm(TDBReplaceForm, DBReplaceForm);
  try
    DBReplaceForm.ExecuteToAdd(FInfo[FileNumber].FileName, StringParam, IntResult, IntIDResult, FCurrentImageDBRecord);
  finally
    R(DBReplaceForm);
  end;
end;

procedure UpdateDBThread.AddAutoAnswer;
begin
  FSender.AutoAnswer := FAutoAnswer;
end;

destructor UpdateDBThread.Destroy;
begin
  F(FInfo);
  inherited;
end;

procedure UpdateDBThread.DoEventReplace(ID: Integer; Name: String);
begin
  IDParam := ID;
  NameParam := name;
  SynchronizeEx(DoEventReplaceSynch);
end;

procedure UpdateDBThread.DoEventReplaceSynch;
var
  EventInfo: TEventValues;
begin
  try
    EventInfo.NewName := NameParam;
    EventInfo.ID := IDParam;
    DBKernel.DoIDEvent(FSender.Form, IDParam, [EventID_Param_Name], EventInfo);
  except
    on E: Exception do
      EventLog(':UpdateDBThread::DoEventReplaceSynch() throw exception: ' + E.message);
  end;
end;

procedure UpdateDBThread.UpdateCurrent;
begin
  UpdateImageRecord(FSender.Form, FInfo[FileNumber].FileName, Res.Ids[0]);
end;

procedure UpdateDBThread.CryptFileWithoutPass;
var
  EventInfo: TEventValues;
begin
  EventInfo.name := FInfo[FileNumber].FileName;
  DBKernel.DoIDEvent(FSender.Form, -1, [EventID_Param_Add_Crypt_WithoutPass], EventInfo);
  CryptFileWithoutPassChecked := True;
end;

function UpdateDBThread.Res: TImageDBRecordA;
begin
  Result := ResArray[FileNumber];
end;

procedure UpdateDBThread.SetImages;
var
  EventInfo: TEventValues;
begin
  EventInfo.name := AnsiLowerCase(FInfo[FileNumber].FileName);
  EventInfo.ID := LastInseredID;
  EventInfo.Rotate := FInfo[FileNumber].Rotation;
  EventInfo.Rating := FInfo[FileNumber].Rating;
  EventInfo.Comment := FInfo[FileNumber].Comment;
  EventInfo.KeyWords := FInfo[FileNumber].KeyWords;
  EventInfo.Access := FInfo[FileNumber].Access;
  EventInfo.Attr := FInfo[FileNumber].Attr;
  EventInfo.Date := Date;
  EventInfo.IsDate := True;
  EventInfo.IsTime := IsTime;
  EventInfo.Time := TimeOf(Time);
  EventInfo.Image := nil;
  EventInfo.Groups := FInfo[FileNumber].Groups;
  EventInfo.JPEGImage := Res.Jpeg;
  EventInfo.Crypt := Res.Crypt;
  EventInfo.Include := True;
  DBKernel.DoIDEvent(FSender.Form, LastInseredID, [SetNewIDFileData], EventInfo);
  if Res.Jpeg <> nil then
    Res.Jpeg.Free;
  ResArray[FileNumber].Jpeg := nil;
end;

procedure UpdateDBThread.FileProcessed;
var
  EventInfo: TEventValues;
begin
  EventInfo.name := AnsiLowerCase(FInfo[FileNumber].FileName);
  EventInfo.ID := LastInseredID;
  EventInfo.Rotate := FInfo[FileNumber].Rotation;
  EventInfo.Rating := FInfo[FileNumber].Rating;
  EventInfo.Comment := FInfo[FileNumber].Comment;
  EventInfo.KeyWords := FInfo[FileNumber].KeyWords;
  EventInfo.Access := FInfo[FileNumber].Access;
  EventInfo.Attr := FInfo[FileNumber].Attr;
  EventInfo.Date := Date;
  EventInfo.IsDate := True;
  EventInfo.IsTime := IsTime;
  EventInfo.Time := TimeOf(Time);
  EventInfo.Image := nil;
  EventInfo.Groups := FInfo[FileNumber].Groups;
  EventInfo.JPEGImage := Res.Jpeg;
  EventInfo.Crypt := Res.Crypt;
  EventInfo.Include := True;
  DBKernel.DoIDEvent(FSender.Form, LastInseredID, [EventID_FileProcessed], EventInfo);
end;

{ DirectorySizeThread }

function DirectorySizeThread.GetDirectory(DirectoryName: string; var Files : TStrings; Terminating : PBoolean): Integer;
var
  Found: Integer;
  SearchRec: TSearchRec;
  FileName: string;
begin
  Result := 0;
  if Terminating^ then
    Exit;
  if not DirectoryExists(DirectoryName) then
    Exit;
  if DirectoryName[Length(DirectoryName)] <> '\' then
    DirectoryName := DirectoryName + '\';
  Found := FindFirst(DirectoryName + '*.*', FaAnyFile, SearchRec);
  while Found = 0 do
  begin
    if Terminating^ then
    begin
      FindClose(SearchRec);
      Exit;
    end;
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
    begin
      if FileExistsSafe(DirectoryName + SearchRec.Name) and IsGraphicFile(DirectoryName + SearchRec.Name) then
      begin
        Result := Result + SearchRec.Size;
        FileName := DirectoryName + SearchRec.Name;
        StrParam := FileName;
        SynchronizeEx(DoFileProcessed);
        FileName := StrParam;
        Files.Add(FileName);
        IntParam := SearchRec.Size;
        SynchronizeEx(DoOnFileFounded);
      end
      else if DirectoryExists(DirectoryName + SearchRec.Name) then
        Result := Result + GetDirectory(DirectoryName + SearchRec.Name, Files, Terminating);
    end;
    Found := SysUtils.FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

constructor DirectorySizeThread.Create(Directory: string; OnDone: TNotifyEvent; Terminating: PBoolean; OnFileFounded : TFileFoundedEvent;
  ProcessFileEvent : TFileProcessProcedureOfObject = nil);
begin
  inherited Create(nil, False);
  FDirectory := Directory;
  FTerminating := Terminating;
  FOnFileFounded := OnFileFounded;
  FProcessFileEvent := ProcessFileEvent;
  FOnDone := OnDone;
end;

procedure DirectorySizeThread.DoOnDone;
begin
  if Assigned(FOnDone) then
    FOnDone(FObject);
end;

procedure DirectorySizeThread.Execute;
var
  Size: Integer;
  Files: TStrings;
begin
  FreeOnTerminate := True;
  Files := TStringList.Create;
  try
    Size := GetDirectory(FDirectory, Files, FTerminating);
    if not FTerminating^ then
    begin
      FObject := TValueObject.Create;
      try
        FObject.TIntValue := Size;
        FObject.TStrValue := Files;
        SynchronizeEx(DoOnDone);
      finally
        F(FObject);
      end;
    end;
  finally
    F(Files);
  end;
end;

procedure DirectorySizeThread.DoFileProcessed;
begin
  if Assigned(FProcessFileEvent) then
    FProcessFileEvent(StrParam);
end;

procedure DirectorySizeThread.DoOnFileFounded;
begin
  if Assigned(FOnFileFounded) then
    FOnFileFounded(nil, StrParam, IntParam);
end;

{ TValueObject }

constructor TValueObject.Create;
begin
  FSTStrValue := TStringList.Create;
end;

destructor TValueObject.Destroy;
begin
  FSTStrValue.Free;
end;

procedure TValueObject.SetTBoolValue(const Value: Boolean);
begin
  FTBoolValue := Value;
end;

procedure TValueObject.SetTIntValue(const Value: Integer);
begin
  FTIntValue := Value;
end;

procedure TValueObject.SetTStrValue(const Value: TStrings);
begin
  FSTStrValue.Assign(Value);
end;

end.
