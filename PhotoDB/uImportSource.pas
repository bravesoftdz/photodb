unit uImportSource;

interface

uses
  Generics.Defaults,
  Generics.Collections,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Imaging.PngImage,

  Dmitry.Utils.Files,
  Dmitry.Controls.Base,
  Dmitry.Controls.LoadingSign,
  Dmitry.PathProviders,

  UnitDBFileDialogs,

  uConstants,
  uRuntime,
  uMemory,
  uBitmapUtils,
  uGraphicUtils,
  uResources,
  uFormInterfaces,
  uThreadForm,
  uThreadTask,
  uPortableClasses,
  uPortableDeviceManager;

type
  TImportType = (itRemovableDevice, itUSB, itCD, itDirectory);

  TButtonInfo = class
    Name: string;
    Path: string;
    ImportType: TImportType;
    SortOrder: Integer;
  end;

type
  TFormImportSource = class(TThreadForm, ISelectSourceForm)
    LsLoading: TLoadingSign;
    LbLoadingMessage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLoadingCount: Integer;
    FButtons: TList<TSpeedButton>;
    procedure StartLoadingSourceList;
    procedure AddLocation(Name: string; ImportType: TImportType; Path: string; Image: TBitmap);
    procedure LoadLanguage;
    procedure FillDeviceCallBack(Packet: TList<IPDevice>; var Cancel: Boolean; Context: Pointer);
    procedure LoadingThreadFinished;
    procedure ReorderForm;
    procedure SelectSourceClick(Sender: TObject);
  protected
    function GetFormID: string; override;
  public
    { Public declarations }
    procedure Execute;
  end;

implementation

{$R *.dfm}

function CheckDriveItems(Path: string): Boolean;
var
  OldMode: Cardinal;
  Found: Integer;
  SearchRec: TSearchRec;
  Directories: TQueue<string>;
  Dir: string;
begin
  Result := False;
  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Directories := TQueue<string>.Create;
    try
      Directories.Enqueue(Path);

      while Directories.Count > 0 do
      begin
        Dir := Directories.Dequeue;

        Dir := IncludeTrailingBackslash(Dir);
        Found := FindFirst(Dir + '*.*', faDirectory, SearchRec);
        try
          while Found = 0 do
          begin
            if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and (faDirectory and SearchRec.Attr = 0) then
              Exit(True);

            if faDirectory and SearchRec.Attr <> 0 then
              Directories.Enqueue(Dir + SearchRec.Name );

            Found := System.SysUtils.FindNext(SearchRec);
          end;
        finally
          FindClose(SearchRec);
        end;
      end;

    finally
      F(Directories);
    end;
  finally
    SetErrorMode(OldMode);
  end;
end;

function CheckDeviceItems(Device: IPDevice): Boolean;
var
  Directories: TQueue<TPathItem>;
  PI, Dir: TPathItem;
  Childs: TPathItemCollection;
  Res: Boolean;
begin
  Res := False;
  Directories := TQueue<TPathItem>.Create;
  try
    PI := PathProviderManager.CreatePathItem(cDevicesPath + '\' + Device.Name);

    Directories.Enqueue(PI);

    while Directories.Count > 0 do
    begin
      if Res then
        Break;
      Dir := Directories.Dequeue;
      try
        Childs := TPathItemCollection.Create;
        try
          Dir.Provider.FillChildList(nil, Dir, Childs, PATH_LOAD_NO_IMAGE or PATH_LOAD_FAST, 0, 10,
            procedure(Sender: TObject; Item: TPathItem; CurrentItems: TPathItemCollection; var Break: Boolean)
            var
              I: Integer;
            begin
              for I := 0 to CurrentItems.Count - 1 do
              begin
                if not CurrentItems[I].IsDirectory then
                begin
                  Res := True;
                  Break := True;
                end else
                  Directories.Enqueue(CurrentItems[I].Copy);
              end;
              CurrentItems.FreeItems;
            end
          );
        finally
          Childs.FreeItems;
          F(Childs);
        end;
      finally
        F(Dir);
      end;
    end;

    while Directories.Count > 0 do
      Directories.Dequeue.Free;

  finally
    F(Directories);
  end;
  Result := Res;
end;

{ TFormImportSource }

procedure TFormImportSource.AddLocation(Name: string; ImportType: TImportType; Path: string; Image: TBitmap);
var
  Button: TSpeedButton;
  BI: TButtonInfo;

  procedure UpdateGlyph(Button: TSpeedButton);
  var
    Png: TPngImage;
    B: TBitmap;
    Image: string;
    Font: TFont;
  begin
    case ImportType of
      itCD:
        Image := 'IMPORT_CD';
      itRemovableDevice:
        Image := 'IMPORT_CAMERA';
      itUSB:
        Image := 'IMPORT_USB';
      else
        Image := 'IMPORT_DIRECTORY';
    end;
    Png := TResourceUtils.LoadGraphicFromRES<TPngImage>(Image);
    try
      B := TBitmap.Create;
      try
        AssignGraphic(B, Png);

        Font := TFont.Create;
        try
          Font.Assign(Self.Font);
          Font.Color := Theme.WindowTextColor;
          Font.Style := [fsBold];
          Font.Size := 12;
          B.Height := B.Height + 4 - Font.Height;

          FillTransparentColor(B, Theme.WindowTextColor, 0, B.Height - 4 + Font.Height, B.Width, 4 - Font.Height, 0);

          DrawText32Bit(B, Name, Font, Rect(0, B.Height - 4 + Font.Height, B.Width, B.Height), DT_CENTER or DT_END_ELLIPSIS);
          Button.Glyph := B;
        finally
          F(Font);
        end;
      finally
        F(B);
      end;
    finally
      F(Png);
    end;
  end;

begin
  if Visible then
    BeginScreenUpdate(Handle);
  try
    Button := TSpeedButton.Create(Self);
    Button.Parent := Self;
    Button.Width := 130;
    Button.Height := 130 + 20;
    Button.Top := 5;
    Button.OnClick := SelectSourceClick;

    BI := TButtonInfo.Create;
    BI.Name := Name;
    BI.Path := Path;
    BI.ImportType := ImportType;
    BI.SortOrder := 1000 * Integer(ImportType);
    if (Path.Length > 1) and (Path[2] = ':') then
      BI.SortOrder := BI.SortOrder + Byte(AnsiChar(Path[2]));
    Button.Tag := NativeInt(BI);

    if Image = nil then
      UpdateGlyph(Button)
    else
      Button.Glyph := Image;

    FButtons.Add(Button);

    ReorderForm;
  finally
    if Visible then
      EndScreenUpdate(Handle, True);
  end;
end;

procedure TFormImportSource.Execute;
begin
  StartLoadingSourceList;
  ShowModal;
end;

procedure TFormImportSource.FillDeviceCallBack(Packet: TList<IPDevice>;
  var Cancel: Boolean; Context: Pointer);
var
  I: Integer;
  Thread: TThreadTask;
begin
  Thread := TThreadTask(Context);

  for I := 0 to Packet.Count - 1 do
    if CheckDeviceItems(Packet[I]) then
      Cancel := not Thread.SynchronizeTask(
        procedure
        begin
          TFormImportSource(Thread.ThreadForm).AddLocation(Packet[I].Name, itRemovableDevice, cDevicesPath + '\' + Packet[I].Name, nil);
        end
      );
end;

procedure TFormImportSource.FormCreate(Sender: TObject);
begin
  FLoadingCount := 0;
  FButtons := TList<TSpeedButton>.Create;
  LoadLanguage;
end;

procedure TFormImportSource.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FButtons.Count - 1 do
    TObject(FButtons[I].Tag).Free;

  F(FButtons);
end;

function TFormImportSource.GetFormID: string;
begin
  Result := 'ImportSource';
end;

procedure TFormImportSource.LoadingThreadFinished;
begin
  Dec(FLoadingCount);
  if FLoadingCount = 0 then
    ReorderForm;
end;

procedure TFormImportSource.LoadLanguage;
begin
  BeginTranslate;
  try
    Caption := L('Import photos and video');
    LbLoadingMessage.Caption := L('Please wait until program searches for sources with images');
  finally
    EndTranslate;
  end;
end;

procedure TFormImportSource.ReorderForm;
var
  I,
  CW,
  LoadingWidth: Integer;
begin
  FButtons.Sort(TComparer<TSpeedButton>.Construct(
     function (const L, R: TSpeedButton): Integer
     begin
       Result := TButtonInfo(L.Tag).SortOrder - TButtonInfo(R.Tag).SortOrder;
     end
  ));

  for I := 0 to FButtons.Count - 1 do
    FButtons[I].Left := 5 + FButtons.IndexOf(FButtons[I]) * (130 + 5);

  CW := 5 + FButtons.Count * (130 + 5);

  LockWindowUpdate(Handle);
  try
    if FLoadingCount > 0 then
    begin
      LoadingWidth := 100;
      Inc(CW, LoadingWidth);
      LbLoadingMessage.Left := CW - LoadingWidth + LoadingWidth div 2 - LbLoadingMessage.Width div 2;
      LsLoading.Left := CW - LoadingWidth + LoadingWidth div 2 - LsLoading.Width div 2;
    end else
    begin
      LbLoadingMessage.Hide;
      LsLoading.Hide;
    end;

    ClientWidth := CW;
    Left := Monitor.Left + Monitor.Width div 2 - Width div 2;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TFormImportSource.SelectSourceClick(Sender: TObject);
var
  BI:  TButtonInfo;
  Path: string;
begin
  BI := TButtonInfo(TControl(Sender).Tag);

  if BI.ImportType = itDirectory then
  begin
    Path := UnitDBFileDialogs.DBSelectDir(Application.Handle, Caption, UseSimpleSelectFolderDialog);
    if Path = '' then
      Exit;

    ImportForm.FromFolder(Path);
    Close;
    Exit;
  end;

  ImportForm.FromFolder(BI.Path);
  Close;
end;

procedure TFormImportSource.StartLoadingSourceList;
begin
  //load CDs
  Inc(FLoadingCount);
  TThreadTask.Create(Self, Pointer(nil),
    procedure(Thread: TThreadTask; Data: Pointer)
    var
      I: Integer;
      OldMode: Cardinal;
      VolumeName: string;
    begin
      OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        for I := Ord('A') to Ord('Z') do
          if (GetDriveType(PChar(Chr(I) + ':\')) = DRIVE_CDROM) and CheckDriveItems(Chr(I) + ':\') then
          begin
            VolumeName := GetDriveVolumeLabel(AnsiChar(I));
            if not Thread.SynchronizeTask(
              procedure
              begin
                TFormImportSource(Thread.ThreadForm).AddLocation(VolumeName, itCD, Chr(I) + ':\', nil);
              end
            ) then Break;
          end;
      finally
        SetErrorMode(OldMode);
        Thread.SynchronizeTask(
          procedure
          begin
            TFormImportSource(Thread.ThreadForm).LoadingThreadFinished;
          end
        );
      end;
    end
  );

  //load Flash cards
  Inc(FLoadingCount);
  TThreadTask.Create(Self, Pointer(nil),
    procedure(Thread: TThreadTask; Data: Pointer)
    var
      I: Integer;
      OldMode: Cardinal;
      VolumeName: string;
    begin
      OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        for I := Ord('A') to Ord('Z') do
          if (GetDriveType(PChar(Chr(I) + ':\')) = DRIVE_REMOVABLE) and CheckDriveItems(Chr(I) + ':\') then
          begin
            VolumeName := GetDriveVolumeLabel(AnsiChar(I));
            if not Thread.SynchronizeTask(
              procedure
              begin
                TFormImportSource(Thread.ThreadForm).AddLocation(VolumeName, itUSB, Chr(I) + ':\', nil);
              end
            ) then Break;
          end;
      finally
        SetErrorMode(OldMode);
        Thread.SynchronizeTask(
          procedure
          begin
            TFormImportSource(Thread.ThreadForm).LoadingThreadFinished;
          end
        );
      end;
    end
  );

  //load Devices
  Inc(FLoadingCount);
  TThreadTask.Create(Self, Pointer(nil),
    procedure(Thread: TThreadTask; Data: Pointer)
    var
      Manager: IPManager;
    begin
      Manager := CreateDeviceManagerInstance;
      try
        Manager.FillDevicesWithCallBack(FillDeviceCallBack, Thread);
      finally
        Manager := nil;
        Thread.SynchronizeTask(
          procedure
          begin
            TFormImportSource(Thread.ThreadForm).LoadingThreadFinished;
          end
        );
      end;
    end
  );

  AddLocation(L('Select a folder'), itDirectory, '', nil);
end;

initialization
  FormInterfaces.RegisterFormInterface(ISelectSourceForm, TFormImportSource);

end.
