unit FloatPanelFullScreen;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ToolWin,
  ImgList,

  Dmitry.Graphics.LayeredBitmap,

  ExtCtrls,
  uThemesUtils,
  uMemory,
  uFormInterfaces;

type
  TFloatPanel = class(TForm)
    NormalImageList: TImageList;
    HotImageList: TImageList;
    ToolBar1: TToolBar;
    TbPlay: TToolButton;
    TbPause: TToolButton;
    ToolButton3: TToolButton;
    TbPrev: TToolButton;
    TbNext: TToolButton;
    ToolButton6: TToolButton;
    TbClose: TToolButton;
    DisabledImageList: TImageList;
    procedure TbPlayClick(Sender: TObject);
    procedure TbPrevClick(Sender: TObject);
    procedure TbNextClick(Sender: TObject);
    procedure TbCloseClick(Sender: TObject);
    procedure RecreateImLists;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetButtonsEnabled(Enabled: Boolean);
  end;

var
  FloatPanel: TFloatPanel = nil;

implementation

{$R *.dfm}

procedure TFloatPanel.TbPlayClick(Sender: TObject);
begin
  Viewer.TogglePause;
end;

procedure TFloatPanel.TbPrevClick(Sender: TObject);
begin
  Viewer.Pause;
  Viewer.PreviousImage;
end;

procedure TFloatPanel.TbNextClick(Sender: TObject);
begin
  Viewer.Pause;
  Viewer.NextImage;
end;

procedure TFloatPanel.TbCloseClick(Sender: TObject);
begin
  Viewer.CloseActiveView;
end;

procedure TFloatPanel.RecreateImLists;
var
  Icons: array [0 .. 1, 0 .. 4] of TIcon;
  I, J: Integer;
  B: TBitmap;
  Imlists: array [0 .. 2] of TImageList;
  Lb: TLayeredBitmap;
const
  Names: array [0 .. 1, 0 .. 4] of string = (('Z_PLAY_NORM', 'Z_PAUSE_NORM', 'Z_PREVIOUS_NORM', 'Z_NEXT_NORM',
      'Z_CLOSE_NORM'), ('Z_PLAY_HOT', 'Z_PAUSE_HOT', 'Z_PREVIOUS_HOT', 'Z_NEXT_HOT', 'Z_CLOSE_HOT'));

begin
  for I := 0 to 1 do
    for J := 0 to 4 do
    begin
      Icons[I, J] := TIcon.Create;
      Icons[I, J].Handle := LoadImage(HInstance, PWideChar(Names[I, J]), IMAGE_ICON, 16, 16, 0);
    end;
  Imlists[0] := NormalImageList;
  Imlists[1] := HotImageList;
  Imlists[2] := DisabledImageList;
  for I := 0 to 2 do
    Imlists[I].Clear;

  for I := 0 to 1 do
    for J := 0 to 4 do
    begin
      Imlists[I].AddIcon(Icons[I, J]);
      if I = 0 then
      begin
        Lb := TLayeredBitmap.Create;
        try
          Lb.LoadFromHIcon(Icons[I, J].Handle);
          Lb.GrayScale;
          B := TBitmap.Create;
          try
            B.Width := 16;
            B.Height := 16;
            B.Canvas.Brush.Color := Theme.PanelColor;
            B.Canvas.Pen.Color := Theme.PanelColor;
            B.Canvas.Rectangle(0, 0, 16, 16);
            Lb.DoStreachDraw(0, 0, 16, 16, B);
            Imlists[2].Add(B, nil);
          finally
            F(B);
          end;
        finally
          F(Lb);
        end;
      end;
    end;
  for I := 0 to 1 do
    for J := 0 to 4 do
      Icons[I, J].Free;
end;

procedure TFloatPanel.SetButtonsEnabled(Enabled: Boolean);
begin
  TbPrev.Enabled := Enabled;
  TbNext.Enabled := Enabled;
  TbPlay.Enabled := Enabled;
  TbPause.Enabled := Enabled;
end;

procedure TFloatPanel.FormCreate(Sender: TObject);
begin
  RecreateImLists;
  SetButtonsEnabled(Viewer.ImagesCount > 1);
end;

end.
