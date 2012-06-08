unit UnitSearchBigImagesLoaderThread;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  UnitDBDeclare,
  uRuntime,
  uCDMappingTypes,
  uThreadForm,
  uLogger,
  uThreadEx,
  uMemory,
  uMultiCPUThreadManager,
  uDBPopupMenuInfo,
  uDBBaseTypes,
  uTranslate,
  uImageLoader;

type
  TSearchBigImagesLoaderThread = class(TMultiCPUThread)
  private
    { Private declarations }
    FSender: TThreadForm;
    FOnDone: TNotifyEvent;
    FPictureSize: Integer;
    FVisibleFiles: TArStrings;
    BoolParam: Boolean;
    StrParam: string;
    IntParam: Integer;
    BitmapParam: TBitmap;
    FI: Integer;
    FMainThread: Boolean;
    FData: TDBPopupMenuInfo;
    FImageFileName: string;
    FImageRotation: Integer;
    FRefresh: Boolean;
  protected
    { Protected declarations }
    procedure Execute; override;
    function IsVirtualTerminate : Boolean; override;
    procedure DoMultiProcessorTask; override;
    procedure ExtractBigImage(PictureSize : Integer; FileName: string; Rotation : Integer);
  public
    { Public declarations }
    constructor Create(Sender : TThreadForm; SID : TGUID;
      OnDone : TNotifyEvent; PictureSize : Integer; Data : TDBPopupMenuInfo;
      MainThread : Boolean; Refresh: Boolean);
    destructor Destroy; override;
    procedure VisibleUp(TopIndex: integer);
    procedure GetVisibleFiles;
    procedure FileNameExists;
    procedure InitializeLoadingBigImages;
    procedure ReplaceBigBitmap;
    procedure EndLoading;
    property ImageFileName : string read FImageFileName write FImageFileName;
    property PictureSize : Integer read FPictureSize write FPictureSize;
    property ImageRotation : Integer read FImageRotation write FImageRotation;
  end;

var
  SearchUpdateBigImageThreadsCount: Integer = 0;

implementation

uses
  Searching,
  uSearchThreadPool;

constructor TSearchBigImagesLoaderThread.Create(Sender: TThreadForm; SID: TGUID; OnDone: TNotifyEvent; PictureSize: integer;
  Data : TDBPopupMenuInfo; MainThread : Boolean; Refresh: Boolean);
begin
  inherited Create(Sender, SID);
  FSender := Sender;
  FOnDone := OnDone;
  FPictureSize := PictureSize;
  FData := Data;
  FMainThread := MainThread;
  FRefresh := Refresh;
end;

procedure TSearchBigImagesLoaderThread.VisibleUp(TopIndex: integer);
var
  I, C: Integer;
  J: Integer;
begin
  C := TopIndex;
  for I := 0 to Length(FVisibleFiles) - 1 do
    for J := TopIndex to FData.Count - 1 do
    begin
      if FVisibleFiles[I] = FData[J].FileName then
      begin
        if C >= FData.Count then
          Break;
        FData.Exchange(C, J);
        Inc(C);
      end;
    end;
end;

procedure TSearchBigImagesLoaderThread.Execute;
var
  I : Integer;
begin
  inherited;
  FreeOnTerminate := True;

  if not FMainThread then
  begin
    StartMultiThreadWork;
    Exit;
  end;

  while SearchUpdateBigImageThreadsCount > (ProcessorCount + 1) do
    Sleep(10);

  Inc(SearchUpdateBigImageThreadsCount);
  try

    SynchronizeEx(InitializeLoadingBigImages);

    for I := 0 to FData.Count - 1 do
    begin

      if (I + 1) mod 5 = 0 then
      begin
        SynchronizeEx(GetVisibleFiles);
        VisibleUp(I);
      end;

      if Terminated then
        Break;

      if ProcessorCount > 1 then
        TSearchThreadPool.Instance.CreateBigImage(Self, FPictureSize, FData[I].FileName, FData[I].Rotation)
      else
        ExtractBigImage(FPictureSize, FData[I].FileName, FData[I].Rotation);

      FI := I + 1;
      IntParam := FI;
    end;

    if ProcessorCount > 1 then
      while TSearchThreadPool.Instance.GetBusyThreadsCountForThread(Self) > 0 do
        Sleep(100);

    if not FRefresh then
      SynchronizeEx(EndLoading);

  finally
    Dec(SearchUpdateBigImageThreadsCount);
  end;
end;

procedure TSearchBigImagesLoaderThread.ExtractBigImage(PictureSize: Integer;
  FileName: string; Rotation: Integer);
var
  Info: TDBPopupMenuInfoRecord;
  ImageInfo: ILoadImageInfo;
begin
  FileName := ProcessPath(FileName);

  Info := TDBPopupMenuInfoRecord.CreateFromFile(FileName);
  try
    Info.Rotation := Rotation;

    if LoadImageFromPath(Info, -1, '', [ilfGraphic, ilfICCProfile, ilfEXIF, ilfPassword], ImageInfo, PictureSize, PictureSize)  then
    begin
      BitmapParam := ImageInfo.GenerateBitmap(Info, PictureSize, PictureSize, pf32Bit, Theme.ListViewColor, [ilboFreeGraphic, ilboRotate, ilboApplyICCProfile]);
      try
        if BitmapParam <> nil then
        begin
          StrParam := FileName;
          SynchronizeEx(ReplaceBigBitmap);
        end;
      finally
        F(BitmapParam);
      end;
    end;
  finally
    F(Info);
  end;
end;

procedure TSearchBigImagesLoaderThread.InitializeLoadingBigImages;
begin
  with (FSender as TSearchForm) do
    // Saving text information
    (FSender as TSearchForm).TbStopOperation.Enabled := True;
end;

function TSearchBigImagesLoaderThread.IsVirtualTerminate: Boolean;
begin
  Result := not FMainThread;
end;

procedure TSearchBigImagesLoaderThread.FileNameExists;
begin
  BoolParam := (FSender as TSearchForm).FileNameExistsInList(StrParam);
end;

procedure TSearchBigImagesLoaderThread.GetVisibleFiles;
begin
  FVisibleFiles := (FSender as TSearchForm).GetVisibleItems;
end;

procedure TSearchBigImagesLoaderThread.ReplaceBigBitmap;
begin
  if (FSender as TSearchForm).ReplaceBitmapWithPath(StrParam, BitmapParam) then
    BitmapParam := nil;
end;

destructor TSearchBigImagesLoaderThread.Destroy;
begin
  F(FData);
  inherited;
end;

procedure TSearchBigImagesLoaderThread.DoMultiProcessorTask;
begin
  if Mode <> 0 then
    ExtractBigImage(PictureSize, FImageFileName, ImageRotation);
end;

procedure TSearchBigImagesLoaderThread.EndLoading;
begin
  if (FSender as TSearchForm).TbStopOperation.Enabled then
    (FSender as TSearchForm).TbStopOperation.Click;
end;

end.
