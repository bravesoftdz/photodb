unit uDXUtils;

interface

uses
  System.Types,
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  Winapi.Windows,
  Vcl.Graphics,
  Vcl.Forms,
  DDraw,
  uDBForm,
  uDBThread,
  uMemory,
  uMemoryEx;

type
  TByteArr = array [0 .. 0] of Byte;
  PByteArr = ^TByteArr;

type
  TCallbackInfo = record
    Action: Byte;
    ForwardThread: Boolean;
    Direction: Boolean;
  end;

type
  TDirectXSlideShowCreatorCallBackResult = record
    Action: Byte;
    FileName: string;
    Result: Integer;
  end;

type
  TDirectXSlideShowCreatorCallBack = function(CallbackInfo: TCallbackInfo)
    : TDirectXSlideShowCreatorCallBackResult of object;

type
  TDirectXSlideShowCreatorManager = class;

  TDirectXSlideShowCreatorInfo = record
    FileName: string;
    Rotate: Integer;
    SID: TGUID;
    Manager: TDirectXSlideShowCreatorManager;
    Form: TDBForm;
  end;

  TThreadDestroyDXObjects = record
    DirectDraw4: IDirectDraw4;
    PrimarySurface: IDirectDrawSurface4;
    Offscreen: IDirectDrawSurface4;
    Buffer: IDirectDrawSurface4;
    Clpr: IDirectDrawClipper;
    Form: TDBForm;
  end;

  TDirectXSlideShowCreatorCustomThread = class(TDBThread)
  private
    FID: TGUID;
  public
    constructor Create(Info: TDirectXSlideShowCreatorInfo);
    property ID: TGUID read FID;
  end;

  TDirectXSlideShowCreatorManager = class(TObject)
  private
    FThreads: TList;
    FIDList: TStrings;
    FFreeOnExit: Boolean;
    FSync: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddThread(Thread: TDirectXSlideShowCreatorCustomThread);
    procedure RemoveThread(Thread: TDirectXSlideShowCreatorCustomThread);
    function ThreadExists(ID: TGUID): Boolean;
    function IsThread(Thread: TDirectXSlideShowCreatorCustomThread): Boolean;
    function ThreadCount: Integer;
    procedure FreeOnExit;
  end;

  TDirectXSlideShowCreatorManagers = class(TObject)
  private
    FManagers: TList;
    FSync: TCriticalSection;
    procedure RegisterManager(Manager: TDirectXSlideShowCreatorManager);
    procedure UnregisterManager(Manager: TDirectXSlideShowCreatorManager);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DestroyManager(Manager: TDirectXSlideShowCreatorManager);
    procedure RemoveThread(Manager: TDirectXSlideShowCreatorManager; Thread: TDirectXSlideShowCreatorCustomThread);
    procedure Lock;
    procedure Unlock;
  end;

procedure LockRead (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
procedure LockWrite (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
function PackColor (Color: TColor; BPP, RBM, GBM, BBM: Byte): TColor; inline;
function CenterBmp(Buffer: IDirectDrawSurface4; Bitmap: TBitmap; Rect: TRect): TRect;
procedure UnLock (Buffer: IDirectDrawSurface4);

function DirectXSlideShowCreatorManagers: TDirectXSlideShowCreatorManagers;

implementation

var
  FDirectXSlideShowCreatorManagers: TDirectXSlideShowCreatorManagers = nil;

function DirectXSlideShowCreatorManagers: TDirectXSlideShowCreatorManagers;
begin
  if FDirectXSlideShowCreatorManagers = nil then
    FDirectXSlideShowCreatorManagers := TDirectXSlideShowCreatorManagers.Create;

  Result := FDirectXSlideShowCreatorManagers;
end;

//������������� �����������.
//�� �������� ���������� � ��������� ������ ����� Lock � UnLock! ��� ��������!
procedure UnLock (Buffer: IDirectDrawSurface4);
begin
  if Buffer = nil then exit;
  Buffer.UnLock (nil);
end;

//�������� ����� � ������ ��������� ���������� �������������
//(�������� RBM, GBM � BBM ��������� ��� �������� DirectDraw)
function PackColor (Color: TColor; BPP, RBM, GBM, BBM: Byte): TColor; inline;
var
  r, g, b: integer;
begin
  Color := ColorToRGB (Color);
  b := (Color shr 16) and $FF;
  G := (Color shr 8) and $FF;
  R := Color and $FF;
  if BPP = 16 then
  begin
    R := R shr 3;
    G := G shr 3;
    B := B shr 3;
  end;
  Result := (R shl RBM) or (G shl GBM) or (B shl BBM);
end;

// ���������� ����������� �� ������. �����, �������, ����������� ������, �� ���
// ���������� ��������, � �������� ������ DDLOCK_READONLY ��� DDLOCK_WRITEONLY
//����� �� ��������� ������� ���-�� ��� ��������������...
//�� �������� ���������� � ��������� ������ ����� Lock � UnLock! ��� ��������!
procedure LockRead (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
begin
  if Buffer = nil then exit;
  ZeroMemory (@SurfaceDesc, sizeof (TDDSurfaceDesc2));
  SurfaceDesc.dwSize := sizeof (TDDSurfaceDesc2);
  Buffer.Lock (nil, SurfaceDesc, DDLOCK_WAIT or DDLOCK_SURFACEMEMORYPTR or DDLOCK_READONLY, 0);
  // � SurfaceDesc.lpSurface ������ ����������� ����� �����������.
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
  if SurfaceDesc.LpSurface = nil then
    UnLock(Buffer);
end;

// � ��� - ����������� �������� �� ������� Delphi TBitmap �� ����������� DirectDraw.
// �������� �������������� ���, ����� ��������� ���������� ����� �������������� Rect,
// ����� ���� ����������� �� ������. ���������� �������������, ������� ������� ���������.
function CenterBmp(Buffer: IDirectDrawSurface4; Bitmap: TBitmap; Rect: TRect): TRect;
var
  Dc: HDC;
  W0, H0: Integer;
  W, H: Double;
begin
  if (Buffer = nil) or (Bitmap = nil) then
     Exit;

  // ������������ � ����������.
  w0 := Bitmap.Width;
  h0 := Bitmap.Height;
  w := Rect.Right - Rect.Left;
  h := 1.0 * h0 * w / w0;
  if h > Rect.Bottom - Rect.Top then
  begin
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
  try
    //��������.
    BitBlt(DC, 0, 0, Bitmap.Width, Bitmap.Height, Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    //������ ���������� device context �����������!
    Buffer.ReleaseDC (DC);
  end;
  Result := System.Classes.Rect(0, 0, Bitmap.Width, Bitmap.Height);
end;

{ TDirectXSlideShowCreatorManager }

procedure TDirectXSlideShowCreatorManager.AddThread(Thread: TDirectXSlideShowCreatorCustomThread);
begin
  FSync.Enter;
  try
    if FThreads.IndexOf(Thread) < 0 then
    begin
      FThreads.Add(Thread);
      FIDList.Add(GUIDToString(Thread.ID));
    end;
  finally
    FSync.Leave;
  end;
end;

constructor TDirectXSlideShowCreatorManager.Create;
begin
  FSync := TCriticalSection.Create;
  FThreads := TList.Create;
  FFreeOnExit := False;
  FIDList := TStringList.Create;
  DirectXSlideShowCreatorManagers.RegisterManager(Self);
end;

destructor TDirectXSlideShowCreatorManager.Destroy;
begin
  DirectXSlideShowCreatorManagers.UnregisterManager(Self);
  F(FThreads);
  F(FSync);
  F(FIDList);
  inherited;
end;

procedure TDirectXSlideShowCreatorManager.FreeOnExit;
begin
  FFreeOnExit := True;
end;

function TDirectXSlideShowCreatorManager.IsThread(Thread: TDirectXSlideShowCreatorCustomThread): Boolean;
begin
  FSync.Enter;
  try
    Result := FThreads.IndexOf(Thread) > -1;
  finally
    FSync.Leave;
  end;
end;

procedure TDirectXSlideShowCreatorManager.RemoveThread(Thread: TDirectXSlideShowCreatorCustomThread);
var
  P: Integer;
begin
  FSync.Enter;
  try
    FThreads.Remove(Thread);

    P := FIDList.IndexOf(GUIDToString(Thread.ID));
    if (P > -1) then
      FIDList.Delete(P);

    if (FThreads.Count = 0) and FFreeOnExit then
      Free;
  finally
    if FSync <> nil then
      FSync.Leave;
  end;
end;

function TDirectXSlideShowCreatorManager.ThreadCount: Integer;
begin
  FSync.Enter;
  try
    Result := FThreads.Count;
  finally
    FSync.Leave;
  end;
end;

function TDirectXSlideShowCreatorManager.ThreadExists(ID: TGUID): Boolean;
begin
  FSync.Enter;
  try
    Result := FIDList.IndexOf(GUIDToString(ID)) > -1;
  finally
    FSync.Leave;
  end;
end;

{ TDirectXSlideShowCreatorManagers }

constructor TDirectXSlideShowCreatorManagers.Create;
begin
  FManagers := TList.Create;
  FSync := TCriticalSection.Create;
end;

destructor TDirectXSlideShowCreatorManagers.Destroy;
begin
  FreeList(FManagers);
  F(FSync);
  inherited;
end;

procedure TDirectXSlideShowCreatorManagers.DestroyManager(
  Manager: TDirectXSlideShowCreatorManager);
begin
  FSync.Enter;
  try
    if FManagers.IndexOf(Manager) > 0 then
    begin
      if Manager.ThreadCount <> 0 then
      begin
        Manager.FreeOnExit;
        Exit;
      end;
    end;

    FManagers.Remove(Manager);
    Manager.Free;
  finally
    FSync.Leave;
  end;
end;

procedure TDirectXSlideShowCreatorManagers.Lock;
begin
  FSync.Enter;
end;

procedure TDirectXSlideShowCreatorManagers.RegisterManager(
  Manager: TDirectXSlideShowCreatorManager);
begin
  FSync.Enter;
  try
    FManagers.Add(Manager);
  finally
    FSync.Leave;
  end;
end;

procedure TDirectXSlideShowCreatorManagers.RemoveThread(
  Manager: TDirectXSlideShowCreatorManager; Thread: TDirectXSlideShowCreatorCustomThread);
begin
  FSync.Enter;
  try
    if FManagers.IndexOf(Manager) > -1 then
      Manager.RemoveThread(Thread);
  finally
    FSync.Leave;
  end;
end;

procedure TDirectXSlideShowCreatorManagers.Unlock;
begin
  FSync.Leave;
end;

procedure TDirectXSlideShowCreatorManagers.UnregisterManager(
  Manager: TDirectXSlideShowCreatorManager);
begin
  FSync.Enter;
  try
    FManagers.Remove(Manager);
  finally
    FSync.Leave;
  end;
end;

{ TDirectXSlideShowCreatorCustomThread }

constructor TDirectXSlideShowCreatorCustomThread.Create(
  Info: TDirectXSlideShowCreatorInfo);
begin
  inherited Create(Info.Form, False);
  FID := Info.SID;
end;

initialization

finalization

  F(FDirectXSlideShowCreatorManagers);

end.
