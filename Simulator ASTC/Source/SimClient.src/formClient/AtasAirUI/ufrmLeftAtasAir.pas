unit ufrmLeftAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.ComCtrls, ufmControlled, ufmSensor, ufmPlatformGuidance,
  ufmCounterMeasure,

  uT3Unit;

type
  TfrmLeftAtasAir = class(TForm)
    pnlContainer: TPanel;
    pnlContactInformation: TPanel;
    imgMainBackgorundContact: TImage;
    lbl26: TLabel;
    pnlContactSheet: TPanel;
    pnlTabHook: TPanel;
    pnlTabDetails: TPanel;
    pnlTabDetection: TPanel;
    pnlTabIFF: TPanel;
    pnlContactInformationBody: TPanel;
    pnlContentDetails: TPanel;
    pnlDetails: TPanel;
    lblTrackDetails: TLabel;
    lbl2: TLabel;
    lblNameDetails: TLabel;
    lblClassdetails: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblDomain: TLabel;
    lbl6: TLabel;
    lblPropulsion: TLabel;
    lblIdentifier: TLabel;
    lblDoppler: TLabel;
    lblSonarClass: TLabel;
    lblTrackType: TLabel;
    lblTypeDetails: TLabel;
    lblMergeStatus: TLabel;
    txt1: TStaticText;
    txt3: TStaticText;
    txt4: TStaticText;
    txt5: TStaticText;
    txt6: TStaticText;
    txt7: TStaticText;
    txt8: TStaticText;
    txt9: TStaticText;
    txt10: TStaticText;
    txt11: TStaticText;
    txt12: TStaticText;
    txt13: TStaticText;
    txt14: TStaticText;
    txt15: TStaticText;
    txt16: TStaticText;
    txt17: TStaticText;
    txt18: TStaticText;
    txt19: TStaticText;
    pnlContentDetection: TPanel;
    pnlDetection: TPanel;
    lblDetectionDetectionType: TLabel;
    lblOwner: TLabel;
    lblClassDetection: TLabel;
    lblNameDetection: TLabel;
    lbl7: TLabel;
    lblTrackDetection: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lblFirstDetected: TLabel;
    lblLastDetected: TLabel;
    txt20: TStaticText;
    txtDetectionType: TStaticText;
    txt21: TStaticText;
    txt22: TStaticText;
    txt23: TStaticText;
    txt24: TStaticText;
    txt25: TStaticText;
    txt26: TStaticText;
    txt27: TStaticText;
    txt28: TStaticText;
    pnlContentIFF: TPanel;
    pnlIFF: TPanel;
    lblTrackIff: TLabel;
    lbl12: TLabel;
    lblNameIff: TLabel;
    lblClassIff: TLabel;
    lbl13: TLabel;
    lbl14: TLabel;
    lbl15: TLabel;
    lblMode2Iff: TLabel;
    lbl16: TLabel;
    lblMode1Iff: TLabel;
    lblMode3CIff: TLabel;
    lblMode3Iff: TLabel;
    lblMode4Iff: TLabel;
    txt29: TStaticText;
    txt30: TStaticText;
    txt31: TStaticText;
    txt32: TStaticText;
    txt33: TStaticText;
    txt34: TStaticText;
    txt35: TStaticText;
    txt36: TStaticText;
    txt37: TStaticText;
    txt38: TStaticText;
    txt39: TStaticText;
    txt40: TStaticText;
    pnlContentNone: TPanel;
    pnlContentHook: TPanel;
    pnlHook: TPanel;
    lblClassHook: TLabel;
    lbl17: TLabel;
    lbl18: TLabel;
    lbl19: TLabel;
    lbl20: TLabel;
    lbl21: TLabel;
    lbl22: TLabel;
    lbl23: TLabel;
    lbl24: TLabel;
    lbl25: TLabel;
    lbllb8: TLabel;
    lblBearingHook: TLabel;
    lblCourseHook: TLabel;
    lblDamage: TLabel;
    lblFormation: TLabel;
    lblGround: TLabel;
    lblNameHook: TLabel;
    lblPositionHook1: TLabel;
    lblPositionHook2: TLabel;
    lblRangeHook: TLabel;
    lblTrackHook: TLabel;
    lblAltitude: TLabel;
    lbllb4: TLabel;
    txt41: TStaticText;
    txt42: TStaticText;
    txt43: TStaticText;
    txt44: TStaticText;
    txt45: TStaticText;
    txt46: TStaticText;
    txt47: TStaticText;
    txt48: TStaticText;
    txt49: TStaticText;
    txt50: TStaticText;
    txt51: TStaticText;
    txt52: TStaticText;
    txtlb3: TStaticText;
    txtlb7: TStaticText;
    txtlb5: TStaticText;
    txt2: TStaticText;
    pnlController: TPanel;
    imgMainBackgorundController: TImage;
    lblShipName: TLabel;
    pnlShipSheet: TPanel;
    pnlTabSensor: TPanel;
    imgSensor: TImage;
    pnlControllerBody: TPanel;
    pnlControllerNone: TPanel;
    pnlSensor: TPanel;
    fmSensor1: TfmSensor;
    pnlTabCounterMeasure: TPanel;
    imgCounterMeasure: TImage;
    pnlCounterMeasure: TPanel;
    fmCounterMeasure1: TfmCounterMeasure;
    procedure THButtonClick(Sender: TObject);
    procedure TDCPButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetControlledObject(pit: TT3PlatformInstance);
  end;

var
  frmLeftAtasAir: TfrmLeftAtasAir;

implementation

{$R *.dfm}

{ TfrmLeftAtasAir }

procedure TfrmLeftAtasAir.SetControlledObject(pit: TT3PlatformInstance);
begin

end;

procedure TfrmLeftAtasAir.TDCPButtonClick(Sender: TObject);
var
  ImgTag: integer;
  Image: Timage;
begin
  Image := Sender as Timage;
  ImgTag := Image.Tag;

  if Image = imgCounterMeasure then
  begin
    if ImgTag = 0 then
    begin
      pnlTabCounterMeasure.Color := RGB(29, 81, 103);
      pnlCounterMeasure.BringToFront;
      imgCounterMeasure.Tag := 1;
      imgSensor.Tag := 0;
      pnlTabSensor.Color := RGB(16, 46, 58);
    end;
  end
  else if Image = imgSensor then
  begin
    if ImgTag = 0 then
    begin
      pnlTabSensor.Color := RGB(29, 81, 103);
      pnlSensor.BringToFront;
      imgSensor.Tag := 1;
      imgCounterMeasure.Tag := 0;
      pnlTabCounterMeasure.Color := RGB(16, 46, 58);
    end;
    end;
end;


procedure TfrmLeftAtasAir.THButtonClick(Sender: TObject);
var
  PanelTag: integer;
  Panel: Tpanel;
begin
  panel := Sender as Tpanel;
  PanelTag := panel.Tag;

  if panel = pnlTabHook then
  begin
    if PanelTag = 0 then
    begin
      pnlTabHook.Color := RGB(29, 81, 103);
      pnlContentHook.BringToFront;
      pnlTabHook.Tag := 1;
      pnlTabDetails.Tag := 0;
      pnlTabDetection.Tag := 0;
      pnlTabIFF.Tag := 0;
      pnlTabDetails.Color := RGB(16, 46, 58);
      pnlTabDetection.Color := RGB(16, 46, 58);
      pnlTabIFF.Color := RGB(16, 46, 58);
    end;
  end

  else if panel = pnlTabDetails then
  begin
    if PanelTag = 0 then
    begin
      pnlTabDetails.Color := RGB(29, 81, 103);
      pnlContentDetails.BringToFront;
      pnlTabDetails.Tag := 1;
      pnlTabHook.Tag := 0;
      pnlTabDetection.Tag := 0;
      pnlTabIFF.Tag := 0;
      pnlTabHook.Color := RGB(16, 46, 58);
      pnlTabDetection.Color := RGB(16, 46, 58);
      pnlTabIFF.Color := RGB(16, 46, 58);
    end;
  end

  else if panel = pnlTabDetection then
  begin
    if PanelTag = 0 then
    begin
      pnlTabDetection.Color := RGB(29, 81, 103);
      pnlContentDetection.BringToFront;
      pnlTabDetection.Tag := 1;
      pnlTabHook.Tag := 0;
      pnlTabDetails.Tag := 0;
      pnlTabIFF.Tag := 0;
      pnlTabHook.Color := RGB(16, 46, 58);
      pnlTabDetails.Color := RGB(16, 46, 58);
      pnlTabIFF.Color := RGB(16, 46, 58);
    end;
  end

  else if panel = pnlTabIFF then
  begin
    if PanelTag = 0 then
    begin
      pnlTabIFF.Color := RGB(29, 81, 103);
      pnlContentIFF.BringToFront;
      pnlTabIFF.Tag := 1;
      pnlTabDetails.Tag := 0;
      pnlTabHook.Tag := 0;
      pnlTabDetection.Tag := 0;
      pnlTabDetails.Color := RGB(16, 46, 58);
      pnlTabDetection.Color := RGB(16, 46, 58);
      pnlTabHook.Color := RGB(16, 46, 58);
    end;
  end;
end;
end.
