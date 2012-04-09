unit GBlur2;

interface

uses
  Windows,
  Graphics,
  GraphicsBaseTypes,
  uEditorTypes;

type
  PRGBTriple = ^TRGBTriple;

  TRGBTriple = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;

type
  TRGBArray = array [0 .. 32677] of Windows.TRGBTriple; // bitmap element (API windows)
  PRGBArray = ^TRGBArray; // type pointer to 3 bytes array

  TArPRGBArray = array of PRGBArray;

  PRow = ^TRow;
  TRow = array [0 .. 32677] of TRGBTriple;

  PPRows = ^TPRows;
  TPRows = array [0 .. 32677] of PRow;

const
  MaxKernelSize = 100;

type

  TKernelSize = 1 .. MaxKernelSize;
  TKernel = record
    Size: TKernelSize;
    Weights: array [-MaxKernelSize .. MaxKernelSize] of Single;
  end;
  // ���� ����������� � ���, ��� ��� ������������� TKernel �� ����������
  // Weights (���), �� ����������� Weights � ��������� -Size..Size.

procedure GBlur(TheBitmap: TBitmap; Radius: Double; CallBack: TProgressCallBackProc = nil);
procedure GBlurW(A, B: Integer; TheBitmap: TBitmap; Radius: Double; CallBack: TProgressCallBackProc = nil);
procedure GBlurWX(A, B: Integer; TheBitmap: TBitmap; ScanLines: TArPRGBArray; Radius: Double;
  CallBack: TProgressCallBackProc = nil);

implementation

uses
  SysUtils;

procedure MakeGaussianKernel(var K: TKernel; Radius: Double;

  MaxData, DataGranularity: Double; CallBack: TProgressCallBackProc = nil);
// ������ K (�������� �����) �� ������������������ ����������� = radius.
// ��� �������� ���������� �� ������������� ���������� MaxData = 255,
// DataGranularity = 1. ������ � ��������� ��������� ��������
// K.Size ���, ��� ��� ������������� K �� ����� ������������ Weights (���)
// � �������� ���������� ����������. (����� ������ ��� �� ������,
// ��������� ����� ���������� �������� ������� ��
// �������� K.Size.)
var
  J: Integer;
  Temp, Delta: Double;
  KernelSize: TKernelSize;
begin

  for J := low(K.Weights) to high(K.Weights) do
  begin
    Temp := J / Radius;
    K.Weights[J] := Exp(-Temp * Temp / 2);
  end;

  // ������ ���, ����� sum(Weights) = 1:

  Temp := 0;
  for J := low(K.Weights) to high(K.Weights) do
    Temp := Temp + K.Weights[J];
  for J := low(K.Weights) to high(K.Weights) do
    K.Weights[J] := K.Weights[J] / Temp;

  // ������ ����������� (��� ������ ������� "������������"
  // ��� ���������� Size) ������, ������� ������������ ��������� �������� -
  // ��� �����, � ��������� ������ ���������� ���������� � ����� �������� �
  // ��� �������, ������� "�������������" ������� ��������...

  KernelSize := MaxKernelSize;
  Delta := DataGranularity / (2 * MaxData);
  Temp := 0;
  while (Temp < Delta) and (KernelSize > 1) do
  begin
    Temp := Temp + 2 * K.Weights[KernelSize];
    Dec(KernelSize);
  end;

  K.Size := KernelSize;

  // ������ ��� ������������ ������������� ���������� �������� �� ��
  // �������� � K.Size, ���, ����� ����� ���� ������ ���� ����� �������:

  Temp := 0;
  for J := -K.Size to K.Size do
    Temp := Temp + K.Weights[J];
  for J := -K.Size to K.Size do
    K.Weights[J] := K.Weights[J] / Temp;

end;

function TrimInt(Lower, Upper, TheInteger: Integer): Integer;
begin

  if (TheInteger <= Upper) and (TheInteger >= Lower) then
    Result := TheInteger
  else if TheInteger > Upper then
    Result := Upper
  else
    result := Lower;
end;

function TrimReal(Lower, Upper: Integer; X: Double): Integer;
begin

  if (X < Upper) and (X >= Lower) then
    Result := Trunc(X)
  else if X > Upper then
    Result := Upper
  else
    Result := Lower;
end;

procedure BlurRow(var TheRow: array of TRGBTriple; K: TKernel; P: PRow);
var
  J, N: Integer;
  Tr, Tg, Tb: Double; // tempRed � ��.

  W: Double;
begin

  for J := 0 to high(TheRow) do

  begin
    Tb := 0;
    Tg := 0;
    Tr := 0;
    for N := -K.Size to K.Size do
    begin
      W := K.Weights[N];

      // TrimInt ������ ������ �� ���� ������...

      with TheRow[TrimInt(0, high(TheRow), J - N)] do
      begin
        Tb := Tb + W * B;
        Tg := Tg + W * G;
        Tr := Tr + W * R;
      end;
    end;
    with P[J] do
    begin
      B := TrimReal(0, 255, Tb);
      G := TrimReal(0, 255, Tg);
      R := TrimReal(0, 255, Tr);
    end;
  end;

  Move(P[0], TheRow[0], ( high(TheRow) + 1) * Sizeof(TRGBTriple));
end;

procedure GBlur(TheBitmap: TBitmap; Radius: Double; CallBack: TProgressCallBackProc = nil);
begin
  GBlurW(0, 100, TheBitmap, Radius, CallBack);
end;

procedure GBlurWX(A, B: Integer; TheBitmap: TBitmap; ScanLines: TArPRGBArray; Radius: Double;
  CallBack: TProgressCallBackProc = nil);
var
  Row, Col: Integer;
  TheRows: PPRows;
  K: TKernel;
  ACol: PRow;
  P: PRow;
  Terminate: Boolean;
begin
  if (TheBitmap.HandleType <> BmDIB) or (TheBitmap.PixelFormat <> pf24Bit) then
    raise Exception.Create('GBlur can work only with 24-bit images');

  MakeGaussianKernel(K, Radius, 255, 1);
  GetMem(TheRows, TheBitmap.Height * SizeOf(PRow));
  GetMem(ACol, theBitmap.Height * SizeOf(TRGBTriple));

  //������ ������� ������ �����������:
  for Row := 0 to theBitmap.Height - 1 do
    theRows[Row] := PRow(ScanLines[Row]); // theBitmap.Scanline[Row];

  // ��������� ������ �������:
  P := AllocMem(TheBitmap.Width * SizeOf(TRGBTriple));
  for Row := 0 to TheBitmap.Height - 1 do

    BlurRow(Slice(TheRows[Row]^, TheBitmap.Width), K, P);

  // ������ ��������� ������ �������
  ReAllocMem(P, TheBitmap.Height * SizeOf(TRGBTriple));
  Terminate := False;
  for Col := 0 to TheBitmap.Width - 1 do
  begin
    // - ��������� ������ ������� � TRow:

    for Row := 0 to TheBitmap.Height - 1 do
      ACol[Row] := TheRows[Row][Col];

    BlurRow(Slice(ACol^, TheBitmap.Height), K, P);

    // ������ �������� ������������ ������� �� ���� ����� � ������ �����������:

    for Row := 0 to TheBitmap.Height - 1 do
      TheRows[Row][Col] := ACol[Row];
    if Col mod (TheBitmap.Width div 50) = 0 then
      if Assigned(CallBack) then
        CallBack(A + Round(Col * B / Thebitmap.Width), Terminate);
    if Terminate then
      Break;
  end;

  FreeMem(TheRows);
  FreeMem(ACol);
  ReAllocMem(P, 0);
end;

procedure GBlurW(A, B: Integer; TheBitmap: TBitmap; Radius: Double; CallBack: TProgressCallBackProc = nil);
var
  Row, Col: Integer;
  TheRows: PPRows;
  K: TKernel;
  ACol: PRow;
  P: PRow;
  Terminate: Boolean;
begin
  if (TheBitmap.HandleType <> BmDIB) or (TheBitmap.PixelFormat <> Pf24Bit) then

    raise Exception.Create('GBlur ����� �������� ������ � 24-������� �������������');

  MakeGaussianKernel(K, Radius, 255, 1);
  GetMem(TheRows, TheBitmap.Height * SizeOf(PRow));
  GetMem(ACol, TheBitmap.Height * SizeOf(TRGBTriple));

  // ������ ������� ������ �����������:
  for Row := 0 to TheBitmap.Height - 1 do

    TheRows[Row] := TheBitmap.Scanline[Row];

  // ��������� ������ �������:
  P := AllocMem(TheBitmap.Width * SizeOf(TRGBTriple));
  for Row := 0 to TheBitmap.Height - 1 do

    BlurRow(Slice(TheRows[Row]^, TheBitmap.Width), K, P);

  // ������ ��������� ������ �������
  ReAllocMem(P, theBitmap.Height * SizeOf(TRGBTriple));
  Terminate:=false;
  for Col := 0 to theBitmap.Width - 1 do
  begin
    //- ��������� ������ ������� � TRow:

    for Row := 0 to theBitmap.Height - 1 do
      ACol[Row] := theRows[Row][Col];

    BlurRow(Slice(ACol^, theBitmap.Height), K, P);

    //������ �������� ������������ ������� �� ���� ����� � ������ �����������:

    for Row := 0 to theBitmap.Height - 1 do
      theRows[Row][Col] := ACol[Row];
    if Col mod (theBitmap.Width div 50)=0 then
    if Assigned(CallBack) then CallBack(a+Round(Col*b/thebitmap.Width),Terminate);
    if Terminate then break;
  end;

  FreeMem(theRows);
  FreeMem(ACol);
  ReAllocMem(P, 0);
end;

end.
