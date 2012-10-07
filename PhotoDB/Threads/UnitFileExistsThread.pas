unit UnitFileExistsThread;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Forms,

  Dmitry.Utils.Files,

  Dolphin_DB,
  UnitDBCommon,
  uLogger,
  uDBThread;

type
  TFileExistsThread = class(TDBThread)
  private
   FFileName : string;
   FIsDirectory : boolean;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(FileName : string; IsDirectory : boolean);
    destructor Destroy; override;
  end;

  function CheckFileExistsWithMessageEx(FileName : string; IsDirectory : boolean) : boolean;
  function CheckFileExistsWithSleep(FileName : string; IsDirectory : boolean) : boolean;

  var
    CheckFileExistsWithMessageWork : boolean = false;
    CheckFileExistsWithMessageResult : boolean = false;

  const
    FileCheckTimeOut = 5000;

implementation

  function CheckFileExistsWithSleep(FileName : string; IsDirectory : boolean) : boolean;
  var
    CheckThread : THandle;
  begin

   EventLog(':CheckFileExistsWithMessageEx()...');
   while CheckFileExistsWithMessageWork do
    Sleep(1);

   CheckFileExistsWithMessageWork := True;
   CheckFileExistsWithMessageResult := False;
   CheckThread := TFileExistsThread.Create(FileName, IsDirectory).Handle;
   WaitForSingleObject(CheckThread, FileCheckTimeOut);

   Result := CheckFileExistsWithMessageResult;
  end;

  function CheckFileExistsWithMessageEx(FileName : string; IsDirectory : boolean) : boolean;
  var
    CheckThread : THandle;
  begin

    EventLog(':CheckFileExistsWithMessageEx()...');
    while CheckFileExistsWithMessageWork do
      Application.ProcessMessages;

    CheckFileExistsWithMessageWork := True;
    CheckFileExistsWithMessageResult := False;

    CheckThread := TFileExistsThread.Create(FileName, IsDirectory).Handle;
    WaitForSingleObject(CheckThread, FileCheckTimeOut);

    Result := CheckFileExistsWithMessageResult;
  end;

{ TFileExistsThread }

constructor TFileExistsThread.Create(FileName: string; IsDirectory : boolean);
begin
  inherited Create(nil, False);
  FFileName := FileName;
  FIsDirectory := IsDirectory;
end;

destructor TFileExistsThread.Destroy;
begin
  CheckFileExistsWithMessageWork:=false;
  inherited;
end;

procedure TFileExistsThread.Execute;
var
  oldMode : Cardinal;
begin
  FreeOnTerminate := True;
  oldMode:= SetErrorMode(SEM_FAILCRITICALERRORS);
  if fIsDirectory then
    CheckFileExistsWithMessageResult:=DirectoryExists(fFileName)
  else
    CheckFileExistsWithMessageResult:=FileExistsEx(fFileName);
  SetErrorMode(oldMode);
end;

end.

