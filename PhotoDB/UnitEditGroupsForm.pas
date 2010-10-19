unit UnitEditGroupsForm;

interface

uses
  Dolphin_DB, UnitGroupsWork, Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, JPEG, UnitDBKernel, Math, UnitGroupsTools,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, AppEvnts, CmpUnit, ImgList,
  uVistaFuncs, UnitDBDeclare, UnitDBCommonGraphics, uDBForm;

type
  TEditGroupsForm = class(TDBForm)
    BtnCancel: TButton;
    BtnOk: TButton;
    BtnCreateGroup: TButton;
    PmGroup: TPopupMenu;
    Delete1: TMenuItem;
    N1: TMenuItem;
    CreateGroup1: TMenuItem;
    ChangeGroup1: TMenuItem;
    GroupManeger1: TMenuItem;
    BtnManager: TButton;
    PmGroupsManager: TPopupMenu;
    GroupManeger2: TMenuItem;
    QuickInfo1: TMenuItem;
    PmClear: TPopupMenu;
    Clear1: TMenuItem;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    ApplicationEvents1: TApplicationEvents;
    SearchForGroup1: TMenuItem;
    GroupsImageList: TImageList;
    LstSelectedGroups: TListBox;
    LstAvaliableGroups: TListBox;
    BtnRemoveGroup: TButton;
    BtnAddGroup: TButton;
    CbRemoveKeywords: TCheckBox;
    CbShowAllGroups: TCheckBox;
    MoveToGroup1: TMenuItem;
    LbInfo: TLabel;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnCreateGroupClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAddGroupClick(Sender: TObject);
    procedure LstSelectedGroupsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ChangeGroup1Click(Sender: TObject);
    procedure GroupManeger1Click(Sender: TObject);
    procedure CreateGroup1Click(Sender: TObject);
    procedure RecreateGroupsList;
    procedure PmGroupPopup(Sender: TObject);
    procedure QuickInfo1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ComboBoxEx1_KeyPress(Sender: TObject; var Key: Char);
    procedure LstSelectedGroupsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure SearchForGroup1Click(Sender: TObject);
    procedure CbShowAllGroupsClick(Sender: TObject);
    procedure CbRemoveKeywordsClick(Sender: TObject);
    procedure LstAvaliableGroupsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BtnRemoveGroupClick(Sender: TObject);
    procedure MoveToGroup1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FGroups: TGroups;
    FRegGroups: TGroups;
    FShowenRegGroups: TGroups;
    FSetGroups: TGroups;
    FNewKeyWords: string;
    FResult: Boolean;
    FOldGroups: TGroups;
    FOldKeyWords: string;
    function AGetGroupByCode(GroupCode: string): Integer;
    procedure ChangedDBDataGroups(Sender: TObject; ID: Integer; Params: TEventFields; Value: TEventValues);
  protected
    function GetFormID : string; override;
  public
    { Public declarations }
    procedure Execute(var Groups: TGroups; var KeyWords: string; CanNew: Boolean = True);
    procedure LoadLanguage;
  end;

procedure DBChangeGroups(var Groups : TGroups; var KeyWords : String; CanNew : Boolean = true); overload;
procedure DBChangeGroups(var SGroups : String; var KeyWords : String; CanNew : Boolean = true); overload;

implementation

uses UnitNewGroupForm, UnitManageGroups, UnitFormChangeGroup,
     UnitQuickGroupInfo, Searching, SelectGroupForm;

{$R *.dfm}

{ TEditGroupsForm }

Procedure DBChangeGroups(var Groups : TGroups; var KeyWords : String; CanNew : Boolean = true);
var
  EditGroupsForm: TEditGroupsForm;
begin
  Application.CreateForm(TEditGroupsForm, EditGroupsForm);
  try
    EditGroupsForm.Execute(Groups, KeyWords, CanNew);
  finally
    EditGroupsForm.Release;
  end;
end;

Procedure DBChangeGroups(var SGroups : String; var KeyWords : String; CanNew : Boolean = true);
var
  FEditGroupsForm: TEditGroupsForm;
  Groups: TGroups;
begin
  Groups := EncodeGroups(SGroups);
  Application.CreateForm(TEditGroupsForm, FEditGroupsForm);
  try
    FEditGroupsForm.Execute(Groups, KeyWords, CanNew);
  finally
    FEditGroupsForm.Release;
  end;
  SGroups := CodeGroups(Groups);
end;

procedure TEditGroupsForm.Execute(var Groups: TGroups; var KeyWords : String; CanNew : Boolean = true);
var
  I: Integer;
begin
  if not CanNew then
  begin
    BtnCreateGroup.Enabled := False;
    BtnManager.Enabled := False;
  end;
  FResult := False;
  FNewKeyWords := KeyWords;
  FOldGroups := CopyGroups(Groups);
  FOldKeyWords := KeyWords;
  FGroups := CopyGroups(Groups);
  FSetGroups := CopyGroups(Groups);
  LstSelectedGroups.Clear;
  for I := 0 to Length(Groups) - 1 do
    LstSelectedGroups.Items.Add(Groups[I].GroupName);

  ShowModal;
  FreeGroups(Groups);
  if FResult then
  begin
    Groups := CopyGroups(FSetGroups);
    KeyWords := FNewKeyWords;
  end else
  begin
    Groups := CopyGroups(FOldGroups);
    KeyWords := FOldKeyWords;
  end;
  FreeGroups(FSetGroups);
  Close;
end;

procedure TEditGroupsForm.BtnCancelClick(Sender: TObject);
begin
  FResult := False;
  Close;
end;

procedure TEditGroupsForm.FormCreate(Sender: TObject);
begin
  SetLength(FGroups, 0);
  SetLength(FRegGroups, 0);
  SetLength(FShowenRegGroups, 0);

  RecreateGroupsList;
  DBKernel.RegisterChangesID(Self, ChangedDBDataGroups);
  LoadLanguage;
  CbRemoveKeywords.Checked := DBkernel.ReadBool('Propetry', 'DeleteKeyWords', True);
  CbShowAllGroups.Checked := DBkernel.ReadBool('Propetry', 'ShowAllGroups', False);
end;

procedure TEditGroupsForm.BtnCreateGroupClick(Sender: TObject);
begin
  CreateNewGroupDialog;
end;

procedure TEditGroupsForm.BtnOkClick(Sender: TObject);
var
  I: Integer;
  FGroup: TGroup;
begin
  FResult := True;
  FreeGroups(FGroups);
  for I := 1 to LstSelectedGroups.Items.Count do
  begin
    SetLength(FGroups, Length(FGroups) + 1);
    FGroups[Length(FGroups) - 1].GroupName := LstSelectedGroups.Items[I - 1];
    FGroup := GetGroupByGroupName(LstSelectedGroups.Items[I - 1], False);
    FGroups[Length(FGroups) - 1].GroupCode := FGroup.GroupCode;
    if FGroup.AutoAddKeyWords then
      AddWordsA(FGroup.GroupKeyWords, FNewKeyWords);
  end;
  FSetGroups := CopyGroups(FGroups);
  Close;
end;

procedure TEditGroupsForm.BtnAddGroupClick(Sender: TObject);
var
  I: Integer;

  procedure AddGroup(Group: TGroup);
  var
    FRelatedGroups: TGroups;
    OldGroups, Groups: TGroups;
    TempGroup: TGroup;
    I: Integer;
  begin
    // ��������� ��������� ������
    FRelatedGroups := EncodeGroups(Group.RelatedGroups);
    // ��������� ��� �����
    OldGroups := CopyGroups(FSetGroups);
    // ��������?
    Groups := CopyGroups(OldGroups);

    // �������� ������ � ��������� � ��� ������
    AddGroupToGroups(Groups, Group);
    AddGroupsToGroups(Groups, FRelatedGroups);

    // ������� ��� �� � FSetGroups - ���������
    FSetGroups := CopyGroups(Groups);

    // �������� ��� ����� ������ ���� ����������� ������
    RemoveGroupsFromGroups(Groups, OldGroups);
    for I := 0 to Length(Groups) - 1 do
    begin
      // ��������� ������ � �������� ����� � ���
      LstSelectedGroups.Items.Add(Groups[I].GroupName);
      TempGroup := GetGroupByGroupCode(Groups[I].GroupCode, False);
      AddWordsA(TempGroup.GroupKeyWords, FNewKeyWords);
    end;
  end;

begin
  // ��������� ���������� ����� � ListBox2
  for I := 0 to LstAvaliableGroups.Items.Count - 1 do
    if LstAvaliableGroups.Selected[I] then
      AddGroup(FShowenRegGroups[I]);

  LstSelectedGroups.Invalidate;
  LstAvaliableGroups.Invalidate;
end;

procedure TEditGroupsForm.LstSelectedGroupsContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  ItemNo : Integer;
  i : integer;
begin
  ItemNo := LstSelectedGroups.ItemAtPos(MousePos, True);
 If ItemNo<>-1 then
 begin
  if not LstSelectedGroups.Selected[ItemNo] then
  begin
   LstSelectedGroups.Selected[ItemNo]:=True;
      for I := 0 to LstSelectedGroups.Items.Count - 1 do
        if I <> ItemNo then
          LstSelectedGroups.Selected[I] := False;
    end;
    PmGroup.Tag := ItemNo;
    PmGroup.Popup(LstSelectedGroups.ClientToScreen(MousePos).X, LstSelectedGroups.ClientToScreen(MousePos).Y);
  end else
  begin
    PmClear.Popup(LstSelectedGroups.ClientToScreen(MousePos).X, LstSelectedGroups.ClientToScreen(MousePos).Y);
  end;
end;

procedure TEditGroupsForm.ChangeGroup1Click(Sender: TObject);
var
  Group: TGroup;
begin
  Group := GetGroupByGroupCode(FindGroupCodeByGroupName(LstSelectedGroups.Items[PmGroup.Tag]), False);
  DBChangeGroup(Group);
end;

function TEditGroupsForm.GetFormID: string;
begin
  Result := 'EditGroupsList';
end;

procedure TEditGroupsForm.GroupManeger1Click(Sender: TObject);
begin
  ExecuteGroupManager;
end;

procedure TEditGroupsForm.CreateGroup1Click(Sender: TObject);
begin
  CreateNewGroupDialogA(fGroups[PmGroup.Tag].GroupName,fGroups[PmGroup.Tag].GroupCode);
end;

procedure TEditGroupsForm.RecreateGroupsList;
var
  I, Size : integer;
  SmallB, B : TBitmap;
begin
  FreeGroups(FRegGroups);
  FreeGroups(FShowenRegGroups);
  FRegGroups:=GetRegisterGroupList(True);
  GroupsImageList.Clear;
  SmallB := TBitmap.Create;
  SmallB.PixelFormat := Pf24bit;
  SmallB.Width := 32;
  SmallB.Height := 32 + 2;
  SmallB.Canvas.Pen.Color := Theme_MainColor;
  SmallB.Canvas.Brush.Color := Theme_MainColor;
  SmallB.Canvas.Rectangle(0, 0, SmallB.Width, SmallB.Height);
  DrawIconEx(SmallB.Canvas.Handle, 0, 0, UnitDBKernel.Icons[DB_IC_GROUPS + 1], SmallB.Width div 2 - 8,
    SmallB.Height div 2 - 8, 0, 0, DI_NORMAL);
  GroupsImageList.Add(SmallB, nil);
  SmallB.Free;
  LstAvaliableGroups.Clear;
  for I := 0 to Length(FRegGroups) - 1 do
  begin
    SmallB := TBitmap.Create;
    SmallB.PixelFormat := Pf24bit;
    SmallB.Canvas.Brush.Color := Theme_MainColor;
    if FRegGroups[I].GroupImage <> nil then
      if not FRegGroups[I].GroupImage.Empty then
      begin
        B := TBitmap.Create;
        B.PixelFormat := Pf24bit;
        B.Canvas.Brush.Color := Theme_MainColor;
        B.Canvas.Pen.Color := Theme_MainColor;
        Size := Max(FRegGroups[I].GroupImage.Width, FRegGroups[I].GroupImage.Height);
        B.Width := Size;
        B.Height := Size;
        B.Canvas.Rectangle(0, 0, Size, Size);
        B.Canvas.Draw(B.Width div 2 - FRegGroups[I].GroupImage.Width div 2,
          B.Height div 2 - FRegGroups[I].GroupImage.Height div 2, FRegGroups[I].GroupImage);
        DoResize(32, 34, B, SmallB);
        B.Free;
      end;
    GroupsImageList.Add(SmallB, nil);
    if FRegGroups[I].IncludeInQuickList or CbShowAllGroups.Checked then
    begin
      UnitGroupsWork.AddGroupToGroups(FShowenRegGroups, FRegGroups[I]);
      LstAvaliableGroups.Items.Add(FRegGroups[I].GroupName);
    end;
    SmallB.Free;
  end;
end;

procedure TEditGroupsForm.PmGroupPopup(Sender: TObject);
begin
  if GroupWithCodeExists(FSetGroups[PmGroup.Tag].GroupCode) then
  begin
    CreateGroup1.Visible := False;
    MoveToGroup1.Visible := False;
    ChangeGroup1.Visible:=True;
  end else
  begin
    CreateGroup1.Visible := True;
    MoveToGroup1.Visible := True;
    ChangeGroup1.Visible := False;
  end;
end;

procedure TEditGroupsForm.QuickInfo1Click(Sender: TObject);
begin
  ShowGroupInfo(FGroups[PmGroup.Tag], False, nil);
end;

procedure TEditGroupsForm.Clear1Click(Sender: TObject);
begin
  LstSelectedGroups.Clear;
  FreeGroups(FSetGroups);
  LstSelectedGroups.Invalidate;
  LstAvaliableGroups.Invalidate;
end;

procedure TEditGroupsForm.ComboBoxEx1_KeyPress(Sender: TObject;
  var Key: Char);
begin
  Key:= #0;
end;

procedure TEditGroupsForm.LstSelectedGroupsDblClick(Sender: TObject);
var
  I: Integer;
begin
  for I :=0 to LstSelectedGroups.Items.Count-1 do
  if LstSelectedGroups.Selected[i] then
    begin
      ShowGroupInfo(FSetGroups[i],false,nil);
    Break;
  end;
end;

procedure TEditGroupsForm.FormShow(Sender: TObject);
begin
  BtnOk.SetFocus;
end;

procedure TEditGroupsForm.LoadLanguage;
begin
  BeginTranslate;
  try
    Caption := L('Edit groups');
    BtnManager.Caption := L('Groups manager');
    BtnCreateGroup.Caption := L('Create group');
    BtnCancel.Caption := L('Cancel');
    BtnOk.Caption := L('Ok');
    Label2.Caption := L('Avaliable groups') + ':';
    Label1.Caption := L('Selected groups') + ':';
    Clear1.Caption := L('Clear');
    GroupManeger2.Caption := L('Groups manager');
    Delete1.Caption := L('Delete');
    CreateGroup1.Caption := L('Create group');
    ChangeGroup1.Caption := L('Change group');
    GroupManeger1.Caption := L('Groups manager');
    QuickInfo1.Caption := L('Group info');
    SearchForGroup1.Caption := L('Search group photos');
    CbShowAllGroups.Caption := L('Show all groups');
    CbRemoveKeywords.Caption := L('Delete group comments');
    MoveToGroup1.Caption := L('Move to group');
    LbInfo.Caption := L('Use button "-->" to select groups and button "<--" to remove them from list');
  finally
    EndTranslate;
  end;
end;

procedure TEditGroupsForm.ApplicationEvents1Message(var Msg: TagMSG; var Handled: Boolean);
begin
  if (Msg.Hwnd = LstSelectedGroups.Handle)
    and (Msg.message = WM_KEYDOWN)
    and (Msg.wParam = VK_DELETE) then
  BtnRemoveGroupClick(Self);
end;

procedure TEditGroupsForm.SearchForGroup1Click(Sender: TObject);
var
  NewSearch: TSearchForm;
begin
  NewSearch := SearchManager.NewSearch;
  NewSearch.SearchEdit.Text := ':Group(' + FGroups[PmGroup.Tag].GroupName+'):';
  NewSearch.WlStartStop.OnClick(Sender);
  NewSearch.Show;
end;

procedure TEditGroupsForm.CbShowAllGroupsClick(Sender: TObject);
begin
  RecreateGroupsList;
  DBkernel.WriteBool('Propetry','ShowAllGroups', CbShowAllGroups.Checked);
end;

procedure TEditGroupsForm.CbRemoveKeywordsClick(Sender: TObject);
begin
  DBkernel.WriteBool('Propetry','DeleteKeyWords', CbRemoveKeywords.Checked);
end;

procedure TEditGroupsForm.LstAvaliableGroupsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  N, I, W : Integer;
  xNewGroups : TGroups;
  Text, Text1 : string;

  function NewGroup(GroupCode : String) : Boolean;
  var
    J : integer;
  begin
   Result:=false;
   for J := 0 to Length(xNewGroups) - 1 do
      if XNewGroups[J].GroupCode = GroupCode then
      begin
        Result := True;
        Break;
      end;
  end;

  function GroupExists(GroupCode: string): Boolean;
  var
    J: Integer;
  begin
    Result := False;
    for J := 0 to Length(FSetGroups) - 1 do
      if FSetGroups[J].GroupCode = GroupCode then
      begin
        Result := True;
        Break;
      end;
  end;

begin
  if Control = LstSelectedGroups then
  begin
    XNewGroups := CopyGroups(FSetGroups);
    RemoveGroupsFromGroups(XNewGroups, FOldGroups);
  end else
  begin
    XNewGroups := CopyGroups(FOldGroups);
    RemoveGroupsFromGroups(xNewGroups,FSetGroups);
  end;

  try
    if Index=-1 then
      exit;
    with (Control as TListBox).Canvas do
    begin
      FillRect(Rect);
      n:=-1;
      if Control=LstSelectedGroups then
      begin
        for i:=0 to Length(FRegGroups)-1 do
        begin
          if FRegGroups[I].GroupCode = FSetGroups[index].GroupCode then
          begin
            N := I + 1;
            Break;
          end;
        end
      end else
      begin
        for I := 0 to Length(FRegGroups) - 1 do
        begin
          if FRegGroups[I].GroupName = (Control as TListBox).Items[index] then
          begin
            N := I + 1;
            Break;
          end;
        end
      end;

      GroupsImageList.Draw((Control as TListBox).Canvas, Rect.Left + 2, Rect.Top + 2, Max(0, N));
      if N = -1 then
      begin
        DrawIconEx((Control as TListBox).Canvas.Handle, Rect.Left + 10, Rect.Top + 8,
          UnitDBKernel.Icons[DB_IC_DELETE_INFO + 1], 8, 8, 0, 0, DI_NORMAL);
      end;
      if Control = LstSelectedGroups then
        if NewGroup(FSetGroups[index].GroupCode) then
          (Control as TListBox).Canvas.Font.Style := (Control as TListBox).Canvas.Font.Style + [FsBold]
        else
          (Control as TListBox).Canvas.Font.Style := (Control as TListBox).Canvas.Font.Style - [FsBold];

      if Control = LstAvaliableGroups then
        if N > -1 then
          if NewGroup(FRegGroups[N - 1].GroupCode) then (Control as TListBox)
            .Canvas.Font.Style := (Control as TListBox).Canvas.Font.Style + [FsBold]
          else
          begin
            if GroupExists(FShowenRegGroups[index].GroupCode) then
            begin
              (Control as TListBox).Canvas.Font.Color := ColorDiv2(Theme_ListFontColor, Theme_MemoEditColor);
            end else
            begin
              (Control as TListBox).Canvas.Font.Color := Theme_ListFontColor;
            end;
            (Control as TListBox).Canvas.Font.Style := (Control as TListBox).Canvas.Font.Style - [FsBold];
          end;
      Text := (Control as TListBox).Items[index];
      W := Control.Width div (Control as TListBox).Canvas.TextWidth('w');
      Text1 := Copy(Text, 1, Min(Length(Text), W));
      Delete(Text, 1, Length(Text1));
      if Text <> '' then
        if CharInSet(Text1[Length(Text1)], ['a' .. 'z', 'A' .. 'Z', '�' .. '�', '�' .. '�']) then
          if CharInSet(Text[1], ['a' .. 'z', 'A' .. 'Z', '�' .. '�', '�' .. '�']) then
            Text1 := Text1 + '-';
      TextOut(Rect.Left + 32 + 5, Rect.Top + 3, Text1);
      TextOut(Rect.Left + 32 + 5, Rect.Top + 3 + 14, Text);
    end;
  except
  end;
end;

function TEditGroupsForm.AGetGroupByCode(GroupCode: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(FRegGroups) - 1 do
    if FRegGroups[I].GroupCode = GroupCode then
    begin
    Result := I;
    break;
  end;
end;

procedure TEditGroupsForm.BtnRemoveGroupClick(Sender: TObject);
var
  I, J: Integer;
  KeyWords, AllGroupsKeyWords, GroupKeyWords: string;
begin
  for I := LstSelectedGroups.Items.Count - 1 downto 0 do
  if LstSelectedGroups.Selected[I] then
  // ������� ���������� ������ ��� ��������
  begin
  // ���� �������� �������� ���� �������� �� ������� ��
      if CbRemoveKeywords.Checked then
      begin
        AllGroupsKeyWords := '';
        for J := LstSelectedGroups.Items.Count - 1 downto 0 do
          if I <> J then
          begin
            if AGetGroupByCode(FSetGroups[J].GroupCode) > -1 then
              AddWordsA(FRegGroups[AGetGroupByCode(FSetGroups[J].GroupCode)].GroupKeyWords, AllGroupsKeyWords);
          end;
        KeyWords := FNewKeyWords;
        if AGetGroupByCode(FSetGroups[I].GroupCode) > -1 then
          GroupKeyWords := FRegGroups[AGetGroupByCode(FSetGroups[I].GroupCode)].GroupKeyWords;
        DeleteWords(GroupKeyWords, AllGroupsKeyWords);
        DeleteWords(KeyWords, GroupKeyWords);
        FNewKeyWords := KeyWords;
      end;

      // ������� ������ ���������
      RemoveGroupFromGroups(FSetGroups, FSetGroups[I]);
      LstSelectedGroups.Items.Delete(I);
    end;
  LstSelectedGroups.Invalidate;
  LstAvaliableGroups.Invalidate;
end;

procedure TEditGroupsForm.MoveToGroup1Click(Sender: TObject);
var
  ToGroup: TGroup;
begin
  if SelectGroup(ToGroup) then
  begin
    MoveGroup(FSetGroups[PmGroup.Tag], ToGroup);
    MessageBoxDB(Handle, L('Reload data in application to see changes!'), L('Warning'), TD_BUTTON_OK, TD_ICON_WARNING);
  end;
end;

procedure TEditGroupsForm.ChangedDBDataGroups(Sender: TObject; ID: integer;
  Params: TEventFields; Value: TEventValues);
begin
  if EventID_Param_GroupsChanged in Params then
  begin
    RecreateGroupsList;
    Exit;
  end;
end;

procedure TEditGroupsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin;
  DBKernel.UnRegisterChangesID(Self, ChangedDBDataGroups);
end;

procedure TEditGroupsForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
