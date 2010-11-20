unit uUninstall;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Classes, uInstallActions, uInstallTypes, uMemory, Registry, uConstants,
  SysUtils, uUninstallTypes;

const
  InstallPoints_UninstallShortcuts = 16 * 1024;

type
  TUninstallShortcut = class
  public
    PathType : string;
    RelativePath : string;
  end;

  TUninstallShortcutsAction = class(TInstallAction)
  private
    FUninstallShortcuts : TList;
    procedure FillList;
    procedure AddUninstallShortcut(APathType : string; ARelativePath : string);
  public
    constructor Create; override;
    destructor Destroy; override;
    function CalculateTotalPoints : Int64; override;
    procedure Execute(Callback : TActionCallback); override;
  end;

implementation

{ TUninstallShortcutsAction }

procedure TUninstallShortcutsAction.AddUninstallShortcut(APathType,
  ARelativePath: string);
var
  Shortcut : TUninstallShortcut;
begin
  Shortcut := TUninstallShortcut.Create;
  Shortcut.PathType := APathType;
  Shortcut.RelativePath := ARelativePath;
  FUninstallShortcuts.Add(Shortcut);
end;

function TUninstallShortcutsAction.CalculateTotalPoints: Int64;
begin
  Result := InstallPoints_UninstallShortcuts * FUninstallShortcuts.Count;
end;

constructor TUninstallShortcutsAction.Create;
begin
  inherited;
  FUninstallShortcuts := TList.Create;
  FillList;
end;

destructor TUninstallShortcutsAction.Destroy;
begin
  FreeList(FUninstallShortcuts);
  inherited;
end;

procedure TUninstallShortcutsAction.Execute(Callback: TActionCallback);
var
  Reg : TRegIniFile;
  I : Integer;
  Shortcut : TUninstallShortcut;
  Path : string;
  FCurrent, FTotal : Int64;
  Terminate : Boolean;
begin
  FTotal := CalculateTotalPoints;
  FCurrent := 0;
  Terminate := False;
  Reg := TRegIniFile.Create(SHELL_FOLDERS_ROOT);
  try
    for I := 0 to FUninstallShortcuts.Count - 1 do
    begin
      Shortcut := TUninstallShortcut(FUninstallShortcuts[I]);
      Path := IncludeTrailingBackslash(Reg.ReadString('Shell Folders', Shortcut.PathType, '')) + Shortcut.RelativePath;
      if ExtractFileExt(Shortcut.RelativePath) <> '' then
        SysUtils.DeleteFile(Path)
      else
        SysUtils.RemoveDir(Path);

      Inc(FCurrent, InstallPoints_UninstallShortcuts);
      Callback(Self, FCurrent, FTotal, Terminate);

      if Terminate then
        Exit;
   end;
  finally
    F(Reg);
  end;
end;

procedure TUninstallShortcutsAction.FillList;
begin
  AddUninstallShortcut('Desktop', ProgramShortCutFile_1_75);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_75 + '\' + ProgramShortCutFile_1_75);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_75 + '\' + HelpShortCutFile_1_75);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_75);

  AddUninstallShortcut('Desktop', ProgramShortCutFile_1_8);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_8 + '\' + ProgramShortCutFile_1_8);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_8 + '\' + HelpShortCutFile_1_8);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_8);

  AddUninstallShortcut('Desktop', ProgramShortCutFile_1_9);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_9 + '\' + ProgramShortCutFile_1_9);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_9 + '\' + HelpShortCutFile_1_9);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_1_9);

  AddUninstallShortcut('Desktop', ProgramShortCutFile_2_0);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_0 + '\' + ProgramShortCutFile_2_0);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_0 + '\' + HelpShortCutFile_2_0);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_0);

  AddUninstallShortcut('Desktop', ProgramShortCutFile_2_1);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_1 + '\' + ProgramShortCutFile_2_1);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_1 + '\' + HelpShortCutFile_2_1);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_1);

  AddUninstallShortcut('Desktop', ProgramShortCutFile_2_2);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_2 + '\' + ProgramShortCutFile_2_2);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_2 + '\' + HelpShortCutFile_2_2);
  AddUninstallShortcut('Start Menu', StartMenuProgramsPath_2_2);
end;

initialization

  TInstallManager.Instance.RegisterScope(TUninstallShortcutsAction);

end.
