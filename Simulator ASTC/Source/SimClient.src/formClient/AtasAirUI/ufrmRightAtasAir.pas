unit ufrmRightAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufmControlled,
  ufmPlatformGuidance, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  VrControls, VrBlinkLed, ufmSensor, Vcl.Menus, Vcl.ComCtrls,

    ufmWeapon,uT3Unit,uT3DetectedTrack,uBaseCoordSystem,uT3Common,uT3Vehicle,
   uDBAsset_Vehicle,uTMapTouch2,uSimObjects,ufrmWeapon,ufToteDisplay, ufTacticalDisplay;

type
  TfrmRightAtasAir = class(TForm)
    pnlContainer: TPanel;
    pnlWeaponController: TPanel;
    Label10: TLabel;
    pmModeSonobuoy: TPopupMenu;
    pnlContact: TPanel;
    lbl1: TLabel;
    pnlTrackSheet: TPanel;
    pnlTabTrackControl: TPanel;
    pnlTabTrackTable: TPanel;
    imgMainBackgorundContact: TImage;
    imgMainBackgorundController: TImage;
    pnlGameStatus: TPanel;
    Image4: TImage;
    Label1: TLabel;
    pnlGameState: TPanel;
    fmWeapon1: TfmWeapon;
    pnlTrackInformationBody: TPanel;
    pnlTrackControl: TPanel;
    lvTrackControl: TListView;
    pnlTrackTable: TPanel;
    lvTrackTable: TListView;
    Panel1: TPanel;
    Image1: TImage;
    pnlStatusRed: TPanel;
    tmrWarning: TTimer;
    procedure TTButtonClick(Sender: TObject);
    procedure fmWeapon1btnWeaponClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvTrackTableSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure fmWeapon1btntControlGyroAdvisedClick(Sender: TObject);
    procedure fmWeapon1btnLaunchATClick(Sender: TObject);
    procedure fmWeapon1btnTargetDetailsClick(Sender: TObject);
    procedure fmWeapon1btnSearchTargetClick(Sender: TObject);
    procedure fmWeapon1btnFiringModeATClick(Sender: TObject);
    procedure fmWeapon1btnRunOutATClick(Sender: TObject);
    procedure fmWeapon1btnGyroAngleATClick(Sender: TObject);
    procedure fmWeapon1btnControlControlRunAdvisedClick(Sender: TObject);
    procedure fmWeapon1btnControlSearchRadiusClick(Sender: TObject);
    procedure fmWeapon1btnControlSearchDepthClick(Sender: TObject);
    procedure fmWeapon1btnControlSafetyClick(Sender: TObject);
    procedure fmWeapon1btnControlSeekerClick(Sender: TObject);
    procedure fmWeapon1btnAccousticDisplayRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnAccousticDisplayRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnDisplayBlindZonesShowClick(Sender: TObject);
    procedure fmWeapon1btnDisplayBlindZonesHideClick(Sender: TObject);
    procedure fmWeapon1btnPlanATClick(Sender: TObject);
    procedure fmWeapon1btnCancelATClick(Sender: TObject);
    procedure fmWeapon1btnTargetTrackAPGClick(Sender: TObject);
    procedure fmWeapon1EdtAPGSearchRadiusKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtAPGSearchDepthKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtAPGSafetyCeilingKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtAPGSeekerRangeKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1btn7Click(Sender: TObject);
    procedure fmWeapon1btn6Click(Sender: TObject);
    procedure fmWeapon1btn5Click(Sender: TObject);
    procedure fmWeapon1btn4Click(Sender: TObject);
    procedure fmWeapon1btnAPGRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnAPGRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnAPGBilndShowClick(Sender: TObject);
    procedure fmWeapon1btnAPGBilndHideClick(Sender: TObject);
    procedure fmWeapon1btnAPGLaunchClick(Sender: TObject);
    procedure fmWeapon1btnTube1ATClick(Sender: TObject);
    procedure fmWeapon1btnTube2ATClick(Sender: TObject);
    procedure fmWeapon1btnTube3ATClick(Sender: TObject);
    procedure fmWeapon1btnTube4ATClick(Sender: TObject);
    procedure fmWeapon1EdtSearchRadiusATKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtSearchDepthATKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1EdtSafetyCeilingATKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtSeekerRangeATKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1EdtGyroAngleATKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1EdtADSearchRadiusKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtADSearchDepthKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1EdtADSafetyCeilingKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1btnADDefaultSearchDepthClick(Sender: TObject);
    procedure fmWeapon1btnADDefaultSafetyCeilingClick(Sender: TObject);
    procedure fmWeapon1btnADTargetTrackClick(Sender: TObject);
    procedure fmWeapon1chkADLaunchWhithoutTargetClick(Sender: TObject);
    procedure fmWeapon1EdtADLaunchBearingKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1chkADUseLaunchPlatformHeadingClick(Sender: TObject);
    procedure fmWeapon1btnADRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnADRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnADBilndShowClick(Sender: TObject);
    procedure fmWeapon1btnADBilndHideClick(Sender: TObject);
    procedure fmWeapon1btnADLaunchClick(Sender: TObject);
    procedure fmWeapon1editVectacWeaponCarrierDropKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1editVectacWeaponCarrierGroundKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1btnVectacPlanClick(Sender: TObject);
    procedure fmWeapon1btnVectacCancelClick(Sender: TObject);
    procedure fmWeapon1btnVectacConfirmClick(Sender: TObject);
    procedure fmWeapon1EdtBombControlSalvoKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1edtBombDepthKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1btnPositionClick(Sender: TObject);
    procedure fmWeapon1btnBombDisplayRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnBombDisplayRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnBombTargetClick(Sender: TObject);
    procedure fmWeapon1chkBombDropWhitoutTargetClick(Sender: TObject);
    procedure fmWeapon1btnBombDropClick(Sender: TObject);
    procedure fmWeapon1sbGunEngagementChaffContolAutoClick(Sender: TObject);
    procedure fmWeapon1sbGunEngagementChaffContolManualClick(Sender: TObject);
    procedure fmWeapon1sbGunEngagementChaffContolChaffClick(Sender: TObject);
    procedure fmWeapon1btnChaffTypeClick(Sender: TObject);
    procedure fmWeapon1sbChaffDisplayShowClick(Sender: TObject);
    procedure fmWeapon1sbChaffDisplayHideClick(Sender: TObject);
    procedure fmWeapon1sbChaffBlindZoneShowClick(Sender: TObject);
    procedure fmWeapon1sbChaffBlindZoneHideClick(Sender: TObject);
    procedure fmWeapon1btnChaffFireClick(Sender: TObject);
    procedure fmWeapon1btnChaffCeaseFireClick(Sender: TObject);
    procedure fmWeapon1btnAddHybridMissileTargetAimpointClick(Sender: TObject);
    procedure fmWeapon1btnDefaultHybridMissileControlCruiseAltitudeClick(
      Sender: TObject);
    procedure fmWeapon1btnDefaultHybridMissileControlSeekerRangeClick(
      Sender: TObject);
    procedure fmWeapon1btnHybridMissileDisplayRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnHybridMissileDisplayRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnHybridMissileDisplayBlindZonesShowClick(
      Sender: TObject);
    procedure fmWeapon1btnHybridMissileDisplayBlindZonesHideClick(
      Sender: TObject);
    procedure fmWeapon1btnHybridMissileLaunchClick(Sender: TObject);
    procedure fmWeapon1EdtMinesDepthKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1edtRangeKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1btnMinesDeployClick(Sender: TObject);
    procedure fmWeapon1btnSRTargetTrackClick(Sender: TObject);
    procedure fmWeapon1btnSRRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnSRRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnSRBlindShowClick(Sender: TObject);
    procedure fmWeapon1btnSRBlindHideClick(Sender: TObject);
    procedure fmWeapon1btnSRLaunchClick(Sender: TObject);
    procedure fmWeapon1ediSurfaceToAirSalvoKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1btnSurfaceToAirTargetTrackClick(Sender: TObject);
    procedure fmWeapon1sbSurfaceToAirDisplayRangeShowClick(Sender: TObject);
    procedure fmWeapon1sbSurfaceToAirDisplayRangeHideClick(Sender: TObject);
    procedure fmWeapon1sbSurfaceToAirDisplayBlindShowClick(Sender: TObject);
    procedure fmWeapon1sbSurfaceToAirDisplayBlindHideClick(Sender: TObject);
    procedure fmWeapon1btSurfaceToAirPlanClick(Sender: TObject);
    procedure fmWeapon1btSurfaceToAirCancelClick(Sender: TObject);
    procedure fmWeapon1btSurfaceToAirLaunchClick(Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileTargetTrackClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileTargetTrackDetailsClick(
      Sender: TObject);
    procedure fmWeapon1pnlLaunch1Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch2Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch3Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch4Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch5Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch6Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch7Click(Sender: TObject);
    procedure fmWeapon1pnlLaunch8Click(Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileEngagementClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileFiringClick(Sender: TObject);
    procedure fmWeapon1btn1Click(Sender: TObject);
    procedure fmWeapon1edtDestructRangeKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1btnSurfaceToSurfaceMissileLauncherMoreClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileWaypointsEditClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileWaypointsAddClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileWaypointsDeleteClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileWaypointsApplyClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceMissileWaypointsCancelClick(
      Sender: TObject);
    procedure fmWeapon1sbSurfaceToSurfaceMissileDisplayRangeShowClick(
      Sender: TObject);
    procedure fmWeapon1sbSurfaceToSurfaceMissileDisplayRangeHideClick(
      Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfacePlanClick(Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceCancelClick(Sender: TObject);
    procedure fmWeapon1btnSurfaceToSurfaceLaunchClick(Sender: TObject);
    procedure fmWeapon1btnTacticalMissileTargetTrackClick(Sender: TObject);
    procedure fmWeapon1btnTacticalMissileTargetAimpointClick(Sender: TObject);
    procedure fmWeapon1editTacticalMissileTargetBearingKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1btnTacticalMissileTargetBearingClick(Sender: TObject);
    procedure fmWeapon1sbTacticalMissileDisplayRangeShowClick(Sender: TObject);
    procedure fmWeapon1sbTacticalMissileDisplayRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnTacticalMissileLaunchClick(Sender: TObject);
    procedure fmWeapon1EdtWHSalvoKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1btnWakeHomingTargetTrackClick(Sender: TObject);
    procedure fmWeapon1EdtWHLaunchBearingKeyPress(Sender: TObject;
      var Key: Char);
    procedure fmWeapon1EdtWHSeekerRangeKeyPress(Sender: TObject; var Key: Char);
    procedure fmWeapon1btnWHDefaultSeekerRangeClick(Sender: TObject);
    procedure fmWeapon1btnWHRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnWHRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnWHBlindShowClick(Sender: TObject);
    procedure fmWeapon1btnWHBlindHideClick(Sender: TObject);
    procedure fmWeapon1btnWHLaunchClick(Sender: TObject);
    procedure fmWeapon1btnWGTargetTrackClick(Sender: TObject);
    procedure fmWeapon1btnWGRangeShowClick(Sender: TObject);
    procedure fmWeapon1btnWGRangeHideClick(Sender: TObject);
    procedure fmWeapon1btnWGBlindShowClick(Sender: TObject);
    procedure fmWeapon1btnWGBlindHideClick(Sender: TObject);
    procedure fmWeapon1btnWGLaunchClick(Sender: TObject);
//    procedure pnlStatusYellowClick(Sender: TObject);
    procedure pnlStatusRedClick(Sender: TObject);
    procedure tmrWarningTimer(Sender: TObject);
  private
    tmrFlag : Integer;
    function FindTrackListByMember(const arg: string): TListItem;
    procedure UpdateTrackListData;
    { Private declarations }
  public
    focusedTrack: TSimObject;
    Map1 : TMapXTouch;
//    statusR_List,statusY_List : TList;

    procedure addStatus(status: String);

//    procedure updateStatus;
    procedure SetControlledObject(pit : TT3PlatformInstance);
    procedure AddTrackPlatform(Sender: TObject);
    procedure RemoveFromTrackList(Sender: TObject);
    procedure UpdateFormData;

    { Public declarations }
  end;

  TStatus = class
    public
    state : String;
  end;

var
  frmRightAtasAir: TfrmRightAtasAir;

implementation

{$R *.dfm}

procedure TfrmRightAtasAir.addStatus(status: String);
begin
  pnlStatusRed.Caption := status;
  pnlStatusRed.Visible := True;

  tmrWarning.Enabled := True;
end;

procedure TfrmRightAtasAir.AddTrackPlatform(Sender: TObject);
var
  sTrackNum, sDomain, sIdent: string;
  li: TListItem;
  pi: TT3PlatformInstance;
  det: TT3DetectedTrack;
begin
  pi := nil;

  if Sender is TT3DetectedTrack then
  begin
    det := Sender as TT3DetectedTrack;

    if Assigned(det.TrackObject) then
    begin
      if det.TrackObject is TT3DeviceUnit then
        pi := det.TrackObject.Parent as TT3PlatformInstance
      else
        pi := det.TrackObject as TT3PlatformInstance;
    end;

    sTrackNum := FormatTrackNumber(det.trackNumber);
    sDomain := getDomain(det.TrackDomain);
    sIdent  := getIdentStr(det.TrackIdent);
  end
  else if (Sender is TT3PlatformInstance) then
  begin
    pi := Sender as TT3PlatformInstance;

    if pi is TT3NonRealVehicle then
    begin
      sTrackNum := IntToStr(TT3PlatformInstance(pi).TrackNumber);
      sDomain   := getDomain(TT3PlatformInstance(pi).TrackDomain);
      sIdent := getIdentStr(TT3PlatformInstance(pi).TrackIdent);
    end
    else
    begin
      sTrackNum := pi.TrackLabel;
      sDomain   := getDomain(TVehicle_Definition(TT3Vehicle(pi).UnitDefinition).FData.Platform_Domain);
      sIdent := getIdentStr(pi.Force_Designation);
    end;
  end;

  if pi <> nil then
  begin
    li := FindTrackListByMember(sTrackNum);
    if li = nil then
    begin
      li := lvTrackTable.Items.Add;

      li.Caption := sDomain;
      li.SubItems.Add(sTrackNum);
      li.SubItems.Add(sIdent);
      li.SubItems.Add(FormatCourse(pi.Course));
      li.SubItems.Add(FormatSpeed(pi.Speed));

      if sDomain = 'Air' then
      begin
        li.SubItems.Add(FormatAltitude(pi.Altitude * C_Meter_To_Feet));
        li.SubItems.Add(' ');
      end
      else
      begin
        li.SubItems.Add(' ');
        li.SubItems.Add(FormatAltitude(pi.Altitude));
      end;
//      else
//      begin
//
//      end;
//
//      if pi.Altitude >= 0 then
//      begin
//        li.SubItems.Add(FormatAltitude(pi.Altitude));
//        li.SubItems.Add(' ');
//      end
//      else
//      begin
//        li.SubItems.Add(' ');
//        li.SubItems.Add(FormatAltitude(pi.Altitude));
//      end;

      li.Data := Sender;
    end
    else
    begin
      // sudah ada.
      li.Caption := sDomain;
      li.SubItems[0] := sTrackNum;
      li.SubItems[1] := sIdent;
      li.SubItems[2] := FormatCourse(pi.Course);
      li.SubItems[3] := FormatSpeed(pi.Speed);

      if sDomain = 'Air' then
      begin
        li.SubItems[4] := FormatAltitude(pi.Altitude * C_Meter_To_Feet);
        li.SubItems[5] := ' ';
      end
      else
      begin
        li.SubItems[4] := ' ';
        li.SubItems[5] := FormatAltitude(pi.Altitude);
      end;
    end;
  end;
end;

function TfrmRightAtasAir.FindTrackListByMember(const arg: string): TListItem;
var
  i: Integer;
  f: Boolean;
  li: TListItem;
begin
  result := nil;
  li := nil;
  f := false;
  i := 0;

  while not f and (i < lvTrackTable.Items.Count) do
  begin
    li := lvTrackTable.Items.Item[i];

    f := SameText(li.SubItems[0], arg);

    Inc(i);
  end;

  if f then
    result := li;
end;

procedure TfrmRightAtasAir.fmWeapon1btn1Click(Sender: TObject);
begin
  fmWeapon1.btnAllLaunch(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btn4Click(Sender: TObject);
begin
  fmWeapon1.APGbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btn5Click(Sender: TObject);
begin
  fmWeapon1.APGbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btn6Click(Sender: TObject);
begin
  fmWeapon1.APGbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btn7Click(Sender: TObject);
begin
  fmWeapon1.APGbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAccousticDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAccousticDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADBilndHideClick(Sender: TObject);
begin
  fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADBilndShowClick(Sender: TObject);
begin
  fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADDefaultSafetyCeilingClick(
  Sender: TObject);
begin
  fmWeapon1.ADbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADDefaultSearchDepthClick(
  Sender: TObject);
begin
  fmWeapon1.ADbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAddHybridMissileTargetAimpointClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADRangeHideClick(Sender: TObject);
begin
  fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADRangeShowClick(Sender: TObject);
begin
  fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnADTargetTrackClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 5) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnAirDroppedTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnAPGBilndHideClick(Sender: TObject);
begin
  fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAPGBilndShowClick(Sender: TObject);
begin
  fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAPGLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAPGRangeHideClick(Sender: TObject);
begin
  fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnAPGRangeShowClick(Sender: TObject);
begin
  fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnBombDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnBombOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnBombDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnBombOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnBombDropClick(Sender: TObject);
begin
  fmWeapon1.btnBombOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnBombTargetClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 1) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnBombOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnCancelATClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnChaffCeaseFireClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnChaffFireClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnChaffTypeClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnControlControlRunAdvisedClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnControlSafetyClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnControlSearchDepthClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnControlSearchRadiusClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnControlSeekerClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnDefaultHybridMissileControlCruiseAltitudeClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnDefaultHybridMissileControlSeekerRangeClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnDisplayBlindZonesHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnDisplayBlindZonesShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnFiringModeATClick(Sender: TObject);
begin
  fmWeapon1.btnFiringModeATClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnGyroAngleATClick(Sender: TObject);
begin
  fmWeapon1.btnGyroAngleATClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnHybridMissileDisplayBlindZonesHideClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnHybridMissileDisplayBlindZonesShowClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnHybridMissileDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnHybridMissileDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnHybridMissileLaunchClick(
  Sender: TObject);
begin
  fmWeapon1.OnHybridMissileClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnLaunchATClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnMinesDeployClick(Sender: TObject);
begin
  fmWeapon1.btnMinesDeployClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnPlanATClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnPositionClick(Sender: TObject);
begin
  fmWeapon1.btnPositionClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnRunOutATClick(Sender: TObject);
begin
  fmWeapon1.btnRunOutATClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSearchTargetClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRBlindHideClick(Sender: TObject);
begin
  fmWeapon1.btnStraightTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRBlindShowClick(Sender: TObject);
begin
  fmWeapon1.btnStraightTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnStraightTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRRangeHideClick(Sender: TObject);
begin
  fmWeapon1.btnStraightTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRRangeShowClick(Sender: TObject);
begin
  fmWeapon1.btnStraightTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSRTargetTrackClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 5) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnStraightTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToAirTargetTrackClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 5) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnSurfaceToAirOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceCancelClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceLaunchClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileEngagementClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceMissileEngagementClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileFiringClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceMissileFiringClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileLauncherMoreClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceMissileLauncherMoreClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileTargetTrackClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 3) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnSurfaceToSurfaceClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileTargetTrackDetailsClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceMissileTargetTrackDetailsClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileWaypointsAddClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileWaypointsApplyClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileWaypointsCancelClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileWaypointsDeleteClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfaceMissileWaypointsEditClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnSurfaceToSurfacePlanClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTacticalMissileLaunchClick(
  Sender: TObject);
begin
  fmWeapon1.btnTacticalMissileLaunchClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTacticalMissileTargetAimpointClick(
  Sender: TObject);
begin
  fmWeapon1.btnTacticalMissileTargetAimpointClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTacticalMissileTargetBearingClick(
  Sender: TObject);
begin
  fmWeapon1.btnTacticalMissileTargetBearingClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTacticalMissileTargetTrackClick(
  Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);
    fmWeapon1.btnTacticalMissileTargetTrackClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnTargetDetailsClick(Sender: TObject);
begin
  fmWeapon1.btnAcousticTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTargetTrackAPGClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 5) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnActivePasiveTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btntControlGyroAdvisedClick(
  Sender: TObject);
begin
   if Assigned(Sender)then
  begin
    fmWeapon1.btnAcousticTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnTube1ATClick(Sender: TObject);
begin
  fmWeapon1.AcousticTubeOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTube2ATClick(Sender: TObject);
begin
  fmWeapon1.AcousticTubeOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTube3ATClick(Sender: TObject);
begin
  fmWeapon1.AcousticTubeOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnTube4ATClick(Sender: TObject);
begin
  fmWeapon1.AcousticTubeOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnVectacCancelClick(Sender: TObject);
begin
  fmWeapon1.btnVectacClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnVectacConfirmClick(Sender: TObject);
begin
  fmWeapon1.btnVectacClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnVectacPlanClick(Sender: TObject);
begin
  fmWeapon1.btnVectacClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWakeHomingTargetTrackClick(
  Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 1) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnWeaponClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmWeapon1.btnWeaponClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnWGBlindHideClick(Sender: TObject);
begin
  fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWGBlindShowClick(Sender: TObject);
begin
  fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWGLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWGRangeHideClick(Sender: TObject);
begin
  fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWGRangeShowClick(Sender: TObject);
begin
  fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWGTargetTrackClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    if (Sender is TSpeedButton) and (TSpeedButton(Sender).Tag = 5) then
      frmTacticalDisplay.SetWeaponTargetObject(focusedTrack);

    fmWeapon1.btnWireGuidedTorpedoOnClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.fmWeapon1btnWHBlindHideClick(Sender: TObject);
begin
  fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWHBlindShowClick(Sender: TObject);
begin
  fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWHDefaultSeekerRangeClick(
  Sender: TObject);
begin
  fmWeapon1.WHbtn(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWHLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWHRangeHideClick(Sender: TObject);
begin
  fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btnWHRangeShowClick(Sender: TObject);
begin
  fmWeapon1.btnWakeHomingTorpedoOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btSurfaceToAirCancelClick(Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btSurfaceToAirLaunchClick(Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1btSurfaceToAirPlanClick(Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1chkADLaunchWhithoutTargetClick(
  Sender: TObject);
begin
  fmWeapon1.chkADLaunchWhithoutTargetClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1chkADUseLaunchPlatformHeadingClick(
  Sender: TObject);
begin
  fmWeapon1.chkADUseLaunchPlatformHeadingClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1chkBombDropWhitoutTargetClick(
  Sender: TObject);
begin
  fmWeapon1.chkBombDropWhithoutTargetClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1ediSurfaceToAirSalvoKeyPress(
  Sender: TObject; var Key: Char);
begin
  fmWeapon1.ediSurfaceToAirSalvoKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1editTacticalMissileTargetBearingKeyPress(
  Sender: TObject; var Key: Char);
begin
  fmWeapon1.editTacticalMissileTargetBearingKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1editVectacWeaponCarrierDropKeyPress(
  Sender: TObject; var Key: Char);
begin
  fmWeapon1.editVectacKeypress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1editVectacWeaponCarrierGroundKeyPress(
  Sender: TObject; var Key: Char);
begin
  fmWeapon1.editVectacKeypress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtADLaunchBearingKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.ADKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtADSafetyCeilingKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.ADKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtADSearchDepthKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.ADKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtADSearchRadiusKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.ADKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtAPGSafetyCeilingKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.APGKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtAPGSearchDepthKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.APGKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtAPGSearchRadiusKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.APGKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtAPGSeekerRangeKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.APGKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtBombControlSalvoKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.BombKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1edtBombDepthKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.MineKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1edtDestructRangeKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.edtDestructRangeKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtGyroAngleATKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.AngkaKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtMinesDepthKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.MineKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1edtRangeKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.edtRangeKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtSafetyCeilingATKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.AcousticKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtSearchDepthATKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.AcousticKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtSearchRadiusATKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.AcousticKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtSeekerRangeATKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.AcousticKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtWHLaunchBearingKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.WHKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtWHSalvoKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.WHKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1EdtWHSeekerRangeKeyPress(Sender: TObject;
  var Key: Char);
begin
  fmWeapon1.WHKeyPress(Sender, Key);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch1Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch2Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch3Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch4Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch5Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch6Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch7Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1pnlLaunch8Click(Sender: TObject);
begin
  fmWeapon1.pnlLaunch1Click(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbChaffBlindZoneHideClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbChaffBlindZoneShowClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbChaffDisplayHideClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbChaffDisplayShowClick(Sender: TObject);
begin
  fmWeapon1.btnChaffClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbGunEngagementChaffContolAutoClick(
  Sender: TObject);
begin
  fmWeapon1.btnGunControlClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbGunEngagementChaffContolChaffClick(
  Sender: TObject);
begin
  fmWeapon1.btnGunControlClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbGunEngagementChaffContolManualClick(
  Sender: TObject);
begin
  fmWeapon1.btnGunControlClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToAirDisplayBlindHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToAirDisplayBlindShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToAirDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToAirDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToAirOnClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToSurfaceMissileDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbSurfaceToSurfaceMissileDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.btnSurfaceToSurfaceClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbTacticalMissileDisplayRangeHideClick(
  Sender: TObject);
begin
  fmWeapon1.sbTacticalMissileDisplayRangeHideClick(Sender);

end;

procedure TfrmRightAtasAir.fmWeapon1sbTacticalMissileDisplayRangeShowClick(
  Sender: TObject);
begin
  fmWeapon1.sbTacticalMissileDisplayRangeShowClick(Sender);

end;

procedure TfrmRightAtasAir.FormCreate(Sender: TObject);
begin
   fmWeapon1.InitCreate(self);

   tmrFlag := 0;
end;

procedure TfrmRightAtasAir.lvTrackTableSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  obj: TObject;
begin
  if Item = nil then
    exit;

  obj := Item.Data;

  if obj is TT3DetectedTrack then
    (obj as TT3DetectedTrack).Selected := true
  else if obj is TT3PlatformInstance then
    (obj as TT3PlatformInstance).Selected := true;

  Map1.Repaint;
end;

procedure TfrmRightAtasAir.pnlStatusRedClick(Sender: TObject);
begin
  pnlStatusRed.Caption := '';
  pnlStatusRed.Visible := False;
end;

procedure TfrmRightAtasAir.RemoveFromTrackList(Sender: TObject);
var
  s: string;
  li: TListItem;
  det: TT3DetectedTrack;
  pi: TT3PlatformInstance;
begin
  if Sender is TT3DetectedTrack then
  begin
    det := Sender as TT3DetectedTrack;
    s := FormatTrackNumber(det.TrackNumber);
  end
  else if Sender is TT3PlatformInstance then
  begin
    pi := Sender as TT3PlatformInstance;

    if pi is TT3NonRealVehicle then
      s := IntToStr(pi.TrackNumber)
    else
      s := pi.TrackLabel;
  end
  else
    Exit;

  li := FindTrackListByMember(s);

  if li <> nil then
    li.Delete;
end;

procedure TfrmRightAtasAir.SetControlledObject(pit: TT3PlatformInstance);
begin
  if not Assigned(pit) then
    Exit;

  if pit is TT3Vehicle then
  begin
    fmWeapon1.SetControlledObject(pit);
    Caption := 'Weapon ' + pit.InstanceName;
  end;
//  if pit is TT3Vehicle then
//  begin
//    frmWeapon.Caption := 'Weapon ' + pit.InstanceName;
//  end;
end;

procedure TfrmRightAtasAir.tmrWarningTimer(Sender: TObject);
begin
  if tmrFlag > 5 then
  begin
    {menghilangkan tmr}
    pnlStatusRed.Caption := '';
    pnlStatusRed.Visible := False;
    tmrWarning.Enabled := False;
    tmrFlag := 0;
  end
  else
  begin
    tmrFlag := tmrFlag + 1;
  end;

end;

procedure TfrmRightAtasAir.TTButtonClick(Sender: TObject);
var
  PanelTag: integer;
  Panel: Tpanel;
begin
  panel := Sender as Tpanel;
  PanelTag := panel.Tag;

  if panel = pnlTabTrackTable then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackTable.Color := RGB(29, 81, 103);
      pnlTrackTable.BringToFront;
      pnlTabTrackTable.Tag := 1;
      pnlTabTrackControl.Tag := 0;
      pnlTabTrackControl.Color := RGB(16, 46, 58);
    end;
  end;

  if panel = pnlTabTrackControl then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackControl.Color := RGB(29, 81, 103);
      pnlTrackControl.BringToFront;
      pnlTabTrackControl.Tag := 1;
      pnlTabTrackTable.Tag := 0;
      pnlTabTrackTable.Color := RGB(16, 46, 58);
    end;
  end;
end;

procedure TfrmRightAtasAir.UpdateFormData;
begin
//    fmWeapon1.SetControlledObject(pit);
//    fmWeapon1.Refresh_VisibleTab;
end;

procedure TfrmRightAtasAir.UpdateTrackListData;
var
  i: Integer;
  li: TListItem;
  sTrackNum, sDomain, sIdent: string;
  pi: TT3PlatformInstance;
  det: TT3DetectedTrack;
  obj: TObject;
begin
  for i := lvTrackTable.Items.Count - 1 downto 0 do
  begin
    pi := nil;
    li := lvTrackTable.Items[i];
    obj := li.Data;

    if obj = nil then
    begin
      lvTrackTable.items.Delete(i);
      Continue;
    end;

    if obj is TT3DetectedTrack then
    begin
      det := obj as TT3DetectedTrack;
      sTrackNum := FormatTrackNumber(det.trackNumber);
      sDomain := getDomain(det.TrackDomain);
      sIdent := getIdentStr(det.TrackIdent);

      if Assigned(det.TrackObject) then
      begin
        if det.TrackObject is TT3DeviceUnit then
          pi := det.TrackObject.Parent as TT3PlatformInstance
        else
          pi := det.TrackObject as TT3PlatformInstance;
      end;
    end
    else if obj is TT3PlatformInstance then
    begin
      pi := obj as TT3PlatformInstance;

      if pi is TT3NonRealVehicle then
      begin
        sTrackNum := IntToStr(TT3PlatformInstance(pi).TrackNumber);
        sDomain   := getDomain(TT3PlatformInstance(pi).TrackDomain);
        sIdent := getIdentStr(TT3PlatformInstance(pi).TrackIdent);
      end
      else
      begin
        sTrackNum := pi.TrackLabel;
        sDomain   := getDomain(TVehicle_Definition(TT3Vehicle(pi).UnitDefinition).FData.Platform_Domain);
        sIdent := getIdentStr(pi.Force_Designation);
      end;
    end;

    if Assigned(pi) then
    begin
      li.Caption := sDomain;

      li.SubItems[0] := sTrackNum;
      li.SubItems[1] := sIdent;
      li.SubItems[2] := FormatCourse(pi.Course);
      li.SubItems[3] := FormatSpeed(pi.Speed);

      if sDomain = 'Air' then
      begin
        li.SubItems[4] := FormatAltitude(pi.Altitude * C_Meter_To_Feet);
        li.SubItems[5] := ' ';
      end
      else
      begin
        li.SubItems[4] := ' ';
        li.SubItems[5] := FormatAltitude(pi.Altitude);
      end;
    end;
  end;
end;

end.
