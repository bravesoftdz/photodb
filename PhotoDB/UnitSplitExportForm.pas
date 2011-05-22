unit UnitSplitExportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DropSource, DropTarget, Dolphin_DB,
  acDlgSelect, ImgList, Menus, DB, UnitGroupsWork, win32crc, uFileUtils,
  DragDrop, DragDropFile, uVistaFuncs, UnitDBDeclare, UnitDBFileDialogs, uLogger,
  UnitDBCommon, uConstants, uDBForm, uShellIntegration, uMemory, WatermarkedEdit,
  uAssociations, uDBUtils;

type
  TSplitExportForm = class(TDBForm)
    Panel1: TPanel;
    ListView1: TListView;
    Image1: TImage;
    Label1: TLabel;
    DropFileTarget1: TDropFileTarget;
    Label2: TLabel;
    ImageList1: TImageList;
    MethodImageList: TImageList;
    PmMethod: TPopupMenu;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    BtnCancel: TButton;
    BtnOk: TButton;
    EdDBName: TWatermarkedEdit;
    BtnChooseFile: TButton;
    BtnNew: TButton;
    CbDeleteRecords: TCheckBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      Point: TPoint; var Effect: Integer);
    procedure BtnChooseFileClick(Sender: TObject);
    procedure ListView1AdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure ListView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Copy1Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure ListView1Resize(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Items: TStrings;
    FRegGroups: TGroups;
    FGroupsFounded: TGroups;
    procedure LoadLanguage;
  protected
    function GetFormID : string; override;
  public
    { Public declarations }
  end;

procedure SplitDB;

var
  Split_Opened: Boolean = False;
  SplitExportForm: TSplitExportForm;

implementation

uses UnitDBKernel, CommCtrl, CommonDBSupport, ProgressActionUnit;

{$R *.dfm}

procedure SplitDB;
begin
  if Split_Opened then
  begin
    SplitExportForm.Show;
    Exit;
  end;
  Split_Opened := True;
  Application.CreateForm(TSplitExportForm, SplitExportForm);
  SplitExportForm.Show;
  Split_Opened := True;
end;

procedure TSplitExportForm.FormCreate(Sender: TObject);
begin
  Items := TStringList.Create;

  DropFileTarget1.Register(ListView1);
  LoadLanguage;
  MethodImageList.BkColor := clWindow;
  ImageList1.BkColor := clWindow;

  ImageList_ReplaceIcon(MethodImageList.Handle, -1, Icons[DB_IC_COPY + 1]);
  ImageList_ReplaceIcon(MethodImageList.Handle, -1, Icons[DB_IC_CUT + 1]);

  PmMethod.Images := DBKernel.ImageList;
  Copy1.ImageIndex := DB_IC_COPY;
  Cut1.ImageIndex := DB_IC_CUT;
  Delete1.ImageIndex := DB_IC_DELETE_INFO;
end;

procedure TSplitExportForm.FormDestroy(Sender: TObject);
begin
  F(Items);
end;

function TSplitExportForm.GetFormID: string;
begin
  Result := 'SplitDatabase';
end;

procedure TSplitExportForm.DropFileTarget1Drop(Sender: TObject;
  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
var
  I, J: Integer;
  Ico: TIcon;
begin

  if DropFileTarget1.Files.Count > 0 then
    for I := DropFileTarget1.Files.Count - 1 downto 0 do
      for J := 0 to Items.Count - 1 do
        if AnsiLowerCase(Items[J]) = AnsiLowerCase(DropFileTarget1.Files[I]) then
        begin
          DropFileTarget1.Files.Delete(I);
          Break;
        end;

  if DropFileTarget1.Files.Count > 0 then
    for I := 0 to DropFileTarget1.Files.Count - 1 do
    begin
      if DirectoryExists(DropFileTarget1.Files[I]) then
      begin
        Ico := TIcon.Create;
        try
          Ico.Handle := ExtractAssociatedIconSafe(DropFileTarget1.Files[I], 0);
          with ListView1.Items.Add do
          begin
            Caption := '';
            ImageIndex := Byte(CbDeleteRecords.Checked);
            Data := Pointer(ImageList1.Count);
          end;
          Items.Add(DropFileTarget1.Files[I]);
          ImageList1.AddIcon(Ico);
        finally
          F(Ico);
        end;
      end;
      if FileExistsSafe(DropFileTarget1.Files[I]) then
        if IsGraphicFile(DropFileTarget1.Files[I]) then
        begin
          Ico := TIcon.Create;
          try
            Ico.Handle := ExtractAssociatedIconSafe(DropFileTarget1.Files[I], 0);
            with ListView1.Items.Add do
            begin
              Caption := '';
              ImageIndex := Byte(CbDeleteRecords.Checked);
              Data := Pointer(ImageList1.Count);
            end;
            Items.Add(DropFileTarget1.Files[I]);
            ImageList1.AddIcon(Ico);
          finally
            F(Ico);
          end;
        end;
    end;
end;

procedure TSplitExportForm.BtnChooseFileClick(Sender: TObject);
var
  OpenDialog: DBOpenDialog;
begin
  OpenDialog := DBOpenDialog.Create;
  try
    OpenDialog.Filter := L('PhotoDB files (*.photodb)|*.photodb|All Files|*.*');

    if OpenDialog.Execute then
      if DBKernel.TestDB(OpenDialog.FileName) then
        EdDBName.Text := OpenDialog.FileName;

  finally
    F(OpenDialog);
  end;
end;

procedure TSplitExportForm.LoadLanguage;
begin
  BeginTranslate;
  try
    BtnNew.Caption := L('New');
    Caption := L('Split Collection');
    BtnOk.Caption := L('Ok');
    BtnCancel.Caption := L('Cancel');
    CbDeleteRecords.Caption := L('Delete records after finish');
    Label2.Caption := L('Path');
    Label3.Caption := L('Files and folders') + ':';
    Copy1.Caption := L('Copy');
    Cut1.Caption := L('Cut');
    ListView1.Columns[0].Caption := L('Method');
    ListView1.Columns[1].Caption := L('Path');
    Label1.Caption := L(
      'Drag into the list files or folders with images. You can move all these images to separeted collection');
    Delete1.Caption := L('Delete');
    EdDBName.WatermarkText := L('Select a file to split the database');
  finally
    EndTranslate;
  end;
end;

procedure TSplitExportForm.ListView1AdvancedCustomDrawSubItem
  (Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  aRect: TRect;
begin
  ListView_GetSubItemRect(ListView1.Handle, Item.Index, SubItem, 0, @aRect);
  ImageList1.Draw(Sender.Canvas, aRect.Left, Item.Top, Integer(Item.Data));
  Sender.Canvas.TextOut(aRect.Left + 20, Item.Top, Items[Item.Index]);
end;

procedure TSplitExportForm.ListView1ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  Item: TListItem;
begin
  Item := ListView1.GetItemAt(10, MousePos.Y);
  if Item <> nil then
  begin
    PmMethod.Tag := Item.Index;
    Item.Selected := True;
    if Item.ImageIndex = 0 then
      Copy1.Default := True
    else
      Cut1.Default := True;
    PmMethod.Popup(ListView1.ClientToScreen(MousePos).X,
      ListView1.ClientToScreen(MousePos).Y);
  end;
end;

procedure TSplitExportForm.Copy1Click(Sender: TObject);
begin
  ListView1.Items[PmMethod.Tag].ImageIndex := Integer((Sender as TMenuItem).Tag);
end;

procedure TSplitExportForm.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Item: TListItem;
begin
  Item := ListView1.GetItemAt(10, Y);
  if Item <> nil then
    Item.Selected := True;
end;

procedure TSplitExportForm.Delete1Click(Sender: TObject);
var
  Index: Integer;
begin
  Index := PmMethod.Tag;
  ListView1.Items.Delete(Index);
  Items.Delete(Index);
end;

procedure TSplitExportForm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TSplitExportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Split_Opened := False;
  Release;
end;

procedure TSplitExportForm.BtnOkClick(Sender: TObject);
var
  S, D: TDataSet;
  I, J: Integer;
  ProgressWindow: TProgressActionForm;
  fn: string;
  ID_Delete: array of Integer;
  Groups: TGroups;

  function RecordOk: Boolean;
  var
    I: Integer;
  begin
    Result := False;
    Fn := S.FieldByName('FFileName').AsString;
    for I := 0 to Items.Count - 1 do
    begin
      if AnsiUpperCase(Copy(Fn, 1, Length(Items[I]))) = AnsiUpperCase(Items[I]) then
      begin
        if ListView1.Items[I].ImageIndex = 1 then
        begin
          SetLength(ID_Delete, Length(ID_Delete) + 1);
          ID_Delete[Length(ID_Delete) - 1] := S.FieldByName('ID').AsInteger;
        end;
        Result := True;
        Exit;
      end;
    end;
  end;

  function RecordDelOk: Boolean;
  var
    I, Id: Integer;
  begin
    Result := False;
    Id := S.FieldByName('ID').AsInteger;
    for I := 0 to Length(ID_Delete) - 1 do
      if ID_Delete[I] = Id then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  if not DBKernel.TestDB(EdDBName.Text) then
  begin
    MessageBoxDB(Handle, L('Please select any database'), L('Error'),
      TD_BUTTON_OK, TD_ICON_ERROR);
    EdDBName.SelectAll;
    EdDBName.SetFocus;
    Exit;
  end
  else if ID_OK = MessageBoxDB(Handle, Format(L(
        'Do you really want to split the database and use this file: $nl$&quot;%s&quot;?$nl$WARNING: $nl$During the process all other windows will not be available!'), [EdDBName.Text]), L('Warning'), TD_BUTTON_OKCANCEL, TD_ICON_WARNING) then
  begin
    SetLength(ID_Delete, 0);
    ProgressWindow := GetProgressWindow;
    try
      ProgressWindow.OneOperation := False;
      ProgressWindow.OperationCount := 3;
      ProgressWindow.OperationPosition := 1;
      ProgressWindow.DoubleBuffered := True;
      S := GetTable;
      try
        S.Open;
        ProgressWindow.xPosition := 0;
        ProgressWindow.MaxPosCurrentOperation := S.RecordCount;

        ProgressWindow.Show;
        ProgressWindow.Repaint;
        SetLength(FGroupsFounded, 0);
        D := GetTable(EdDBName.Text, DB_TABLE_IMAGES);
        try
          D.Open;
          for I := 1 to S.RecordCount do
          begin
            if RecordOk then
            begin
              D.Append;
              CopyRecordsW(S, D, False, False, '', Groups);
              D.Post;
            end;
            S.Next;
            if I mod 10 = 0 then
              ProgressWindow.Repaint;
            ProgressWindow.xPosition := I;
            if not ProgressWindow.Visible then
              Break;
          end;

          ProgressWindow.OperationPosition := 2;
          ProgressWindow.xPosition := 0;
          ProgressWindow.MaxPosCurrentOperation := Length(FGroupsFounded);
          FRegGroups := GetRegisterGroupList(True);
          try
            CreateGroupsTableW(EdDBName.Text);
            for I := 0 to Length(FGroupsFounded) - 1 do
            begin
              ProgressWindow.xPosition := I;
              for J := 0 to Length(FRegGroups) - 1 do
                if FRegGroups[J].GroupCode = FGroupsFounded[I].GroupCode then
                begin
                  AddGroupW(FRegGroups[J], EdDBName.Text);
                  Break;
                end;
            end;
          finally
            FreeGroups(FRegGroups);
          end;

          ProgressWindow.OperationPosition := 3;
          ProgressWindow.xPosition := 0;
          ProgressWindow.MaxPosCurrentOperation := S.RecordCount;
          S.Last;
          for I := S.RecordCount downto 1 do
          begin
            if RecordDelOk then
              S.Delete;

            S.Prior;
            if S.Bof then
              Break;
            if I mod 10 = 0 then
              ProgressWindow.Repaint;
            ProgressWindow.xPosition := S.RecordCount - I;
            if not ProgressWindow.Visible then
              Break;
          end;
        finally
          FreeDS(D);
        end;
      finally
        FreeDS(S);
      end;
    finally
      ProgressWindow.Release;
    end;

    Close;
  end;

end;

procedure TSplitExportForm.BtnNewClick(Sender: TObject);
var
  SaveDialog: DBSaveDialog;
  FileName: string;
begin
  SaveDialog := DBSaveDialog.Create;
  try
    SaveDialog.Filter := L('PhotoDB files (*.photodb)|*.photodb');
    SaveDialog.FilterIndex := 1;

    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName;

      if SaveDialog.GetFilterIndex = 2 then
        if GetExt(FileName) <> 'DB' then
          FileName := FileName + '.db';
      if SaveDialog.GetFilterIndex = 1 then
        if GetExt(FileName) <> 'PHOTODB' then
          FileName := FileName + '.photodb';

      if FileExistsSafe(FileName) and (ID_OK <> MessageBoxDB(Handle,
          Format(L('File &quot;%s&quot; already exists! $nl$Replace?'),
            [FileName]), L('Warning'), TD_BUTTON_OKCANCEL, TD_ICON_WARNING))
        then
        Exit;
      begin
        DBKernel.CreateDBbyName(FileName);
        EdDBName.Text := FileName;
      end;
    end;
  finally
    F(SaveDialog);
  end;
end;

procedure TSplitExportForm.ListView1Resize(Sender: TObject);
begin
  ListView1.Columns[1].Width := ListView1.Width - ListView1.Columns[0].Width - 5;
end;

procedure TSplitExportForm.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Index: Integer;
begin
  if ListView1.Selected <> nil then
  begin
    Index := ListView1.Selected.Index;
    ListView1.Items.Delete(Index);
    Items.Delete(Index);
  end;
end;

end.
