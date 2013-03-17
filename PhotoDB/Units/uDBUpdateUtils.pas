unit uDBUpdateUtils;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  Vcl.Forms,
  Vcl.Imaging.jpeg,

  CCR.Exif,

  Dmitry.CRC32,
  Dmitry.Utils.System,
  Dmitry.Utils.Files,

  CommonDBSupport,
  GraphicCrypt,
  UnitDBDeclare,
  UnitGroupsWork,
  CmpUnit,
  UnitLinksSupport,
  UnitDBKernel,

  uConstants,
  uRuntime,
  uMemory,
  uGroupTypes,
  uDBTypes,
  uDBUtils,
  uShellIntegration,
  uLogger,
  uDBForm,
  uTranslate,
  uSettings,
  uExifUtils,
  uDBClasses;

type
  TDatabaseUpdateManager = class
  class var
    FGroupReplaceActions: TGroupsActionsW;
  protected
    class procedure CleanUp;
    class procedure NotifyFileAdded(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
  public
    class procedure AddFile(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
    class procedure AddFileAsDuplicate(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
    class function MergeWithExistedInfo(ID: Integer; Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA): Boolean;
    class function AddNewImageRecord(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA): Boolean;
    class procedure ProcessGroups(Info: TDBPopupMenuInfoRecord; ExifGroups: string);
  end;

implementation

uses
  UnitGroupsReplace;

class procedure TDatabaseUpdateManager.AddFile(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
var
  Groups, ExifGroups: string;
begin
  try
    Info.FileName := AnsiLowerCase(Info.FileName);

    //save original groups and extract Exif groups
    Groups := Info.Groups;
    ExifGroups := '';
    Info.Groups := '';
    UpdateImageRecordFromExif(Info, True, True);

    ExifGroups := Info.Groups;
    Info.Groups := Groups;

    ProcessGroups(Info, ExifGroups);

    if AddNewImageRecord(Info, Res) then
    begin
      Res.Jpeg.DIBNeeded;
      NotifyFileAdded(Info, Res);
    end else
      F(Res.Jpeg);

  except
    on e: Exception do
      EventLog(e);
  end;
end;

class procedure TDatabaseUpdateManager.AddFileAsDuplicate(
  Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
begin
  //TODO:
end;

class function TDatabaseUpdateManager.AddNewImageRecord(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA): Boolean;
var
  IC: TInsertCommand;
  M: TMemoryStream;
  ExifData: TExifData;

  procedure HandleError(Error: string);
  begin
    MessageBoxDB(0, Error, TA('Error'), TD_BUTTON_OK, TD_ICON_ERROR);
    EventLog(Error);
  end;

begin
  Result := False;
  M := nil;

  if Settings.ReadBool('Options', 'DontAddSmallImages', True) then
  begin
    if (Settings.ReadInteger('Options', 'DontAddSmallImagesWidth', 64) > Res.ImageWidth) or
       (Settings.ReadInteger('Options', 'DontAddSmallImagesHeight', 64) > Res.ImageHeight) then
      // small images are no photos
      Exit;
  end;

  //if date isn't defined yet
  if not ((YearOf(Date) > 1900) and Info.IsTime and Info.IsDate) then
  begin
    ExifData := TExifData.Create;
    try
      Info.Date := 0;
      Info.Time := 0;
      Info.IsDate := False;
      Info.IsTime := False;
      try
        ExifData.LoadFromGraphic(Info.FileName);
        if not ExifData.Empty and (ExifData.DateTimeOriginal > 0) then
        begin;
          Info.Date := DateOf(ExifData.DateTimeOriginal);
          Info.Time := TimeOf(ExifData.DateTimeOriginal);
          Info.IsDate := True;
          Info.IsTime := True;

          //if rotation no==isn't set
          if (Info.Rotation and DB_IMAGE_ROTATE_MASK = DB_IMAGE_ROTATE_0) and (Info.Rotation <> DB_IMAGE_ROTATE_FIXED) then
            Info.Rotation := ExifOrientationToRatation(Ord(ExifData.Orientation));
        end;
      except
        on e: Exception do
          Eventlog('Reading EXIF failed: ' + e.Message);
      end;
    finally
      F(ExifData);
    end;
  end;
  Info.Rotation := Info.Rotation and DB_IMAGE_ROTATE_MASK;

  IC := TInsertCommand.Create(ImageTable);
  try
    IC.AddParameter(TStringParameter.Create('Name', ExtractFileName(Info.FileName)));
    IC.AddParameter(TStringParameter.Create('FFileName', AnsiLowerCase(Info.FileName)));
    IC.AddParameter(TIntegerParameter.Create('FileSize', GetFileSize(Info.FileName)));
    if YearOf(Date) < 1900 then
    begin
      IC.AddParameter(TDateTimeParameter.Create('DateToAdd', Now));
      IC.AddParameter(TBooleanParameter.Create('IsDate', True));
      IC.AddParameter(TDateTimeParameter.Create('aTime', TimeOf(Now)));
      IC.AddParameter(TBooleanParameter.Create('IsTime', True));
    end else
    begin
      IC.AddParameter(TDateTimeParameter.Create('DateToAdd', Info.Date));
      IC.AddParameter(TBooleanParameter.Create('IsDate', True));
      IC.AddParameter(TDateTimeParameter.Create('aTime', TimeOf(Info.Time)));
      IC.AddParameter(TBooleanParameter.Create('IsTime', True));
    end;

    IC.AddParameter(TStringParameter.Create('StrTh', Res.ImTh));
    IC.AddParameter(TStringParameter.Create('KeyWords', Info.KeyWords));
    IC.AddParameter(TStringParameter.Create('Owner', GetWindowsUserName));
    IC.AddParameter(TStringParameter.Create('Collection', 'DB'));
    IC.AddParameter(TIntegerParameter.Create('Access', Info.Access));
    IC.AddParameter(TIntegerParameter.Create('Width', Res.ImageWidth));
    IC.AddParameter(TIntegerParameter.Create('Height', Res.ImageHeight));
    IC.AddParameter(TStringParameter.Create('Comment', Info.Comment));
    IC.AddParameter(TIntegerParameter.Create('Attr', Db_attr_norm));
    IC.AddParameter(TIntegerParameter.Create('Rotated', Info.Rotation));
    IC.AddParameter(TIntegerParameter.Create('Rating', Info.Rating));
    IC.AddParameter(TBooleanParameter.Create('Include', Info.Include));
    IC.AddParameter(TStringParameter.Create('Links', Info.Links));
    IC.AddParameter(TStringParameter.Create('Groups', Info.Groups));

    IC.AddParameter(TIntegerParameter.Create('FolderCRC', GetPathCRC(Info.FileName, True)));
    IC.AddParameter(TIntegerParameter.Create('StrThCRC', Integer(StringCRC(Res.ImTh))));

    if Res.IsEncrypted then
    begin
      M := TMemoryStream.Create;
      EncryptGraphicImage(Res.Jpeg, Res.Password, M);
      IC.AddParameter(TStreamParameter.Create('Thum', M));
    end else
      IC.AddParameter(TPersistentParameter.Create('Thum', Res.Jpeg));

    LastInseredID := IC.Execute;
  finally
    F(IC);
    F(M);
  end;
  Result := True;
end;

class procedure TDatabaseUpdateManager.ProcessGroups(
  Info: TDBPopupMenuInfoRecord; ExifGroups: string);
var
  RegisteredGroups: TGroups;
begin
  if ExifGroups <> '' then
  begin

    RegisteredGroups := GetRegisterGroupList(False);
    try

      TThread.Synchronize(nil,
        procedure
        var
          Groups, GExifGroups: TGroups;
          InRegGroups: TGroups;
        begin
          Groups := EncodeGroups(Info.Groups);
          GExifGroups := EncodeGroups(ExifGroups);
          //in groups are empty because in exif no additional groups information
          SetLength(InRegGroups, 0);

          FilterGroups(GExifGroups, RegisteredGroups, InRegGroups, FGroupReplaceActions);

          AddGroupsToGroups(Groups, GExifGroups);
          Info.Groups := CodeGroups(Groups);
        end
      );

    finally
      FreeGroups(RegisteredGroups);
    end;

  end;
end;

class procedure TDatabaseUpdateManager.CleanUp;
begin
  FreeGroup(FGroupReplaceActions.ActionForUnKnown.OutGroup);
  FreeGroup(FGroupReplaceActions.ActionForUnKnown.InGroup);
  FreeGroup(FGroupReplaceActions.ActionForKnown.OutGroup);
  FreeGroup(FGroupReplaceActions.ActionForKnown.InGroup);
end;

class function TDatabaseUpdateManager.MergeWithExistedInfo(ID: Integer;
  Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA): Boolean;
var
  DBInfo: TDBPopupMenuInfoRecord;
  UC: TUpdateCommand;
  Comment, Groups, KeyWords, Links: string;
begin
  Result := False;

  DBInfo := GetMenuInfoRecordByID(ID);
  if DBInfo = nil then
    Exit;

  UC := TUpdateCommand.Create(ImageTable);
  try
    if Info.Comment <> '' then
    begin
      Comment := Info.Comment;
      if DBInfo.Comment <> '' then
        Comment := Comment + sLineBreak + DBInfo.Comment;

      UC.AddParameter(TStringParameter.Create('Comment', Comment));
    end;

    if (Info.Rotation <> DB_IMAGE_ROTATE_0) and (Info.Rotation <> DB_IMAGE_ROTATE_UNKNOWN) then
      UC.AddParameter(TIntegerParameter.Create('Rotated', Info.Rotation));

    if Info.Rating <> 0 then
      UC.AddParameter(TIntegerParameter.Create('Rating', Info.Rating));

    if Info.Groups <> '' then
    begin
      Groups := Info.Groups;
      AddGroupsToGroups(Groups, DBInfo.Groups);
      UC.AddParameter(TStringParameter.Create('Groups', Groups));
    end;

    if Info.KeyWords <> '' then
    begin
      KeyWords := Info.KeyWords;
      AddWordsA(DBInfo.KeyWords, KeyWords);
      UC.AddParameter(TStringParameter.Create('KeyWords', KeyWords));
    end;

    if Info.Links <> '' then
    begin
      Links := Info.Links;
      ReplaceLinks('', DBInfo.Links, Links);
      UC.AddParameter(TStringParameter.Create('Links', Links));
    end;

    if not Info.Include then
      UC.AddParameter(TBooleanParameter.Create('Include', Info.Include));

    UC.AddParameter(TStringParameter.Create('Name', ExtractFileName(Info.FileName)));
    UC.AddParameter(TStringParameter.Create('FFileName', AnsiLowerCase(Info.FileName)));
    UC.AddParameter(TIntegerParameter.Create('FolderCRC', GetPathCRC(Info.FileName, True)));

    UC.AddWhereParameter(TIntegerParameter.Create('ID', ID));

    UC.Execute;
  finally
    F(UC);
  end;
end;

class procedure TDatabaseUpdateManager.NotifyFileAdded(Info: TDBPopupMenuInfoRecord; Res: TImageDBRecordA);
var
  EventInfo: TEventValues;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      EventInfo.ReadFromInfo(Info);

      EventInfo.JPEGImage := Res.Jpeg;
      EventInfo.IsEncrypted := Res.IsEncrypted;
      DBKernel.DoIDEvent(TDBForm(Application.MainForm), LastInseredID, [SetNewIDFileData], EventInfo);
    end
  );
end;


initialization

finalization
  TDatabaseUpdateManager.CleanUp;

end.
