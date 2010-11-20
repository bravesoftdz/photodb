unit UnitPrinterTypes;

interface

{$DEFINE PHOTODB}

uses Windows, SysUtils, Math, Graphics, Printers, Classes, ComObj, ULogger,
  Dolphin_DB, GraphicCrypt, GraphicsBaseTypes, UnitDBCommonGraphics,
  ImageConverting, ActiveX;

type

  TCallBackPrinterGeneratePreviewProc = procedure(Progress: Byte; var Terminate: Boolean) of object;

  TPaperSize = (TPS_A4, TPS_B5, TPS_CAN13X18, TPS_CAN10X15, TPS_CAN9X13, TPS_OTHER);

  TPrintSampleSizeOne = (TPSS_FullSize, TPSS_C35, TPSS_20X25C1, TPSS_13X18C2, TPSS_13X18C1, TPSS_10X15C1, TPSS_10X15C2,
    TPSS_10X15C3, TPSS_9X13C1, TPSS_9X13C4, TPSS_9X13C2, TPSS_C9, TPSS_CUSTOM, TPSS_3X4C6, TPSS_4X6C4);

  TPrintSampleSize = set of TPrintSampleSizeOne;

  TGenerateImageOptions = record
    VirtualImage: Boolean;
    Image: TBitmap;
    CropImages: Boolean;
    FreeCenterSize: Boolean;
    FreeWidthPx: Integer;
    FreeHeightPx: Integer;
  end;

type
  TMargins = record
    Left, Top, Right, Bottom: Double
  end;

type
  TXSize = record
    Width, Height: Extended
  end;

function GetCID : string;
function GenerateImage(FullImage : Boolean; Width, Height : Integer; SampleImage : TBitmap;
Files : TStrings; SampleImageType: TPrintSampleSizeOne; Options : TGenerateImageOptions; CallBack : TCallBackPrinterGeneratePreviewProc = nil) : TBitmap;
function GetPixelsPerInch : TXSize;
function InchToCm(Pixel: Single): Single;
function CmToInch(Pixel: Single): Single;
function GetPaperSize : TPaperSize;
function MmToPix(Size : TXSize) : TXSize;
function XSize(Width,Height : extended) : TXSize;
function PixToSm(Size : TXSize) : TXSize;
function PixToIn(Size : TXSize) : TXSize;

implementation

function XSize(Width,Height : extended) : TXSize;
begin
 Result.Width:=Width;
 Result.Height:=Height;
end;

function MmToPix(Size : TXSize) : TXSize;
var
  Inch, PixelsPerInch : TXSize;
begin
 PixelsPerInch:=GetPixelsPerInch;
 Inch.Width:=CmToInch(Size.Width/10);
 Inch.Height:=CmToInch(Size.Height/10);
 Result.Width:=Inch.Width*PixelsPerInch.Width;
 Result.Height:=Inch.Height*PixelsPerInch.Height;
end;

function PixToSm(Size : TXSize) : TXSize;
var
  Inch, PixelsPerInch : TXSize;
begin
 PixelsPerInch:=GetPixelsPerInch;
 Inch.Width:=Size.Width/PixelsPerInch.Width;
 Inch.Height:=Size.Height/PixelsPerInch.Height;
 Result.Width:=InchToCm(Inch.Width);
 Result.Height:=InchToCm(Inch.Height);
end;

function PixToIn(Size : TXSize) : TXSize;
var
  PixelsPerInch : TXSize;
begin
 PixelsPerInch:=GetPixelsPerInch;
 Result.Width:=Size.Width/PixelsPerInch.Width;
 Result.Height:=Size.Height/PixelsPerInch.Height;
end;

function GetCID : string;
var
  CID : TGUID;
begin
 CoCreateGuid(CID);
 Result:=GUIDToString(CID);
end;

procedure CropImageOfHeight(CroppedHeight : Integer; var Bitmap : TBitmap);
var
  i,j, dy : integer;
  Xp : array of PARGB;
begin
 Bitmap.PixelFormat:=pf24bit;
 SetLength(Xp,Bitmap.height);
 if Bitmap.Height*Bitmap.Width=0 then exit;
 if CroppedHeight=Bitmap.Height then exit;
 for i:=0 to Bitmap.Height-1 do
 Xp[i]:=Bitmap.ScanLine[i];
 dy:=Bitmap.Height div 2 - CroppedHeight div 2;
 for i:=0 to CroppedHeight-1 do
 for j:=0 to Bitmap.Width-1 do
 begin
  Xp[i,j]:=Xp[i+dy,j];
 end;
 Bitmap.Height:=CroppedHeight;
end;

procedure CropImageOfWidth(CroppedWidth : Integer; var Bitmap : TBitmap);
var
  i,j, dx : integer;
  Xp : array of PARGB;
begin
 Bitmap.PixelFormat:=pf24bit;
 SetLength(Xp,Bitmap.height);
 if Bitmap.Height*Bitmap.Width=0 then exit;
 if CroppedWidth=Bitmap.Width then exit;
 for i:=0 to Bitmap.Height-1 do
 Xp[i]:=Bitmap.ScanLine[i];
 dx:=Bitmap.Width div 2 - CroppedWidth div 2;
 for i:=0 to Bitmap.Height-1 do
 for j:=0 to CroppedWidth do
 begin
  Xp[i,j]:=Xp[i,j+dx];
 end;
 Bitmap.Width:=CroppedWidth;
end;

procedure CropImage(aWidth, aHeight : Integer; var Bitmap : TBitmap);
var
  temp : Integer;
begin
 if aHeight=0 then exit;
 if (((aWidth/aHeight)>1) and ((Bitmap.Width/Bitmap.Height)<1)) or
 (((aWidth/aHeight)<1) and ((Bitmap.Width/Bitmap.Height)>1)) then
 begin
  temp:=aWidth;
  aWidth:=aHeight;
  aHeight:=temp;
 end;
 if Bitmap.Width/Bitmap.Height<aWidth/aHeight then
 begin
  CropImageOfHeight(Round(Bitmap.Width*(aHeight/aWidth)),Bitmap);
 end else
 begin
  CropImageOfWidth(Round(Bitmap.Height*(aWidth/aHeight)),Bitmap);
 end;
end;

procedure ProportionalSize(aWidth, aHeight: Integer; var aWidthToSize, aHeightToSize: Integer);
begin
// If Max(aWidthToSize,aHeightToSize)<Min(aWidth,aHeight) then
{ If (aWidthToSize<aWidth) and (aHeightToSize<aHeight) then
 begin
  Exit;
 end;  }
 if aWidthToSize*aWidth=0 then exit;
 if (aWidthToSize = 0) or (aHeightToSize = 0) then
 begin
  aHeightToSize := 0;
  aWidthToSize  := 0;
 end else begin
  if (aHeightToSize/aWidthToSize) < (aHeight/aWidth) then
  begin
   aHeightToSize := Round ( (aWidth/aWidthToSize) * aHeightToSize );
   aWidthToSize  := aWidth;
  end else begin
   aWidthToSize  := Round ( (aHeight/aHeightToSize) * aWidthToSize );
   aHeightToSize := aHeight;
  end;
 end;
end;

procedure GetPrinterMargins(var Margins: TMargins);
var
  PixelsPerInch: TPoint;
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Margins.Top := OffsetStart.y / PixelsPerInch.y;
  // Left Margin
  Margins.Left := OffsetStart.x / PixelsPerInch.x;
  // Bottom Margin
  Margins.Bottom := ((PhysPageSize.y - PageRes.y) / PixelsPerInch.y) -
    (OffsetStart.y / PixelsPerInch.y);
  // Right Margin
  Margins.Right := ((PhysPageSize.x - PageRes.x) / PixelsPerInch.x) -
    (OffsetStart.x / PixelsPerInch.x);
end;

function InchToCm(Pixel: Single): Single;
// Convert inch to Centimeter
begin
  Result := Pixel * 2.54
end;

function CmToInch(Pixel: Single): Single;
// Convert Centimeter to inch
begin
  Result := Pixel / 2.54
end;

function GetPixelsPerInch : TXSize;
begin
  Result.Height := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  Result.Width := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
end;

function SizeIn(X, A,B : Extended) : Boolean;
begin
 Result:=((X>A) and (X<B));
end;

function GetPaperSize : TPaperSize;
var
  PixInInch, PageSizeMm : TXSize;
begin
 PixInInch:=GetPixelsPerInch;
 PageSizeMm.Width:=InchToCm(Printer.PageWidth*10/PixInInch.Width);
 PageSizeMm.Height:=InchToCm(Printer.PageHeight*10/PixInInch.Height);
 if SizeIn(PageSizeMm.Width,200,220) and SizeIn(PageSizeMm.Height,270,300) then
 begin
  Result:=TPS_A4;
  exit;
 end;
 if SizeIn(PageSizeMm.Width,170,182) and SizeIn(PageSizeMm.Height,235,260) then
 begin
  Result:=TPS_B5;
  exit;
 end;
 if (Min(PageSizeMm.Width,PageSizeMm.Height)>=130) and (Max(PageSizeMm.Width,PageSizeMm.Height)>=180) then
 begin
  Result:=TPS_CAN13X18;
  exit;
 end;
 if (Min(PageSizeMm.Width,PageSizeMm.Height)>=100) and (Max(PageSizeMm.Width,PageSizeMm.Height)>=150) then
 begin
  Result:=TPS_CAN10X15;
  exit;
 end;
 if (Min(PageSizeMm.Width,PageSizeMm.Height)>=90) and (Max(PageSizeMm.Width,PageSizeMm.Height)>130) then
 begin
  Result:=TPS_CAN9X13;
  exit;
 end; Result:=TPS_OTHER;
end;

procedure Rotate90A(var im : tbitmap);
var
 i, j : integer;
 p1 : pargb;
 p : array of pargb;
 image : tbitmap;
begin
 im.PixelFormat:=pf24bit;
 image:=tbitmap.create;
 image.PixelFormat:=pf24bit;
 image.Assign(im);
 im.Width:=image.Height;
 im.Height:=image.Width;
 setlength(p,image.Width);
 for i:=0 to image.Width-1 do
 p[i]:=im.ScanLine[i];
 for i:=0 to image.Height-1 do
 begin
  p1:=image.ScanLine[image.Height-i-1];
  for j:=0 to image.Width-1 do
  begin
   p[j,i].r:=p1[j].r;
   p[j,i].g:=p1[j].g;
   p[j,i].b:=p1[j].b;
  end;
 end;
 image.Free;
end;

function GenerateImage(FullImage: Boolean; Width, Height: Integer; SampleImage: TBitmap; Files: TStrings;
  SampleImageType: TPrintSampleSizeOne; Options: TGenerateImageOptions;
  CallBack: TCallBackPrinterGeneratePreviewProc = nil): TBitmap;
var
  AWidth, AHeight, I, J, W, H, Aw, Ah, TopSize: Integer;
  SmallImage: TBitmap;
  Graphic: TGraphic;
  PrSize, Size: TXSize;
  Pos, Ainc: Integer;
  Terminating: Boolean;


  function LoadPicture(var Graphic: TGraphic; FileName: string): Boolean;
  var
    PassWord: string;
    GraphicClass : TGraphicClass;
  begin
    Result := False;
    Graphic := nil;
    try
      if ValidCryptGraphicFile(FileName) then
      begin
        PassWord := DBKernel.FindPasswordForCryptImageFile(FileName);
        if PassWord <> '' then
          Graphic := DeCryptGraphicFile(FileName, PassWord);

        Result := Graphic <> nil;
      end else
      begin
        GraphicClass := GetGraphicClass(ExtractFileExt(FileName), False);

        if Graphic <> nil then
        begin
          Graphic := GraphicClass.Create;
          Graphic.LoadFromFile(FileName);
        end else
          Exit;
      end;
      Result := True;
    except
      on e : Exception do
        EventLog(e.Message);
    end;
  end;

  procedure CenterImageSize(imWidth, imHeight : Integer);
  begin
   if FullImage then
   begin
    if not Options.VirtualImage then
    begin
     LoadPicture(Graphic,Files[0]);
     if Assigned(CallBack) then CallBack(Round(100*(1/7)),Terminating);
     if Terminating then begin Graphic.free; exit; end;
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Graphic);
     if Assigned(CallBack) then CallBack(Round(100*(2/7)),Terminating);
     Graphic.free;
     if Terminating then begin if FullImage then SampleImage.Free; exit; end;
     end else
    begin
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Options.Image);
     if Assigned(CallBack) then CallBack(Round(100*(2/7)),Terminating);
     if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    end;
   end;
   if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
   ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
   Rotate90A(SampleImage);
   if Assigned(CallBack) then CallBack(Round(100*(3/7)),Terminating);
   if Terminating then begin if FullImage then SampleImage.Free; exit; end;
   if Options.CropImages then CropImage(imWidth,imHeight,SampleImage);
   if Assigned(CallBack) then CallBack(Round(100*(4/7)),Terminating);
   if Terminating then begin if FullImage then SampleImage.Free; exit; end;
   aWidth:=SampleImage.Width;
   aHeight:=SampleImage.Height;
   if FullImage then
   begin
    Size:=MmToPix(XSize(imWidth,imHeight));
   end else
   begin
    Size:=MmToPix(XSize(imWidth,imHeight));
    PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
    Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
   end;
   ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
   if aWidth/SampleImage.Width<1 then
   StretchCool(Result.Width div 2 - aWidth div 2,Result.Height div 2 - aHeight div 2,aWidth,aHeight,SampleImage,Result) else
   Interpolate(Result.Width div 2 - aWidth div 2,Result.Height div 2 - aHeight div 2,aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
   if FullImage then SampleImage.Free;
   if Assigned(CallBack) then CallBack(Round(100*(7/7)),Terminating);
  end;

  procedure ImageSizeTwo(imWidth, imHeight : Integer);
  var
    i : integer;
  begin
   for i:=0 to 1 do
   begin
    if FullImage then
    begin
     if (Files.Count=1) and (i=1) then Continue;
     LoadPicture(Graphic,Files[i]);
     if Assigned(CallBack) then CallBack(Round(100*((1+i*7)/14)),Terminating);
     if Terminating then begin Graphic.Free; exit; end;
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Graphic);
     if Assigned(CallBack) then CallBack(Round(100*((2+i*7)/14)),Terminating);
     Graphic.free;
     if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    end;
    if ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)<1) or
    ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)>1) then
    Rotate90A(SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*((3+i*7)/14)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if Options.CropImages then CropImage(imWidth,imHeight,SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*((4+i*7)/14)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    if FullImage then
    begin
     Size:=MmToPix(XSize(imWidth,imHeight));
    end else
    begin
     Size:=MmToPix(XSize(imWidth,imHeight));
     PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
     Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
    end;
    ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
    if aWidth/SampleImage.Width<1 then
    StretchCool(Result.Width div 2 - aWidth div 2,(Result.Height div 4+(Result.Height div 2)*i) - aHeight div 2,aWidth,aheight,SampleImage,Result) else
    Interpolate(Result.Width div 2 - aWidth div 2,(Result.Height div 4+(Result.Height div 2)*i) - aHeight div 2,aWidth,aheight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
    if Assigned(CallBack) then CallBack(Round(100*((7+i*7)/14)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if FullImage then SampleImage.Free;
   end;
  end;

begin
 if Options.VirtualImage then
 begin
  if Options.Image=nil then exit;
  if Options.Image.Empty then exit;
 end;

 Pos:=0;
 Terminating:=false;
 Result:=TBitmap.Create;
 Result.PixelFormat:=pf24bit;
 Result.Width:=Width;
 Result.Height:=Height;

 try
  if not FullImage then
  begin
   Result.Canvas.Brush.Color:=$EEEEEE;
   Result.Canvas.Pen.Color:=$0;
   Result.Canvas.Rectangle(0,0,Width,Height);
  end;
  SmallImage:=TBitmap.Create;
  SmallImage.PixelFormat:=pf24bit;

  Case SampleImageType of

  TPSS_FullSize :
  begin
   if FullImage then
   begin
    if not Options.VirtualImage then
    begin
     LoadPicture(Graphic,Files[0]);
     if Assigned(CallBack) then CallBack(Round(100*(1/5)),Terminating);
     if Terminating then begin Graphic.free; exit; end;
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Graphic);
     Graphic.free;
    end else
    begin
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Options.Image);
     if Assigned(CallBack) then CallBack(Round(100*(1/5)),Terminating);
    end;
   end;
   if Assigned(CallBack) then CallBack(Round(100*(2/5)),Terminating);
   if Terminating then begin SampleImage.free; exit; end;
   if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
   ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
   Rotate90A(SampleImage);
   if Assigned(CallBack) then CallBack(Round(100*(3/5)),Terminating);
   if Terminating then begin SampleImage.free; exit; end;
   aWidth:=SampleImage.Width;
   aHeight:=SampleImage.Height;
   ProportionalSize(Result.Width,Result.Height,aWidth,aHeight);
   if aWidth/SampleImage.Width<1 then
   StretchCool(Result.Width div 2 - aWidth div 2,Result.Height div 2 - aHeight div 2,aWidth,aheight,SampleImage,Result) else
   Interpolate(Result.Width div 2 - aWidth div 2,Result.Height div 2 - aHeight div 2,aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
   if Assigned(CallBack) then CallBack(Round(100*(4/4)),Terminating);
   if FullImage then SampleImage.Free;
  end;

 TPSS_C35:
  begin
   if not FullImage then
   begin
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    ProportionalSize(Result.Width div 6,Result.Height div 8,aWidth,aHeight);
    StretchCool(aWidth,aheight,SampleImage,SmallImage);
    w:=(Result.Width div 5);
    h:=(Result.Height div 7);
    for i:=1 to 7 do
    for j:=1 to 5 do
    Result.Canvas.Draw(w*(j-1)+w div 2-SmallImage.Width div 2,h*(i-1)+h div 2-SmallImage.Height div 2,SmallImage);
   end else
   begin
    SampleImage:=TBitmap.Create;
    SampleImage.PixelFormat:=pf24bit;
    w:=(Result.Width div 5);
    h:=(Result.Height div 7);
    for i:=1 to 7 do
    for j:=1 to 5 do
    begin
     if Files.Count<(i-1)*5+j then exit;
     LoadPicture(Graphic,Files[(i-1)*5+j-1]);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(5*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.free; exit; end;
     SampleImage.Assign(Graphic);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(5*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.free; exit; end;
     aWidth:=SampleImage.Width;
     aHeight:=SampleImage.Height;
     ProportionalSize(Result.Width div 6,Result.Height div 8,aWidth,aHeight);
     if aWidth/SampleImage.Width<1 then
     StretchCool(w*(j-1)+w div 2-aWidth div 2,h*(i-1)+h div 2-aHeight div 2,aWidth,aheight,SampleImage,Result) else
     interpolate(w*(j-1)+w div 2-aWidth div 2,h*(i-1)+h div 2-aHeight div 2,aWidth,aheight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);

     inc(Pos,3);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(5*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.free; exit; end;
    end;
    SampleImage.free;
    Graphic.free;
   end;
  end;

  TPSS_20X25C1 :
  begin
   CenterImageSize(200,250);
  end;

  TPSS_13X18C1:
  begin
   CenterImageSize(130,180);
  end;

  TPSS_10X15C1:
  begin
   CenterImageSize(100,150);
  end;

  TPSS_9X13C1:
  begin
   CenterImageSize(90,130);
  end;

  TPSS_13X18C2:
  begin
   ImageSizeTwo(180,130);
  end;

  TPSS_10X15C2:
  begin
   ImageSizeTwo(150,100);
  end;

  TPSS_9X13C2:
  begin
   ImageSizeTwo(130,90);
  end;

  TPSS_10X15C3:
  begin
   for i:=0 to 2 do
   begin
    if FullImage then
    begin
     if i>=Files.Count then Continue;
     LoadPicture(Graphic,Files[i]);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(7*Files.Count))),Terminating);
     if Terminating then begin Graphic.free; exit; end;
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Graphic);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(7*Files.Count))),Terminating);
     Graphic.free;
     if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    end;
    Case i of
    0 :
     if ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)<1) or
     ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)>1) then
     Rotate90A(SampleImage);
    1,2 :
     if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
     ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
     Rotate90A(SampleImage);
    end;
    inc(Pos);
    if Assigned(CallBack) then CallBack(Round(100*(Pos/(7*Files.Count))),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    case i of
     0 : begin aw:=150; ah:=100; end;
     1 : begin aw:=100; ah:=150; end;
     2 : begin aw:=100; ah:=150; end;
     else begin aw:=150; ah:=100; end;
    end;
    if Options.CropImages then CropImage(aw,ah,SampleImage);
    inc(Pos);
    if Assigned(CallBack) then CallBack(Round(100*(Pos/(7*Files.Count))),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    if FullImage then
    begin
     Size:=MmToPix(XSize(aw,ah));
    end else
    begin
     Size:=MmToPix(XSize(aw,ah));
     PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
     Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
    end;
    ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
    if FullImage then
    TopSize:=Round(MmToPix(XSize(10,10)).Height) else
    TopSize:=Round((MmToPix(XSize(10,10)).Height/Printer.PageHeight)*Result.Height);

    Case i of
    0 :
     begin
      if FullImage then
      h:=Result.Height - aHeight - Round(MmToPix(XSize(10,10)).Height) else
      h:=Result.Height - aHeight - Round((MmToPix(XSize(10,10)).Height/Printer.PageHeight)*Result.Height);

      if aWidth/SampleImage.Width<1 then
      StretchCool(Result.Width div 2 - aWidth div 2,h,aWidth,aHeight,SampleImage,Result) else
      Interpolate(Result.Width div 2 - aWidth div 2,h,aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
     end;
    1 :
     begin
      //if FullImage then
      //h:=Result.Height - aHeight - Round(MmToPix(XSize(10,10)).Height) else
      //h:=Result.Height - aHeight - Round((MmToPix(XSize(10,10)).Height/Printer.PageHeight)*Result.Height);

      if FullImage then ainc:=0 else ainc:=1;
      if aWidth/SampleImage.Width<1 then
      StretchCool(Result.Width div 4 - aWidth div 2+ainc,TopSize{h div 2 - aHeight div 2},aWidth,aHeight,SampleImage,Result) else
      Interpolate(Result.Width div 4 - aWidth div 2+ainc,TopSize{h div 2 - aHeight div 2},aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
     end;
    2 :
     begin
      //if FullImage then
      //h:=Result.Height - aHeight - Round(MmToPix(XSize(10,10)).Height) else
      //h:=Result.Height - aHeight - Round((MmToPix(XSize(10,10)).Height/Printer.PageHeight)*Result.Height);

      if FullImage then ainc:=0 else ainc:=1;
      if aWidth/SampleImage.Width<1 then
      StretchCool((Result.Width div 4)*3 - aWidth div 2+ainc,TopSize{h div 2 - aHeight div 2},aWidth,aHeight,SampleImage,Result) else
      Interpolate((Result.Width div 4)*3 - aWidth div 2+ainc,TopSize{h div 2 - aHeight div 2},aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
     end;
    end;
    inc(Pos,3);
    if Assigned(CallBack) then CallBack(Round(100*(Pos/(7*Files.Count))),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if FullImage then SampleImage.free;
    SmallImage.Height:=0;
    SmallImage.Width:=0;
   end;

  end;

  TPSS_9X13C4:
  begin
   for j:=0 to 1 do
   for i:=0 to 1 do
   begin
    if FullImage then
    begin
     if j*2+i>=Files.Count then Continue;
     LoadPicture(Graphic,Files[j*2+i]);
     if Assigned(CallBack) then CallBack(Round(100*((1+(j*2+i)*7)/28)),Terminating);
     if Terminating then begin Graphic.Free; exit; end;
     SampleImage:=TBitmap.Create;
     SampleImage.PixelFormat:=pf24bit;
     SampleImage.Assign(Graphic);
     if Assigned(CallBack) then CallBack(Round(100*((2+(j*2+i)*7)/28)),Terminating);
     Graphic.free;
     if Terminating then begin SampleImage.Free; exit; end;
    end;
    if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
    ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
    Rotate90A(SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*((3+(j*2+i)*7)/28)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if Options.CropImages then CropImage(90,130,SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*((4+(j*2+i)*7)/28)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    if FullImage then
    begin
     Size:=MmToPix(XSize(90,130));
    end else
    begin
     Size:=MmToPix(XSize(90,130));
     PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
     Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
    end;
    ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
    if aWidth/SampleImage.Width<1 then
    StretchCool(Result.Width div 4+(Result.Width div 2)*i - aWidth div 2,Result.Height div 4+(Result.Height div 2)*j - aHeight div 2,aWidth,aHeight,SampleImage,Result) else
    Interpolate(Result.Width div 4+(Result.Width div 2)*i - aWidth div 2,Result.Height div 4+(Result.Height div 2)*j - aHeight div 2,aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
    if Assigned(CallBack) then CallBack(Round(100*((7+(j*2+i)*7)/28)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if FullImage then SampleImage.free;
   end;
  end;

  TPSS_C9:
  begin
   if not FullImage then
   begin
    if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
    ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
    Rotate90A(SampleImage);
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    ProportionalSize(Result.Width div 4,Result.Height div 4,aWidth,aHeight);
    StretchCool(aWidth,aheight,SampleImage,SmallImage);
    w:=(Result.Width div 3);
    h:=(Result.Height div 3);
    for i:=1 to 3 do
    for j:=1 to 3 do
    Result.Canvas.Draw(w*(j-1)+w div 2-SmallImage.Width div 2,h*(i-1)+h div 2-SmallImage.Height div 2,SmallImage);
   end else
   begin
    SampleImage:=TBitmap.Create;
    SampleImage.PixelFormat:=pf24bit;
    w:=(Result.Width div 3);
    h:=(Result.Height div 3);
    for i:=1 to 3 do
    for j:=1 to 3 do
    begin
     if Files.Count<(i-1)*3+j then exit;
     LoadPicture(Graphic,Files[(i-1)*3+j-1]);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(6*Files.Count))),Terminating);
     if Terminating then begin Graphic.Free; exit; end;
     SampleImage.Assign(Graphic);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(6*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.Free; exit; end;
     if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
     ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
     Rotate90A(SampleImage);
     inc(Pos);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(6*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.Free; exit; end;
     aWidth:=SampleImage.Width;
     aHeight:=SampleImage.Height;
     ProportionalSize(Result.Width div 4,Result.Height div 4,aWidth,aHeight);
     SmallImage.Height:=0;
     SmallImage.Width:=0;
     if aWidth/SampleImage.Width<1 then
     StretchCool(w*(j-1)+w div 2-aWidth div 2,h*(i-1)+h div 2-aHeight div 2,aWidth,aHeight,SampleImage,Result) else
     Interpolate(w*(j-1)+w div 2-aWidth div 2,h*(i-1)+h div 2-aHeight div 2,aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
     inc(Pos,3);
     if Assigned(CallBack) then CallBack(Round(100*(Pos/(6*Files.Count))),Terminating);
     if Terminating then begin SampleImage.Free; Graphic.Free; exit; end;
     end;
    SampleImage.free;
    Graphic.free;
   end;
  end;

  TPSS_CUSTOM:
  begin
   CenterImageSize(Round(PixToSm(XSize(Options.FreeWidthPx,0)).Width*10),Round(PixToSm(XSize(0,Options.FreeHeightPx)).Height*10));
  end;

  TPSS_4X6C4:
  begin
   begin
    if FullImage then
    begin
     if not Options.VirtualImage then
     begin
      LoadPicture(Graphic,Files[0]);
       if Assigned(CallBack) then CallBack(Round(100*(1/7)),Terminating);
      if Terminating then begin Graphic.Free; exit; end;
      SampleImage:=TBitmap.Create;
      SampleImage.PixelFormat:=pf24bit;
      SampleImage.Assign(Graphic);
      if Assigned(CallBack) then CallBack(Round(100*(2/7)),Terminating);
      Graphic.free;
      if Terminating then begin SampleImage.Free; exit; end;
     end else
     begin
      SampleImage:=TBitmap.Create;
      SampleImage.PixelFormat:=pf24bit;
      SampleImage.Assign(Options.Image);
      if Assigned(CallBack) then CallBack(Round(100*(3/7)),Terminating);
     end;
    end;
    if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
    ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
    Rotate90A(SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*(3/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if Options.CropImages then CropImage(40,60,SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*(4/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    if FullImage then
    begin
     Size:=MmToPix(XSize(40,60));
    end else
    begin
     Size:=MmToPix(XSize(40,60));
     PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
     Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
    end;
    ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
    for i:=-1 to 1 do
    for j:=-1 to 1 do
    begin
    if i*j=0 then continue;
    if aWidth/SampleImage.Width<1 then
    StretchCool(Result.Width div 2 - aWidth div 2+Round(i*aWidth*0.55),Result.Height div 2 - aHeight div 2+Round(j*aHeight*0.55),aWidth,aHeight,SampleImage,Result) else
    Interpolate(Result.Width div 2 - aWidth div 2+Round(i*aWidth*0.55),Result.Height div 2 - aHeight div 2+Round(j*aHeight*0.55),aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
    end;
    if Assigned(CallBack) then CallBack(Round(100*(7/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if FullImage then SampleImage.free;
   end;
  end;

  TPSS_3X4C6:
  begin
   begin
    if FullImage then
    begin
     if not Options.VirtualImage then
     begin
      LoadPicture(Graphic,Files[0]);
      if Assigned(CallBack) then CallBack(Round(100*(1/7)),Terminating);
      if Terminating then begin Graphic.Free; exit; end;
      SampleImage:=TBitmap.Create;
      SampleImage.PixelFormat:=pf24bit;
      SampleImage.Assign(Graphic);
      if Assigned(CallBack) then CallBack(Round(100*(2/7)),Terminating);
      Graphic.free;
      if Terminating then begin SampleImage.Free; exit; end;
     end else
     begin
      SampleImage:=TBitmap.Create;
      SampleImage.PixelFormat:=pf24bit;
      SampleImage.Assign(Options.Image);
      if Assigned(CallBack) then CallBack(Round(100*(3/7)),Terminating);
     end;
    end;
    if ((Result.Width/Result.Height)>1) and ((SampleImage.Width/SampleImage.Height)<1) or
    ((Result.Width/Result.Height)<1) and ((SampleImage.Width/SampleImage.Height)>1) then
    Rotate90A(SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*(3/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if Options.CropImages then CropImage(30,40,SampleImage);
    if Assigned(CallBack) then CallBack(Round(100*(4/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    aWidth:=SampleImage.Width;
    aHeight:=SampleImage.Height;
    if FullImage then
    begin
     Size:=MmToPix(XSize(30,40));
    end else
    begin
     Size:=MmToPix(XSize(30,40));
     PrSize:=xSize(Size.Width/Printer.PageWidth,Size.Height/Printer.PageHeight);
     Size:=xSize(Result.Width*PrSize.Width,Result.Height*PrSize.Height);
    end;
    ProportionalSize(Round(Size.Width),Round(Size.Height),aWidth,aHeight);
    for i:=-1 to 1 do
    for j:=-1 to 1 do
    if j<>0 then
    begin
    if aWidth/SampleImage.Width<1 then
    StretchCool(Result.Width div 2 - aWidth div 2+Round(i*aWidth*1.05),Result.Height div 2 - aHeight div 2+Round(j*aHeight*0.55),aWidth,aHeight,SampleImage,Result) else
    Interpolate(Result.Width div 2 - aWidth div 2+Round(i*aWidth*1.05),Result.Height div 2 - aHeight div 2+Round(j*aHeight*0.55),aWidth,aHeight,Rect(0,0,SampleImage.Width,SampleImage.Height),SampleImage,Result);
    end;
    if Assigned(CallBack) then CallBack(Round(100*(7/7)),Terminating);
    if Terminating then begin if FullImage then SampleImage.Free; exit; end;
    if FullImage then SampleImage.free;
   end;
  end;

  end;
 except
  on e : Exception do EventLog(':GenerateImage() throw exception: '+e.Message);
 end;
 SmallImage.free;
end;

end.
