unit uImageViewer;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.ComCtrls,

  Dmitry.Utils.System,
  Dmitry.Controls.LoadingSign,
  Dmitry.Controls.WebLink,

  UnitDBDeclare,
  UnitDBKernel,
  ExplorerTypes,

  uMemory,
  uGOM,
  uIImageViewer,
  uDBPopupMenuInfo,
  uImageViewerControl,
  uFaceDetection,
  uImageViewerThread,
  uThreadForm,
  uGUIDUtils,
  uTranslate,
  uInterfaces,
  uImageSource;

type
  TImageViewer = class(TInterfacedObject, IImageViewer, IFaceResultForm)
  private
    FOwnerForm: TThreadForm;
    FTop: Integer;
    FLeft: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FOwner: TWinControl;
    FImageSource: IImageSource;
    FImageControl: TImageViewerControl;
    FCurrentFile: string;
    FFiles: TDBPopupMenuInfo;
    FIsWaiting: Boolean;
    FActiveThreadId: TGUID;
    FItem: TDBPopupMenuInfoRecord;
    FOnBeginLoadingImage: TBeginLoadingImageEvent;
    FOnPersonsFoundOnImage: TPersonsFoundOnImageEvent;
    procedure Resize;
    procedure LoadFile(FileInfo: TDBPopupMenuInfoRecord; NewImage: Boolean);
    procedure LoadImage(Sender: TObject; Item: TDBPopupMenuInfoRecord; Width, Height: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    //IObjectSource Implementation
    function GetObject: TObject;
    //IObjectSource END

    procedure RefreshFaceDetestionState;
    procedure UpdateFaces(FileName: string; Faces: TFaceDetectionResult);
    procedure FinishDetectionFaces;
    procedure SetFaceDetectionControls(AWlFaceCount: TWebLink; ALsDetectingFaces: TLoadingSign; ATbrActions: TToolBar);
    procedure SelectPerson(PersonID: Integer);
    procedure ResetPersonSelection;
    procedure StartPersonSelection;
    procedure StopPersonSelection;

    procedure UpdateAvatar(PersonID: Integer);

    procedure AttachTo(OwnerForm: TThreadForm; Control: TWinControl; X, Y: Integer);
    procedure LoadFiles(FileList: TDBPopupMenuInfo);
    procedure LoadPreviousFile;
    procedure LoadNextFile;
    function GetText: string;
    procedure SetText(Text: string);
    procedure ResizeTo(Width, Height: Integer);
    procedure SetStaticImage(Image: TBitmap; RealWidth, RealHeight: Integer; Rotation: Integer; ImageScale: Double);
    procedure SetAnimatedImage(Image: TGraphic; RealWidth, RealHeight: Integer; Rotation: Integer; ImageScale: Double);
    procedure FailedToLoadImage;

    procedure ZoomOut;
    procedure ZoomIn;

    procedure RotateCW;
    procedure RotateCCW;

    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTop: Integer;
    function GetLeft: Integer;
    function GetActiveThreadId: TGUID;
    function GetItem: TDBPopupMenuInfoRecord;
    function GetDisplayBitmap: TBitmap;
    function GetCurentFile: string;

    procedure SetOnBeginLoadingImage(Event: TBeginLoadingImageEvent);
    function GetOnBeginLoadingImage: TBeginLoadingImageEvent;
    procedure SetOnRequestNextImage(Event: TNotifyEvent);
    function GetOnRequestNextImage: TNotifyEvent;
    procedure SetOnRequestPreviousImage(Event: TNotifyEvent);
    function GetOnRequestPreviousImage: TNotifyEvent;
    procedure SetOnDblClick(Event: TNotifyEvent);
    function GetOnDblClick: TNotifyEvent;
    procedure SetOnPersonsFoundOnImage(Event: TPersonsFoundOnImageEvent);
    function GetOnPersonsFoundOnImage: TPersonsFoundOnImageEvent;
    procedure SetOnStopPersonSelection(Event: TNotifyEvent);
    function GetOnStopPersonSelection: TNotifyEvent;
  end;

implementation

{ TImageViewer }

procedure TImageViewer.AttachTo(OwnerForm: TThreadForm; Control: TWinControl; X, Y: Integer);
begin
  if Control = nil then
    raise EArgumentNilException.Create('Control is null!');

  FOwner := Control;
  FTop := Y;
  FLeft := X;

  FOwnerForm := OwnerForm;
  FOwnerForm.GetInterface(IImageSource, FImageSource);

  FImageControl := TImageViewerControl.Create(Control);
  FImageControl.ImageViewer := Self;
  FImageControl.Top := Y;
  FImageControl.Left := X;
  FImageControl.OnImageRequest := LoadImage;
  FImageControl.Parent := Control;
  if FOwnerForm is TCustomExplorerForm then
     FImageControl.Explorer := TCustomExplorerForm(FOwnerForm);

  inherited;
end;

constructor TImageViewer.Create;
begin
  GOM.AddObj(Self);
  FFiles := nil;
  FImageSource := nil;
  FCurrentFile := '';
  FIsWaiting := False;
  FActiveThreadId := GetEmptyGUID;
  FItem := TDBPopupMenuInfoRecord.Create;

  FOnBeginLoadingImage := nil;
  FOnPersonsFoundOnImage := nil;
end;

destructor TImageViewer.Destroy;
begin
  GOM.RemoveObj(Self);
  F(FItem);
  F(FFiles);
end;

procedure TImageViewer.FinishDetectionFaces;
begin
  FImageControl.FinishDetectingFaces;
end;

function TImageViewer.GetActiveThreadId: TGUID;
begin
  Result := FActiveThreadId;
end;

function TImageViewer.GetCurentFile: string;
begin
  Result := FItem.FileName;
end;

function TImageViewer.GetDisplayBitmap: TBitmap;
begin
  Result := FImageControl.FullImage;
end;

function TImageViewer.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TImageViewer.GetItem: TDBPopupMenuInfoRecord;
begin
  Result := FItem;
end;

function TImageViewer.GetLeft: Integer;
begin
  Result := FLeft;
end;

{$REGION IObjectSource}

function TImageViewer.GetObject: TObject;
begin
  Result := Self;
end;

function TImageViewer.GetOnBeginLoadingImage: TBeginLoadingImageEvent;
begin
  Result := FOnBeginLoadingImage;
end;

function TImageViewer.GetOnDblClick: TNotifyEvent;
begin
  Result := FImageControl.OnDblClick;
end;

function TImageViewer.GetOnPersonsFoundOnImage: TPersonsFoundOnImageEvent;
begin
  Result := FOnPersonsFoundOnImage;
end;

function TImageViewer.GetOnRequestNextImage: TNotifyEvent;
begin
  Result := FImageControl.OnRequestNextImage;
end;

function TImageViewer.GetOnRequestPreviousImage: TNotifyEvent;
begin
  Result := FImageControl.OnRequestPreviousImage;
end;

function TImageViewer.GetOnStopPersonSelection: TNotifyEvent;
begin
  Result := FImageControl.OnStopPersonSelection;
end;

{$ENDREGION}

function TImageViewer.GetText: string;
begin
  Result := FImageControl.Text;
end;

function TImageViewer.GetTop: Integer;
begin
  Result := FTop;
end;

function TImageViewer.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TImageViewer.LoadFile(FileInfo: TDBPopupMenuInfoRecord; NewImage: Boolean);
var
  Width, Height: Integer;
  Bitmap: TBitmap;
begin        
  FActiveThreadId := GetGUID;

  if FileInfo.Encrypted then
  begin
    if DBKernel.FindPasswordForCryptImageFile(FileInfo.FileName) = '' then
    begin
      SetText(TA('File is encrypted', 'Explorer'));
      Exit;
    end;
  end;

  if FImageSource <> nil then
  begin
    Width := 0;
    Height := 0;
    Bitmap := TBitmap.Create;
    try
      if FImageSource.GetImage(FileInfo.FileName, Bitmap, Width, Height) then
      begin
        FImageControl.LoadStaticImage(FileInfo, Bitmap, Width, Height, FileInfo.Rotation, 1);
        Bitmap := nil;
      end;
    finally
      F(Bitmap);
    end;
  end;

  F(FItem);
  FItem := FileInfo.Copy;

  if Assigned(FOnBeginLoadingImage) then
    FOnBeginLoadingImage(Self, NewImage);

  FImageControl.StartLoadingImage;
  LoadImage(Self, FileInfo, FWidth, FHeight);
end;

procedure TImageViewer.LoadFiles(FileList: TDBPopupMenuInfo);
var
  I, Position: Integer;
  TheSameFileList: Boolean;
begin
  TheSameFileList := (FFiles <> nil) and (FFiles.Count = FileList.Count) and (FImageControl.Text = '');
  if TheSameFileList then
  begin
    for I := 0 to FFiles.Count - 1 do
    begin
      if AnsiLowerCase(FFiles[I].FileName) <> AnsiLowerCase(FileList[I].FileName) then
      begin
        TheSameFileList := False;
        Break;
      end;
    end;
    if TheSameFileList then
      TheSameFileList := FFiles.Position = FileList.Position;
  end;

  F(FFiles);
  FFiles := FileList;

  if not TheSameFileList then
  begin
    Position := FFiles.Position;
    if Position > -1 then
      LoadFile(FFiles[Position], True);
  end else
  begin
    F(FItem);
    FItem := FFiles[FFiles.Position].Copy;
    FImageControl.UpdateItemInfo(FItem);
    if Assigned (FOnBeginLoadingImage) then
      FOnBeginLoadingImage(Self, False);
  end;
end;

procedure TImageViewer.LoadImage(Sender: TObject; Item: TDBPopupMenuInfoRecord; Width, Height: Integer);
var
  DisplaySize: TSize;
begin
  DisplaySize.cx := Width;
  DisplaySize.cy := Height;
  TImageViewerThread.Create(FOwnerForm, Self, FActiveThreadId, Item, DisplaySize, True, -1);
end;

procedure TImageViewer.LoadNextFile;
begin
  if FFiles = nil then
    Exit;

  FFiles.NextSelected;
  if FFiles.Position > -1 then
    LoadFile(FFiles[FFiles.Position], True);
end;

procedure TImageViewer.LoadPreviousFile;
begin
  if FFiles = nil then
    Exit;

  FFiles.PrevSelected;
  if FFiles.Position > -1 then
    LoadFile(FFiles[FFiles.Position], True);
end;

procedure TImageViewer.ResetPersonSelection;
begin
  FImageControl.HightliteReset;
end;

procedure TImageViewer.Resize;
begin
  //TODO:
end;

procedure TImageViewer.ResizeTo(Width, Height: Integer);
begin
  FWidth := Width;
  FHeight := Height;
  FImageControl.Width := Width;
  FImageControl.Height := Height;
  
  Resize;
end;

procedure TImageViewer.RotateCCW;
begin
  FImageControl.RotateCCW;
end;

procedure TImageViewer.RotateCW;
begin
  FImageControl.RotateCW;
end;

procedure TImageViewer.SelectPerson(PersonID: Integer);
begin
  FImageControl.HightlitePerson(PersonID);
end;

procedure TImageViewer.FailedToLoadImage;
begin
  FImageControl.FailedToLoadImage;
end;

procedure TImageViewer.SetAnimatedImage(Image: TGraphic; RealWidth, RealHeight: Integer; Rotation: Integer; ImageScale: Double);
begin
  if FFiles.Position < 0 then
    Exit;
  if FFiles.Position > FFiles.Count - 1 then
    Exit;

  FImageControl.LoadAnimatedImage(FFiles[FFiles.Position], Image, RealWidth, RealHeight, Rotation, ImageScale);
end;

procedure TImageViewer.SetFaceDetectionControls(AWlFaceCount: TWebLink;
  ALsDetectingFaces: TLoadingSign; ATbrActions: TToolBar);
begin
  FImageControl.SetFaceDetectionControls(AWlFaceCount, ALsDetectingFaces, ATbrActions);
end;

procedure TImageViewer.SetOnBeginLoadingImage(Event: TBeginLoadingImageEvent);
begin
  FOnBeginLoadingImage := Event;
end;

procedure TImageViewer.SetOnDblClick(Event: TNotifyEvent);
begin
  FImageControl.OnDblClick := Event;
end;

procedure TImageViewer.SetOnPersonsFoundOnImage(Event: TPersonsFoundOnImageEvent);
begin
  FOnPersonsFoundOnImage := Event;
end;

procedure TImageViewer.SetOnRequestNextImage(Event: TNotifyEvent);
begin
  FImageControl.OnRequestNextImage := Event;
end;

procedure TImageViewer.SetOnRequestPreviousImage(Event: TNotifyEvent);
begin
  FImageControl.OnRequestPreviousImage := Event;
end;

procedure TImageViewer.SetOnStopPersonSelection(Event: TNotifyEvent);
begin
  FImageControl.OnStopPersonSelection := Event;
end;

procedure TImageViewer.SetStaticImage(Image: TBitmap; RealWidth, RealHeight: Integer; Rotation: Integer; ImageScale: Double);
begin
  if FFiles.Position < 0 then
    Exit;
  if FFiles.Position > FFiles.Count - 1 then
    Exit;

  FImageControl.LoadStaticImage(FFiles[FFiles.Position], Image, RealWidth, RealHeight, Rotation, ImageScale);
end;

procedure TImageViewer.SetText(Text: string);
begin          
  FActiveThreadId := GetGUID;
  FImageControl.SetText(Text);
end;

procedure TImageViewer.StartPersonSelection;
begin
  FImageControl.StartPersonSelection;
end;

procedure TImageViewer.StopPersonSelection;
begin
  FImageControl.StopPersonSelection;
end;

procedure TImageViewer.RefreshFaceDetestionState;
begin

end;

procedure TImageViewer.UpdateAvatar(PersonID: Integer);
begin
  FImageControl.UpdateAvatar(PersonID);
end;

procedure TImageViewer.UpdateFaces(FileName: string; Faces: TFaceDetectionResult);
begin
  if AnsiLowerCase(FItem.FileName) <> AnsiLowerCase(FileName) then
    Exit;

  FImageControl.UpdateFaces(FileName, Faces);
  if Assigned(FOnPersonsFoundOnImage) then
    FOnPersonsFoundOnImage(Self, FileName, Faces);
end;

procedure TImageViewer.ZoomIn;
begin
  FImageControl.ZoomIn;
end;

procedure TImageViewer.ZoomOut;
begin
  FImageControl.ZoomOut;
end;

end.
