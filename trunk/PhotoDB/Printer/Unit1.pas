unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScrollingImage, ScrollingImageAddons, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses PrintMainForm;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 files : TStrings;
begin
 files := TStringList.Create;
  Files.Add('D:\Dmitry\My Pictures\806690  ������ - ����� ������ �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\769150 Alexandr Zadiraka - �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\796283 ��� �������� - ��� ��������.jpg');
 Files.Add('D:\Dmitry\My Pictures\808138 �������� - ������ 2 ����� �����.jpg');
{ Files.Add('D:\Dmitry\My Pictures\808709 Ira Bordo - ---.jpg');
 Files.Add('D:\Dmitry\My Pictures\815206 HALFMAX - ��� ������..jpg');
 Files.Add('D:\Dmitry\My Pictures\815794  ����� ������� - �������� ������.jpg');
 Files.Add('D:\Dmitry\My Pictures\815903 igor vorobey - MADE IN CHINA.jpg');
 Files.Add('D:\Dmitry\My Pictures\769150 Alexandr Zadiraka - �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\796283 ��� �������� - ��� ��������.jpg');
 Files.Add('D:\Dmitry\My Pictures\806690  ������ - ����� ������ �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\808138 �������� - ������ 2 ����� �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\808709 Ira Bordo - ---.jpg');
 Files.Add('D:\Dmitry\My Pictures\815206 HALFMAX - ��� ������..jpg');
 Files.Add('D:\Dmitry\My Pictures\815794  ����� ������� - �������� ������.jpg');
 Files.Add('D:\Dmitry\My Pictures\815903 igor vorobey - MADE IN CHINA.jpg');
 Files.Add('D:\Dmitry\My Pictures\769150 Alexandr Zadiraka - �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\796283 ��� �������� - ��� ��������.jpg');
 Files.Add('D:\Dmitry\My Pictures\806690  ������ - ����� ������ �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\808138 �������� - ������ 2 ����� �����.jpg');
 Files.Add('D:\Dmitry\My Pictures\808709 Ira Bordo - ---.jpg');
 Files.Add('D:\Dmitry\My Pictures\815206 HALFMAX - ��� ������..jpg');
 Files.Add('D:\Dmitry\My Pictures\815794  ����� ������� - �������� ������.jpg');
 Files.Add('D:\Dmitry\My Pictures\815903 igor vorobey - MADE IN CHINA.jpg'); 

 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292073.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292036.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292043.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292049.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292061.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292068.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292070.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292083.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292086.JPG');
 Files.Add('D:\Dmitry\My Pictures\Photoes\05.03.29 = 29 ����� 2005 �. (���, ����)\P3292093.JPG'); }
 GetPrintForm(Files);

// PrintForm.Execute(Files);
// PrintForm.show;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
pic : Tpicture;
bit : Tbitmap;
begin
pic := Tpicture.create;
pic.LoadFromFile('D:\Dmitry\My Pictures\808709 Ira Bordo - ---.jpg');
bit := Tbitmap.Create;
bit.PixelFormat:=pf24bit;
bit.Assign(pic.Graphic);
pic.free;
GetPrintForm(bit);
end;

end.
