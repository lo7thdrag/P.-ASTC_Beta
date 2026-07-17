unit ufrmLeftNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzBmpBtn,
  Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, VrControls, VrWheel, Vcl.StdCtrls, Vcl.ComCtrls,
  VrMeter, AdvSmoothLabel, Vcl.Buttons;

type
  TfrmLeftNav = class(TForm)
    pnlContent: TPanel;
    pnlEnvironment: TPanel;
    imgMainBackgorund: TImage;
    Label5: TLabel;
    pnlAboveWater: TPanel;
    Image1: TImage;
    lblTittle1: TLabel;
    Label12: TLabel;
    lblWindSpeed: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    o: TLabel;
    Image10: TImage;
    Image15: TImage;
    btnPlatformOp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    Image5: TImage;
    Label3: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Image13: TImage;
    Label19: TLabel;
    Image16: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Image4: TImage;
    Label29: TLabel;
    Bevel8: TBevel;
    Label30: TLabel;
    Label23: TLabel;
    lblRange: TLabel;
    Bevel5: TBevel;
    Label28: TLabel;
    Label24: TLabel;
    Panel2: TPanel;
    Image2: TImage;
    lblShipName: TLabel;
    Panel5: TPanel;
    Image3: TImage;
    Label4: TLabel;
    lblHeading: TLabel;
    Image14: TImage;
    Label22: TLabel;
    Image17: TImage;
    Panel6: TPanel;
    Image7: TImage;
    Label8: TLabel;
    Bevel3: TBevel;
    lblCOG: TLabel;
    Label10: TLabel;
    lblSOG: TLabel;
    Bevel4: TBevel;
    Label9: TLabel;
    Bevel1: TBevel;
    lblSWT: TLabel;
    Label11: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Panel10: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLeftNav: TfrmLeftNav;

implementation

{$R *.dfm}

end.
