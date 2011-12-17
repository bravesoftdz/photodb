unit UnitHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DmMemo, ImButton, ExtCtrls, Menus, clipbrd, Dolphin_DB,
  GraphicsBaseTypes, uMemory, uTranslate, Types;

type
  TCanHelpCloseProcedure = procedure(Sender: TObject; var CanClose: Boolean) of object;

type
  THelpPopup = class(TForm)
    MemText: TDmMemo;
    ImbClose: TImButton;
    DestroyTimer: TTimer;
    ImbNext: TImButton;
    Label1: TLabel;
    PmCopy: TPopupMenu;
    Copy1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ColorFill(var image : tbitmap);
    procedure ImbCloseClick(Sender: TObject);
    procedure SetPos(P : TPoint);
    procedure ReCreateRGN;
    procedure DestroyTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure ImbNextClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Copy1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    FActivePoint: TPoint;
    FText: TStrings;
    FSimpleText : String;
    Bitmap : TBitmap;
    Dw, Dh: Integer;
    FNextButtonVisible: Boolean;
    FCallBack: TNotifyEvent;
    FNextText: String;
    FOnHelpClose: TNotifyEvent;
    FCanHelpClose: TCanHelpCloseProcedure;
    FOnCanCloseMessage : Boolean;
    FHelpCaption: String;
    procedure SetActivePoint(const Value: TPoint);
    procedure SetText(const Value: String);
    procedure SetNextButtonVisible(const Value: Boolean);
    procedure SetCallBack(const Value: TNotifyEvent);
    procedure SetNextText(const Value: String);
    procedure SetOnHelpClose(const Value: TNotifyEvent);
    procedure SetCanHelpClose(const Value: TCanHelpCloseProcedure);
    procedure SetHelpCaption(const Value: String);
    { Private declarations }
  public
    property ActivePoint: TPoint read FActivePoint write SetActivePoint;
    property HelpText: string read FSimpleText write SetText;
    property NextButtonVisible: Boolean read FNextButtonVisible write SetNextButtonVisible;
    property CallBack: TNotifyEvent read FCallBack write SetCallBack;
    property OnHelpClose: TNotifyEvent read FOnHelpClose write SetOnHelpClose;
    property NextText: string read FNextText write SetNextText;
    property CanHelpClose: TCanHelpCloseProcedure read FCanHelpClose write SetCanHelpClose;
    property HelpCaption: string read FHelpCaption write SetHelpCaption;
    procedure Refresh;
    procedure DoDelp(HelpMessage: string; Point: TPoint);
    { Public declarations }
  end;

procedure DoHelpHint(Caption, HelpText: string; MyPoint: TPoint; Control: TControl);
procedure DoHelpHintCallBack(Caption, HelpText: string; MyPoint: TPoint; Control: TControl; CallBack: TNotifyEvent;
  Text: string);
procedure DoHelpHintCallBackOnCanClose(Caption, HelpText: string; MyPoint: TPoint; Control: TControl;
  CallBack: TNotifyEvent; Text: string; OnCanClose: TCanHelpCloseProcedure);

implementation

{$R *.dfm}

procedure DoHelpHint(Caption, HelpText: string; MyPoint: TPoint; Control: TControl);
var
  HelpPopup: THelpPopup;
begin
  Application.CreateForm(THelpPopup, HelpPopup);
  HelpPopup.NextButtonVisible := False;
  HelpPopup.HelpCaption := Caption;
  if Control <> nil then
    MyPoint := Control.ClientToScreen(Point(Control.ClientWidth div 2, Control.Clientheight div 2));

  HelpPopup.DoDelp(HelpText, MyPoint);
end;

procedure DoHelpHintCallBack(Caption, HelpText: string; MyPoint: TPoint; Control: TControl; CallBack: TNotifyEvent;
  Text: string);
var
  HelpPopup: THelpPopup;
begin
  Application.CreateForm(THelpPopup, HelpPopup);
  HelpPopup.NextButtonVisible := True;
  HelpPopup.NextText := Text;
  HelpPopup.CallBack := CallBack;
  HelpPopup.HelpCaption := Caption;
  if Control <> nil then
    MyPoint := Control.ClientToScreen(Point(Control.ClientWidth div 2, Control.Clientheight div 2));

  HelpPopup.DoDelp(HelpText, MyPoint);
end;

procedure DoHelpHintCallBackOnCanClose(Caption, HelpText: string; MyPoint: TPoint; Control: TControl;
  CallBack: TNotifyEvent; Text: string; OnCanClose: TCanHelpCloseProcedure);
var
  HelpPopup: THelpPopup;
begin
  Application.CreateForm(THelpPopup, HelpPopup);
  HelpPopup.NextButtonVisible := True;
  HelpPopup.NextText := Text;
  HelpPopup.CallBack := CallBack;
  HelpPopup.CanHelpClose := OnCanClose;
  HelpPopup.HelpCaption := Caption;
  if Control <> nil then
    MyPoint := Control.ClientToScreen(Point(Control.ClientWidth div 2, Control.Clientheight div 2));

  HelpPopup.DoDelp(HelpText, MyPoint);
end;

function CreateBitmapRgn(Bitmap: TBitmap; TransClr: TColorRef): hRgn;
var
  // bmInfo: TBitmap;                //��������� BITMAP WinAPI
  W, H: Integer; // ������ � ������ ������
  BmDIB: HBitmap; // ���������� ������������ ������
  BmiInfo: BITMAPINFO; // ��������� BITMAPINFO WinAPI
  LpBits, LpOldBits: PRGBTriple; // ��������� �� ��������� RGBTRIPLE WinAPI
  LpData: PRgnData; // ��������� �� ��������� RGNDATA WinAPI
  X, Y, C, F, I: Integer; // ���������� ������
  Buf: Pointer; // ���������
  BufSize: Integer; // ������ ���������
  RdhInfo: TRgnDataHeader; // ��������� RGNDATAHEADER WinAPI
  LpRect: PRect; // ��������� �� TRect (RECT WinAPI)
  MemDC: HDC;
begin
  Result := 0;
  if Bitmap = nil then
    Exit; // ���� ����� �� �����, �������

  // GetObject(Bitmap, SizeOf(bmInfo), @bmInfo);  //������ ������� ������
  W := Bitmap.Width; // ��������� ��������� BITMAP
  H := Bitmap.Height;
  I := (W * 3) - ((W * 3) div 4) * 4; // ���������� �������� � ������
  if I <> 0 then
    I := 4 - I;

  // ���������: ����� Windows Bitmap �������� ����� �����, ������ ������ ������
  // ����������� �������� ������� �� �� ��������� 4.
  // ��� 32-� ������ ������� ����� ����� ������ �� ����.

  // ��������� BITMAPINFO ��� �������� � CreateDIBSection
  MemDC := CreateCompatibleDC(0);
  bmiInfo.bmiHeader.biWidth := W;             //������
  bmiInfo.bmiHeader.biHeight := H;            //������
  bmiInfo.bmiHeader.biPlanes := 1;            //������ 1
  bmiInfo.bmiHeader.biBitCount := 24;         //��� ����� �� �������
  bmiInfo.bmiHeader.biCompression := BI_RGB;  //��� ����������
  BmiInfo.BmiHeader.BiSizeImage := 0; // ������ �� �����, ������ � ����
  BmiInfo.BmiHeader.BiXPelsPerMeter := 2834; // �������� �� ����, ���.
  BmiInfo.BmiHeader.BiYPelsPerMeter := 2834; // �������� �� ����, ����.
  BmiInfo.BmiHeader.BiClrUsed := 0; // ������� ���, ��� � ����
  BmiInfo.BmiHeader.BiClrImportant := 0; // �� ��
  BmiInfo.BmiHeader.BiSize := SizeOf(BmiInfo.BmiHeader); // ������ ���������
  BmDIB := CreateDIBSection(MemDC, BmiInfo, DIB_RGB_COLORS, Pointer(LpBits), 0, 0);
  // ������� ����������� ����� WxHx24, ��� �������, � ��������� lpBits ��������
  // ����� ������� ����� ����� ������. bmDIB - ���������� ������

  // ��������� ������ ����� ������ BITMAPINFO ��� �������� � GetDIBits

  BmiInfo.BmiHeader.BiWidth := W; // ������
  BmiInfo.BmiHeader.BiHeight := H; // ������
  BmiInfo.BmiHeader.BiPlanes := 1; // ������ 1
  BmiInfo.BmiHeader.BiBitCount := 24; // ��� ����� �� �������
  BmiInfo.BmiHeader.BiCompression := BI_RGB; // ��� ���������
  BmiInfo.BmiHeader.BiSize := SizeOf(BmiInfo.BmiHeader); // ������ ���������
  GetDIBits(MemDC, Bitmap.Handle, 0, H - 1, LpBits, BmiInfo, DIB_RGB_COLORS);
  // ������������ �������� ����� � ��� � ��� ������������ �� ������ lpBits

  LpOldBits := LpBits; // ���������� ����� lpBits

  // ������ ������ - ������������ ����� ���������������, ����������� ���
  // �������� �������
  C := 0; // ������� ����
  for Y := H - 1 downto 0 do // ������ ����� �����
  begin
    X := 0;
    while X < W do // �� 0 �� ������-1
    begin
      // ���������� ��������� ����, ���������� ���������� � ���������
      while (RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) = TransClr) and (X < W) do
      begin
        Inc(LpBits);
        X := X + 1;
      end;
      // ���� ����� �� ���������� ����, �� �������, ������� ����� � ���� �� ����
      if RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) <> TransClr then
      begin
        while (RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) <> TransClr) and (X < W) do
        begin
          Inc(LpBits);
          X := X + 1;
        end;
        C := C + 1; // ����������� ������� ���������������
      end;
    end;
    // ��� ����������, ���������� ��������� ��������� �� ��������� 4
    PChar(LpBits) := PChar(LpBits) + I;
  end;

  LpBits := LpOldBits; // ��������������� �������� lpBits

  // ��������� ��������� RGNDATAHEADER
  RdhInfo.IType := RDH_RECTANGLES; // ����� ������������ ��������������
  RdhInfo.NCount := C; // �� ����������
  RdhInfo.NRgnSize := 0; // ������ �������� ������ �� �����
  RdhInfo.RcBound := Rect(0, 0, W, H); // ������ �������
  RdhInfo.DwSize := SizeOf(RdhInfo); // ������ ���������

  // �������� ������ ��� �������� RGNDATA:
  // ����� RGNDATAHEADER � ����������� �� ���������������
  BufSize := SizeOf(RdhInfo) + SizeOf(TRect) * C;
  GetMem(Buf, BufSize);
  LpData := Buf; // ������ ��������� �� ���������� ������
  LpData.Rdh := RdhInfo; // ������� � ������ RGNDATAHEADER

  // ���������� ������ ����������������
  LpRect := @LpData.Buffer; // ������ �������������
  for Y := H - 1 downto 0 do
  begin
    X := 0;
    while X < W do
    begin
      while (RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) = TransClr) and (X < W) do
      begin
        Inc(LpBits);
        X := X + 1;
      end;
      if RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) <> TransClr then
      begin
        F := X;
        while (RGB(LpBits.RgbtRed, LpBits.RgbtGreen, LpBits.RgbtBlue) <> TransClr) and (X < W) do
        begin
          Inc(LpBits);
          X := X + 1;
        end;
        LpRect^ := Rect(F, Y - 1, X, Y); // ������� ����������
        Inc(LpRect); // ��������� � ����������
      end;
    end;
    PChar(LpBits) := PChar(LpBits) + I;
  end;

  // ����� ��������� ���������� ��������� RGNDATA ����� ��������� ������.
  // ������������� ��� �� �����, ������ � nil, ��������� ������
  // ��������� ��������� � �� ����.
  Result := ExtCreateRegion(nil, BufSize, LpData^); // ������� ������

  FreeMem(Buf, BufSize); // ������ ��������� RGNDATA ������ �� �����, �������
  DeleteObject(BmDIB); // ��������� ����� ���� �������
end;

function BitmapToRegion(HBmp: TBitmap; TransColor: TColor): HRGN;
begin
  Result := CreateBitmapRgn(HBmp, TransColor);
end;

procedure THelpPopup.ColorFill(var Image: TBitmap);
var
  I, J: Integer;
  P: PARGB;
begin
  for I := 0 to Image.Height - 1 do
  begin
    P := Image.ScanLine[I];
    for J := 0 to Image.Width - 1 do
    begin
      P[J].B := P[J].B div 2;
      P[J].R := P[J].R div 2 + 128;
      P[J].G := P[J].G div 2 + 128;
    end;
  end;
end;

procedure THelpPopup.DoDelp(HelpMessage: string; Point: TPoint);
begin
  HelpText := HelpMessage;
  ActivePoint := Point;
  Show;
  Refresh;
end;

procedure THelpPopup.FormCreate(Sender: TObject);
begin
  Copy1.Caption := TA('Copy', 'Help');
  FCallBack := nil;
  FOnCanCloseMessage := True;
  FNextButtonVisible := False;
  FText := TStringList.Create;
  ImbClose.Filter := ColorFill;
  ImbClose.Refresh;
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := Pf24bit;
  Dh := 100;
  Dw := 220;
  FOnHelpClose := nil;
  ImbNext.Filter := ColorFill;
  ImbNext.Refresh;
  ImbNext.Caption := 'Ok';
  ImbNext.ShowCaption := False;
end;

procedure THelpPopup.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, -1, Bitmap);
end;

procedure THelpPopup.ImbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure THelpPopup.ReCreateRGN;
var
  RGN: HRGN;
  Dx, Dy: Integer;
  PP: array [0 .. 3] of TPoint;
begin
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.Brush.Color := $FFFFFF;
  Bitmap.Canvas.Pen.Color := $FFFFFF;
  Bitmap.Canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);
  Bitmap.Canvas.Brush.Color := $00FFFF;
  Bitmap.Canvas.Pen.Color := $0;
  Dx := 50;
  Dy := 50;
  Bitmap.Canvas.RoundRect(0+dx,0+dy,dw+dx,dh+dy,10,10);
  if (Left-FActivePoint.X>=0) and (Top-FActivePoint.y>=0) then
  begin
    PP[0]:=Point(dx+20,dy);
    PP[1]:=Point(dx+40,dy);
    PP[2]:=Point(0, 0);
    PP[3] := Point(Dx + 20, Dy);
    Bitmap.Canvas.Polygon(PP);
    Bitmap.Canvas.Brush.Color := $00FFFF;
    Bitmap.Canvas.Pen.Color := $00FFFF;
    Bitmap.Canvas.MoveTo(Dx + 20, Dy);
    Bitmap.Canvas.LineTo(Dx + 40, Dy);
  end;
  if (Left - FActivePoint.X >= 0) and (Top-FActivePoint.y<0) then
  begin
    PP[0]:=Point(dx+20,dy+dh-1);
    PP[1]:=Point(dx+40,dy+dh-1);
    PP[2]:=Point(0, Height - 1);
    PP[3] := Point(Dx + 20, Dy + Dh - 1);
    Bitmap.Canvas.Polygon(PP);
    Bitmap.Canvas.Brush.Color := $00FFFF;
    Bitmap.Canvas.Pen.Color := $00FFFF;
    Bitmap.Canvas.MoveTo(Dx + 20, Dy + Dh - 1);
    Bitmap.Canvas.LineTo(Dx + 40, Dy + Dh - 1);
  end;
  if (Left - FActivePoint.X < 0) and (Top - FActivePoint.Y < 0) then
  begin
    PP[0] := Point(Dx - 20 + Dw, Dy + Dh - 1);
    PP[1] := Point(Dx - 40 + Dw, Dy + Dh - 1);
    PP[2] := Point(Width - 1, Height - 1);
    PP[3] := Point(Dx - 20 + Dw, Dy + Dh - 1);
    Bitmap.Canvas.Polygon(PP);
    Bitmap.Canvas.Brush.Color:=$00FFFF;
    Bitmap.Canvas.Pen.Color:=$00FFFF;
    Bitmap.Canvas.MoveTo(dx+dw- 20, Dy + Dh - 1);
    Bitmap.Canvas.LineTo(Dx + Dw - 40, Dy + Dh - 1);
  end;
  if (Left - FActivePoint.X < 0) and (Top - FActivePoint.Y >= 0) then
  begin
    PP[0] := Point(Dx - 20 + Dw, Dy);
    PP[1] := Point(Dx - 40 + Dw, Dy);
    PP[2] := Point(Width - 1, 0);
    PP[3] := Point(Dx - 20 + Dw, Dy);
    Bitmap.Canvas.Polygon(PP);
    Bitmap.Canvas.Brush.Color := $00FFFF;
    Bitmap.Canvas.Pen.Color := $00FFFF;
    Bitmap.Canvas.MoveTo(Dx - 20 + Dw, Dy);
    Bitmap.Canvas.LineTo(Dx - 40 + Dw, Dy);
  end;
  RGN := BitmapToRegion(Bitmap, $FFFFFF);
  SetWindowRGN(Handle, RGN, False);
  FormPaint(Self);
end;

procedure THelpPopup.Refresh;
begin
  FormPaint(Self);
  MemText.Invalidate;
end;

procedure THelpPopup.SetActivePoint(const Value: TPoint);
begin
  FActivePoint := Value;
  SetPos(Value);
  ReCreateRGN;
end;

procedure THelpPopup.SetPos(P: TPoint);
var
  FTop, FLeft: Integer;
begin
  FTop := P.Y + 1;
  FLeft := P.X + 1;
  if FTop + Height > Screen.Height then
    FTop := P.Y - Height-1;
  if FLeft+Width>Screen.Width then
    FLeft := P.X - Width-1;
  Top:=FTop;
  Left:=FLeft;
end;

procedure THelpPopup.SetText(const Value: String);
begin
  FText.Text := Value;
  MemText.Lines.Assign(FText);
  MemText.Height := Abs((MemText.Lines.Count + 1 ) * MemText.Font.Height);
  dh := Abs((MemText.Lines.Count + 1) * MemText.Font.Height) + 10 + ImbClose.Height + 5;
  ImbNext.Top := MemText.Top + MemText.Height + 3;
  if ImbNext.Visible then
    dh := dh + ImbNext.Height + 5;
  Height := 50 + dh + 50;
  FSimpleText := Value;
end;

procedure THelpPopup.DestroyTimerTimer(Sender: TObject);
begin
  DestroyTimer.Enabled := False;
  Release;
end;

procedure THelpPopup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FOnHelpClose) then
    FOnHelpClose(self);
  DestroyTimer.Enabled := True;
end;

procedure THelpPopup.FormDeactivate(Sender: TObject);
begin
  FOnCanCloseMessage := False;
  if not DestroyTimer.Enabled then
    Close;
end;

procedure THelpPopup.FormDestroy(Sender: TObject);
begin
  F(Bitmap);
  F(FText);
end;

procedure THelpPopup.SetNextButtonVisible(const Value: Boolean);
begin
  FNextButtonVisible := Value;
  ImbNext.Visible:=Value;
  SetText(HelpText);
end;

procedure THelpPopup.SetCallBack(const Value: TNotifyEvent);
begin
  FCallBack := Value;
end;

procedure THelpPopup.ImbNextClick(Sender: TObject);
begin
  FOnCanCloseMessage := False;
  if Assigned(FCallBack) then
    FCallBack(Self);
  Close;
end;

procedure THelpPopup.SetNextText(const Value: string);
begin
  FNextText := Value;
  ImbNext.Caption := FNextText;
  ImbNext.ShowCaption := False;
  ImbNext.ShowCaption := True;
end;

procedure THelpPopup.SetOnHelpClose(const Value: TNotifyEvent);
begin
  FOnHelpClose := Value;
end;

procedure THelpPopup.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FOnCanCloseMessage then
    if Assigned(CanHelpClose) then
      CanHelpClose(Sender, CanClose);
end;

procedure THelpPopup.SetCanHelpClose(const Value: TCanHelpCloseProcedure);
begin
  FCanHelpClose := Value;
end;

procedure THelpPopup.SetHelpCaption(const Value: String);
begin
  FHelpCaption := Value;
  Label1.Caption:=Value;
end;

procedure THelpPopup.Copy1Click(Sender: TObject);
begin
  ClipBoard.SetTextBuf(PChar(MemText.Text));
end;

procedure THelpPopup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
