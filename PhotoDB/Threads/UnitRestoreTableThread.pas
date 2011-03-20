unit UnitRestoreTableThread;

interface

uses
  Windows, Classes, UnitDBKernel, Forms, UnitGroupsWork, SysUtils,
  CommonDBSupport, UnitDBDeclare, uFileUtils, uConstants,
  uDBThread;

type
  ThreadRestoreTable = class(TDBThread)
  private
    { Private declarations }
    FOptions: TRestoreThreadOptions;
    StrParam: string;
    procedure DoExit;
  protected
    procedure Execute; override;
    function GetThreadID : string; override;
    procedure TextOut;
  public
    constructor Create(Options: TRestoreThreadOptions);
  end;

implementation

uses CMDUnit;

{ ThreadRestoreTable }

procedure ThreadRestoreTable.DoExit;
begin
  CMDForm.OnEnd(Self);
end;

constructor ThreadRestoreTable.Create(Options: TRestoreThreadOptions);
begin
  inherited Create(False);
  FOptions := Options;
end;

procedure ThreadRestoreTable.Execute;
var
  S: string;
  FileName: string;
begin
  FreeOnTerminate := True;

  S := ExtractFilePath(Application.ExeName);
  try
    if not CreateDirA(GetAppDataDirectory + BackUpFolder) then
      RaiseLastOSError;

    CopyFile(PChar(Dbname), PChar(GetAppDataDirectory + BackUpFolder + GetFileNameWithoutExt(Dbname) + '[BU].photodb'),
      False);
    if not FileExistsSafe(GetAppDataDirectory + BackUpFolder + GetFileNameWithoutExt(Dbname) + '[BU].photodb') then
      RaiseLastOSError;
  except
    on E: Exception do
    begin
      StrParam := Format(L('Error! Unable to create backup for currect collection: %s!'), [E.message]);
      Synchronize(TextOut);
      Sleep(10000);
      Synchronize(DoExit);
      Exit;
    end;
  end;

  try
    if not DeleteFile(Dbname) then
      RaiseLastOSError;
    if not CreateDirA(GetAppDataDirectory + DBRestoreFolder) then
      RaiseLastOSError;

    S := ExtractFilePath(Application.ExeName);
    FileName := GetAppDataDirectory + DBRestoreFolder + ExtractFileName(FOptions.FileName);
    if not CopyFile(PChar(FOptions.FileName), PChar(FileName), False) then
      RaiseLastOSError;
  except
    on e: Exception do
    begin
      StrParam := Format(L('Unable to restore collection (%s)! The current collection may be corrupted or missing! After starting try to restore the file "%s" which is a backup of your collection. Error: %s'), [FOptions.FileName,
        GetAppDataDirectory + BackUpFolder + GetFileNameWithoutExt(Dbname) + '[BU].db', e.Message]);
      Synchronize(TextOut);
      Sleep(10000);
      Synchronize(DoExit);
      Exit;
    end;
  end;
  DBKernel.AddDB(GetFileNameWithoutExt(FOptions.FileName), FOptions.FileName, Application.ExeName + ',0', False);
  DBKernel.SetDataBase(FileName);

  Sleep(2000);
  Synchronize(DoExit);
end;

function ThreadRestoreTable.GetThreadID: string;
begin
  Result := 'CMD';
end;

procedure ThreadRestoreTable.TextOut;
begin
  FOptions.WriteLineProc(Self, StrParam, LINE_INFO_OK);
end;

end.
