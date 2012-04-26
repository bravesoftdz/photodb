unit uMachMask; // � Alexandr Petrovich Sysoev

interface

uses
  Classes;

/// ////////////////////////////////////////////////// ������ �� ������� ��������
// ������� ������������� ��� ������������� ������� (���� ������) ��
// ������������ ��������� ������� ��� ������ ��������.
// ������ ������������ ��� ���������� ������� ��������, �������� �����������
// �������� �������� ��������� Total Commander.
//
// ������ ������ ���������� ������� ���� ������ � MS-DOS � MS Windows,
// �.�. ����� �������� "���������" ������� '*' � '?' � �� ����� ��������
// ������ '|'.
// ����� ������ ����� ���� �������� � ������� ������� ('''), ��� ���� �������
// ������� ��������� � ������� ������ ���� �������. ���� ������ ��������
// ������� ';' ��� ' ' (������) �� �� ����������� ������ ���� �������� �
// ������� �������.
// � ������, ������� ����������� �������� ';'.
// �� ������ ������� ��������, ����� ��������� ������ '|', �� ������� �����
// ��������� ������ ������.
// ����� (��� �����) ����� ��������� ��������������� ������ �������� ������
// ���� �� ������������� ���� �� ������ ������� �� ������� ������,
// � �� ������������� �� ������ ������� �� ������� ������.
// ���� ������ ������ ����, �� ��������������� '*'
//
// ���������� �������� ���������� ������ ��������:
//
// ������ ������ ��������      :: [<������ ���������� ��������>]['|'<������ ����������� ��������>]
// ������ ���������� ��������  :: <������ ��������>
// ������ ����������� �������� :: <������ ��������>
// ������ ��������             :: <������>[';'<������>]
// ������                      :: ������ ����������� ������� ���� ������ �
// MS-DOS � MS Windows, �.�. ����� ��������
// "���������" ������� '*' � '?' � �� �����
// �������� ������ '|'. ������ ����� ����
// �������� � ������� ������� (''') ��� ����
// ������� ������� ��������� � ������� ������
// ���� �������. ���� ������ �������� �������
// ';' ��� ' ' (������) �� ��
// ����������� ������ ���� �������� � �������
// �������.
//
// ��������:
// '*.ini;*.wav'          - ������������� ����� ������ � ����������� 'ini'
// ��� 'wav'
// '*.*|*.exe'            - ������������� ����� ������, ����� ������ �
// ����������� 'EXE'
// '*.mp3;*.wav|?.*;??.*' - ������������� ����� ������ � ����������� 'mp3'
// � 'wav' �� ����������� ������ � ������� ���
// ������� �� ������ ��� ���� ��������.
// '|awString.*'          - ������������� ����� ������ �� ����������� ������
// � ������ awString � ����� �����������.
//

function IsMatchMask(AText, AMask: PChar): Boolean; overload;
function IsMatchMask(AText, AMask: string; AFileNameMode: Boolean = True): Boolean; overload;
// ��������� ������������� ������ aText � ����� �������� aMask.
// ���������� True ���� ������������� ��������� �������, �.�. �����
// aText ������������� ������� aMask.
// ���� aFileNameModd=True, �� ������ ������������ ��� �������������
// ���� ������ � ��������. � ������, � ���� ������, ���� aText ��
// �������� ������� '.' �� �� ����������� � �����. ��� ���������� ���
// ����, ����� ����� ��� ���������� ��������������� �������� ������� '*.*'

function IsMatchMaskList(AText, AMaskList: string; AFileNameMode: Boolean = True): Boolean;
// ��������� ������������� ������ aText �� ������� �������� aMaskList.
// ���������� True ���� ������������� ��������� �������, �.�. �����
// aText ������������� ������ �������� aMaskList.
// ���� aFileNameModd=True, �� ������ ������������ ��� �������������
// ���� ������ � ��������. � ������, � ���� ������, ���� aText ��
// �������� ������� '.' �� �� ����������� � �����. ��� ���������� ���
// ����, ����� ����� ��� ���������� ��������������� �������� ������� '*.*'
//
// ���������, ���� ��������� �������� ������������� ���������� ����� ������
// ������ ��������, ����������� ����� ��������������� �������� tMatchMaskList.

type
  TMatchMaskList = class(TObject)
  private
    FMaskList: string;
    FCaseSensitive: Boolean;
    FFileNameMode: Boolean;

    FPrepared: Boolean;
    FIncludeMasks: TStringList;
    FExcludeMasks: TStringList;

    procedure SetMaskList(V: string);
    procedure SetCaseSensitive(V: Boolean);

  public
    constructor Create(const AMaskList: string = '');
    // ������� ������. ���� ����� �������� aMaskList, �� �� �������������
    // �������� MaskList.

    destructor Destroy; override;
    // ��������� ������

    procedure PrepareMasks;
    // ������������ ���������� ������ �������� �� ���������� ���������
    // ������������ ��� ������������� ������.
    // ����� ������� ������ �� �������� ������������ � ��� �������������
    // ����� ������ �������������.

    function IsMatch(AText: string): Boolean;
    // ��������� ������������� ������ aText �� ������� �������� MaskList.
    // ���������� True ���� ������������� ��������� �������, �.�. �����
    // aText ������������� ������ �������� MaskList.

    property MaskList: string read FMaskList write SetMaskList;
    // ������ �������� ������������ ��� ������������� � �������

    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive default False;
    // ���� False (�� ���������), �� ��� ������������� ������ �����
    // ������� �������� �� ����� �����������.
    // �����, ���� True, ������������� ����� ����������� � ������ ��������.

    property FileNameMode: Boolean read FFileNameMode write FFileNameMode default True;
    // ���� True (�� ���������), �� ������ ������������ ��� �������������
    // ���� ������ � ��������. � ������, � ���� ������, ���� aText ��
    // �������� ������� '.' �� �� ����������� � �����. ��� ���������� ���
    // ����, ����� ����� ��� ���������� ��������������� �������� ������� '*.*'

  end;

implementation

uses
  SysUtils;

function IsMatchMask(AText, AMask: PChar): Boolean; overload;
begin
  Result := False;
  while True do
  begin
    case AMask^ of
      '*': // ������������� ������ ����� ����� �������� ����� ����� ������
        begin
          // ������������� �� ��������� ������ �������, ��� ����, ������
          // ������ '*' ������������ ������, ������� ������� ���� '*'
          repeat
            Inc(AMask);
          until (AMask^ <> '*');
          // ���� �� '*' ������� ����� ������ ����� '?' �� �� ������ ��������
          // � �������� � ������. �.�. ����� ���������� ��� �� �����������,
          // �� �� ����� ����� ������
          if AMask^ <> '?' then
            while (AText^ <> #0) and (AText^ <> AMask^) do
              Inc(AText);

          if AText^ <> #0 then
          begin // �� ����� ������, ������ ������ ������
            // '*' '������' ������ ������� ��������� ������ ��������� ������
            // ���. �.�. ��������� ���������� ����������� ������ � ��������,
            // ������� � ����-�� '*'. ���� ����������� ���������, ��
            if IsMatchMask(AText + 1, AMask - 1) then
              Break; // ��� ����������
            // ����������� �� �������, ������ ������� ��� ����� �����������
            // ������������ '*'. ��������� ������������� �� ����������
            // ������� �������
            Inc(AMask);
            Inc(AText); // ����� ��������� � ���������� �������
          end
          else if (AMask^ = #0) then // ����� ������ � ����� �������
            Break // ��� ����������
          else // ����� ������ �� �� ����� �������
            Exit // ��� �� ����������
        end;

      '?': // ������������� ������ ����� ����� ������
        if (AText^ = #0) then // ����� ������
          Exit // ��� �� ����������
        else
        begin // �����
          Inc(AMask);
          Inc(AText); // ����� ��������� � ���������� �������
        end;

    else // ������ � ������� ������ �������� � �������� � ������
      if AMask^ <> AText^ then // ������� �� ������� -
        Exit // ��� �� ����������
      else
      begin // ������ ��������� ������
        if (AMask^ = #0) then // ��������� ������ ��������� -
          Break; // ��� ����������
        Inc(AMask);
        Inc(AText); // ����� ��������� � ���������� �������
      end;
    end;
  end;
  Result := True;
end;

function IsMatchMask(AText, AMask: string; AFileNameMode: Boolean = True): Boolean; overload;
begin
  if AFileNameMode and (Pos('.', AText) = 0) then
    AText := AText + '.';
  Result := IsMatchMask(PChar(AText), PChar(AMask));
end;

function IsMatchMaskList(AText, AMaskList: string; AFileNameMode: Boolean = True): Boolean;
begin
  with TMatchMaskList.Create(AMaskList) do
    try
      FileNameMode := AFileNameMode;
      Result := IsMatch(AText);
    finally
      Free;
    end;
end;

/// //////////////////////////////////////////////////////// tFileMask

procedure TMatchMaskList.SetMaskList(V: string);
begin
  if FMaskList = V then
    Exit;
  FMaskList := V;
  FPrepared := False;
end;

procedure TMatchMaskList.SetCaseSensitive(V: Boolean);
begin
  if FCaseSensitive = V then
    Exit;
  FCaseSensitive := V;
  FPrepared := False;
end;

constructor TMatchMaskList.Create(const AMaskList: string);
begin
  MaskList := AMaskList;
  FFileNameMode := True;

  FIncludeMasks := TStringList.Create;
  with FIncludeMasks do
  begin
    Delimiter := ';';
    // Sorted     := True;
    // Duplicates := dupIgnore;
  end;

  FExcludeMasks := TStringList.Create;
  with FExcludeMasks do
  begin
    Delimiter := ';';
    // Sorted     := True;
    // Duplicates := dupIgnore;
  end;
end;

destructor TMatchMaskList.Destroy;
begin
  FIncludeMasks.Free;
  FExcludeMasks.Free;
end;

procedure TMatchMaskList.PrepareMasks;

  procedure CleanList(L: TStrings);
  var
    I: Integer;
  begin
    for I := L.Count - 1 downto 0 do
      if L[I] = '' then
        L.Delete(I);
  end;

var
  S: string;
  I: Integer;
begin
  if FPrepared then
    Exit;

  if CaseSensitive then
    S := MaskList
  else
    S := UpperCase(MaskList);

  I := Pos('|', S);
  if I = 0 then
  begin
    FIncludeMasks.DelimitedText := S;
    FExcludeMasks.DelimitedText := '';
  end
  else
  begin
    FIncludeMasks.DelimitedText := Copy(S, 1, I - 1);
    FExcludeMasks.DelimitedText := Copy(S, I + 1, MaxInt);
  end;

  CleanList(FIncludeMasks);
  CleanList(FExcludeMasks);

  // ���� ������ ���������� �������� ���� �
  // ������ ����������� �������� �� ����, ��
  // ������� ����� ��� ������ ���������� �������� ����� <��� �����>
  if (FIncludeMasks.Count = 0) and (FExcludeMasks.Count <> 0) then
    FIncludeMasks.Add('*');

  FPrepared := True;
end;

function TMatchMaskList.IsMatch(AText: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  if AText = '' then
    Exit;

  if not CaseSensitive then
    AText := UpperCase(AText);

  if FileNameMode and (Pos('.', AText) = 0) then
    AText := AText + '.';

  if not FPrepared then
    PrepareMasks;

  // ����� � ������ "����������" ����� �� ������� ����������
  for I := 0 to FIncludeMasks.Count - 1 do
    if IsMatchMask(PChar(AText), PChar(FIncludeMasks[I])) then
    begin
      Result := True;
      Break;
    end;

  // ���� ���������� �������, ���� ��������� �� ������ "�����������"
  if Result then
    for I := 0 to FExcludeMasks.Count - 1 do
      if IsMatchMask(PChar(AText), PChar(FExcludeMasks[I])) then
      begin
        Result := False;
        Break;
      end;
end;

end.
