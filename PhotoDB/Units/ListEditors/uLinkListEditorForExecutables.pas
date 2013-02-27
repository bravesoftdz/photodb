unit uLinkListEditorForExecutables;

interface

uses
  Generics.Collections,
  Winapi.Windows,
  System.SysUtils,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  Dmitry.Controls.Base,
  Dmitry.Controls.WatermarkedEdit,
  Dmitry.Controls.WebLink,

  UnitDBFileDialogs,

  uMemory,
  uVclHelpers,
  uIconUtils,
  uShellIntegration,
  uFormInterfaces;

type
  TExecutableInfo = class(TDataObject)
  public
    Title: string;
    Path: string;
    Icon: string;
    Parameters: string;
    UseSubMenu: Boolean;
    constructor Create(Title, Path, Icon, Parameters: string; UseSubMenu: Boolean);
    function Clone: TDataObject; override;
    procedure Assign(Source: TDataObject); override;
  end;

  TLinkListEditorForExecutables = class(TInterfacedObject, ILinkEditor)
  private
    procedure LoadIconForLink(Link: TWebLink; Path, Icon: string);
    procedure OnPlaceIconClick(Sender: TObject);
    procedure OnChangePlaceClick(Sender: TObject);
  public
    procedure CreateNewItem(Sender: ILinkItemSelectForm; var Data: TDataObject; Verb: string; Elements: TListElements);
    procedure CreateEditorForItem(Sender: ILinkItemSelectForm; Data: TDataObject; Editor: TPanel);
    procedure UpdateItemFromEditor(Sender: ILinkItemSelectForm; Data: TDataObject; Editor: TPanel);
    procedure FillActions(Sender: ILinkItemSelectForm; AddActionProc: TAddActionProcedure);
  end;

implementation

const
  CHANGE_EXEC_ICON          = 1;
  CHANGE_EXEC_CAPTION_EDIT  = 2;
  CHANGE_EXEC_CHANGE_PATH   = 3;
  CHANGE_EXEC_PATH          = 4;
  CHANGE_PEXEC_PARAMS_EDIT  = 5;
  CHANGE_PEXEC_PARAMS_LABEL = 6;

{ TExecutableInfo }

procedure TExecutableInfo.Assign(Source: TDataObject);
var
  EI: TExecutableInfo;
begin
  EI := Source as TExecutableInfo;
  if EI <> nil then
  begin
    Title := EI.Title;
    Path := EI.Path;
    Icon := EI.Icon;
    Parameters := EI.Parameters;
    UseSubMenu := EI.UseSubMenu;
  end;
end;

function TExecutableInfo.Clone: TDataObject;
begin
  Result := TExecutableInfo.Create(Title, Path, Icon, Parameters, UseSubMenu);
end;

constructor TExecutableInfo.Create(Title, Path, Icon, Parameters: string; UseSubMenu: Boolean);
begin
  Self.Title := Title;
  Self.Path := Path;
  Self.Icon := Icon;
  Self.Parameters := Parameters;
  Self.UseSubMenu := UseSubMenu;
end;

{ TLinkListEditorForExecutables }

procedure TLinkListEditorForExecutables.CreateEditorForItem(
  Sender: ILinkItemSelectForm; Data: TDataObject; Editor: TPanel);
var
  EI: TExecutableInfo;
  WlIcon: TWebLink;
  WlChangeLocation: TWebLink;
  WedCaption,
  WedParameters: TWatermarkedEdit;
  LbInfo,
  LbParameters: TLabel;
  Icon: HICON;
begin
  EI := TExecutableInfo(Data);

  WlIcon := Editor.FindChildByTag<TWebLink>(CHANGE_EXEC_ICON);
  WedCaption :=  Editor.FindChildByTag<TWatermarkedEdit>(CHANGE_EXEC_CAPTION_EDIT);
  WlChangeLocation := Editor.FindChildByTag<TWebLink>(CHANGE_EXEC_CHANGE_PATH);
  LbInfo := Editor.FindChildByTag<TLabel>(CHANGE_EXEC_PATH);

  WedParameters :=  Editor.FindChildByTag<TWatermarkedEdit>(CHANGE_PEXEC_PARAMS_EDIT);
  LbParameters :=  Editor.FindChildByTag<TLabel>(CHANGE_PEXEC_PARAMS_LABEL);

  if WedCaption = nil then
  begin
    WedCaption := TWatermarkedEdit.Create(Editor);
    WedCaption.Parent := Editor;
    WedCaption.Tag := CHANGE_EXEC_CAPTION_EDIT;
    WedCaption.Top := 8;
    WedCaption.Left := 35;
    WedCaption.Width := 200;
  end;

  if WlIcon = nil then
  begin
    WlIcon := TWebLink.Create(Editor);
    WlIcon.Parent := Editor;
    WlIcon.Tag := CHANGE_EXEC_ICON;
    WlIcon.Width := 16;
    WlIcon.Height := 16;
    WlIcon.Left := 8;
    WlIcon.Top := 8 + WedCaption.Height div 2 - WlIcon.Height div 2;
    WlIcon.OnClick := OnPlaceIconClick;
  end;

  if WlChangeLocation = nil then
  begin
    WlChangeLocation := TWebLink.Create(Editor);
    WlChangeLocation.Parent := Editor;
    WlChangeLocation.Tag := CHANGE_EXEC_CHANGE_PATH;
    WlChangeLocation.Height := 26;
    WlChangeLocation.Text := 'Change executable';
    WlChangeLocation.RefreshBuffer(True);
    WlChangeLocation.Top := 8 + WedCaption.Height div 2 - WlChangeLocation.Height div 2;
    WlChangeLocation.Left := 240;
    //WlChangeLocation.Icon := TIcon(Image1.Picture.Graphic);
    WlChangeLocation.OnClick := OnChangePlaceClick;
  end;

  if LbInfo = nil then
  begin
    LbInfo := TLabel.Create(Editor);
    LbInfo.Parent := Editor;
    LbInfo.Tag := CHANGE_EXEC_PATH;
    LbInfo.Left := 35;
    LbInfo.Top := 35;
    LbInfo.Width := 350;
    LbInfo.AutoSize := False;
    LbInfo.EllipsisPosition := epPathEllipsis;
  end;

  if WedParameters = nil then
  begin
    WedParameters := TWatermarkedEdit.Create(Editor);
    WedParameters.Parent := Editor;
    WedParameters.Tag := CHANGE_PEXEC_PARAMS_EDIT;
    WedParameters.Top := 62;
    WedParameters.Left := 35;
    WedParameters.Width := 200;
  end;

  if LbParameters = nil then
  begin
    LbParameters := TLabel.Create(Editor);
    LbParameters.Parent := Editor;
    LbParameters.Tag := CHANGE_PEXEC_PARAMS_LABEL;
    LbParameters.Caption := 'Parameters';
    LbParameters.Left := WedParameters.AfterRight(5);
    LbParameters.Top := WedParameters.Top + WedParameters.Height div 2 - LbParameters.Height div 2;
  end;

  Icon := ExtractSmallIconByPath(EI.Icon);
  try
    WlIcon.LoadFromHIcon(Icon);
  finally
    DestroyIcon(Icon);
  end;
  WedCaption.Text := EI.Title;
  LbInfo.Caption := EI.Path;
  WedParameters.Text := EI.Parameters;
end;

procedure TLinkListEditorForExecutables.CreateNewItem(Sender: ILinkItemSelectForm;
  var Data: TDataObject; Verb: string; Elements: TListElements);
var
  Link: TWebLink;
  Info: TLabel;
  EI: TExecutableInfo;
  OpenDialog: DBOpenDialog;
begin
  if Data = nil then
  begin

    OpenDialog := DBOpenDialog.Create;
    try
      OpenDialog.Filter := ('Programs (*.exe)|*.exe|All Files (*.*)|*.*');
      OpenDialog.FilterIndex := 1;
      if OpenDialog.Execute then
        Data := TExecutableInfo.Create(ExtractFileName(OpenDialog.FileName), OpenDialog.FileName, OpenDialog.FileName + ',0', '%1', True);

    finally
      F(OpenDialog);
    end;

    Exit;
  end;
  EI := TExecutableInfo(Data);

  Link := TWebLink(Elements[leWebLink]);
  Info := TLabel(Elements[leInfoLabel]);

  Link.Text := EI.Title;
  Info.Caption := EI.Path;
  Info.EllipsisPosition := epPathEllipsis;

  LoadIconForLink(Link, EI.Path, EI.Icon);
end;

procedure TLinkListEditorForExecutables.FillActions(Sender: ILinkItemSelectForm;
  AddActionProc: TAddActionProcedure);
begin
  AddActionProc(['Create'],
    procedure(Action: string; WebLink: TWebLink)
    begin
      WebLink.Text := 'Create new';
    end
  );
end;

procedure TLinkListEditorForExecutables.LoadIconForLink(Link: TWebLink; Path,
  Icon: string);
var
  Ico: HIcon;
begin
  if Icon <> '' then
    Ico := ExtractSmallIconByPath(Icon)
  else
    Ico := ExtractAssociatedIconSafe(Path);
  try
    Link.LoadFromHIcon(Ico);
  finally
    DestroyIcon(Ico);
  end;
end;

procedure TLinkListEditorForExecutables.OnChangePlaceClick(Sender: TObject);
var
  EI: TExecutableInfo;
  LbInfo: TLabel;
  Editor: TPanel;
  OpenDialog: DBOpenDialog;
begin
  Editor := TPanel(TControl(Sender).Parent);
  EI := TExecutableInfo(Editor.Tag);

  OpenDialog := DBOpenDialog.Create;
  try
    OpenDialog.Filter := ('Programs (*.exe)|*.exe|All Files (*.*)|*.*');
    OpenDialog.FilterIndex := 1;
    if OpenDialog.Execute then
    begin
      LbInfo := Editor.FindChildByTag<TLabel>(CHANGE_EXEC_PATH);
      LbInfo.Caption := OpenDialog.FileName;
      EI.Path := OpenDialog.FileName;
    end;

  finally
    F(OpenDialog);
  end;
end;

procedure TLinkListEditorForExecutables.OnPlaceIconClick(Sender: TObject);
var
  EI: TExecutableInfo;
  Icon: string;
  Editor: TPanel;
  WlIcon: TWebLink;
begin
  Editor := TPanel(TControl(Sender).Parent);
  EI := TExecutableInfo(Editor.Tag);

  Icon := EI.Icon;
  if ChangeIconDialog(0, Icon) then
  begin
    EI.Icon := Icon;
    WlIcon := Editor.FindChildByTag<TWebLink>(CHANGE_EXEC_ICON);
    LoadIconForLink(WlIcon, EI.Path, EI.Icon);
  end;
end;

procedure TLinkListEditorForExecutables.UpdateItemFromEditor(
  Sender: ILinkItemSelectForm; Data: TDataObject; Editor: TPanel);
var
  EI: TExecutableInfo;
  WedCaption,
  WedParameters: TWatermarkedEdit;
begin
  EI := TExecutableInfo(Data);

  WedCaption := Editor.FindChildByTag<TWatermarkedEdit>(CHANGE_EXEC_CAPTION_EDIT);
  WedParameters :=  Editor.FindChildByTag<TWatermarkedEdit>(CHANGE_PEXEC_PARAMS_EDIT);

  EI.Assign(Sender.EditorData);
  EI.Title := WedCaption.Text;
  EI.Parameters := WedParameters.Text;
end;

end.
