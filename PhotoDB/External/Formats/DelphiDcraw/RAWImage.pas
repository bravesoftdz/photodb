unit RAWImage;

interface

uses  Windows, Messages, SysUtils, Graphics, Classes, FileCtrl, GraphicEX, Forms,
      uScript, UnitScripts, uConstants, uFileUtils, uTime,
      FreeBitmap, FreeImage, GraphicsBaseTypes;

type
  TRAWImage = class(TBitmap)
  protected
    FWidth : Integer;
    FHeight : Integer;
    FIsPreview: Boolean;
    function GetWidth : Integer; override;
    function GetHeight : Integer; override;
  private
    procedure SetIsPreview(const Value: boolean);
    procedure LoadFromFreeImage(Image : TFreeBitmap);
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure LoadFromFile(const Filename: string); override;
    function LoadThumbnailFromFile(const FileName : string; Width, Height : Integer) : boolean;
    procedure Assign(Source : TPersistent); override;
    property IsPreview : Boolean read FIsPreview write SetIsPreview;
    property GraphicWidth: Integer read FWidth;
    property GraphicHeight: Integer read FHeight;
  end;

  TRAWExifRecord = class(TObject)
  private
    FDescription : string;
    FKey : string;
    FValue : string;
  public
    property Key : string read FKey write FKey;
    property Value : string read FValue write FValue;
    property Description : string read FDescription write FDescription;
  end;

  TRAWExif = class(TObject)
  private
    FExifList : TList;
    function GetCount: Integer;
    function GetValueByIndex(Index: Integer): TRAWExifRecord;
    function GetTimeStamp: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Description, Key, Value : string) : TRAWExifRecord;
    function IsEXIF : Boolean;
    property TimeStamp : TDateTime read GetTimeStamp;
    property Count : Integer read GetCount;
    property Items[Index: Integer]: TRAWExifRecord read GetValueByIndex; default;
  end;

  function ReadRAWExif(FileName : String) : TRAWExif;

var
  IsRAWSupport : Boolean = True;

implementation

uses
  Dolphin_DB, UnitDBCommon;

const
  RAW_DISPLAY = 2;
  RAW_PREVIEW = 1;

{ TRAWImage }

function ReadRAWExif(FileName : String) : TRAWExif;
var
  RawBitmap : TFreeWinBitmap;
  FindMetaData : PFIMETADATA;
  I : Integer;
  TagData : PFITAG;

  procedure AddTag;
  var
    Description, Value, Key : PAnsiChar;
  begin
    Description := FreeImage_GetTagDescription(TagData);
    Key := FreeImage_GetTagKey(TagData);
    if (Key <> 'Artist') and (Description <> 'Image title') then
    begin
      Value := FreeImage_TagToString(I, TagData);
      if Description <> nil then
        Result.Add(string(Description), string(Key), string(Value))
      else
        Result.Add(string(Key), string(Key), string(Value));
    end;
  end;
begin
  Result := TRAWExif.Create;

  TagData := nil;
  RawBitmap := TFreeWinBitmap.Create;
  try
    RawBitmap.LoadU(Filename, RAW_PREVIEW);
    for I := FIMD_NODATA to FIMD_CUSTOM do
    begin
      FindMetaData := FreeImage_FindFirstMetadata(I, RawBitmap.Dib, TagData);
      try
        if FindMetaData <> nil then
        begin
          AddTag;

          while FreeImage_FindNextMetadata(FindMetaData, TagData) do
            AddTag;
        end;
      finally
        RawBitmap.FindCloseMetadata(FindMetaData);
      end;
    end;
  finally
    RawBitmap.Free;
  end;
end;

procedure TRAWImage.Assign(Source: TPersistent);
begin
  if Source is TRAWImage then
  begin
    //for crypting - loading private variables width and height
    FWidth := (Source as TRAWImage).FWidth;
    FHeight := (Source as TRAWImage).FHeight;
    FIsPreview := (Source as TRAWImage).FIsPreview;
  end;
  inherited Assign(Source);
end;

constructor TRAWImage.Create;
begin
  inherited;
  FreeImageInit;
  FIsPreview := False;
end;

function TRAWImage.GetHeight: integer;
begin
  if FIsPreview then
    Result := FHeight * 2
  else
    Result := FHeight;
end;

function TRAWImage.GetWidth: integer;
begin
  if FIsPreview then
    Result := FWidth * 2
  else
    Result := FWidth;
end;

procedure TRAWImage.LoadFromFile(const Filename: string);
var
  RawBitmap : TFreeWinBitmap;
begin
  RawBitmap := TFreeWinBitmap.Create;
  try
    if FIsPreview then
      RawBitmap.LoadU(Filename, RAW_PREVIEW)
    else
      RawBitmap.LoadU(Filename, RAW_DISPLAY);
    RawBitmap.ConvertTo24Bits;
    fWidth := RawBitmap.GetWidth;
    fHeight := RawBitmap.GetHeight;
    LoadFromFreeImage(RawBitmap);
  finally
    RawBitmap.Free;
  end;
end;

procedure TRAWImage.LoadFromStream(Stream: TStream);
var
  RawBitmap : TFreeWinBitmap;
  MemIO: TFreeMemoryIO;
  Data: PByte;
begin
  RawBitmap := TFreeWinBitmap.Create;
  try
    if Stream is TMemoryStream then
    begin
      Data := TMemoryStream(Stream).Memory;
      MemIO := TFreeMemoryIO.Create(Data, Stream.Size);
      try
        if FIsPreview then
          RawBitmap.LoadFromMemory(MemIO, RAW_PREVIEW)
        else
          RawBitmap.LoadFromMemory(MemIO, RAW_DISPLAY);
      finally
        MemIO.Free;
      end;
    end else
    begin
      if FIsPreview then
        RawBitmap.LoadFromStream(Stream, RAW_PREVIEW)
      else
        RawBitmap.LoadFromStream(Stream, RAW_DISPLAY);
    end;
    RawBitmap.ConvertTo24Bits;
    fWidth := RawBitmap.GetWidth;
    fHeight := RawBitmap.GetHeight;
    LoadFromFreeImage(RawBitmap);
  finally
    RawBitmap.Free;
  end;
end;

procedure TRAWImage.LoadFromFreeImage(Image: TFreeBitmap);
var
  I, J : Integer;
  PS, PD : PARGB;
  W, H : integer;
begin
  PixelFormat := pf24Bit;
  W := Image.GetWidth;
  H := Image.GetHeight;
  Width := W;
  Height := H;

  for I := 0 to H - 1 do
  begin
    PS := PARGB(Image.GetScanLine(H - I - 1));
    PD := ScanLine[I];
    for J := 0 to W - 1 do
      PD[J] := PS[J];
  end;
end;

function TRAWImage.LoadThumbnailFromFile(const FileName: string; Width, Height : Integer): boolean;
var
  RawBitmap : TFreeWinBitmap;
  RawThumb : TFreeWinBitmap;
  W, H : Integer;
begin
  Result := True;
  RawBitmap := TFreeWinBitmap.Create;
  try
    RawBitmap.LoadU(Filename, RAW_PREVIEW);
    RawThumb := TFreeWinBitmap.Create;
    try
      fWidth := RawBitmap.GetWidth;
      fHeight := RawBitmap.GetHeight;
      W := fWidth;
      H := fHeight;
      ProportionalSize(Width, Height, W, H);
      RawBitmap.MakeThumbnail(W, H, RawThumb);
      LoadFromFreeImage(RawThumb);
    finally
      RawThumb.Free;
    end;
  finally
    RawBitmap.Free;
  end;
end;

procedure TRAWImage.SetIsPreview(const Value: boolean);
begin
  FIsPreview := Value;
end;

{ TRAWExif }

function TRAWExif.Add(Description, Key, Value: string) : TRAWExifRecord;
begin
  Result := TRAWExifRecord.Create;
  Result.Description := Description;
  Result.Key := Key;
  Result.Value := Value;
  FExifList.Add(Result);
end;

constructor TRAWExif.Create;
begin
  FExifList := TList.Create;
end;

destructor TRAWExif.Destroy;
var
  I : Integer;
begin
  for I := 0 to FExifList.Count - 1 do
    TRAWExifRecord(FExifList[I]).Free;
  FExifList.Free;
  inherited;
end;

function TRAWExif.GetCount: Integer;
begin
  Result := FExifList.Count;
end;

function TRAWExif.GetTimeStamp: TDateTime;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Count - 1 do
    if Self[I].Key = 'DateTime' then
        Result := EXIFDateToDate(Self[I].Value) + EXIFDateToTime(Self[I].Value);
end;

function TRAWExif.GetValueByIndex(Index: Integer): TRAWExifRecord;
begin
  Result := FExifList[Index];
end;

function TRAWExif.IsEXIF: Boolean;
begin
  Result := Count > 0;
end;

initialization

  TPicture.RegisterFileFormat('crw', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('cr2', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('nef', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('raf', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('dng', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('mos', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('kdc', 'Camera RAW Images', TRAWImage);
  TPicture.RegisterFileFormat('dcr', 'Camera RAW Images', TRAWImage);

finalization

  TPicture.UnregisterGraphicClass(TRAWImage);

end.
