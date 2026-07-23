unit ufrmLeftNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzBmpBtn,
  Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, VrControls, VrWheel, Vcl.StdCtrls, Vcl.ComCtrls,
  VrMeter, AdvSmoothLabel, Vcl.Buttons,

  uT3Unit;

type
  TfrmLeftNav = class(TForm)
    pnlContent: TPanel;
    pnlEnvironment: TPanel;
    imgMainBackgorund: TImage;
    Label5: TLabel;
    pnlAboveWater: TPanel;
    Image1: TImage;
    lblTittle1: TLabel;
    lbl: TLabel;
    lblSpeedWIndTrue: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    lblDirectionWindTrue: TLabel;
    btnPlatformOp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel4: TPanel;
    Panel1: TPanel;
    Image5: TImage;
    Label3: TLabel;
    lblOceanCurrentSpeed: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblOceanCurrentDirection: TLabel;
    Label19: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel8: TPanel;
    Panel9: TPanel;
    Image4: TImage;
    Label29: TLabel;
    Bevel8: TBevel;
    lblWaterTemp: TLabel;
    lblRange: TLabel;
    Bevel5: TBevel;
    lblDepthNav: TLabel;
    Panel2: TPanel;
    lblShipName: TLabel;
    Panel5: TPanel;
    Image3: TImage;
    Label4: TLabel;
    lblActualHeading: TLabel;
    Image14: TImage;
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
    Image2: TImage;
    procedure Refresh_OwnShipTab(Sender: TObject);
  protected
    FControlled: TObject;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLeftNav: TfrmLeftNav;

implementation

uses
  uDBAsset_GameEnvironment, uT3SimManager, uSimMgr_Client, uBaseCoordSystem, uMapLayerDB,
  uSimObjects, ufmOwnShip, tttData, ufmControlled, uT3Vehicle;

{$R *.dfm}

procedure TfrmLeftNav.Refresh_OwnShipTab(Sender: TObject);
var
  ge: TGame_Environment_Definition;
  isOnlandTemp, isdeptAvailTemp : Boolean;
  d1, d2: Double;

begin
  {$REGION ' LEFT '}
  if not Assigned(simMgrClient) then Exit;
  ge := (simMgrClient).GameEnvironment;

  with ge.FData do
  begin
    lblSpeedWIndTrue.Caption              := FormatSpeed(Wind_Speed);
    lblDirectionWindTrue.Caption          := FormatCourse(Wind_Direction);
    lblWaterTemp.Caption                  := FormatFloat('00.0', Air_Temperature);
    lblOceanCurrentSpeed.Caption          := FormatFloat('00.0', Ocean_Current_Speed);
    lblOceanCurrentDirection.Caption      := FormatFloat('000.0', Ocean_Current_Direction);
  end;

  if Assigned(FControlled) and TT3PlatformInstance(FControlled).Initialized then
  begin
    with TT3PlatformInstance(FControlled) do
    begin
      isOnlandTemp := DepthLayerDB.GetMapLand(getPositionX, getPositionY, d1, d2);

      if isOnlandTemp then
      begin
        lblDepthNav.Caption := FormatSpeed(d2) + ' Meter';
      end
      else
      begin
        try
          isdeptAvailTemp := DepthLayerDB.GetMapDepth(getPositionX, getPositionY, d1, d2);
        except
          isdeptAvailTemp := False;
        end;

        if isdeptAvailTemp then
        begin
          lblDepthNav.Caption := FormatSpeed(d2) + ' Meter';
        end
        else
        begin
          lblDepthNav.Caption := '0 Meter';
        end;
      end;
    end;

    if Assigned(FControlled) then
    begin
      if TT3Vehicle(FControlled).Course = 0 then
      begin
        lblActualHeading.Caption := '0.00';
      end
      else
      begin
        lblActualHeading.Caption := FormatCourse(TT3Vehicle(FControlled).Heading);
      end;
    end
    else
    begin
      lblActualHeading.Caption := '---';
    end;
  end;
  {$ENDREGION}
end;

end.
