unit uDXUtils;

interface

uses
  Windows, Graphics, Classes, DDraw;

procedure LockRead (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
procedure LockWrite (Buffer: IDirectDrawSurface4; var SurfaceDesc: TDDSurfaceDesc2);
function PackColor (Color: TColor; BPP, RBM, GBM, BBM: Byte): TColor; inline;
function CenterBmp(Buffer: IDirectDrawSurface4; Bitmap: TBitmap; Rect: TRect): TRect;
procedure UnLock (Buffer: IDirectDrawSurface4);

implementation

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
  Result := Classes.Rect(0,0,Bitmap.Width,Bitmap.Height);
end;

end.
