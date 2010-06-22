unit DX_Alpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, ComCtrls, StdCtrls, ExtCtrls, jpeg, AppEvnts, Dolphin_DB, DDraw,
  language, Math, Effects, UnitDBCommonGraphics;

type
  TDirectShowForm = class(TForm)
    MouseTimer: TTimer;
    ApplicationEvents1: TApplicationEvents;
    DelayTimer: TTimer;
    FadeTimer: TTimer;
    DestroyTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Execute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowMouse;
    procedure HideMouse;
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ReTransForm(Alpha : byte);
    function FirstLoad : Boolean;
    procedure SetFirstImage(Image : TBitmap);
    procedure NewImage(Image : TBitmap);
    procedure DelayTimerTimer(Sender: TObject);
    procedure BeginFade;
    procedure FadeTimerTimer(Sender: TObject);
    procedure SetThreadImage(var Image : PByteArr);
    procedure LoadCurrentImage(XForward, Next : Boolean);
    procedure Pause;
    procedure Play;
    procedure Next(XForward : Boolean);
    procedure Previous;
    procedure DoClose;
    function CanSetImage : Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DestroyTimerTimer(Sender: TObject);
    function CallBack(CallbackInfo : TCallbackInfo) : TDirectXSlideShowCreatorCallBackResult;
  private
    FReady: boolean;
    FForwardThreadExists: boolean;
    FForwardFileName: String;
    procedure SetReady(const Value: boolean);
    procedure SetForwardThreadExists(const Value: boolean);
    procedure SetForwardFileName(const Value: String);
    { Private declarations }
  public
    fPlay : Boolean;
    SID : TGUID;
    ForwardSID : TGUID;
    FManager : TObject;
    FNowPaused : Boolean;
    FReadyAfterPause : Boolean;
    property Ready : boolean read FReady write SetReady;
    property ForwardThreadExists : boolean read FForwardThreadExists Write SetForwardThreadExists;
    property ForwardFileName : String read FForwardFileName Write SetForwardFileName;
    { Public declarations }
  end;

var
  DirectShowForm: TDirectShowForm;
  FDirectXShowTerminated : Boolean;
  FDirectXShowReadyForImage : Boolean;
  AlphaCount : Byte = 0;
  XAlphaCount : Extended;
    //�������� ��������� DirectDraw
  DirectDraw4: IDirectDraw4;
    //�������� (�������) �����������
  PrimarySurface: IDirectDrawSurface4;
    //����������� ��� ��������� WM_PAINT
  Offscreen: IDirectDrawSurface4;
    //����������� (���������) �����������
  Buffer : IDirectDrawSurface4;
    //���������� � �������� ����������
  BPP, RBM, GBM, BBM: integer;
    //�������, �������� ������ ������������
  TransSrc1, TransSrc2{, TempSrc, TempThreadScr} : PByteArr;
    //��������� ��������������
  TransHeight, TransPitch, TransSize: integer;
    //����� �������� ��������
  FileLoaded: boolean;
  ThreadDestroy : Boolean = false;
   SurfaceDesc: TDDSurfaceDesc2;
    Clpr: IDirectDrawClipper;
    AlphaSteeps : integer = 20;

implementation

{$R *.DFM}

//     �������� �����-������ � ������� ������������ ��� DIRECTDRAW
//
//     ���������: Windows 95/98
//     ����: Borland Delphi 5.0
//     ����������� � ����: ����
//     �������� �����: Delphi, DirectX, DirectDraw, transparency, alpha channel, emulation
//     ������: DX_alphachannel.dpr, DX_alphachannel.res, DX_Alpha.pas, DX_Alpha.dfm
//            + ������������ ����� DirectX 6.0 ��� Delphi (��. ����)
//
//     ���� ��� ������������ "AS IS" ��� �����-���� ��������!
//
//-----------------------------------------------------------------------------------------
//
//     �����: ����� "t_lambda" ������������, 2001
//     �������� ��������: http://t_lambda.chat.ru
//     E-mail: t_lambda@chat.ru
//
//-----------------------------------------------------------------------------------------
//
//� DirectDraw ��� �������� ������������. ��� ������� ������� ����������� DirectDraw
//� ������ DDSD_ALPHABITDEPTH ��� ������ �� ��������� (����� ��� � Direct3D
//�����-����� ��������). �������, ����� ������������ �������������� DirectX Media
//Transform (���� MetaCreations Color Fade), �� a) �� ��� ���� ������� �����, � b)
//������ ������� ������ �������������� ������� ��������������, � �� ������������
//���������������� �������.
//
//� ���� ������� ��������� ��� ����������� DirectDraw, �� ��� ����������� �������� �
//������� .bmp, ����� ���� ��������� �������� ������ � ������ ������������ � �������
//������� IDirectDrawSurface4.Lock. ����� � ����� ������� ����� ������ ��� ��� ������,
//� ��� ����� � ����������� �����-����� (������������). ������ ����������� ������������
//��� ��������� WM_PAINT. � �������� ��� ��� �� ���������, ��� MetaCreations Color Fade.
//
//��������� ���������� ���������� � �������� ���������� ������ � ��������� �������� ���
//���������� 16, 24 � 32 bpp. ��������� �� �������� ��� 256 ������. ��������� ��
//������������ WM_SIZE � ������ ������������� ��� ��������� ���������� ������ ���
//������� ����������� ������������� ����������� ���� ������������ (IDirectDrawSurface4.
//IsLost). � ���� ������� ���� �� ������� ��� ��������� DirectDraw � ������� ������,
//����� ���� ��������� ��� �������� � ������������������� ��������������. �� ��� ��
//�������, ��� ��� �������������� ���������.
//
//��������� ���������� ����� ddraw.pas, comswitch.inc � stringswitch.inc �� ���������
//������������ ������ DirectX 6.0, �������������� ��� Delphi Erik Unger:
//
//  http://www.delphi-jedi.org/DelphiGraphics/ E-Mail: Erik.Unger@gmx.at
//
//��� ���� ���� comswitch.inc ������ ��������� ������ {$DEFINE D2COM}, ��� ��� ���������
//���������� COM-������ Delphi 3 ��� ��������� �� ������� (��������, ��-�� ������� � ����
//����������� Delphi). �� ���� �� ������� ����� �������� ���� ole2.pas �� ��������� Delphi.
//
//-----------------------------------------------------------------------------------------
//
//     �������������� ����������:
//     1. Windows platform SDK
//     2. DirectX SDK
//     3. ������������ ����� DirectX 6.0 ��� Delphi:
//     http://www.delphi-jedi.org/DelphiGraphics/
//
//-----------------------------------------------------------------------------------------
//
//����������: ������-��, ����� ����� ���� ������ ��� ������� ���� ����������.
//�� ���-�� ���� ��� � ���� ����������� ����, ��� � ���� ������ �������...
//

uses  FloatPanelFullScreen, SlideShow, SlideShowFullScreen,
     UnitDirectXSlideShowCreator;

//� ���� ������ ����������� ������ �����������
//type TByteArr = array[0..0] of byte;

//����������� Offscreen �� ����� (�� WM_PAINT, � �������)
procedure UpdateSurface (ParentControl: TControl);
var r1, r2: TRect;
    p: TPoint;
    fx: TDDBltFx;
begin
  r1 := ParentControl.ClientRect;
  r2 := r1;
  //���������� ������� ����������� - ��������, ���������� Offscreen - ����������.
  //������� �����������...
  p := ParentControl.ClientToScreen (Point (0, 0));
  OffsetRect (r2, p.x, p.y);
  //...� ��������.
  FillChar (fx, sizeof (fx), 0);
  fx.dwSize := sizeof (fx);
  PrimarySurface.Blt (@r2, Offscreen, @r1, DDBLT_WAIT, @fx);
end;

//�������� ����� � ������ ��������� ���������� �������������
//(�������� RBM, GBM � BBM ��������� ��� �������� DirectDraw)
function PackColor (Color: TColor): TColor;
var r, g, b: integer;
begin
  Color := ColorToRGB (Color);
  b := (Color shr 16) and $FF;
  g := (Color shr 8) and $FF;
  r := Color and $FF;
  if BPP = 16 then begin
     r := r shr 3;
     g := g shr 3;
     b := b shr 3;
  end;
  Result := (r shl RBM) or (g shl GBM) or (b shl BBM);
end;

//������������� �����������.
//�� �������� ���������� � ��������� ������ ����� Lock � UnLock! ��� ��������!
procedure UnLock (Buffer: IDirectDrawSurface4);
begin
  if Buffer = nil then exit;
  Buffer.UnLock (nil);
end;

//���������� ����������� �� ������. �����, �������, ����������� ������, �� ���
//���������� ��������, � �������� ������ DDLOCK_READONLY ��� DDLOCK_WRITEONLY
//����� �� ��������� ������� ���-�� ��� ��������������...
//�� �������� ���������� � ��������� ������ ����� Lock � UnLock! ��� ��������!
procedure LockRead (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
begin
  if Buffer = nil then exit;
  ZeroMemory (@SurfaceDesc, sizeof (TDDSurfaceDesc2));
  SurfaceDesc.dwSize := sizeof (TDDSurfaceDesc2);
  Buffer.Lock (nil, SurfaceDesc, DDLOCK_WAIT or DDLOCK_SURFACEMEMORYPTR or DDLOCK_READONLY, 0);
  //� SurfaceDesc.lpSurface ������ ����������� ����� �����������.
  if SurfaceDesc.lpSurface = nil then
     UnLock (Buffer);
end;

//���������� ����������� �� ������.
//�� �������� ���������� � ��������� ������ ����� Lock � UnLock! ��� ��������!
procedure LockWrite (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
begin
  if Buffer = nil then exit;
  ZeroMemory (@SurfaceDesc, sizeof (TDDSurfaceDesc2));
  SurfaceDesc.dwSize := sizeof (TDDSurfaceDesc2);
  Buffer.Lock (nil, SurfaceDesc, DDLOCK_WAIT or DDLOCK_SURFACEMEMORYPTR or DDLOCK_WRITEONLY, 0);
  if SurfaceDesc.lpSurface = nil then
     UnLock (Buffer);
end;

//� ��� - ����������� �������� �� ������� Delphi TBitmap �� ����������� DirectDraw.
//�������� �������������� ���, ����� ��������� ���������� ����� �������������� Rect,
//����� ���� ����������� �� ������. ���������� �������������, ������� ������� ���������.
function CenterBmp (Buffer: IDirectDrawSurface4; Bitmap: TBitmap; Rect: TRect): TRect;
var dc: HDC;
    w0, h0: integer;
    w, h: double;
begin
  if (Buffer = nil) or (Bitmap = nil) then exit;
  //������������ � ����������.
  w0 := Bitmap.Width;
  h0 := Bitmap.Height;
  w := Rect.Right - Rect.Left;
  h := 1.0 * h0 * w / w0;
  if h > Rect.Bottom - Rect.Top then begin
     h := Rect.Bottom - Rect.Top;
     w := 1.0 * w0 * h / h0;
  end;
  Rect.Top := trunc ((Rect.Bottom + Rect.Top - h) / 2.0);
  Rect.Left := trunc ((Rect.Right + Rect.Left - w) / 2.0);
  Rect.Right := trunc (Rect.Left + w);
  Rect.Bottom := trunc (Rect.Top + h);
  //�������� device context �����������. Device context �������� - TBitmap.Canvas.Handle.
  //�� �������� ���� ���������� � ��������� ������! ��� ��������!
  Buffer.GetDC (DC);
//  SetStretchBltMode (dc, STRETCH_HALFTONE);
  //��������.
  BitBlt(dc,0,0,Bitmap.Width,Bitmap.Height, Bitmap.Canvas.Handle,0,0,SRCCOPY);
{  StretchBlt (dc, Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
              Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, SRCCOPY);       }
  //������ ���������� device context �����������!
  Buffer.ReleaseDC (DC);
  Result := Classes.Rect(0,0,Bitmap.Width,Bitmap.Height);
end;

//����������� �������, �������� ������ ������������.
procedure UnPrepareTransform;
begin
  if TransSrc1 <> nil then begin
     FreeMem (TransSrc1);
     FreeMem (TransSrc2);
//     FreeMem (TempSrc);
//     FreeMem (TempThreadScr);
//     TempSrc:= nil;
//     TempThreadScr:= nil;
     TransSrc1 := nil;
     TransSrc2 := nil;
  end;
end;

//������� ��������������: ��������� �����������, ������� ������ ��� �������,
//�������� ������ ������������.
procedure PrepareTransform (Buffer1, Buffer2: IDirectDrawSurface4);
var dd: TDDSurfaceDesc2;
begin
  if (Buffer1 = nil) or (Buffer2 = nil) then exit;
  //������ ������.
  UnPrepareTransform;
  //��������� ������ ��������.
  LockRead (Buffer1, dd);
  //�� �������� ���� ���������� � ��������� ������!
  //���������� �������.
  TransPitch := dd.lPitch;
  TransHeight := dd.dwHeight;
  TransSize := TransHeight * TransPitch;
  //������� ������.
  GetMem (TransSrc1, TransSize);
  GetMem (TransSrc2, TransSize);
  //�������� ������ ��������...
  CopyMemory (TransSrc1, dd.lpSurface, TransSize - 1);
  //...� ������������ ���.
  UnLock (Buffer1);
  //��������� ������ ��������.
  LockRead (Buffer2, dd);
  //�� �������� ���� ���������� � ��������� ������!
  //�������� ���...
  CopyMemory (TransSrc2, dd.lpSurface, TransSize - 1);
  //...� ������������ ���.
  UnLock (Buffer2);
end;

procedure ReplaseTransform(Buffer : IDirectDrawSurface4);
var
  dd: TDDSurfaceDesc2;
  T : PByteArr;
begin
 T:=TransSrc1;
 TransSrc1:=TransSrc2;
 TransSrc2 := T;
 LockRead (Buffer, dd);
 TransPitch := dd.lPitch;
 TransHeight := dd.dwHeight;
 TransSize := TransHeight * TransPitch;
 CopyMemory (TransSrc2, dd.lpSurface, TransSize - 1);
 UnLock (Buffer);
end;

//O.K. ��� ��� - ����� �������. �������� �����-������ �������� �����, ���������
//��������������� ������ ������������. ��������� ��������� � Buffer. Alpha -
//����������� ������������, �� 0 �� 255.
//
//������, ��� ����� ��������� �������. ���� �� ���������� ��� �� ����������,
//�� � ASM'� �� ����. �����, ���-������ ��������� � ��� �������, �?
//
//� ��������, ����� ������ ������������ ����� ������� ��� ��� ������, ������ ��
//����������� �������������� ���������. �������� �� ���, ����� ������ ��������....
procedure TransformAlpha (Buffer: IDirectDrawSurface4; Alpha: integer);
var dd: TDDSurfaceDesc2;
    c, c1, m, n: integer;
    a, msa, x1: integer;
    bb: ^TByteArray;
begin
 {$R-}
  if (TransSrc1 = nil) or (Buffer = nil) then exit;
  //��������� ����� ����������.
  //�� �������� ���� ���������� � ��������� ������!
  LockWrite (Buffer, dd);
  if dd.lpSurface = nil then exit;
  bb := dd.lpSurface;
  m := 0;
  x1 := BPP shr 3;
  n := TransSize - x1;
  //��������� ������ ��� 16 bpp (2 ����� �� �������) � 24/32 bpp (3 ����� �� �������).
  //���� ������ ���� ���� � �������� ��������� ���������� ������, ��� ����� -10% �
  //��������������. ������� ����� ��� �����.
  if Bpp = 16 then begin
     a := alpha shr 3; //��������� ������������ ������� ���������.
     msa := $1F - a;   //��������� ������������ ������� ���������.
     repeat
        c := integer ((@(TransSrc1^[m]))^); //������� ������� ���������.
        c1 := integer ((@(TransSrc2^[m]))^);//������� ������� ���������.
        //�������������� �������
        c := (((msa * ((c shr Rbm) and $1F) + a * ((c1 shr Rbm) and $1F)) shr 5) shl Rbm) or
             (((msa * ((c shr Gbm) and $1F) + a * ((c1 shr Gbm) and $1F)) shr 5) shl Gbm) or
             (((msa * ((c shr Bbm) and $1F) + a * ((c1 shr Bbm) and $1F)) shr 5) shl Bbm);
        //���������� � �������� ������
        bb^[m] := c;
        bb^[m + 1] := c shr 8;
        //��������� �����:
        inc (m, x1);
     until m > n
  end else begin
     a := alpha;    //��������� ������������ ������� ���������.
     msa := $FF - a;//��������� ������������ ������� ���������.
     repeat
        c := integer ((@(TransSrc1^[m]))^); //������� ������� ���������.
        c1 := integer ((@(TransSrc2^[m]))^);//������� ������� ���������.
        //�������������� �������
        c := (((msa * ((c shr Rbm) and $FF) + a * ((c1 shr Rbm) and $FF)) shr 8) shl Rbm) or
             (((msa * ((c shr Gbm) and $FF) + a * ((c1 shr Gbm) and $FF)) shr 8) shl Gbm) or
             (((msa * ((c shr Bbm) and $FF) + a * ((c1 shr Bbm) and $FF)) shr 8) shl Bbm);
        //���������� � �������� ������
        bb^[m] := c;
        bb^[m + 1] := c shr 8;
        bb^[m + 2] := c shr 16;
        //��������� �����:
        inc (m, x1);
     until m > n
  end;
  //������������ �����.
  UnLock (Buffer);
end;

//�� Create ������� DirectDraw � ��� �����������. ���� �� ��� ������ �� Resize
//� ����� ������� IDirectDrawSurface4.IsLost, �� � ����� ����.
procedure TDirectShowForm.FormCreate(Sender: TObject);
var
    pp: integer;
    DirectDraw2: IDirectDraw;
    fx: TDDBltFx;
    r: TRect;
    PixelFormat: TDDPixelFormat;
    Objects : TThreadDestroyDXObjects;
begin
 DDrawInit;
 AlphaSteeps:=Min(Max(DBKernel.ReadInteger('Options','SlideShow_SlideSteps',25),1),100);
 DelayTimer.Interval:=Min(Max(DBKernel.ReadInteger('Options','SlideShow_SlideDelay',40),1),100)*50;
 FNowPaused :=false;
 FReadyAfterPause :=false;
 FManager:=TDirectXSlideShowCreatorManager.Create;
 Ready:=false;
 FForwardThreadExists:=false;
 fPlay:=true;
 if FloatPanel=nil then
 Application.CreateForm(TFloatPanel, FloatPanel);
 SID:=GetGUID;
 try
 //������� DirectDraw.
 DirectDrawCreate (nil, DirectDraw2, nil);
 //����������� ��������� IDirectDraw4.
 DirectDraw2.QueryInterface (IID_IDirectDraw4, DirectDraw4);
 DirectDraw2.Release;
 DirectDraw2 := nil;

 DirectDraw4.SetCooperativeLevel (handle, {DDSCL_SETFOCUSWINDOW or }DDSCL_EXCLUSIVE or DDSCL_FULLSCREEN or DDSCL_MULTITHREADED);
 //�������� (�������) �����������...
 FillChar (SurfaceDesc, sizeof (SurfaceDesc), 0);

{ with SurfaceDesc do
 begin
	dwSize := sizeof(SurfaceDesc); // ������� � ���� dwSize ������ ���������
	dwFlags := DDSD_CAPS or DDSD_BACKBUFFERCOUNT;
  // ������������� ����� ������������ ���� ������������
  ddsCaps.dwCaps :=DDSCAPS_PRIMARYSURFACE or DDSCAPS_FLIP or DDSCAPS_COMPLEX;
  // ���������� �������� �����, ��� ���������, ������������� �����������.
	DwBackBufferCount := 1;
	// ���� ��������� ����������� ����� ���� ���������.
 end;    }

 DirectDraw4.SetCooperativeLevel (Handle, DDSCL_NORMAL);
  //�������� (�������) �����������...
 FillChar (SurfaceDesc, sizeof (SurfaceDesc), 0);
 SurfaceDesc.dwSize := sizeof (SurfaceDesc);
 SurfaceDesc.dwFlags := DDSD_CAPS;
 SurfaceDesc.ddsCaps.dwCaps := DDSCAPS_PRIMARYSURFACE;  
       
 DirectDraw4.CreateSurface (SurfaceDesc, PrimarySurface, nil);
 //...������������� � �������� ���� ����� IDirectDrawClipper.
 //������� ������� IDirectDrawClipper...
 DirectDraw4.CreateClipper (0, Clpr, nil);
 //...��������� ��� � ������� �����...
 Clpr.SetHWND (0, Handle);
           
 //...� ����� - � ������� ������������.
 PrimarySurface.SetClipper (Clpr);

  //���������� �������� ������ ������...
 PixelFormat.dwSize := sizeof (TDDPIXELFORMAT);
 PrimarySurface.GetPixelFormat (PixelFormat);
 BPP := PixelFormat.dwRGBBitCount;
 BPP:=32;
 //...� ����� ��������, ������ � �������� �������.
 //��� ����� ������������ ��� ������� �����.
 pp := round (exp (BPP / 3.0 * ln (2.0)));
 if pp > $FF then pp := $FF;
 RBM := round (ln (1.0 * PixelFormat.dwRBitMask / pp) / ln (2.0));
 GBM := round (ln (1.0 * PixelFormat.dwGBitMask / pp) / ln (2.0));
 BBM := round (ln (1.0 * PixelFormat.dwBBitMask / pp) / ln (2.0));
 //������ ������� ����������� (���������) �����������. ��� ��� �����
 //���������� �������.
 SurfaceDesc.dwFlags := DDSD_HEIGHT or DDSD_WIDTH;
 SurfaceDesc.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;
 SurfaceDesc.dwWidth := Width;
 SurfaceDesc.dwHeight := Height;
 //��� ������������ ��� ��������� WM_PAINT.
 DirectDraw4.CreateSurface (SurfaceDesc, Offscreen, nil);
 //�������� �� ������ ���� (����� �� ��� ����� "����").
 FillChar (fx, sizeof (fx), 0);
 fx.dwSize := sizeof (fx);
 fx.dwFillColor := PackColor (Color);
 r := ClientRect;
 Offscreen.Blt (@r, nil, nil, DDBLT_WAIT + DDBLT_COLORFILL, @fx);
  //��� - ������ �������� ��� ��������������.
 DirectDraw4.CreateSurface (SurfaceDesc, Buffer, nil);
 except
  ShowMessage(TEXT_MES_DIRECT_X_FAILTURE);
 end;
 //�����, �� ���� ���� ��� �� ��������.
 FileLoaded := false;
 FDirectXShowTerminated:=false;
 Objects.DirectDraw4:=DirectDraw4;
 Objects.PrimarySurface:=PrimarySurface;
 Objects.Offscreen:=Offscreen;
 Objects.Buffer:=Buffer;
 Objects.Clpr:=Clpr;
 Objects.TransSrc1:=TransSrc1;
 Objects.TransSrc2:=TransSrc2;
 Objects.Form:=self;
// Objects.TempSrc:=TempSrc;
// Objects.TempSrc:=TempThreadScr;
 (FManager as TDirectXSlideShowCreatorManager).SetDXObjects(Objects);
end;

//�� Destroy ����������� ��� ������.
procedure TDirectShowForm.FormDestroy(Sender: TObject);
begin
 FDirectXShowTerminated:=true;
end;

//�� Paint �������� ����������� ����� (Offscreen) �� �����.
procedure TDirectShowForm.FormPaint(Sender: TObject);
begin
  UpdateSurface (self);
end;

//�� ��������� �������� ��������� �������������� � ��������� �����.
procedure TDirectShowForm.Execute(Sender: TObject);
var
  TempImage, FirstImage : TBitmap;
  x1, x2, y1, y2, fh, fw : integer;
  Zoom : Extended;
begin
  Show;
  if FloatPanel<>nil then
  FloatPanel.Show;
  MouseTimer.Enabled:=false;
  MouseTimer.Enabled:=true;
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 1, nil, 0);
  FirstImage := TBitmap.Create;
  FirstImage.Width:=Screen.Width;
  FirstImage.Height:=Screen.Height;
  FirstImage.Canvas.Brush.Color:=ClBlack;
  FirstImage.Canvas.Pen.Color:=ClBlack;
  FirstImage.PixelFormat:=pf24bit;
  FirstImage.Canvas.Rectangle(0,0,FirstImage.width,FirstImage.Height);
  if (FbImage.width>fnewcsrbmp.width) or (FbImage.Height>fnewcsrbmp.Height) then
  begin
   if FbImage.width/FbImage.Height<fnewcsrbmp.width/fnewcsrbmp.Height then
   begin
    fh:=fnewcsrbmp.Height;
    fw:=round(fnewcsrbmp.Height*(FbImage.width/fbImage.Height));
   end else begin
    fw:=fnewcsrbmp.width;
    fh:=round(fnewcsrbmp.width*(FbImage.Height/fbImage.width));
   end;
  end else begin
   fh:=FbImage.Height;
   fw:=FbImage.width;
  end;
  x1:=Screen.Width div 2 - fw div 2;
  y1:=Screen.Height div 2 - fh div 2;
  x2:=Screen.Width div 2 + fw div 2;
  y2:=Screen.Height div 2 + fh div 2;
  If DBKernel.ReadboolW('Options','SlideShow_UseCoolStretch',True) then
  begin
   if FbImage.Width<>0 then
   Zoom:=(x2-x1)/FbImage.Width else Zoom:=1;

   if (Zoom<ZoomSmoothMin) or UseOnlyDefaultDraw then
   StretchCool(x1,y1,x2-x1,y2-y1,FbImage,FirstImage)
   else begin
    TempImage := TBitmap.Create;
    TempImage.PixelFormat:=pf24bit;
    TempImage.Width:=x2-x1;
    TempImage.Height:=y2-y1;
    SmoothResize(x2-x1,y2-y1,FbImage,TempImage);
    FirstImage.Canvas.Draw(x1,y1,TempImage);
    TempImage.Free;
   end;

  end else
  FirstImage.Canvas.StretchDraw(rect(x1,y1,x2,y2),FbImage);
  DirectShowForm.SetFirstImage(FirstImage);
  FirstImage.Free;
//  TempThreadScr:=nil;
  DelayTimer.Enabled:=true;
end;

procedure TDirectShowForm.FormDeactivate(Sender: TObject);
begin
  ShowMouse;
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, nil, 0);
//  Close;
end;

procedure TDirectShowForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Showmouse;
  MouseTimer.Enabled:=false;
  MouseTimer.Enabled:=true;
end;

procedure TDirectShowForm.MouseTimerTimer(Sender: TObject);
var
  p : TPoint;
begin
 if Visible then
 begin
  GetCursorPos(p);
  if FloatPanel=nil then exit;
  p:=FloatPanel.ScreenToClient(p);
  if PtInRect(FloatPanel.ClientRect,p) then exit;
  HideMouse;
 end;
end;

procedure TDirectShowForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin          
  MouseTimer.Enabled:=true;
  if (abs(OldPoint.X-x)>5) or (abs(OldPoint.X-x)>5) then
  begin
   ShowMouse;
   OldPoint:=Point(x,y);
   MouseTimer.Enabled:=false;
   MouseTimer.Enabled:=true;
  end;
end;

procedure TDirectShowForm.FormContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  ShowMouse;
  MouseTimer.Enabled:=false;
  if Viewer<>nil then
  begin
   Viewer.PopupMenu1.Popup(ClientToScreen(MousePos).X,ClientToScreen(MousePos).y);
  end;
end;

procedure TDirectShowForm.FormClick(Sender: TObject);
begin
{ DelayTimer.Enabled:=false;
 Viewer.Next_(Sender);
 LoadCurrentImage(false,true); }
 if Viewer=nil then exit;
 Viewer.Pause;
 Viewer.SpeedButton4Click(nil);
end;

procedure TDirectShowForm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowMouse;
  MouseTimer.Enabled:=false;
  MouseTimer.Enabled:=true;
end;

procedure TDirectShowForm.HideMouse;
var
  CState: Integer;
begin
  CState := ShowCursor(True);
  while Cstate >= 0 do
    Cstate := ShowCursor(False);
  if FloatPanel<>nil then
  FloatPanel.Hide;
end;

procedure TDirectShowForm.ShowMouse;
var
  Cstate: Integer;
begin
  Cstate := ShowCursor(True);
  while CState < 0 do
    CState := ShowCursor(True);
  if SlideShowNow then
  if FloatPanel<>nil then
  FloatPanel.Show;
end;

procedure TDirectShowForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
 if Active then
 if Msg.message=260 then Msg.message:=0;
 if Msg.message=256 then
 begin
  if Msg.wParam=37 then
  begin
   if Viewer<>nil then
   begin
    Viewer.Pause;
    Viewer.SpeedButton3Click(nil);
   end;
  end;
  if (Msg.wParam=39) or (Msg.wParam=32) then
  begin
   if Viewer<>nil then
   begin
    Viewer.Pause;
    Viewer.SpeedButton4Click(nil);
   end;
  end;
  if Msg.wParam=27 then
  begin
   if Viewer<>nil then Viewer.Exit1Click(nil);
   Msg.message:=0;
  end;
 end;
 if Msg.message<>522 then exit;
 if Msg.wParam>0 then
 begin
  if Viewer<>nil then
  begin
   Viewer.Pause;
   Viewer.SpeedButton3Click(nil);
  end;
 end else
 begin
  if Viewer<>nil then
  begin
   Viewer.Pause;
   Viewer.SpeedButton4Click(nil);
  end;
 end;
end;

procedure TDirectShowForm.FormResize(Sender: TObject);
begin
 if FloatPanel=nil then exit;
 FloatPanel.Top:=0;
 FloatPanel.Left:=ClientWidth-FloatPanel.Width;
end;

procedure TDirectShowForm.ReTransForm(Alpha: byte);
begin
 TransformAlpha (Offscreen, Alpha);
 UpdateSurface (self);
end;

function TDirectShowForm.FirstLoad: Boolean;
begin
 Result:=not FileLoaded;
end;

procedure TDirectShowForm.SetFirstImage(Image: TBitmap);
var
  fx: TDDBltFx;
  r: TRect;
begin
 FillChar (fx, sizeof (fx), 0);
 fx.dwSize := sizeof (fx);
 fx.dwFillColor := PackColor (0);
 r := ClientRect;
  //...����� ���� ����������, ����� ������ ���� ������ (������ ��� ������
  //��������), � � ����������� �� ����� ����� �������� � ���������������
  //����� (�������������� �������� ��� ������ ����, ����� ������� ����������
  //����������).
 FileLoaded := true;
 Buffer.Blt (@r, nil, nil, DDBLT_WAIT + DDBLT_COLORFILL, @fx);
 CenterBmp (Buffer, Image, ClientRect);
 PrepareTransform (Buffer, Buffer);
 TransformAlpha (Offscreen, 0);
 UpdateSurface (self);
 FForwardThreadExists:=false;
end;

procedure TDirectShowForm.NewImage(Image: TBitmap);
var
  fx: TDDBltFx;
  r: TRect;
begin
 FillChar (fx, sizeof (fx), 0);
 fx.dwSize := sizeof (fx);
 fx.dwFillColor := PackColor (0);
 r := ClientRect;
  //...����� ���� ����������, ����� ������ ���� ������ (������ ��� ������
  //��������), � � ����������� �� ����� ����� �������� � ���������������
  //����� (�������������� �������� ��� ������ ����, ����� ������� ����������
  //����������).
 FileLoaded := true;
 Buffer.Blt (@r, nil, nil, DDBLT_WAIT + DDBLT_COLORFILL, @fx);
 CenterBmp (Buffer, Image, ClientRect);
 ReplaseTransform (Buffer);
 TransformAlpha (Offscreen, 0);
 UpdateSurface (self);
end;

procedure TDirectShowForm.DelayTimerTimer(Sender: TObject);
begin
 if not fplay then exit;
 DelayTimer.Enabled:=false;
 if Viewer<>nil then Viewer.Next_(Sender);
 LoadCurrentImage(false,true);
end;

procedure TDirectShowForm.BeginFade;
begin
 TransformAlpha (Offscreen, 0);
 UpdateSurface (self);
 DelayTimer.Enabled:=false;
 FadeTimer.Enabled:=true;
 XAlphaCount:=0;
 AlphaCount:=0;
end;

procedure TDirectShowForm.FadeTimerTimer(Sender: TObject);
begin
 if not Visible then exit;
 XAlphaCount:=XAlphaCount+(pi/2)/AlphaSteeps;
 AlphaCount:=255-Round(255*sqr(cos(XAlphaCount)));
 if XAlphaCount>pi/2 then
 begin
  FNowPaused :=false;
  FReadyAfterPause :=false;
  DelayTimer.Enabled:=true;
  FadeTimer.Enabled:=false;
  FReady:=false;
  if not fPlay then
  begin
   FForwardThreadExists:=true;
   Next(true);
  end;
  Exit;
 end else
 begin
  TransformAlpha (Offscreen, AlphaCount);
  UpdateSurface (self);
 end;
end;

procedure TDirectShowForm.SetThreadImage(var Image : PByteArr);
var
  T : PByteArr;
begin
 T:=TransSrc1;
 TransSrc1:=TransSrc2;
 TransSrc2:=Image;
 Image:=T;
end;

procedure TDirectShowForm.Pause;
begin
 if fPlay=false then exit;
 FNowPaused :=true;
 FReadyAfterPause :=false;
 SID:=GetGUID;
 DelayTimer.Enabled:=false;
 fPlay:=false;
end;

procedure TDirectShowForm.Play;
begin
 if FNowPaused then
 begin
  FReadyAfterPause :=true;
  FNowPaused:=false;
  exit;
 end;
 DelayTimer.Enabled:=true;
 fPlay:=true;
end;

function TDirectShowForm.CanSetImage: Boolean;
begin
 Result:=fPlay;
end;

procedure TDirectShowForm.Next(XForward : Boolean);
begin
 if FNowPaused then
 begin
  FReadyAfterPause :=true;
  FNowPaused:=false;
  exit;
 end;    
 FNowPaused:=false;
 FReadyAfterPause:=false;
 if not XForward then
 SID:=GetGUID;
 AlphaCount:=255-Round(255*sqr(cos(XAlphaCount)));
 if AlphaCount<30 then exit;
 if not XForward then
 begin
  inc(CurrentFileNumber);
  if CurrentFileNumber>=Length(CurrentInfo.ItemFileNames) then
  CurrentFileNumber:=0;
 end;
 LoadCurrentImage(XForward,true);
end;

procedure TDirectShowForm.Previous;
begin
 FNowPaused:=false;
 FReadyAfterPause:=false;
 SID:=GetGUID;
 Dec(CurrentFileNumber);
 if CurrentFileNumber<0 then
 CurrentFileNumber:=Length(CurrentInfo.ItemFileNames)-1;
 LoadCurrentImage(false,false);
end;

procedure TDirectShowForm.LoadCurrentImage(XForward, Next : Boolean);
var
  Info : TDirectXSlideShowCreatorInfo;
  n : integer;
begin
 if not XForward then
 begin
  if FForwardThreadExists and (ForwardFileName=CurrentInfo.ItemFileNames[CurrentFileNumber]) then
  begin
   Ready:=true;
   exit;
  end else
  begin
   FForwardThreadExists:=false;
  end;
 end;
 if XForward then
 begin
  n:=CurrentFileNumber;
  ForwardSID:=GetGUID;
  if Next then
  begin
   inc(n);
   if n>=Length(CurrentInfo.ItemFileNames) then
   n:=0;
  end else
  begin
   dec(n);
   if n<0 then
   n:=Length(CurrentInfo.ItemFileNames)-1;
  end;
  Info.FileName:=CurrentInfo.ItemFileNames[n];
  Info.Rotate:=CurrentInfo.ItemRotates[n];
  ForwardFileName:=CurrentInfo.ItemFileNames[n]
 end else
 begin
  Info.FileName:=CurrentInfo.ItemFileNames[CurrentFileNumber];
  Info.Rotate:=CurrentInfo.ItemRotates[CurrentFileNumber];
 end;
 Info.CallBack:=CallBack;
 Info.FDirectXSlideShowReady:=@FDirectXShowReadyForImage;
 Info.FDirectXSlideShowTerminate:=@FDirectXShowTerminated;
 info.DirectDraw4:=DirectDraw4;
 info.PrimarySurface:=PrimarySurface;
 info.Offscreen:=Offscreen;
 info.Clpr:=Clpr;
 info.BPP:=BPP;
 info.RBM:=RBM;
 info.GBM:=GBM;
 info.BBM:=BBM;
 info.TransSrc1:=TransSrc1;
 info.TransSrc2:=TransSrc2;
 info.TempSrc:=nil;
 if XForward then
 info.SID:=ForwardSID
 else
 info.SID:=SID;
 info.Manager:=FManager;
 info.Form:=self;
 DirectDraw4.CreateSurface (SurfaceDesc, info.Buffer, nil);
 TDirectXSlideShowCreator.Create(false,Info,XForward,Next);
end;

procedure TDirectShowForm.DoClose;
begin
 ShowMouse;
 Hide;
 DelayTimer.Enabled:=false;
 FadeTimer.Enabled:=false;
 UnPrepareTransform;
 SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, nil, 0);
 if (FManager as TDirectXSlideShowCreatorManager).ThreadCount<>0 then
 (FManager as TDirectXSlideShowCreatorManager).FreeOnExit else
 begin
  FManager.Free;
  if DirectDraw4 = nil then exit;
  Buffer.Release;
  Buffer := nil;
  Offscreen.Release;
  Offscreen := nil;
  PrimarySurface.Release;
  PrimarySurface := nil;
  Clpr.Release;
  Clpr:=nil;
  //��������� DirectDraw...
  Release;
  Free;
  DirectDraw4.Release;
  DirectDraw4 := nil;
  DirectShowForm:=nil;
  exit;
 end;
 Hide;
end;

procedure TDirectShowForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 DestroyTimer.Enabled:=true;
end;

procedure TDirectShowForm.DestroyTimerTimer(Sender: TObject);
begin
 DestroyTimer.Enabled:=false;
 Release;
 if UseFreeAfterRelease then Free;
 DirectShowForm:=nil;
end;

function TDirectShowForm.CallBack(
  CallbackInfo: TCallbackInfo): TDirectXSlideShowCreatorCallBackResult;
begin
 if Visible and SlideShowNow then
 if CallbackInfo.Action=CallBack_Next then
 begin
  if not CallbackInfo.ForwardThread then
  begin
   if not fplay then exit;
   DelayTimer.Enabled:=false;
   if CallbackInfo.Direction then
   begin
    if Viewer<>nil then Viewer.Next_(nil)
   end else
   begin
    if Viewer<>nil then Viewer.Previous_(nil);
   end;
   LoadCurrentImage(false,CallbackInfo.Direction);
  end else
  begin
   if CallbackInfo.Direction then
   begin
    if Viewer<>nil then Viewer.Next_(nil)
   end else
   begin
    if Viewer<>nil then Viewer.Previous_(nil);
   end;
   LoadCurrentImage(true,CallbackInfo.Direction);
  end;
 end;
end;

procedure TDirectShowForm.SetReady(const Value: boolean);
begin
  FReady := Value;
end;

procedure TDirectShowForm.SetForwardThreadExists(const Value: boolean);
begin
  FForwardThreadExists := Value;
end;

procedure TDirectShowForm.SetForwardFileName(const Value: String);
begin
  FForwardFileName := Value;
end;

end.

