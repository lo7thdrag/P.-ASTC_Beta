unit ufrmTopAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfrmTopAtasAir = class(TForm)
    Panel1: TPanel;
    Panel10: TPanel;
    pnlTop: TPanel;
    Image1: TImage;
    lblHeadingCap: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblSOGCap: TLabel;
    lblClass: TLabel;
    lblDate: TLabel;
    lblHeading: TLabel;
    lblName: TLabel;
    lblSOG: TLabel;
    lblTrackID: TLabel;
    Image2: TImage;
    Label2: TLabel;
    lblLong1: TLabel;
    lbl1: TLabel;
    lblLat1: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    protected
    FControlled: TObject;
  private
    { Private declarations }
  public
    Procedure Refresh_OwnShipTab(Sender: TObject);
    procedure SetControlledObject(ctrlObj: TObject);
    procedure UpdateFormData;
    { Public declarations }
  end;

var
  frmTopAtasAir: TfrmTopAtasAir;

implementation

uses
  ufTacticalDisplay,uMapXHandler, uT3Unit, uT3Vehicle, uBaseCoordSystem, uDBAsset_Vehicle,
  uSimMgr_Client, uSettingCoordinate, ufToteDisplay, uLibSettingTTT;

{$R *.dfm}

{ TfrmTopAtasAir }

procedure TfrmTopAtasAir.Refresh_OwnShipTab(Sender: TObject);
var
  idCoordinat: integer;
  long, lat: double;
  pY, pX: Extended;
  hasilUTM, hasilMGRS : string;   //dng
  largeLtr, smallLtr, horizontalNumb, verticalNumb, horzPoint, vertPoint : string;

  d1,d2 : Double;
  isOnlandTemp, isdeptAvailTemp : Boolean;
begin
  idCoordinat := fSettingCoordinate.IdCoordinat;
  long := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Long;
  lat := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Lat;

  if Sender = nil then
    exit;

  if FControlled = nil then
  begin
    exit;
  end;

  if not TT3PlatformInstance(FControlled).Initialized then
    exit;

  with TT3PlatformInstance(FControlled) do
  begin

    if FControlled is TT3Vehicle then
    begin
      lblName.Caption := InstanceName;
      lblClass.Caption := TT3Vehicle(FControlled).VehicleDefinition.FData.Vehicle_Identifier;
      lblTrackID.Caption := Track_ID;
    end
    else
    begin
      lblName.Caption := '---';
      lblClass.Caption := '---';
    end;

    case idCoordinat of
      1:
      begin
        lblLong1.Caption  := formatDMS_long(getPositionX);
        lblLat1.Caption   := formatDMS_latt(getPositionY);
      end;
      2:
      begin
        pX := CalcMove(getPositionX, long);
        pY := CalcMove(getPositionY, lat);

        if (pX >= 0) and (pY >=0) then
        begin
          lblLong1.Caption := 'White ' + FormatFloat('0.00', Abs(pX));
        end;
        if (pX <= 0) and (pY >=0) then
        begin
          lblLong1.Caption := 'Red ' + FormatFloat('0.00', Abs(pX));
        end;
        if (pX < 0) and (pY < 0) then
        begin
          lblLong1.Caption := 'Green ' + FormatFloat('0.00', Abs(pX));
        end;
        if (pX >= 0) and (pY <= 0) then
        begin
          lblLong1.Caption := 'Blue ' + FormatFloat('0.00', Abs(pX));
        end;

       lblLat1.Caption := FormatFloat('0.00', Abs(pY));
      end;
      3:
      begin
        lblLong1.Caption := ConvDegree_To_Georef(getPositionX,getPositionY);
        lblLat1.Caption := '---';
      end;
      4:
      begin
        lblLong1.Caption := hasilUTM ;   //dng
        lblLat1.Caption := '';
      end;
      5:
      begin
        ConvDegree_To_UTM_and_MGRS(lat, long, hasilUTM, hasilMGRS);
        lblLong1.Caption := hasilMGRS ;   //dng
        lblLat1.Caption := '';
      end;
      6:
      begin
        VSimMap.GetValLayerKarvak(getPositionX, getPositionY, largeLtr, smallLtr, horizontalNumb, verticalNumb);
        ConvDegree_To_Karvak(getPositionX, getPositionY, horzPoint, vertPoint);
        lblLong1.Caption :=  largeLtr+horizontalNumb + horzPoint + verticalNumb + vertPoint;
        lblLat1.Caption := '';
      end;
    end;
  end;

  if (simMgrClient <> nil) and (simMgrClient.ControlledPlatform <> nil) and
    (simMgrClient.ControlledPlatform is TT3Vehicle) then
  begin
  with TT3PlatformInstance(simMgrClient.ControlledPlatform) do
  begin
    lblHeading.Caption := FormatCourse(TT3Vehicle(simMgrClient.ControlledPlatform).Heading) + ' Deg T';
    lblSOG.Caption := FormatSpeed(TT3Vehicle(simMgrClient.ControlledPlatform).Speed) + ' Knot';
  end;
  end;
end;

procedure TfrmTopAtasAir.SetControlledObject(ctrlObj: TObject);
begin
  FControlled := ctrlObj;
  Refresh_OwnShipTab(FControlled);
end;

procedure TfrmTopAtasAir.UpdateFormData;
begin
  Refresh_OwnShipTab(FControlled);
end;

end.
