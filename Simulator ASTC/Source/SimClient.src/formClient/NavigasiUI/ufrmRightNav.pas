unit ufrmRightNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzBmpBtn, Vcl.StdCtrls, VrControls,
  VrWheel, Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmRightNav = class(TForm)
    pnlContainer: TPanel;
    Panel1: TPanel;
    imgMainBackgorund: TImage;
    Image2: TImage;
    Label10: TLabel;
    PanelGuidanceControlChoices: TPanel;
    SpeedButton2: TSpeedButton;
    edGuidance: TEdit;
    gbWaypoint: TGroupBox;
    whHeading: TVrWheel;
    Label119: TLabel;
    Label121: TLabel;
    Label123: TLabel;
    lblStraightLineActualGroundSpeed: TLabel;
    lblStraightLineActuaCourse: TLabel;
    lblStraightLineActualHeading: TLabel;
    Label125: TLabel;
    Label124: TLabel;
    Label128: TLabel;
    Label126: TLabel;
    Label122: TLabel;
    StaticText81: TStaticText;
    StaticText82: TStaticText;
    edtStraightLineOrderedGroundSpeed: TEdit;
    edtStraightLineOrderedHeading: TEdit;
    StaticText83: TStaticText;
    StaticText84: TStaticText;
    StaticText85: TStaticText;
    StaticText87: TStaticText;
    StaticText86: TStaticText;
    pnlHookContactInfoTraineeDisplay: TPanel;
    pnlTabDetails: TPanel;
    pnlTabDetection: TPanel;
    pnlTabIFF: TPanel;
    pnlTabHook: TPanel;
    pnlContentDetails: TPanel;
    pnlDetails: TPanel;
    lbTrackDetails: TLabel;
    Label11: TLabel;
    lbNameDetails: TLabel;
    lbClassdetails: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lbDomain: TLabel;
    Label15: TLabel;
    lbPropulsion: TLabel;
    lbIdentifier: TLabel;
    lbDoppler: TLabel;
    lbSonarClass: TLabel;
    lbTrackType: TLabel;
    lbTypeDetails: TLabel;
    lbMergeStatus: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText37: TStaticText;
    StaticText38: TStaticText;
    StaticText39: TStaticText;
    StaticText40: TStaticText;
    StaticText41: TStaticText;
    StaticText42: TStaticText;
    StaticText43: TStaticText;
    StaticText44: TStaticText;
    StaticText45: TStaticText;
    StaticText46: TStaticText;
    StaticText47: TStaticText;
    pnlContentDetection: TPanel;
    pnlDetection: TPanel;
    lbDetectionDetectionType: TLabel;
    lbOwner: TLabel;
    lbClassDetection: TLabel;
    lbNameDetection: TLabel;
    Label16: TLabel;
    lbTrackDetection: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lbFirstDetected: TLabel;
    lbLastDetected: TLabel;
    StaticText48: TStaticText;
    lbDetectionType: TStaticText;
    StaticText15: TStaticText;
    StaticText14: TStaticText;
    StaticText49: TStaticText;
    StaticText55: TStaticText;
    StaticText54: TStaticText;
    StaticText53: TStaticText;
    StaticText51: TStaticText;
    StaticText50: TStaticText;
    pnlContentIFF: TPanel;
    pnlIFF: TPanel;
    lbTrackIff: TLabel;
    Label88: TLabel;
    lbNameIff: TLabel;
    lbClassIff: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    lbMode2Iff: TLabel;
    Label95: TLabel;
    lbMode1Iff: TLabel;
    lbMode3CIff: TLabel;
    lbMode3Iff: TLabel;
    lbMode4Iff: TLabel;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText19: TStaticText;
    StaticText20: TStaticText;
    StaticText52: TStaticText;
    StaticText56: TStaticText;
    StaticText57: TStaticText;
    StaticText59: TStaticText;
    StaticText60: TStaticText;
    StaticText61: TStaticText;
    StaticText62: TStaticText;
    StaticText63: TStaticText;
    pnlContentHook: TPanel;
    pnlHook: TPanel;
    lbClassHook: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lb8: TLabel;
    lbBearingHook: TLabel;
    lbCourseHook: TLabel;
    lbDamage: TLabel;
    lbFormation: TLabel;
    lbGround: TLabel;
    lbNameHook: TLabel;
    lbPositionHook1: TLabel;
    lbPositionHook2: TLabel;
    lbRangeHook: TLabel;
    lbTrackHook: TLabel;
    lbAltitude: TLabel;
    lb4: TLabel;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText25: TStaticText;
    StaticText28: TStaticText;
    StaticText29: TStaticText;
    StaticText30: TStaticText;
    StaticText31: TStaticText;
    StaticText32: TStaticText;
    StaticText33: TStaticText;
    StaticText36: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    lb3: TStaticText;
    lb7: TStaticText;
    lb5: TStaticText;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRightNav: TfrmRightNav;

implementation

uses
  ufTacticalDisplay, ufToteDisplay;

{$R *.dfm}
procedure TfrmRightNav.Button1Click(Sender: TObject);
begin
  frmTacticalDisplay.SendToBack;
  frmToteDisplay.BringToFront;
end;

end.
