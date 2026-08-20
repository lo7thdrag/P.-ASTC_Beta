unit ufrmTopNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzBmpBtn, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.DateUtils, Vcl.Buttons, ufmControlled;

type
  TfrmTopNav = class(TForm)
    Timer1: TTimer;
    tmr2: TTimer;
    tmrUTC: TTimer;
    Panel1: TPanel;
    Panel10: TPanel;
    pnlTop: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    lblClass: TLabel;
    lblDate: TLabel;
    lblLMT: TLabel;
    lblName: TLabel;
    lblTime: TLabel;
    lblTrackID: TLabel;
    Image2: TImage;
    Label2: TLabel;
    lblLong1: TLabel;
    lbl1: TLabel;
    lblLat1: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Image1: TImage;
    Image3: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure tmrUTCTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    FControlled: TObject;

  private
    { Private declarations }
  public
    gTime: TDateTime;
//    procedure InitCreate(sender: TForm);
    procedure UpdateFormData;
    procedure SetControlledObject(ctrlObj: TObject);
    procedure Refresh_OwnShipTab(Sender: TObject);
  end;

var
  frmTopNav: TfrmTopNav;

implementation

uses
  ufTacticalDisplay,uMapXHandler, uT3Unit, uT3Vehicle, uBaseCoordSystem, uDBAsset_Vehicle,
  uSimMgr_Client, uSettingCoordinate, ufToteDisplay;

{$R *.dfm}


procedure TfrmTopNav.FormCreate(Sender: TObject);
begin
//
end;

//procedure TfrmTopNav.InitCreate(sender: TForm);
//begin
////  FControlled := nil;
//end;

procedure TfrmTopNav.Refresh_OwnShipTab(Sender: TObject);
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
end;

procedure TfrmTopNav.SetControlledObject(ctrlObj: TObject);
begin
  FControlled := ctrlObj;
  Refresh_OwnShipTab(FControlled);
end;

procedure TfrmTopNav.Timer1Timer(Sender: TObject);
begin
  lblLMT.Caption := FormatDateTime('hh:mm:ss', gTime);
end;

procedure TfrmTopNav.tmr2Timer(Sender: TObject);
begin
  lblDate.Caption := FormatDateTime('dddd, dd mmmm yyyy', gTime);
end;

procedure TfrmTopNav.tmrUTCTimer(Sender: TObject);
var
  WaktuUTC: TDateTime;
begin
  WaktuUTC := TTimeZone.Local.ToUniversalTime(gTime);
  lblTime.Caption := FormatDateTime('HH:nn:ss', WaktuUTC);
end;

procedure TfrmTopNav.UpdateFormData;
begin
  Refresh_OwnShipTab(FControlled);
end;

end.
