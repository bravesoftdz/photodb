unit uIconUtils;

interface

uses
  Windows, Graphics, ShellApi, SysUtils;

function ExtractSmallIconByPath(IconPath: string; Big: Boolean = False): HIcon;

implementation

function ExtractSmallIconByPath(IconPath: string; Big: Boolean = False): HIcon;
var
  Path, Icon: string;
  IconIndex, I: Integer;
  Ico1, Ico2: HIcon;
begin
  I := Pos(',', IconPath);
  Path := Copy(IconPath, 1, I - 1);
  Icon := Copy(IconPath, I + 1, Length(IconPath) - I);
  IconIndex := StrToIntDef(Icon, 0);
  Ico1 := 0;

  ExtractIconEx(PWideChar(Path), IconIndex, Ico1, Ico2, 1);

  if Big then
  begin
    Result := Ico1;
    if Ico2 <> 0 then
      DestroyIcon(Ico2);
  end else
  begin
    Result := Ico2;
    if Ico1 <> 0 then
      DestroyIcon(Ico1);
  end;
end;

end.
