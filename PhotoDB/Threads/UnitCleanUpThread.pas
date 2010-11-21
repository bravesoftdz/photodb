unit UnitCleanUpThread;

interface

uses
  UnitDBKernel, windows, Messages, CommCtrl, Dialogs, Classes, DBGrids, DB,
  SysUtils,ComCtrls, Graphics, jpeg, UnitINI, DateUtils, uFileUtils,
  CommonDBSupport, win32crc, UnitCDMappingSupport, uLogger, uConstants,
  CCR.Exif, uMemory;

type
  CleanUpThread = class(TThread)
  private
   FTable: TDataSet;
   fQuery : TDataSet;
   fReg : TBDRegistry;
   FText : string;
   FPosition : Integer;
   FMaxPosition : integer;
   lastID : integer;
  procedure UpdateProgress;
  procedure UpdateMaxProgress;
  procedure UpdateText;
  procedure InitializeForm;
  procedure FinalizeForm;
  procedure RegisterThread;
  procedure UnRegisterThread;
  function GetDBRecordCount : integer;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure SavePosition;
  end;

  var   Termitating : boolean = false;
        Active : boolean = false;
      Share_Position, Share_MaxPosition : Integer;

implementation

uses Searching, dolphin_db, UnitDBCleaning, Language, FormManegerUnit;

{ CleanUpThread }

procedure CleanUpThread.Execute;
var
  i, int, position : integer;
  s, str_position, _sqlexectext, FromDB : string;
  ExifData: TExifData;
  crc : cardinal;
  folder : string;
  SetQuery : TDataSet;
  DateToAdd, aTime : TDateTime;
  IsDate, IsTime : boolean;
begin
 FreeOnTerminate:=True;
 if FolderView then exit;
 Synchronize(RegisterThread);

 If Active then exit;
 Priority:=tpIdle;
 Termitating:=false;
 Active:=true;

 FTable:=GetQuery;
 fQuery:=GetQuery;

 fReg:=TBDRegistry.Create(REGISTRY_CURRENT_USER);
 fReg.OpenKey(RegRoot,true);
 str_position:=fReg.ReadString('CleanPosition');
 if fReg.ValueExists('CleanLastID') then
 lastID:=fReg.ReadInteger('CleanLastID') else lastID:=0;
 position:=StrToIntDef(str_position,1);
 if Position<1 then Position:=1;
 FMaxPosition:=GetDBRecordCount;
 if Position>FMaxPosition then
 begin
  DBKernel.WriteBool('Options','AllowFastCleaning',False);
  Position:=1;
 end;
 fReg.free;

 Share_Position:=0;

 Share_MaxPosition:=FMaxPosition;
 Synchronize(UpdateMaxProgress);
 Synchronize(InitializeForm);
 FPosition:=Position;
 while not FMaxPosition<FPosition do
 begin
  if not DBKernel.ReadBool('Options','AllowFastCleaning',False) then
  Sleep(2500);

  if Termitating then break;
  _sqlexectext:='Select * from $DB$ where ID=(Select MIN(ID) from $DB$ where ID>'+IntToStr(lastID)+')';

  SetSQL(FTable,_sqlexectext);
  FTable.Open;

  FText:=format(TEXT_MES_CLEANING_ITEM,[Trim(FTable.FieldByName('Name').AsString)]);
  lastID:=FTable.FieldByName('ID').AsInteger;
  Synchronize(UpdateText);
  inc(Fposition);
  //Fposition:=FTable.RecNo;

  Share_Position:=FPosition;
  Synchronize(UpdateProgress);
  if fPosition mod 10 = 0 then SavePosition;
  if FTable=nil then break;
  if Termitating then break;

  try

    if not StaticPath(FTable.FieldByName('FFileName').AsString) then
    begin
     Continue;
    end;

    folder:=GetDirectory(FTable.FieldByName('FFileName').AsString);

    folder:=AnsiLowerCase(folder);
    UnFormatDir(folder);
    CalcStringCRC32(AnsiLowerCase(folder),crc);
    int:=Integer(crc);
    if int<>FTable.FieldByName('FolderCRC').AsInteger then
    begin
     SetQuery:=GetQuery;
     SetSQL(SetQuery,'Update $DB$ Set FolderCRC=:FolderCRC Where ID='+IntToStr(FTable.FieldByName('ID').AsInteger));
     SetIntParam(SetQuery,0,crc);
     ExecSQL(SetQuery);

     FreeDS(SetQuery);
    end;


   if DBKernel.ReadBool('Options','DeleteNotValidRecords',True) then
   begin
    if not FileExists( FTable.FieldByName('FFileName').AsString) then
    begin
     if DBKernel.ReadBool('Options','DeleteNotValidRecords',True) then
     begin
      if (FTable.FieldByName('Rating').AsInteger=0) and (FTable.FieldByName('Access').AsInteger<>db_access_private) and (FTable.FieldByName('Comment').AsString='') and (FTable.FieldByName('KeyWords').AsString='') and (FTable.FieldByName('Groups').AsString='') and (FTable.FieldByName('IsDate').AsBoolean=False)  then
      begin
              SetQuery := GetQuery;
              try
                SetSQL(SetQuery, 'Delete from $DB$ Where ID=' + IntToStr(FTable.FieldByName('ID').AsInteger));
                ExecSQL(SetQuery);
              finally
                FreeDS(SetQuery);
              end;
       Continue;
      end;
     end;
     fQuery.Active:=false;

     SetSQL(fQuery,'UPDATE $DB$ SET Attr='+inttostr(db_attr_not_exists)+' WHERE ID='+inttostr(FTable.FieldByName('ID').AsInteger));
     ExecSQL(fQuery);
    end else
    begin
     if (FTable.FieldByName('Attr').AsInteger=db_attr_not_exists) then
     SetAttr(FTable.FieldByName('ID').AsInteger,db_attr_norm);
    end;
   end
  except
   on e : Exception do EventLog(':CleanUpThread::Execute() throw exception: '+e.Message);
  end;

  if Termitating then break;

  try
   s:=FTable.FieldByName('FFileName').AsString;
   If s<>AnsiLowerCase(s) then
   begin
     SetQuery:=GetQuery;
     SetSQL(SetQuery,'UPDATE $DB$ Set FFileName=:FFileName Where ID='+IntToStr(FTable.FieldByName('ID').AsInteger));
     SetStrParam(SetQuery,0,AnsiLowerCase(s));
     ExecSQL(SetQuery);
     FreeDS(SetQuery);
    end;
  except
   on e : Exception do EventLog(':CleanUpThread::Execute() throw exception: '+e.Message);
  end;

  if Termitating then break;

  if DBKernel.ReadBool('Options','FixDateAndTime',True) then
  begin
   ExifData := TExifData.Create;
   try
    ExifData.LoadFromJPEG(FTable.FieldByName('FFileName').AsString);
    if YearOf(ExifData.DateTime)>2000 then
    if (FTable.FieldByName('DateToAdd').AsDateTime<>ExifData.DateTime) or (FTable.FieldByName('aTime').AsDateTime<>TimeOf(ExifData.DateTime)) then
    begin

       DateToAdd:=ExifData.DateTime;
       aTime:=TimeOf(ExifData.DateTime);
       IsDate:=True;
       IsTime:=True;
       _sqlexectext:='';
       _sqlexectext:=_sqlexectext+'DateToAdd=:DateToAdd,';
       _sqlexectext:=_sqlexectext+'aTime=:aTime,';
       _sqlexectext:=_sqlexectext+'IsDate=:IsDate,';
       _sqlexectext:=_sqlexectext+'IsTime=:IsTime';
       SetQuery:=GetQuery;
       SetSQL(SetQuery,'Update $DB$ Set '+_sqlexectext+' where ID = '+IntToStr(FTable.FieldByName('ID').AsInteger));
       SetDateParam(SetQuery,'DateToAdd',DateToAdd);
       SetDateParam(SetQuery,'aTime',aTime);
       SetBoolParam(SetQuery,2,IsDate);
       SetBoolParam(SetQuery,3,IsTime);
       ExecSQL(SetQuery);
       FreeDS(SetQuery);
     end;
   except
   on e : Exception do EventLog(':CleanUpThread::Execute() throw exception: '+e.Message);
   end;
    F(ExifData);
  end;

  if Termitating then break;
  try
  if DBKernel.ReadBool('Options','VerifyDublicates',False) then
  begin
   fQuery.Active:=false;

   if (GetDBType(dbname)=DB_TYPE_MDB) then
   begin
    FromDB:='(Select * from $DB$ where StrThCrc=:StrThCrc)';
    SetSQL(fQuery,'SELECT * FROM '+FromDB+' WHERE StrTh = :StrTh ORDER BY ID');
    SetIntParam(fQuery,0,StringCRC(FTable.FieldByName('StrTh').AsString));
    SetStrParam(fQuery,1,FTable.FieldByName('StrTh').AsString);
   end else
   begin
    SetSQL(fQuery,'SELECT * FROM $DB$ WHERE StrTh = :StrTh ORDER BY ID');
    SetStrParam(fQuery,0,FTable.FieldByName('StrTh').AsString);
   end;

{   SetSQL(fQuery,'SELECT * FROM '+GetDefDBName+' WHERE (StrTh = :str)');

   SetStrParam(fQuery,0,FTable.FieldByName('StrTh').AsString);
}
   if Termitating then Break;

   fQuery.Active:=true;
   fQuery.First;
   if fQuery.RecordCount>1 then
   begin
    for i:=1 to fQuery.RecordCount do
    begin
     if FTable=nil then break;
     if termitating then break;
     if fQuery.FieldByName('Attr').AsInteger<>db_attr_dublicate then
     SetAttr(fQuery.FieldByName('ID').AsInteger,db_attr_dublicate);
     fQuery.next;
    end;
   end;
   if (fQuery.RecordCount=1) and  fileexists(FTable.FieldByName('FFileName').AsString) and (FTable.FieldByName('Attr').AsInteger=db_attr_dublicate) then
   SetAttr(FTable.FieldByName('ID').AsInteger,db_attr_norm);
  end;
  except
   on e : Exception do EventLog(':CleanUpThread::Execute() throw exception: '+e.Message);
  end;

  //FTable.next;
 end;
 SavePosition;
 FreeDS(FTable);
 FreeDS(fQuery);
 Synchronize(FinalizeForm);
 Active:=false;
 try
  Synchronize(UnRegisterThread);
 except
   on e : Exception do EventLog(':CleanUpThread::Execute()/UnRegisterThread throw exception: '+e.Message);
 end;
end;

procedure CleanUpThread.FinalizeForm;
begin
 if DBCleaningForm<>nil then
 begin
  DBCleaningForm.Button3.Enabled:=True;
  DBCleaningForm.Button4.Enabled:=False;
  DBCleaningForm.DmProgress1.MaxValue:=1;
  DBCleaningForm.DmProgress1.Position:=0;
  DBCleaningForm.DmProgress1.Text:=TEXT_MES_CLEANING_STOPED;
 end;
end;

function CleanUpThread.GetDBRecordCount: integer;
var
  DS : TDataSet;
begin
 DS := GetQuery;
 SetSQL(DS,'SELECT count(*) as DB_Count from $DB$');
 try
  DS.Open;
  Result:=DS.FieldByName('DB_Count').AsInteger;
 except
  Result:=0;
 end;
 FreeDS(DS);
end;

procedure CleanUpThread.InitializeForm;
begin
 if DBCleaningForm<>nil then
 begin
  DBCleaningForm.Button3.Enabled:=False;
  DBCleaningForm.Button4.Enabled:=True;
  DBCleaningForm.DmProgress1.MaxValue:=Share_MaxPosition;
  DBCleaningForm.DmProgress1.Position:=Share_Position;
 end;
end;

procedure CleanUpThread.RegisterThread;
Var
  TermInfo : TTemtinatedAction;
begin
 TermInfo.TerminatedPointer:=@Termitating;
 TermInfo.TerminatedVerify:=@Active;
 TermInfo.Options:=TA_INFORM_AND_NT;
 TermInfo.Owner:=Self;
 FormManager.RegisterActionCanTerminating(TermInfo);
end;

procedure CleanUpThread.SavePosition;
begin
 fReg:=TBDRegistry.Create(REGISTRY_CURRENT_USER);
 fReg.OpenKey(RegRoot,true);
 fReg.WriteString('CleanPosition',IntToStr(fposition));
 fReg.WriteInteger('CleanLastID',LastID);
 fReg.free;
end;

procedure CleanUpThread.UnRegisterThread;
Var
  TermInfo : TTemtinatedAction;
begin
 TermInfo.TerminatedPointer:=@Termitating;
 TermInfo.TerminatedVerify:=@Active;
 TermInfo.Options:=TA_INFORM_AND_NT;
 TermInfo.Owner:=Self;
 FormManager.UnRegisterActionCanTerminating(TermInfo);
end;

procedure CleanUpThread.UpdateMaxProgress;
begin
 if DBCleaningForm<>nil then
 begin
  DBCleaningForm.DmProgress1.MinValue:=0;
  DBCleaningForm.DmProgress1.MaxValue:=FMaxPosition;
 end;
end;

procedure CleanUpThread.UpdateProgress;
begin
 if DBCleaningForm<>nil then
 begin
  DBCleaningForm.DmProgress1.Position:=Fposition;
 end;
end;

procedure CleanUpThread.UpdateText;
begin
 if DBCleaningForm<>nil then
 begin
  DBCleaningForm.DmProgress1.Text:=FText;
 end;
end;

end.
