unit UnitRestoreTableThread;

interface

uses
  Windows, Classes, DBTables, Dolphin_DB, Forms, UnitGroupsWork, SysUtils,
  Language, CommonDBSupport, UnitDBDeclare;

type
  ThreadRestoreTable = class(TThread)
  private
    fOptions : TRestoreThreadOptions;
    StrParam : String;
    procedure DoExit;
    { Private declarations }
  protected
   procedure TextOut;    
   procedure Execute; override;
  public
   constructor Create(CreateSuspennded: Boolean; Options : TRestoreThreadOptions);
  end;

implementation

uses CMDUnit;

{ ThreadRestoreTable }

procedure ThreadRestoreTable.DoExit;
begin
 CMDForm.OnEnd(Self);
end;

constructor ThreadRestoreTable.Create(CreateSuspennded: Boolean;
        Options : TRestoreThreadOptions);
begin
 inherited Create(true);
 fOptions:=Options;
 if not CreateSuspennded then Resume;
end;

procedure ThreadRestoreTable.Execute;
var
  s : String;
  FTable : TTable;
  CurrentFile, FileName : String;
begin
 FreeOnTerminate:=True;

 if GetDBType(dbname)=DB_TYPE_BDE then
 begin
  try
   s:=GetDirectory(Application.ExeName);
   FormatDir(S);
   CreateDirA(GetAppDataDirectory+BackUpFolder);
   FTable:=TTable.Create(nil);
   FTable.Active:=false;
   FTable.TableName:=dbname;
   FTable.Active:=true;
   CopyTable(FTable,GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].db');
   FTable.free;
   FTable:=TTable.Create(nil);
   FTable.Active:=false;
   FTable.TableName:=GroupsTableFileNameW(dbname);
   FTable.Active:=true;
   CopyTable(FTable,GroupsTableFileNameW(GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].db'));
   FTable.free;
  except
   StrParam:=TEXT_MES_ERROR_CREATE_BACK_UP_DEFAULT_DB;
   Synchronize(TextOut);
   Synchronize(DoExit);
   exit;
  end;
  CurrentFile:=dbname;
  try
   DeleteFile(CurrentFile);
  except
  end;
  CurrentFile:=ChangeFileExt(CurrentFile,'.mb');
  try
   DeleteFile(CurrentFile);
  except
  end;
  CurrentFile:=GroupsTableFileNameW(dbname);
  try
   DeleteFile(CurrentFile);
  except
  end;
  CurrentFile:=ChangeFileExt(CurrentFile,'.mb');
  try
   DeleteFile(CurrentFile);
  except
  end;

  try
   s:=GetDirectory(Application.ExeName);
   FormatDir(S);
   FTable:=TTable.Create(nil);
   FTable.Active:=false;
   FTable.TableName:=fOptions.FileName;
   FTable.Active:=true;
   CopyTable(FTable,dbname);
   FTable.free;
   FTable:=TTable.Create(nil);
   FTable.Active:=false;
   FTable.TableName:=GroupsTableFileNameW(fOptions.FileName);
   FTable.Active:=true;
   CopyTable(FTable,GroupsTableFileNameW(dbname));
   FTable.free;
  except
   StrParam:=Format(TEXT_MES_ERROR_COPYING_DB,[fOptions.FileName,GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].db']);
   Sleep(10000);
   Synchronize(TextOut);
   Synchronize(DoExit);
   exit;
  end;
 end;

 if GetDBType(dbname)=DB_TYPE_MDB then
 begin
   s:=GetDirectory(Application.ExeName);
   FormatDir(S);
   try
    CreateDirA(GetAppDataDirectory+BackUpFolder);
   except
    StrParam:=TEXT_MES_ERROR_CREATE_BACK_UP_DEFAULT_DB;
    Sleep(10000);
    Synchronize(TextOut);
    Synchronize(DoExit);
    exit;
   end;
   try
    CopyFile(PChar(dbname),PChar(GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].photodb'),false);
    if not FileExists(GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].photodb') then
    Exception.Create('');
   except
    StrParam:=TEXT_MES_ERROR_CREATE_BACK_UP_DEFAULT_DB;
    Sleep(10000);
    Synchronize(TextOut);
    Synchronize(DoExit);
    exit;
   end;
   try
    DeleteFile(dbname);
    CreateDirA(GetAppDataDirectory+DBRestoreFolder);
   except
    StrParam:=Format(TEXT_MES_ERROR_COPYING_DB,[fOptions.FileName,GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].db']);
    Sleep(10000);
    Synchronize(TextOut);
    Synchronize(DoExit);
    exit;
   end;
   try
    s:=GetDirectory(Application.ExeName);
    FormatDir(S);
    FileName:=GetAppDataDirectory+DBRestoreFolder+ExtractFileName(fOptions.FileName);
    CopyFile(PChar(fOptions.FileName),PChar(FileName),false);
   except
    StrParam:=Format(TEXT_MES_ERROR_COPYING_DB,[fOptions.FileName,GetAppDataDirectory+BackUpFolder+GetFileNameWithoutExt(dbname)+'[BU].db']);
    Sleep(10000);
    Synchronize(TextOut);
    Synchronize(DoExit);
    exit;
   end;
   DBKernel.AddDB(GetFileNameWithoutExt(fOptions.FileName),fOptions.FileName,Application.ExeName+',0',false);
   DBKernel.SetDataBase(FileName);
 end;

 
 Sleep(2000);
 Synchronize(DoExit);
end;

procedure ThreadRestoreTable.TextOut;
begin
 fOptions.WriteLineProc(self,StrParam,LINE_INFO_OK);
// CMDForm.RichEdit1.Lines[CMDForm.RichEdit1.Lines.Count-1]:=StrParam;
end;

end.
 