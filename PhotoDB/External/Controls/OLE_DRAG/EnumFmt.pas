unit EnumFmt;

interface

uses Windows, ActiveX;

type
  { TFormatList -- ������ ������� TFormatEtc }
  PFormatList = ^TFormatList;
  TFormatList = array[0..1] of TFormatEtc;

  TEnumFormatEtc = class (TInterfacedObject, 
  IEnumFormatEtc)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;
    FIndex: Integer;
  public
    constructor Create
      (FormatList: PFormatList; FormatCount, 
      Index: Integer);
    { IEnumFormatEtc }
    function Next
      (celt: Longint; out elt; 
      pceltFetched: PLongint): HResult; stdcall;
    function Skip (celt: Longint) : HResult; 
    stdcall;
    function Reset : HResult; stdcall;
    function Clone (out enum : IEnumFormatEtc) : 
    HResult; stdcall;
  end;

implementation

constructor TEnumFormatEtc.Create
    (
      FormatList: PFormatList;
      FormatCount, Index : Integer
    );
begin
  inherited Create;
  FFormatList := FormatList;
  FFormatCount := FormatCount;
  FIndex := Index;
end;

{
  Next ��������� �������� ���������� 
  �������� TFormatEtc
  � ������������ ������ elt.
  ����������� celt ���������, ������� � 
  ������� ������� � ������.
}
function TEnumFormatEtc.Next
    (
      celt: Longint;
      out elt;
      pceltFetched: PLongint
    ): HResult;
var
  i : Integer;
  eltout : TFormatList absolute elt;
begin
  i := 0;

  while (i < celt) and (FIndex < 
  FFormatCount) do
  begin
    eltout[i] := FFormatList[FIndex];
    Inc (FIndex);
    Inc (i);
  end;

  if (pceltFetched <> nil) then
    pceltFetched^ := i;

  if (I = celt) then
    Result := S_OK
  else
    Result := S_FALSE;
end;

{
  Skip ���������� celt ��������� ������, 
  ������������ ������� �������
  �� (CurrentPointer + celt) ��� �� ����� 
  ������ � ������ ������������.
}
function TEnumFormatEtc.Skip
    (
      celt: Longint
    ): HResult;
begin
  if (celt <= FFormatCount - FIndex) then
  begin
    FIndex := FIndex + celt;
    Result := S_OK;
  end else
  begin
    FIndex := FFormatCount;
    Result := S_FALSE;
  end;
end;

{ Reset ������������� ��������� ������� 
������� �� ������ ������ }
function TEnumFormatEtc.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

{ Clone �������� ������ �������� }
function TEnumFormatEtc.Clone
    (
      out enum: IEnumFormatEtc
     ): HResult;
begin
  enum := TEnumFormatEtc.Create 
  (FFormatList, FFormatCount, FIndex);
  Result := S_OK;
end;

end.

