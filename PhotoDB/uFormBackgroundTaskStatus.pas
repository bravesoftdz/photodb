unit uFormBackgroundTaskStatus;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Themes,

  Dmitry.Controls.Base,
  Dmitry.Controls.LoadingSign,

  uMemory,
  uFormUtils,
  uBitmapUtils,
  uThemesUtils,
  uDBForm,
  uFormInterfaces;

type
  TFormBackgroundTaskStatus = class(TDBForm, IBackgroundTaskStatusForm)
    LbMessage: TLabel;
    LsMain: TLoadingSign;
    TmrRedraw: TTimer;
    procedure TmrRedrawTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FLoadingState: Extended;
    procedure DrawForm;
  protected
    function GetFormID: string; override;
    procedure InterfaceDestroyed; override;
    function DisableMasking: Boolean; override;
  public
    { Public declarations }
    function ShowModal: Integer; override;
    procedure SetProgress(Max, Position: Int64);
    procedure SetText(Text: string);
    procedure CloseForm;
  end;

var
  FormBackgroundTaskStatus: TFormBackgroundTaskStatus;

implementation

{$R *.dfm}

procedure TFormBackgroundTaskStatus.CloseForm;
begin
  Close;
end;

function TFormBackgroundTaskStatus.DisableMasking: Boolean;
begin
  Result := True;
end;

procedure TFormBackgroundTaskStatus.DrawForm;
var
  Bitmap : TBitmap;
  R: TRect;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Width;
    Bitmap.Height := Height;
    FillTransparentColor(Bitmap, clBlack, 0);
    DrawRoundGradientVert(Bitmap, Rect(0, 0, Width, Height),
      Theme.GradientFromColor, Theme.GradientToColor, Theme.HighlightColor, 8, 240);

    DrawLoadingSignImage(LsMain.Left, LsMain.Top,
      Round((LsMain.Height div 2) * 70 / 100),
      LsMain.Height, Bitmap, clBlack, FLoadingState, 240);

    if StyleServices.Enabled and TStyleManager.IsCustomStyleActive then
      Font.Color := Theme.GradientText;
    R := Rect(LsMain.Left + LsMain.Width + 5, LsMain.Top, ClientWidth, ClientHeight);
    DrawText32Bit(Bitmap, LbMessage.Caption, Font, R, 0);

    RenderForm(Self.Handle, Bitmap, 220);

  finally
    F(Bitmap);
  end;
end;

procedure TFormBackgroundTaskStatus.SetProgress(Max, Position: Int64);
begin
  LbMessage.Caption := IntToStr(Round(Position * 100 / Max)) + '%';
  DrawForm;
end;

procedure TFormBackgroundTaskStatus.SetText(Text: string);
begin

end;

function TFormBackgroundTaskStatus.ShowModal: Integer;
begin
  DrawForm;
  Result := inherited ShowModal;
end;

procedure TFormBackgroundTaskStatus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
  TmrRedraw.Enabled := False;
end;

procedure TFormBackgroundTaskStatus.FormCreate(Sender: TObject);
begin
  LbMessage.Caption := L('Please wait...');
end;

procedure TFormBackgroundTaskStatus.FormDestroy(Sender: TObject);
begin
  TmrRedraw.Enabled := False;
end;

function TFormBackgroundTaskStatus.GetFormID: string;
begin
  Result := 'BackgroundTaskStatus';
end;

procedure TFormBackgroundTaskStatus.InterfaceDestroyed;
begin
  inherited;
  Release;
end;

procedure TFormBackgroundTaskStatus.TmrRedrawTimer(Sender: TObject);
begin
  DrawForm;
end;

initialization
  FormInterfaces.RegisterFormInterface(IBackgroundTaskStatusForm, TFormBackgroundTaskStatus);

end.
