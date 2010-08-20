unit UnitHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DmMemo, ImButton, ExtCtrls, Menus, clipbrd, Dolphin_DB;

Type
  TRGB=record
  b,g,r : byte;
  end;

    ARGB=array [0..32677] of TRGB;
    PARGB=^ARGB;
    PRGB = ^TRGB;

  TCanHelpCloseProcedure = Procedure(Sender : TObject; var CanClose : Boolean) of object;

type
  THelpPopup = class(TForm)
    DmMemo1: TDmMemo;
    ImButton1: TImButton;
    DestroyTimer: TTimer;
    ImButton2: TImButton;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ColorFill(var image : tbitmap);
    procedure ImButton1Click(Sender: TObject);
    procedure SetPos(P : TPoint);
    procedure ReCreateRGN;
    procedure DestroyTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure ImButton2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Copy1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FActivePoint: TPoint;
    FText: TStrings;
    FSimpleText : String;
    Bitmap : TBitmap;
    dw, dh : integer;
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
  Property ActivePoint : TPoint read FActivePoint write SetActivePoint;
  Property HelpText : String read FSimpleText write SetText;
  Property NextButtonVisible : Boolean read FNextButtonVisible Write SetNextButtonVisible;
  Property CallBack : TNotifyEvent read FCallBack Write SetCallBack;
  Property OnHelpClose : TNotifyEvent read FOnHelpClose Write SetOnHelpClose;
  Property NextText : String read FNextText write SetNextText;
  Property CanHelpClose : TCanHelpCloseProcedure read FCanHelpClose write SetCanHelpClose;
  Property HelpCaption : String read FHelpCaption Write SetHelpCaption;
  procedure Refresh;
  procedure DoDelp(HelpMessage : String; Point : TPoint);
    { Public declarations }
  end;
  
Procedure DoHelpHint(Caption, HelpText : String; MyPoint : TPoint; Control : TControl);
Procedure DoHelpHintCallBack(Caption, HelpText : String; MyPoint : TPoint; Control : TControl; CallBack : TNotifyEvent; Text : String);
Procedure DoHelpHintCallBackOnCanClose(Caption, HelpText : String; MyPoint : TPoint; Control : TControl; CallBack : TNotifyEvent; Text : String; OnCanClose : TCanHelpCloseProcedure);

implementation

uses Language;

{$R *.dfm}

Procedure DoHelpHint(Caption, HelpText : String; MyPoint : TPoint; Control : TControl);
var
  HelpPopup: THelpPopup;
begin
 Application.CreateForm(THelpPopup, HelpPopup);
 HelpPopup.NextButtonVisible:=false;
 HelpPopup.HelpCaption:=Caption;
 if Control<>nil then
 begin
  MyPoint:=Control.ClientToScreen(Point(Control.ClientWidth div 2,Control.Clientheight div 2));
 end;
 HelpPopup.DoDelp(HelpText,MyPoint);
end;

Procedure DoHelpHintCallBack(Caption, HelpText : String; MyPoint : TPoint; Control : TControl; CallBack : TNotifyEvent; Text : String);
var
  HelpPopup: THelpPopup;
begin
 Application.CreateForm(THelpPopup, HelpPopup);
 HelpPopup.NextButtonVisible:=True;
 HelpPopup.NextText:=Text;
 HelpPopup.CallBack:=CallBack;
 HelpPopup.HelpCaption:=Caption;
 if Control<>nil then
 begin
  MyPoint:=Control.ClientToScreen(Point(Control.ClientWidth div 2,Control.Clientheight div 2));
 end;
 HelpPopup.DoDelp(HelpText,MyPoint);
end;

Procedure DoHelpHintCallBackOnCanClose(Caption, HelpText : String; MyPoint : TPoint; Control : TControl; CallBack : TNotifyEvent; Text : String; OnCanClose : TCanHelpCloseProcedure);
var
  HelpPopup: THelpPopup;
begin
 Application.CreateForm(THelpPopup, HelpPopup);
 HelpPopup.NextButtonVisible:=True;
 HelpPopup.NextText:=Text;
 HelpPopup.CallBack:=CallBack;
 HelpPopup.CanHelpClose:=OnCanClose;
 HelpPopup.HelpCaption:=Caption;
 if Control<>nil then
 begin
  MyPoint:=Control.ClientToScreen(Point(Control.ClientWidth div 2,Control.Clientheight div 2));
 end;
 HelpPopup.DoDelp(HelpText,MyPoint);
end;

function CreateBitmapRgn(Bitmap: TBitmap; TransClr: TColorRef): hRgn;
var
// bmInfo: TBitmap;                //��������� BITMAP WinAPI
 W, H: Integer;                  //������ � ������ ������
 bmDIB: hBitmap;                 //���������� ������������ ������
 bmiInfo: BITMAPINFO;            //��������� BITMAPINFO WinAPI
 lpBits, lpOldBits: PRGBTriple;  //��������� �� ��������� RGBTRIPLE WinAPI
 lpData: PRgnData;               //��������� �� ��������� RGNDATA WinAPI
 X, Y, C, F, I: Integer;         //���������� ������
 Buf: Pointer;                   //���������
 BufSize: Integer;               //������ ���������
 rdhInfo: TRgnDataHeader;        //��������� RGNDATAHEADER WinAPI
 lpRect: PRect;                  //��������� �� TRect (RECT WinAPI)
 memDC : HDC;
begin
 Result:=0;
 if Bitmap=nil then Exit;          //���� ����� �� �����, �������

// GetObject(Bitmap, SizeOf(bmInfo), @bmInfo);  //������ ������� ������
 W:=Bitmap.Width;                           //��������� ��������� BITMAP
 H:=Bitmap.Height;
 I:=(W*3)-((W*3) div 4)*4;                    //���������� �������� � ������
 if I<>0 then I:=4-I;

//���������: ����� Windows Bitmap �������� ����� �����, ������ ������ ������
//����������� �������� ������� �� �� ��������� 4.
//��� 32-� ������ ������� ����� ����� ������ �� ����.

//��������� BITMAPINFO ��� �������� � CreateDIBSection
 memDC := CreateCompatibleDC(0);
 bmiInfo.bmiHeader.biWidth:=W;             //������
 bmiInfo.bmiHeader.biHeight:=H;            //������
 bmiInfo.bmiHeader.biPlanes:=1;            //������ 1
 bmiInfo.bmiHeader.biBitCount:=24;         //��� ����� �� �������
 bmiInfo.bmiHeader.biCompression:=BI_RGB;  //��� ����������
 bmiInfo.bmiHeader.biSizeImage:=0;         //������ �� �����, ������ � ����
 bmiInfo.bmiHeader.biXPelsPerMeter:=2834;  //�������� �� ����, ���.
 bmiInfo.bmiHeader.biYPelsPerMeter:=2834;  //�������� �� ����, ����.
 bmiInfo.bmiHeader.biClrUsed:=0;           //������� ���, ��� � ����
 bmiInfo.bmiHeader.biClrImportant:=0;      //�� ��
 bmiInfo.bmiHeader.biSize:=SizeOf(bmiInfo.bmiHeader); //������ ���������
 bmDIB:=CreateDIBSection(memDC, bmiInfo, DIB_RGB_COLORS,
                         Pointer(lpBits), 0, 0);
//������� ����������� ����� WxHx24, ��� �������, � ��������� lpBits ��������
//����� ������� ����� ����� ������. bmDIB - ���������� ������

//��������� ������ ����� ������ BITMAPINFO ��� �������� � GetDIBits

 bmiInfo.bmiHeader.biWidth:=W;             //������
 bmiInfo.bmiHeader.biHeight:=H;            //������
 bmiInfo.bmiHeader.biPlanes:=1;            //������ 1
 bmiInfo.bmiHeader.biBitCount:=24;         //��� ����� �� �������
 bmiInfo.bmiHeader.biCompression:=BI_RGB;  //��� ���������
 bmiInfo.bmiHeader.biSize:=SizeOf(bmiInfo.bmiHeader); //������ ���������
 GetDIBits(memDC, Bitmap.Handle, 0, H-1, lpBits, bmiInfo, DIB_RGB_COLORS);
//������������ �������� ����� � ��� � ��� ������������ �� ������ lpBits

 lpOldBits:=lpBits;  //���������� ����� lpBits

//������ ������ - ������������ ����� ���������������, ����������� ���
//�������� �������
 C:=0;                         //������� ����
 for Y:=H-1 downto 0 do        //������ ����� �����
   begin
     X:=0;
     while X<W do              //�� 0 �� ������-1
       begin
//���������� ��������� ����, ���������� ���������� � ���������
         while (RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                    lpBits.rgbtBlue)=TransClr) and (X<W) do
           begin
             Inc(lpBits);
             X:=X+1;
           end;
//���� ����� �� ���������� ����, �� �������, ������� ����� � ���� �� ����
         if RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                lpBits.rgbtBlue)<>TransClr then
           begin
             while (RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                     lpBits.rgbtBlue)<>TransClr) and (X<W) do
               begin
                 Inc(lpBits);
                 X:=X+1;
               end;
             C:=C+1;  //����������� ������� ���������������
           end;
       end;
//��� ����������, ���������� ��������� ��������� �� ��������� 4
     PChar(lpBits):=PChar(lpBits)+I;
   end;

 lpBits:=lpOldBits;  //��������������� �������� lpBits

//��������� ��������� RGNDATAHEADER
 rdhInfo.iType:=RDH_RECTANGLES;             //����� ������������ ��������������
 rdhInfo.nCount:=C;                         //�� ����������
 rdhInfo.nRgnSize:=0;                       //������ �������� ������ �� �����
 rdhInfo.rcBound:=Rect(0, 0, W, H);         //������ �������
 rdhInfo.dwSize:=SizeOf(rdhInfo);           //������ ���������

//�������� ������ ��� �������� RGNDATA:
//����� RGNDATAHEADER � ����������� �� ���������������
 BufSize:=SizeOf(rdhInfo)+SizeOf(TRect)*C;
 GetMem(Buf, BufSize);
 lpData:=Buf;             //������ ��������� �� ���������� ������
 lpData.rdh:=rdhInfo;     //������� � ������ RGNDATAHEADER

//���������� ������ ����������������
 lpRect:=@lpData.Buffer;  //������ �������������
 for Y:=H-1 downto 0 do
   begin
     X:=0;
     while X<W do
       begin
         while (RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                 lpBits.rgbtBlue)=TransClr) and (X<W) do
           begin
             Inc(lpBits);
             X:=X+1;
           end;
         if RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                lpBits.rgbtBlue)<>TransClr then
           begin
             F:=X;
             while (RGB(lpBits.rgbtRed, lpBits.rgbtGreen,
                     lpBits.rgbtBlue)<>TransClr) and (X<W) do
               begin
                 Inc(lpBits);
                 X:=X+1;
               end;
             lpRect^:=Rect(F, Y-1, X, Y);  //������� ����������
             Inc(lpRect);                  //��������� � ����������
           end;
       end;
     PChar(lpBits):=PChar(lpBits)+I;
   end;

//����� ��������� ���������� ��������� RGNDATA ����� ��������� ������.
//������������� ��� �� �����, ������ � nil, ��������� ������
//��������� ��������� � �� ����.
 Result:=ExtCreateRegion(nil, BufSize, lpData^);  //������� ������

 FreeMem(Buf, BufSize);  //������ ��������� RGNDATA ������ �� �����, �������
 DeleteObject(bmDIB);    //��������� ����� ���� �������
end;

function BitmapToRegion(hBmp: TBitmap; TransColor: TColor): HRGN;
begin
 Result:=CreateBitmapRgn(hBmp,TransColor);
end; 


procedure THelpPopup.ColorFill(var image : tbitmap);
var
  i, j : integer;
  p: PARGB;
begin
 for i:=0 to image.Height-1 do
 begin
  p:=image.ScanLine[i];
  for j:=0 to image.Width-1 do
  begin
   p[j].b:=p[j].b div 2;
   p[j].r:=p[j].r div 2+128;
   p[j].g:=p[j].g div 2+128;
  end;
 end;
end;

procedure THelpPopup.DoDelp(HelpMessage: String; Point: TPoint);
begin
 HelpText:=HelpMessage;
 ActivePoint:=Point;
 Show;
 Refresh;
end;

procedure THelpPopup.FormCreate(Sender: TObject);
begin
 Copy1.Caption:=TEXT_MES_COPY;
 FCallBack:=nil;
 FOnCanCloseMessage:=true;
 FNextButtonVisible:=false;
 FText:=TStringList.Create;
 ImButton1.Filter:=ColorFill;
 ImButton1.refresh;
 Bitmap := TBitmap.Create;
 Bitmap.PixelFormat:=pf24bit;
 dh:=100;
 dw:=220;
 FOnHelpClose:=nil;
 ImButton2.Filter:=ColorFill;
 ImButton2.refresh;
 ImButton2.Caption:='Ok';
 ImButton2.ShowCaption:=false;
end;

procedure THelpPopup.FormPaint(Sender: TObject);
begin
 try
  Canvas.Draw(0,-1,Bitmap);
 except
 end;
end;

procedure THelpPopup.ImButton1Click(Sender: TObject);
begin
 Close
end;

procedure THelpPopup.ReCreateRGN;
var
  RGN : HRGN;
  dx, dy : integer;
  PP : array[0..3] of TPoint;
begin
 Bitmap.Width:=Width;
 Bitmap.Height:=Height;
 Bitmap.Canvas.Brush.Color:=$FFFFFF;
 Bitmap.Canvas.Pen.Color:=$FFFFFF;
 Bitmap.Canvas.Rectangle(0,0,Bitmap.Width,Bitmap.Height);
 Bitmap.Canvas.Brush.Color:=$00FFFF;
 Bitmap.Canvas.Pen.Color:=$0;
 dx:=50;
 dy:=50;
 Bitmap.Canvas.RoundRect(0+dx,0+dy,dw+dx,dh+dy,10,10);
 if (Left-FActivePoint.X>=0) and (Top-FActivePoint.y>=0) then
 begin
  PP[0]:=Point(dx+20,dy);
  PP[1]:=Point(dx+40,dy);
  PP[2]:=Point(0,0);
  PP[3]:=Point(dx+20,dy);
  Bitmap.Canvas.Polygon(PP);
  Bitmap.Canvas.Brush.Color:=$00FFFF;
  Bitmap.Canvas.Pen.Color:=$00FFFF;
  Bitmap.Canvas.MoveTo(dx+20,dy);
  Bitmap.Canvas.LineTo(dx+40,dy);
 end;
 if (Left-FActivePoint.X>=0) and (Top-FActivePoint.y<0) then
 begin
  PP[0]:=Point(dx+20,dy+dh-1);
  PP[1]:=Point(dx+40,dy+dh-1);
  PP[2]:=Point(0,height-1);
  PP[3]:=Point(dx+20,dy+dh-1);
  Bitmap.Canvas.Polygon(PP);
  Bitmap.Canvas.Brush.Color:=$00FFFF;
  Bitmap.Canvas.Pen.Color:=$00FFFF;
  Bitmap.Canvas.MoveTo(dx+20,dy+dh-1);
  Bitmap.Canvas.LineTo(dx+40,dy+dh-1);
 end;
 if (Left-FActivePoint.X<0) and (Top-FActivePoint.y<0) then
 begin
  PP[0]:=Point(dx-20+dw,dy+dh-1);
  PP[1]:=Point(dx-40+dw,dy+dh-1);
  PP[2]:=Point(Width-1,Height-1);
  PP[3]:=Point(dx-20+dw,dy+dh-1);
  Bitmap.Canvas.Polygon(PP);
  Bitmap.Canvas.Brush.Color:=$00FFFF;
  Bitmap.Canvas.Pen.Color:=$00FFFF;
  Bitmap.Canvas.MoveTo(dx+dw-20,dy+dh-1);
  Bitmap.Canvas.LineTo(dx+dw-40,dy+dh-1);
 end;
 if (Left-FActivePoint.X<0) and (Top-FActivePoint.y>=0) then
 begin
  PP[0]:=Point(dx-20+dw,dy);
  PP[1]:=Point(dx-40+dw,dy);
  PP[2]:=Point(Width-1,0);
  PP[3]:=Point(dx-20+dw,dy);
  Bitmap.Canvas.Polygon(PP);
  Bitmap.Canvas.Brush.Color:=$00FFFF;
  Bitmap.Canvas.Pen.Color:=$00FFFF;
  Bitmap.Canvas.MoveTo(dx-20+dw,dy);
  Bitmap.Canvas.LineTo(dx-40+dw,dy);
 end;
 RGN:=BitmapToRegion(Bitmap,$FFFFFF);
 SetWindowRGN(Handle,RGN,false);
 FormPaint(Self);
end;

procedure THelpPopup.Refresh;
begin
 FormPaint(Self);
 DmMemo1.Invalidate;
end;

procedure THelpPopup.SetActivePoint(const Value: TPoint);
begin
  FActivePoint := Value;
  SetPos(Value);
  ReCreateRGN;
end;

procedure THelpPopup.SetPos(P: TPoint);
var
  FTop, FLeft : integer;
begin
 FTop:=P.Y+1;
 FLeft:=P.X+1;
 if FTop+Height>Screen.Height then FTop:=P.Y-Height-1;
 if FLeft+Width>Screen.Width then FLeft:=P.X-Width-1;
 Top:=FTop;
 Left:=FLeft;
end;

procedure THelpPopup.SetText(const Value: String);
begin
  FText.Text:=Value;
  DmMemo1.Lines.Assign(FText);
  DmMemo1.Height:=abs((DmMemo1.Lines.Count+1)*DmMemo1.Font.Height);
  dh:=abs((DmMemo1.Lines.Count+1)*DmMemo1.Font.Height)+10+ImButton1.Height+5;
  ImButton2.Top:=DmMemo1.Top+DmMemo1.Height+3;
  if ImButton2.Visible then
  dh:=dh+ImButton2.Height+5;
  Height:=50+dh+50;
  FSimpleText:=Value;
end;

procedure THelpPopup.DestroyTimerTimer(Sender: TObject);
begin
 DestroyTimer.Enabled:=false;
 Release;
 if UseFreeAfterRelease then Free;
end;

procedure THelpPopup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Assigned(FOnHelpClose) then FOnHelpClose(self);
 DestroyTimer.Enabled:=true;
end;

procedure THelpPopup.FormDeactivate(Sender: TObject);
begin
 FOnCanCloseMessage:=false;
 if not DestroyTimer.Enabled then
 Close;
end;

procedure THelpPopup.SetNextButtonVisible(const Value: Boolean);
begin
  FNextButtonVisible := Value;
  ImButton2.Visible:=Value;
  SetText(HelpText);
end;

procedure THelpPopup.SetCallBack(const Value: TNotifyEvent);
begin
  FCallBack := Value;
end;

procedure THelpPopup.ImButton2Click(Sender: TObject);
begin
 FOnCanCloseMessage:=false;
 if Assigned(FCallBack) then FCallBack(Self);
 Close;
end;

procedure THelpPopup.SetNextText(const Value: String);
begin
  FNextText := Value;
  ImButton2.Caption:=FNextText;
  ImButton2.ShowCaption:=False;
  ImButton2.ShowCaption:=True;
end;

procedure THelpPopup.SetOnHelpClose(const Value: TNotifyEvent);
begin
  FOnHelpClose := Value;
end;

procedure THelpPopup.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if FOnCanCloseMessage then
 if Assigned(CanHelpClose) then CanHelpClose(Sender,CanClose);
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
  ClipBoard.SetTextBuf(PWideChar(DmMemo1.Text));
end;

procedure THelpPopup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //ESC
  if Key = 27 then
    Close();
end;

end.
