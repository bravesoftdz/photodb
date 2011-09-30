unit uExplorerGroupsProvider;

interface

uses
  Windows, Graphics, uExplorerPathProvider, uPathProviders, UnitGroupsWork,
  uBitmapUtils, UnitDBDeclare, uConstants, UnitDBKernel, StrUtils,
  uShellIntegration, SysUtils, uDBForm, uExplorerMyComputerProvider,
  uMemory, uTranslate, uShellIcons, uStringUtils;

type
  TGroupsItem = class(TPathItem)
  protected
    function InternalGetParent: TPathItem; override;
    function InternalCreateNewInstance: TPathItem; override;
  public
    function LoadImage(Options, ImageSize: Integer): Boolean; override;
    constructor CreateFromPath(APath: string; Options, ImageSize: Integer); override;
  end;

  TGroupItem = class(TPathItem)
  protected
    function InternalGetParent: TPathItem; override;
  public
    function LoadImage(Options, ImageSize: Integer): Boolean; override;
    procedure ReadFromGroup(Group: TGroup; Options, ImageSize: Integer);
    function InternalCreateNewInstance: TPathItem; override;
  end;

type
  TGroupProvider = class(TExplorerPathProvider)
  protected
    function InternalFillChildList(Sender: TObject; Item: TPathItem; List: TPathItemCollection; Options, ImageSize: Integer; PacketSize: Integer; CallBack: TLoadListCallBack): Boolean; override;
    function GetTranslateID: string; override;
    function Delete(Sender: TObject; Item: TDBPopupMenuInfoRecord; Options: Integer): Boolean;
  public
    function ExtractPreview(Item: TPathItem; MaxWidth, MaxHeight: Integer; var Bitmap: TBitmap; var Data: TObject): Boolean; override;
    function Supports(Item: TPathItem): Boolean; override;
    function Supports(Path: string): Boolean; override;
    function SupportsFeature(Feature: string): Boolean; override;
    function ExecuteFeature(Sender: TObject; Item: TPathItem; Feature: string; Options: Integer): Boolean; override;
    function CreateFromPath(Path: string): TPathItem; override;
  end;

implementation

uses
  UnitGroupsTools;

{ TGroupProvider }

function ExtractGroupName(Path: string): string;
var
  P: Integer;
begin
  Result := '';
  P := Pos('\', Path);
  if P > 0 then
    Result := Right(Path, P + 1);;
end;

function TGroupProvider.CreateFromPath(Path: string): TPathItem;
begin
  Result := nil;
  if Path = cGroupsPath then
    Result := TGroupsItem.CreateFromPath(Path, PATH_LOAD_NO_IMAGE, 0);
end;

function TGroupProvider.Delete(Sender: TObject; Item: TDBPopupMenuInfoRecord; Options: Integer): Boolean;
var
  EventInfo: TEventValues;
  Group: TGroup;
  Form: TDBForm;
begin
  Result := False;
  Form := TDBForm(Sender);
  Group := GetGroupByGroupName(Item.Name, False);
  try
    if ID_OK = MessageBoxDB(Form.Handle, Format(L('Do you really want to delete group "%s"?'), [Group.GroupName]), L('Warning'), TD_BUTTON_OKCANCEL, TD_ICON_WARNING) then
      if UnitGroupsWork.DeleteGroup(Group) then
      begin
        if ID_OK = MessageBoxDB(Form.Handle, Format(L('Scan collection and remove all pointers to group "%s"?'), [Group.GroupName]),
          L('Warning'), TD_BUTTON_OKCANCEL, TD_ICON_WARNING) then
        begin
          UnitGroupsTools.DeleteGroup(Group);
          MessageBoxDB(Form.Handle, L('Update the data in the windows to apply changes!'), L('Warning'), TD_BUTTON_OKCANCEL, TD_ICON_WARNING);
          DBKernel.DoIDEvent(Form, 0, [EventID_Param_GroupsChanged], EventInfo);
          Result := True;
          Exit;
        end;
        DBKernel.DoIDEvent(Form, 0, [EventID_Param_GroupsChanged], EventInfo);
      end;
  finally
    FreeGroup(Group);
  end;
end;

function TGroupProvider.ExecuteFeature(Sender: TObject; Item: TPathItem;
  Feature: string; Options: Integer): Boolean;
begin
  Result := inherited ExecuteFeature(Sender, Item, Feature, Options);

  if Feature = PATH_FEATURE_DELETE then
    Result := Delete(Sender, TDBPopupMenuInfoRecord(Item), Options);
end;

function TGroupProvider.ExtractPreview(Item: TPathItem; MaxWidth,
  MaxHeight: Integer; var Bitmap: TBitmap; var Data: TObject): Boolean;
var
  Group: TGroup;
begin
  Result := False;
  Group := GetGroupByGroupName(ExtractGroupName(Item.Path), True);

  if Group.GroupImage = nil then
    Exit;

  try
    Bitmap.Assign(Group.GroupImage);
    KeepProportions(Bitmap, MaxWidth, MaxHeight);
    Result := True;
  finally
    FreeGroup(Group);
  end;
end;

function TGroupProvider.GetTranslateID: string;
begin
  Result := 'GroupsProvider';
end;

function TGroupProvider.InternalFillChildList(Sender: TObject; Item: TPathItem;
  List: TPathItemCollection; Options, ImageSize, PacketSize: Integer;
  CallBack: TLoadListCallBack): Boolean;
var
  I: Integer;
  GI: TGroupsItem;
  G: TGroupItem;
  Cancel: Boolean;
  Groups: TGroups;
begin
  inherited;
  Result := True;
  Cancel := False;

  if Item is THomeItem then
  begin
    GI := TGroupsItem.CreateFromPath(cGroupsPath, Options, ImageSize);
    List.Add(GI);
  end;

  if Item is TGroupsItem then
  begin
    Groups := GetRegisterGroupList(True);
    try
      for I := 0 to Length(Groups) - 1 do
      begin
        G := TGroupItem.CreateFromPath(cGroupsPath + '\' + Groups[I].GroupName, Options, ImageSize);
        G.ReadFromGroup(Groups[I], Options, ImageSize);
        List.Add(G);

        if List.Count mod PacketSize = 0 then
        begin
          if Assigned(CallBack) then
            CallBack(Sender, Item, List, Cancel);
          if Cancel then
            Break;
        end;
      end;
    finally
      FreeGroups(Groups);
    end;
  end;

  if Assigned(CallBack) then
    CallBack(Sender, Item, List, Cancel);
end;

function TGroupProvider.Supports(Item: TPathItem): Boolean;
begin
  Result := Item is TGroupsItem;
  Result := Item is TGroupItem or Result;
  Result := Result or Supports(Item.Path);
end;

function TGroupProvider.Supports(Path: string): Boolean;
begin
  Result := StrUtils.StartsText(cGroupsPath, Path);
end;

function TGroupProvider.SupportsFeature(Feature: string): Boolean;
begin
  Result := Feature = PATH_FEATURE_DELETE;
end;

{ TGroupItem }

constructor TGroupsItem.CreateFromPath(APath: string; Options, ImageSize: Integer);
begin
  inherited;
  FPath := cGroupsPath;
  FDisplayName := TA('Groups', 'Path');
  if Options and PATH_LOAD_NO_IMAGE = 0 then
    LoadImage(Options, ImageSize);
end;

function TGroupsItem.InternalCreateNewInstance: TPathItem;
begin
  Result := TGroupsItem.Create;
end;

function TGroupsItem.InternalGetParent: TPathItem;
begin
  Result := THomeItem.Create;
end;

function TGroupsItem.LoadImage(Options, ImageSize: Integer): Boolean;
var
  Icon: TIcon;
begin
  F(FImage);
  FindIcon(HInstance, 'GROUPS', ImageSize, 32, Icon);
  FImage := TPathImage.Create(Icon);
  Result := True;
end;

{ TGroupItem }

function TGroupItem.InternalCreateNewInstance: TPathItem;
begin
  Result := TGroupItem.Create;
end;

function TGroupItem.InternalGetParent: TPathItem;
begin
  Result := TGroupsItem.CreateFromPath(cGroupsPath, PATH_LOAD_NORMAL, 0);
end;

function TGroupItem.LoadImage(Options, ImageSize: Integer): Boolean;
var
  Group: TGroup;
begin
  Group := GetGroupByGroupName(FDisplayName, True);
  try
    ReadFromGroup(Group, Options, ImageSize);
    Result := True;
  finally
    FreeGroup(Group);
  end;
end;

procedure TGroupItem.ReadFromGroup(Group: TGroup; Options, ImageSize: Integer);
var
  Bitmap: TBitmap;
begin
  FDisplayName := Group.GroupName;
  Bitmap := TBitmap.Create;
  try
    Bitmap.Assign(Group.GroupImage);
    KeepProportions(Bitmap, ImageSize, ImageSize);
    if Options and PATH_LOAD_FOR_IMAGE_LIST <> 0 then
      CenterBitmap24To32ImageList(Bitmap, ImageSize);
    F(FImage);
    FImage := TPathImage.Create(Bitmap);
    Bitmap := nil;
  finally
    F(Bitmap);
  end;
end;

initialization
  PathProviderManager.RegisterProvider(TGroupProvider.Create);
  PathProviderManager.RegisterSubProvider(TMyComputerProvider, TGroupProvider);

end.
