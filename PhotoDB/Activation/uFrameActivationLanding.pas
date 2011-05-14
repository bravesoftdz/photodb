unit uFrameActivationLanding;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, uFrameWizardBase, uActivationUtils, uFrameActicationSetCode;

type
  TFrameActivationLanding = class(TFrameWizardBase)
    RbActivateApplication: TRadioButton;
    RbSetCode: TRadioButton;
  private
    { Private declarations }
  protected
    procedure LoadLanguage; override;
  public
    { Public declarations }
    function InitNextStep: Boolean; override;
    procedure Init(Manager: TWizardManagerBase; FirstInitialization: Boolean); override;
  end;

implementation

uses
  uFrameFreeActivation,
  uFrameBuyApplication;

{$R *.dfm}

{ TFrameActivationLanding }

procedure TFrameActivationLanding.Init(Manager: TWizardManagerBase; FirstInitialization: Boolean);
var
  FreeActivationRequired,
  FullActivationRequired: Boolean;
begin
  inherited;
  FreeActivationRequired := TActivationManager.Instance.IsDemoMode and TActivationManager.Instance.CanUseFreeActivation;
  FullActivationRequired := not TActivationManager.Instance.CanUseFreeActivation and not TActivationManager.Instance.IsFullMode;
  RbActivateApplication.Enabled := FreeActivationRequired or FullActivationRequired;
  if not RbActivateApplication.Enabled then
    RbSetCode.Checked := True;
end;

function TFrameActivationLanding.InitNextStep: Boolean;
begin
  Result := inherited;
  if RbActivateApplication.Checked then
  begin
    if TActivationManager.Instance.CanUseFreeActivation then
      Manager.AddStep(TFrameFreeActivation)
    else
      Manager.AddStep(TFrameBuyApplication);
  end else
  begin
    Manager.AddStep(TFrameActicationSetCode);
  end;
end;

procedure TFrameActivationLanding.LoadLanguage;
begin
  inherited;
  RbActivateApplication.Caption := L('Activate new copy of application');
  RbSetCode.Caption := L('Install activation code');
end;

end.
