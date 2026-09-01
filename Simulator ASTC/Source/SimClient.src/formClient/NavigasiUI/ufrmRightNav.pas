unit ufrmRightNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzBmpBtn, Vcl.StdCtrls, VrControls,
  VrWheel, Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uT3Unit, uSimObjects, ufmControlled, Vcl.ComCtrls, ufmPlatformGuidance, ufmOwnShip,
  Vcl.Menus, ufmSensor;

type
  TfrmRightNav = class(TForm)
    pnlContainer: TPanel;
    pnlPlatformGuidance: TPanel;
    fmPlatformGuidance1: TfmPlatformGuidance;
    pnlGameStatus: TPanel;
    lbl1: TLabel;
    pnlGameState: TPanel;
    pnlSensor: TPanel;
    fmSensor1: TfmSensor;
    Image4: TImage;
    pnlController: TPanel;
    imgMainBackgorundController: TImage;
    pnlControllerNone: TPanel;
    pnlShipSheet: TPanel;
    pnlTabPlatformGuidance: TPanel;
    imgPlatformGuidance: TImage;
    pnlTabSensor: TPanel;
    imgSensor: TImage;
    pnlContactInformation: TPanel;
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
    pnlContentNone: TPanel;
    imgMainBackgorundContact: TImage;
    lblShipName: TLabel;
    pnlControllerBody: TPanel;
    lbl26: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    pnlStatusRed: TPanel;
    tmrWarning: TTimer;
    procedure THButtonClick(Sender: TObject);
    procedure TDCPButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fmPlatformGuidance1SpeedButton2Click(aTrack: TSimObject; Sender: TObject);
    procedure fmPlatformGuidance1whHeadingChange(Sender: TObject);
    procedure fmPlatformGuidance1edtStraightLineOrderedHeadingKeyPress(
      Sender: TObject; var Key: Char);
    procedure fmPlatformGuidance1edtStraightLineOrderedGroundSpeedKeyPress(
      Sender: TObject; var Key: Char);
    procedure fmPlatformGuidance1edOrderAltitudeKeyPress(Sender: TObject;
      var Key: Char);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fmPlatformGuidance1btnWaypointClick(Sender: TObject);
    procedure fmSensor1sbIFFTransponderControlModeOnClick(Sender: TObject);
    procedure tmrWarningTimer(Sender: TObject);
    procedure pnlStatusRedClick(Sender: TObject);
  protected
    FControlled: TObject;

  private
    tmrFlag : Integer;
    { Private declarations }
  public
  focusedTrack: TSimObject;
  statusR_List,statusY_List : TList;
    procedure GetNameAndClass(const obj: TSimObject; var n, c: string);
    procedure Refresh_Controller(aIsGuidanceOpen: Boolean; aIsWasdal: Boolean);

    {HOOK-IFF}
    procedure UpdateTabHooked(aTrack: TSimObject);
    procedure UpdateHookedInfo(Sender: TObject);
    procedure InitTabHookedInfo;
    procedure DisplayTabHooked(Sender: TObject);
    procedure DisplayTabDetail(Sender: TObject);
    procedure DisplayTabDetection(Sender: TObject);
    procedure DisplayTabIFF(Sender: TObject);

    procedure InitCreate(sender: TForm);
    procedure UpdateFormData;
    procedure SetControlledObject(pit : TT3PlatformInstance);
    procedure addStatus1(status: String);
    procedure AddStatus(command: String);


    { Public declarations }
  end;

var
  frmRightNav: TfrmRightNav;

implementation

uses
  ufTacticalDisplay, ufToteDisplay, uT3DetectedTrack, uSettingCoordinate, uT3Radar,
  uBaseCoordSystem, uSimMgr_Client, tttData, uT3Vehicle, uDBAsset_Vehicle, uT3Torpedo, uT3Missile,
  uDBAsset_Weapon, uT3Sonobuoy, uT3Mine, uT3CounterMeasure, uMapXHandler, uT3Common, uT3OtherSensor, ufrmGuidance,
  ufrmWeapon, ufrmRadar, uT3SimManager, ufrmTrackDetails, uSimContainers;

{$R *.dfm}
Function DecToOct(Inp : String): String;

Var
  HasilBagi,SisaBagi : Integer;
  Oct,Oktal : String;
  i : integer;
  Des : integer;
begin
  Oct := '';
  Oktal := '';
  Des:= StrToInt(inp);
  Repeat
    SisaBagi := des Mod 8;
    Oct:= Oct + intToStr(SisaBagi);
    HasilBagi := Des Div 8;
    des:= HasilBagi;
  Until HasilBagi = 0;

  For I := length (Oct) Downto 1 Do
  Begin
    Oktal := Oktal+ Oct[i];
  End;

  Result:= Oktal;
end;

procedure TfrmRightNav.TDCPButtonClick(Sender: TObject);
var
  senderTag: integer;
  imageTemp: Timage;
  panelTemp : TPanel;
begin
  if Sender is TImage then
  begin
    imageTemp := Sender as Timage;
    senderTag := imageTemp.Tag;

    if imageTemp = imgPlatformGuidance then
    begin
      if senderTag = 0 then
      begin
        pnlTabPlatformGuidance.Color := RGB(29, 81, 103);
        pnlPlatformGuidance.BringToFront;
        imgPlatformGuidance.Tag := 1;
        imgSensor.Tag := 0;
        pnlTabSensor.Color := RGB(16, 46, 58);
      end;
    end

    else if imageTemp = imgSensor then
    begin
      if senderTag = 0 then
      begin
        pnlTabSensor.Color := RGB(29, 81, 103);
        pnlSensor.BringToFront;
        imgSensor.Tag := 1;
        imgPlatformGuidance.Tag := 0;
        pnlTabPlatformGuidance.Color := RGB(16, 46, 58);
      end;
    end
  end
  else if Sender is TPanel then
  begin
    panelTemp := Sender as TPanel;
    senderTag := panelTemp.Tag;

    if panelTemp = pnlTabPlatformGuidance then
    begin
      if senderTag = 0 then
      begin
        pnlTabPlatformGuidance.Color := RGB(29, 81, 103);
        pnlPlatformGuidance.BringToFront;
        imgPlatformGuidance.Tag := 1;
        imgSensor.Tag := 0;
        pnlTabSensor.Color := RGB(16, 46, 58);
      end;
    end

    else if panelTemp = pnlTabSensor then
    begin
      if senderTag = 0 then
      begin
        pnlTabSensor.Color := RGB(29, 81, 103);
        pnlSensor.BringToFront;
        imgSensor.Tag := 1;
        imgPlatformGuidance.Tag := 0;
        pnlTabPlatformGuidance.Color := RGB(16, 46, 58);
      end;
    end
  end;



end;

procedure TfrmRightNav.THButtonClick(Sender: TObject);
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

procedure TfrmRightNav.tmrWarningTimer(Sender: TObject);
begin
  if tmrFlag > 8 then
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

procedure TfrmRightNav.UpdateFormData;
var
  i: Integer;
begin
  {Update Guidance}
  if (simMgrClient.ControlledPlatform <> nil) and (simMgrClient.ControlledPlatform is TT3PlatformInstance) then
  begin
    if imgPlatformGuidance.Tag = 1 then i := 1;
    if imgSensor.Tag = 1 then i := 2;

    if i = 1 then
      TT3Vehicle(simMgrClient.ControlledPlatform).Waypoints.IsOpenGuidanceTab := True
    else
      TT3Vehicle(simMgrClient.ControlledPlatform).Waypoints.IsOpenGuidanceTab := False;

    case i of
      1:
        fmPlatformGuidance1.Refresh_VisibleTab();
      2:
        fmSensor1.Refresh_VisibleTab();
    end;
  end;

  if focusedTrack <> nil then
  begin
    UpdateHookedInfo(focusedTrack);
  end
  else
  begin
    InitTabHookedInfo;
  end;
end;

procedure TfrmRightNav.UpdateHookedInfo(Sender: TObject);
begin
 InitTabHookedInfo;

  if not Assigned(Sender) then

    exit;

  if pnlTabHook.Tag = 1 then
    DisplayTabHooked(Sender);

//  if pnlTabDetails.Tag = 1 then
//    DisplayTabDetail(Sender);

//  if pnlTabDetection.Tag = 1 then
//    DisplayTabDetection(Sender);

//  if pnlTabIFF.Tag = 1 then
//    DisplayTabIFF(Sender);
end;

procedure TfrmRightNav.UpdateTabHooked(aTrack: TSimObject);
begin
  if Assigned(aTrack) then
  begin
    UpdateHookedInfo(aTrack);
  end
  else
  begin
    InitTabHookedInfo;
  end;
end;

procedure TfrmRightNav.DisplayTabHooked(Sender: TObject);
var
  v: TT3PlatformInstance;
  ct: TT3PlatformInstance;
  det: TT3DetectedTrack;
  d, b, long, lat: double;
  pY, pX: Extended;
  idCoordinat: Integer;
  esm: TT3ESMTrack;
  hasilUTM, hasilMGRS : string;   //dng
  largeLtr, smallLtr, horizontalNumb, verticalNumb, horzPoint, vertPoint : string;
begin
  v := nil;
  det := nil;

  if Assigned(sender) then
  begin
    if Sender is TT3PlatformInstance then
    begin
      {$REGION ' TT3PlatformInstance '}

      v := TT3PlatformInstance(Sender)

      {$ENDREGION}
    end
    else if Sender is TT3DetectedTrack then
    begin
      {$REGION ' TT3DetectedTrack '}

      det := TT3DetectedTrack(Sender);

      if Assigned(det.MergedESM) then
      begin
        lblTrackHook.Caption:= (det.MergedESM.TrackNumber);
        lblNameHook.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lblClassHook.Caption:= TT3Radar(det.MergedESM.TrackObject).RadarDefinition.FDef.Radar_Emitter;
        lblBearingHook.Caption := FormatFloat('000.0', det.MergedESM.Bearing);

        txt50.Caption := 'Origin';
        lblPositionHook1.Caption := formatDMS_long(det.MergedESM.DetectBy.PosX);
        lblPositionHook2.Caption := formatDMS_latt(det.MergedESM.DetectBy.PosY);

        Exit;
      end;

      v := TT3PlatformInstance(det.TrackObject);
      {$ENDREGION}
    end
    else if Sender is TT3ESMTrack then
    begin
      {$REGION ' TT3ESMTrack '}

      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lblTrackHook.Caption      := esm.TrackNumber
      else
        lblTrackHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lblNameHook.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lblNameHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lblClassHook.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lblClassHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Bearing_Data_Capability then
        lblBearingHook.Caption      := FormatFloat('000.0', esm.Bearing)
      else
        lblBearingHook.Caption      := '---';

      txt50.Caption := 'Origin';
      lblPositionHook1.Caption := formatDMS_long(TT3ESMTrack(sender).DetectBy.PosX);
      lblPositionHook2.Caption := formatDMS_latt(TT3ESMTrack(sender).DetectBy.PosY);

      Exit;
      {$ENDREGION}
    end;
  end;

  b := 0;
  d := 0;

  if v <> nil then
  begin
    if simMgrClient.ControlledPlatform <> nil then
    begin
      ct := TT3PlatformInstance(simMgrClient.ControlledPlatform);
      b := CalcBearing(ct.getPositionX, ct.getPositionY, v.getPositionX, v.getPositionY);
      d := CalcRange(ct.getPositionX, ct.getPositionY, v.getPositionX, v.getPositionY);
    end;
  end;

  if det <> nil then
  begin
    {$REGION ' det tidak sama dengan nil '}
    if det.TrackObject is TT3DeviceUnit then
    begin
      v := det.TrackObject.Parent as TT3PlatformInstance;
    end
    else if det.TrackObject is TT3PlatformInstance then
    begin
      v := det.TrackObject as TT3PlatformInstance;
    end;

    if (det.TrackDomain = vhdSubsurface) then
    begin
      txtlb5.Caption := 'Depth';
      lbllb4.Caption := 'meter';

      if v.Altitude <> 0 then
        lblAltitude.Caption := FormatAltitude(v.Altitude)
      else
        lblAltitude.Caption := '0';
    end
    else
    begin
      txtlb5.Caption := 'Altitude';
      lbllb4.Caption := 'feet';

      if v.Altitude <> 0 then
       lblAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
      else
       lblAltitude.Caption := '0';
    end;

    if Assigned(v) then
    begin
//      if det.IsDetailViewed then
//      begin
        if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
        begin
//          lblNameHook.Caption      := v.InstanceName;
          lblNameHook.Caption      := det.TrackName;
        end
        else
        begin
//          lblNameHook.Caption      := 'Unknown';
          lblNameHook.Caption      := det.TrackName;
        end;

        if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
        begin
//          lblClassHook.Caption     := v.InstanceClass;
          lblClassHook.Caption      := det.TrackClass;
        end
        else
        begin
//          lbClassHook.Caption     := 'Unknown';
          lblClassHook.Caption      := det.TrackClass;
        end;

        if det.DetailedDetectionShowed.Heading_Data_Capability then
          lblCourseHook.Caption    := FormatCourse(v.Course)
        else
          lblCourseHook.Caption    := '---';

        if det.DetailedDetectionShowed.Ground_Speed_Data_Capability then
          lblGround.Caption        := FormatSpeed(v.Speed)
        else
          lblGround.Caption        := '---';

        if det.DetailedDetectionShowed.Altitude_Data_Capability then
        begin
          if (det.TrackDomain = vhdSubsurface) then
          begin
            txtlb5.Caption := 'Depth';
            lbllb4.Caption := 'meter';

            if v.Altitude <> 0 then
              lblAltitude.Caption    := FormatAltitude(v.Altitude)
            else
              lblAltitude.Caption := '0';
          end
          else
          begin
            txtlb5.Caption := 'Altitude';
            lbllb4.Caption := 'feet';

            if v.Altitude <> 0 then
             lblAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
            else
             lblAltitude.Caption := '0';
          end;
        end
        else
          lblAltitude.Caption    := '---';
//      end;

      if det.DetailedDetectionShowed.Track_ID then
        lblTrackHook.Caption := FormatTrackNumber(det.trackNumber)
      else
        lblTrackHook.Caption   := 'Unknown';
    end
    else
    begin
      lblNameHook.Caption := 'Unknown';
      lblClassHook.Caption := 'Unknown';
    end;

    lblFormation.Caption     := '---';
    if Assigned(v) then
    begin
      lblDamage.Caption        := IntToStr(100 - Round(v.HealthPercent)) + '%';
    end;
    {$ENDREGION}
  end
  else
  begin
    if Assigned(v) then
    begin
      if v is TT3NonRealVehicle then
        lblTrackHook.Caption := IntToStr(v.TrackNumber)
      else
        lblTrackHook.Caption := v.Track_ID;

      lblNameHook.Caption := v.InstanceName;

      if v is TT3Vehicle then
        lblClassHook.Caption := TVehicle_Definition(v.UnitDefinition).FData.Vehicle_Identifier;

      if v is TT3Missile then
        lblClassHook.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then
        lblClassHook.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lblClassHook.Caption := 'Chaff';

      if v is TT3AirBubble then lblClassHook.Caption := 'Air Bubble';

      if v is TT3Decoy then lblClassHook.Caption := 'Decoy';

      if v is TT3Sonobuoy then lblClassHook.Caption := 'Sonobuoy';

      if v is TT3Mine then lblClassHook.Caption := 'Mine';

      if (v.PlatformDomain = vhdSubsurface) then
      begin
        txtlb5.Caption := 'Depth';
        lbllb4.Caption := 'meter';

        if v.Altitude <> 0 then
          lblAltitude.Caption    := FormatAltitude(v.Altitude)
        else
          lblAltitude.Caption := '0';
      end
      else
      begin
        txtlb5.Caption := 'Altitude';
        lbllb4.Caption := 'feet';

        if v.Altitude <> 0 then
         lblAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
        else
         lblAltitude.Caption := '0';
      end;

      lblCourseHook.Caption    := FormatCourse(v.Course);
      lblGround.Caption        := FormatSpeed(v.Speed);
      lblFormation.Caption     := '---';

      lblDamage.Caption        := IntToStr(100 - Round(v.HealthPercent)) + '%';
    end;
  end;

  {$REGION ' Setting tampilan position sesuai option '}

  long := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Long;
  lat := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Lat;
  txt50.Caption := 'Position';

  idCoordinat := fSettingCoordinate.IdCoordinat;

  case idCoordinat of
    1:
    begin
      if Assigned(v) then
      begin
        lblPositionHook1.Caption := formatDMS_long(v.getPositionX);
        lblPositionHook2.Caption := formatDMS_latt(v.getPositionY);
      end;
    end;
    2:
    begin
      pX := CalcMove(v.getPositionX, long);
      pY := CalcMove(v.getPositionY, lat);

      if (pX >= 0) and (pY >=0) then
      begin
        lblPositionHook1.Caption := 'White ' + FormatFloat('0.00', Abs(pX));  //kuadran 1
      end;
      if (pX <= 0) and (pY >=0) then
      begin
        lblPositionHook1.Caption := 'Red ' + FormatFloat('0.00', Abs(pX));   //kuadran 2
      end;
      if (pX < 0) and (pY < 0) then
      begin
        lblPositionHook1.Caption := 'Green ' + FormatFloat('0.00', Abs(pX)); //kuadran 3
      end;
      if (pX >= 0) and (pY <= 0) then
      begin
        lblPositionHook1.Caption := 'Blue ' + FormatFloat('0.00', Abs(pX));  //kuadran 4
      end;

      lblPositionHook2.Caption := FormatFloat('0.00', Abs(pY));
    end;
    3:
    begin
      if Assigned(v) then
      begin
        lblPositionHook1.Caption := ConvDegree_To_Georef(v.getPositionX, v.getPositionY);
      end;
    end;
    4:
    begin
      begin
        ConvDegree_To_UTM_and_MGRS(lat, long, hasilUTM, hasilMGRS);
        lblPositionHook1.Caption := hasilUTM ;   //dng
        lblPositionHook2.Caption := '';
      end;
    end;
    5:
    begin
        ConvDegree_To_UTM_and_MGRS(lat, long, hasilUTM, hasilMGRS);
        lblPositionHook1.Caption := hasilMGRS ;   //dng
        lblPositionHook2.Caption := '';
    end;
    6:
    begin
      if Assigned(v) then
      begin
        VSimMap.GetValLayerKarvak(v.getPositionX, v.getPositionY, largeLtr, smallLtr, horizontalNumb, verticalNumb);
        ConvDegree_To_Karvak(v.getPositionX, v.getPositionY, horzPoint, vertPoint);
        lblPositionHook1.Caption :=  largeLtr+horizontalNumb + horzPoint + verticalNumb + vertPoint;
        lblPositionHook2.Caption := '';
      end;
    end;
  end;
  {$ENDREGION}

  lblBearingHook.Caption   := FormatCourse(b); ;
  lblRangeHook.Caption     := FormatFloat('000.00', d);
end;

procedure TfrmRightNav.AddStatus(command: String);
begin
    frmTacticalDisplay.addStatus(Command);

  if Assigned(frmRightNav) then
    frmRightNav.addStatus1(Command);
end;

procedure TfrmRightNav.addStatus1(status: String);
begin
  pnlStatusRed.Caption := status;
  pnlStatusRed.Visible := True;

  tmrWarning.Enabled := True;
end;

procedure TfrmRightNav.DisplayTabDetail(Sender: TObject);
var
  v: TT3PlatformInstance;
  det: TT3DetectedTrack;
  dName, dClass: string;
  esm: TT3ESMTrack;
begin
  v := nil;
  det := nil;

  if Assigned(Sender) then
  begin
    if Sender is TT3PlatformInstance then
      v := TT3PlatformInstance(Sender)
    else
    if Sender is TT3DetectedTrack then
    begin
      {$REGION ' Detected Track '}
      det := TT3DetectedTrack(Sender);

      if Assigned(det.MergedESM) then
      begin
        lblMergeStatus.Caption := 'Merged';
        lblTrackDetails.Caption := (det.MergedESM.TrackNumber);
        lblNameDetails.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lblClassDetails.Caption := TT3Radar(det.MergedESM.TrackObject).RadarDefinition.FDef.Radar_Emitter;
        lblTypeDetails.Caption := 'Other';
        lblDoppler.Caption := '[None]';
        lblTrackType.Caption := 'Real Time Bearing Track';
        {Navigasi}

        if TT3ESMTrack(Sender).IsMerged then
          lblMergeStatus.Caption := 'Merged'
        else
          lblMergeStatus.Caption := 'Not Merged';

        Exit;
      end
      else
        lblMergeStatus.Caption := 'Not Merged';

      v := TT3PlatformInstance(det.TrackObject);
      {$ENDREGION}
    end
    else if Sender is TT3ESMTrack then
    begin
      {$REGION ' ESM Track '}
      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lblTrackDetails.Caption      := esm.TrackNumber
      else
        lblTrackDetails.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lblNameDetails.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lblNameDetails.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lblClassDetails.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lblClassDetails.Caption      := 'Unknown';

      lblIdentifier.Caption  := getIdentStr(esm.TrackIdent);
      lblDomain.Caption      := getDomain(esm.TrackDomain);
      lblTypeDetails.Caption := 'Other';
      lblDoppler.Caption     := '[None]';
      lblTrackType.Caption   := 'Real Time Bearing Track';

      if esm.IsMerged then
        lblMergeStatus.Caption := 'Merged'
      else
        lblMergeStatus.Caption := 'Not Merged';

      Exit;

      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      GetNameAndClass(det, dName, dClass);

      lblTrackDetails.Caption := FormatTrackNumber(det.trackNumber);
      lblNameDetails.Caption  := det.TrackName;
      lblClassDetails.Caption := det.TrackClass;
      lblTypeDetails.Caption := 'Unknown';

      {$REGION ' Kodingan Lama '}
      if det.IsDetailViewed then
      begin
//        if det.DetailedDetectionShowed.Track_ID then
//          lbTrackDetails.Caption := FormatTrackNumber(det.trackNumber)
//        else
//          lbTrackDetails.Caption   := 'Unknown';
//
//        if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
//        begin
//          lbNameDetails.Caption      := v.InstanceName;
//        end
//        else
//        begin
//          lbNameDetails.Caption      := 'Unknown';
//        end;
//
//        if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
//        begin
//          lbClassDetails.Caption     := v.InstanceClass;
//        end
//        else
//        begin
//          lbClassDetails.Caption     := 'Unknown';
//        end;
//
//        if det.DetailedDetectionShowed.Plat_Type_Recog_Capability then
////          lbTypeDetails.Caption := getVehicleTypestr(det.TrackDomain, det.track, det.TrackType)  //no category on det track, ask mas Hambali
//            lbTypeDetails.Caption := 'Unknown'
//        else
//          lbTypeDetails.Caption := 'Unknown';

      end;
      {$ENDREGION}

      lblIdentifier.Caption  := getIdentStr(det.TrackIdent);
      lblDomain.Caption      := getDomain(det.TrackDomain);
      lblTrackType.Caption   := 'Real Time Point Track';
      {$ENDREGION}
    end
    else
    begin
      {$REGION ' Jk yg di hook selain detected track  '}
      if v is TT3NonRealVehicle then
      begin
        lblTrackDetails.Caption := IntToStr(v.TrackNumber);
        lblTypeDetails.Caption  := 'Other';
        lblIdentifier.Caption    := getIdentStr(v.TrackIdent);
        lblDomain.Caption        := getDomain(v.TrackDomain);
        lblTrackType.Caption     := getNRTrackTypeStr(TT3NonRealVehicle(v).NRPType);
      end
      else
      begin
        lblTrackDetails.Caption := v.Track_ID;
        lblTypeDetails.Caption := getVehicleTypestr(v.PlatformDomain, v.PlatformCategory, v.PlatformType);

        case v.Force_Designation of
          1 : lblIdentifier.Caption := 'Red Force';
          2 : lblIdentifier.Caption := 'Yellow Force';
          3 : lblIdentifier.Caption := 'Blue Force';
          4 : lblIdentifier.Caption := 'Green Force';
          5 : lblIdentifier.Caption := 'White Force';
          6 : lblIdentifier.Caption := 'Black Force';
        else
          lblIdentifier.Caption := 'White Force';
        end;

        lblDomain.Caption    := getDomain(v.PlatformDomain);
        lblTrackType.Caption := 'Real Time Point Track';
      end;

      lblNameDetails.Caption   := v.InstanceName;
      lblClassDetails.Caption  := v.InstanceClass;

      if v is TT3Missile then lblClassDetails.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then lblClassDetails.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lblClassDetails.Caption := 'Chaff';

      if v is TT3AirBubble then lblClassDetails.Caption := 'Air Bubble';

      if v is TT3Decoy then lblClassDetails.Caption := 'Decoy';

      if v is TT3Sonobuoy then lblClassDetails.Caption := 'Sonobuoy';

      if v is TT3Mine then lblClassDetails.Caption := 'Mine';
      {$ENDREGION}
    end;
  end;
end;

procedure TfrmRightNav.DisplayTabDetection(Sender: TObject);
var
  v: TT3PlatformInstance;
  dName, dClass: string;
  det: TT3DetectedTrack;
  //dev : TSimObject;
  esm: TT3ESMTrack;
begin
  v := nil;
  det := nil;

  if Assigned(Sender) then
  begin
    if Sender is TT3PlatformInstance then
      v := TT3PlatformInstance(Sender);

    if Sender is TT3DetectedTrack then
    begin
      {$REGION ' Detected Track '}
      det := TT3DetectedTrack(Sender);

      if Assigned(det.MergedESM) then
      begin
        lblTrackDetection.Caption := (det.MergedESM.TrackNumber);
        lblNameDetection.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lblClassDetection.Caption := TT3Radar(det.MergedESM.TrackObject).RadarDefinition.FDef.Radar_Emitter;
        lblFirstDetected.Caption := FormatDateTime('ddhhnn', det.MergedESM.FirstDetected)+ 'Z ' + FormatDateTime(' mmm yyyy', det.MergedESM.FirstDetected);
        lblLastDetected.Caption := FormatDateTime('ddhhnn', det.MergedESM.LastDetected)+ 'Z ' + FormatDateTime(' mmm yyyy', det.MergedESM.LastDetected);
        lblDetectionDetectionType.Caption := 'Merged Track';
        Exit;
      end;

      v := TT3PlatformInstance(det.TrackObject);
      {$ENDREGION}
    end
    else if Sender is TT3ESMTrack then
    begin
      {$REGION ' ESM Track '}
      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lblTrackDetection.Caption      := esm.TrackNumber
      else
        lblTrackDetection.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lblNameDetection.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lblNameDetection.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lblClassDetection.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lblClassDetection.Caption      := 'Unknown';

      lblFirstDetected.Caption := FormatDateTime('ddhhnn', esm.FirstDetected)+ 'Z ' + FormatDateTime(' mmm yyyy', esm.FirstDetected);
      lblLastDetected.Caption := FormatDateTime('ddhhnn', esm.LastDetected)+ 'Z ' + FormatDateTime(' mmm yyyy', esm.LastDetected);
      lblDetectionDetectionType.Caption := 'ESM';

      Exit;
      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      GetNameAndClass(det, dName, dClass);

      lblTrackDetection.Caption := FormatTrackNumber(det.trackNumber);
      lblNameDetection.Caption  := det.TrackName;
      lblClassDetection.Caption := det.TrackClass;

      {$REGION '  Kodingan Lama '}
      if det.IsDetailViewed then
      begin
//        if det.DetailedDetectionShowed.Track_ID then
//          lbTrackDetection.Caption := FormatTrackNumber(det.trackNumber)
//        else
//          lbTrackDetection.Caption  := 'Unknown';
//
//        if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
//        begin
//          lbNameDetection.Caption  := det.TrackName;//v.InstanceName;
//        end
//        else
//        begin
//          lbNameDetection.Caption  := 'Unknown';
//        end;
//
//        if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
//        begin
//          lbClassDetection.Caption := det.TrackClass;//v.InstanceClass;
//        end
//        else
//        begin
//          lbClassDetection.Caption := 'Unknown';
//        end;

//          lbNameDetection.Caption   := TT3DeviceUnit(det.TrackDetectedBy.Items[0]).InstanceName;
//          dev := det.TrackDetectedBy.Items[0];
//          if dev is TT3Visual then
//            lbClassDetection.Caption := 'Visual Sensor'
//          else
//          if dev is TT3Radar then
//            lbClassDetection.Caption := TT3Radar(dev).RadarDefinition.FDef.Radar_Emitter
//          else
//          if dev is TT3Sonar then
//            case (TT3Sonar(dev).SonarCategory) of
//              scHMS : lbClassDetection.Caption     := scsHMS;
//              scVDS : lbClassDetection.Caption     := scsVDS;
//              scTAS : lbClassDetection.Caption     := scsTAS;
//              scDipping : lbClassDetection.Caption := scsDipping;
//              scSonobuoy : lbClassDetection.Caption:= scsSonobuoy;
//            end
//          else
//          if dev is TT3EOSensor then
//            case (TT3EOSensor(dev).EODefinition.FData.Instance_Type) of
//              Byte(eocOptical) : lbClassDetection.Caption     := eocsOptical;
//              Byte(eocLaserSensor) : lbClassDetection.Caption := eocsLaserSensor;
//              Byte(eocInfrared) : lbClassDetection.Caption    := eocsInfrared;
//            end
//          else
//            lbClassDetection.Caption := TT3DeviceUnit(det.TrackDetectedBy.Items[0]).InstanceClass;
      end;
      {$ENDREGION}

      {$ENDREGION}
    end
    else
    begin
      {$REGION ' Jk yg di hook selain detected track  '}
      if v is TT3NonRealVehicle then
        lblTrackDetection.Caption := IntToStr(v.TrackNumber)
      else
        lblTrackDetection.Caption := v.Track_ID;

      lblNameDetection.Caption := v.InstanceName;
      lblClassDetection.Caption := v.InstanceClass;

      if v is TT3Missile then lblClassDetection.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then lblClassDetection.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lblClassDetection.Caption := 'Chaff';

      if v is TT3AirBubble then lblClassDetection.Caption := 'Air Bubble';

      if v is TT3Decoy then lblClassDetection.Caption := 'Decoy';

      if v is TT3Sonobuoy then lblClassDetection.Caption := 'Sonobuoy';

      if v is TT3Mine then lblClassDetection.Caption := 'Mine';

      {$ENDREGION}
    end;
  end;
end;

procedure TfrmRightNav.DisplayTabIFF(Sender: TObject);
var
  v: TT3PlatformInstance;
  det: TT3DetectedTrack;
  SensorDevice: TT3DeviceUnit;
  i: Integer;
  SensorIFF: TT3IFFSensor;
  esm: TT3ESMTrack;
begin
  v := nil;
  det := nil;

  if Assigned(Sender) then   //mk
  begin
    if Sender is TT3PlatformInstance then
      v := TT3PlatformInstance(Sender);

    if Sender is TT3DetectedTrack then
    begin
      {$REGION ' Detected Track '}
      det := TT3DetectedTrack(Sender);
      v := TT3PlatformInstance(det.TrackObject);
      {$ENDREGION}
    end
    else if Sender is TT3ESMTrack then
    begin
      {$REGION ' ESM Track '}
      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lblTrackIff.Caption      := esm.TrackNumber
      else
        lblTrackIff.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lblNameIff.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lblNameIff.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lblClassIff.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lblClassIff.Caption      := 'Unknown';

      exit;
      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      lblTrackIff.Caption := FormatTrackNumber(det.trackNumber);
      lblNameIff.Caption  := det.TrackName;
      lblClassIff.Caption := det.TrackClass;

      {$REGION '  Kodingan Lama '}
//      if det.DetailedDetectionShowed.Track_ID then
//        lbTrackIff.Caption := FormatTrackNumber(det.trackNumber)
//      else
//        lbTrackIff.Caption := 'Unknown';
//
//      if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
//      begin
//        lbNameIff.Caption  := v.InstanceName;
//      end
//      else
//      begin
//        lbNameIff.Caption  := 'Unknown';
//      end;
//
//      if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
//      begin
//        lbClassIff.Caption := v.InstanceClass;
//      end
//      else
//      begin
//        lbClassIff.Caption := 'Unknown';
//      end;
      {$ENDREGION}

      lblMode1Iff.Caption := det.TransMode1Detected;
      lblMode2Iff.Caption := det.TransMode2Detected;
      lblMode3Iff.Caption := det.TransMode3Detected;
      lblMode3CIff.Caption := det.TransMode3CDetected;

      if det.TransMode1Detected = '' then
      lblMode1Iff.Caption := '---';

      if det.TransMode2Detected = '' then
      lblMode2Iff.Caption := '---';

      if det.TransMode3Detected = '' then
      lblMode3Iff.Caption := '---';

      if det.TransMode3CDetected = '' then
      lblMode3CIff.Caption := '---';
      {$ENDREGION}
    end
    else
    begin
      {$REGION ' Jk yg di hook selain detected track  '}
      if v is TT3NonRealVehicle then
      begin
        lblTrackIff.Caption := IntToStr(v.TrackNumber);
      end
      else
      begin
        lblTrackIff.Caption := v.Track_ID;
      end;

      lblNameIff.Caption := v.InstanceName;
      lblClassIff.Caption := v.InstanceClass;

      if v is TT3Missile then
        lblClassIff.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then
        lblClassIff.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lblClassIff.Caption := 'Chaff';

      if v is TT3AirBubble then lblClassIff.Caption := 'Air Bubble';

      if v is TT3Decoy then lblClassIff.Caption := 'Decoy';

      if v is TT3Sonobuoy then lblClassIff.Caption := 'Sonobuoy';

      if v is TT3Mine then lblClassIff.Caption := 'Mine';

//      if v is TT3Vehicle then
//      begin
//        for i := 0 to TT3Vehicle(v).Devices.Count -1 do
//        begin
//          SensorDevice := TT3DeviceUnit(TT3Vehicle(v).Devices.Items[i]);
//
//          if SensorDevice is TT3IFFSensor then
//          begin
//            SensorIFF := TT3IFFSensor(SensorDevice);
//
//            lbMode3CIff.Caption := '---';
//            if SensorIFF.TransponderOperateStatus = sopon then
//              begin
//                if SensorIFF.TransponderMode1Enabled then
//                  lbMode1Iff.Caption := DecToOct(IntToStr(SensorIFF.TransponderMode1))
//                else
//                  lbMode1Iff.Caption := '---';
//                if SensorIFF.TransponderMode2Enabled then
//                  lbMode2Iff.Caption := DecToOct(IntToStr(SensorIFF.TransponderMode2))
//                else
//                  lbMode2Iff.Caption := '---';
//                if SensorIFF.TransponderMode3Enabled then
//                  lbMode3Iff.Caption := DecToOct(IntToStr(SensorIFF.TransponderMode3))
//                else
//                  lbMode3Iff.Caption := '---';
//                end
//            else
//            begin
//              lbMode1Iff.Caption  :='---';
//              lbMode2Iff.Caption  := '---';
//              lbMode3Iff.Caption  := '---';
//              lbMode3CIff.Caption := '---';
//            end;
//          end;
//        end;
//      end;
      {$ENDREGION}
    end;
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1btnWaypointClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmPlatformGuidance1.btnWaypointClick(Sender);
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1edOrderAltitudeKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Assigned(Sender)then
  begin
    fmPlatformGuidance1.edOrderAltitudeKeyPress(Sender, Key);
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1edtStraightLineOrderedGroundSpeedKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Assigned(Sender)then
  begin
    fmPlatformGuidance1.edtStraightLineOrderedGroundSpeedKeyPress(Sender, Key);
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1edtStraightLineOrderedHeadingKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Assigned(Sender)then
  begin
    fmPlatformGuidance1.edtStraightLineOrderedHeadingKeyPress(Sender, Key);
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1SpeedButton2Click(aTrack: TSimObject; Sender: TObject);
begin
  if Assigned(Sender) then
  begin
    if Assigned(aTrack) then
    begin
      if aTrack is TT3DetectedTrack then
      begin
        if Assigned(TT3DetectedTrack(aTrack).TrackObject) and
           (TT3DetectedTrack(aTrack).TrackObject is TT3PlatformInstance) then
        begin
          fmPlatformGuidance1.SetFocusedPlatform(TT3PlatformInstance(TT3DetectedTrack(aTrack).TrackObject));
        end;
      end

      else if aTrack is TT3PlatformInstance then
      begin
        fmPlatformGuidance1.SetFocusedPlatform(TT3PlatformInstance(aTrack));
//        pnlNone.Visible := False;
      end;

      fmPlatformGuidance1.PanelPlatformGuidance.Enabled := True;
    end
    else
    begin
      fmPlatformGuidance1.SetFocusedPlatform(nil);
      fmPlatformGuidance1.PanelPlatformGuidance.Enabled := False;
    end;
  end;
end;

procedure TfrmRightNav.fmPlatformGuidance1whHeadingChange(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmPlatformGuidance1.whHeadingChange(Sender);
  end;
end;

procedure TfrmRightNav.fmSensor1sbIFFTransponderControlModeOnClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmSensor1.btnIFFOnClick(Sender);
  end;
end;

procedure TfrmRightNav.FormCreate(Sender: TObject);
begin
  fmPlatformGuidance1.InitCreate(self);
  fmSensor1.InitCreate(self);
end;

procedure TfrmRightNav.FormDestroy(Sender: TObject);
begin
//  ClearAndFreeItems(statusR_List);
end;

procedure TfrmRightNav.FormShow(Sender: TObject);
begin
  if focusedTrack <> nil then
    TT3PlatformInstance(focusedTrack).Selected := True;
end;

procedure TfrmRightNav.GetNameAndClass(const obj: TSimObject; var n, c: string);
var
  det: TT3DetectedTrack;
  fd: byte;
  v: TT3Vehicle;
begin
  if not Assigned(obj) then   //mk
    Exit;

  det := TT3DetectedTrack(obj);
  if not simMgrClient.ISInstructor or not simMgrClient.ISWasdal then
  begin
    fd := simMgrClient.FMyCubGroup.FData.Force_Designation;

    if det.TrackObject is TT3PlatformInstance then
    begin
      if det.TrackObject is TT3Vehicle then
      begin
        v := det.TrackObject as TT3Vehicle;
        if fd = TT3PlatformInstance(det.TrackObject).Force_Designation then
        begin
          n := v.InstanceName;
          c := TVehicle_Definition(v.UnitDefinition).FData.Vehicle_Identifier;
        end
        else
        begin
          n := 'Unknown';
          c := 'Unknown';
        end;
      end
      else
      begin
        if fd = TT3PlatformInstance(det.TrackObject).Force_Designation then
        begin
          n := TT3PlatformInstance(det.TrackObject).InstanceName;
          c := TT3PlatformInstance(det.TrackObject).InstanceClass;
        end
        else
        begin
          n := 'Unknown';
          c := 'Unknown';
        end;
      end;
    end;
  end;
end;

procedure TfrmRightNav.InitCreate(sender: TForm);
begin
  fmPlatformGuidance1.InitCreate(self);
end;

procedure TfrmRightNav.InitTabHookedInfo;
begin
  //Hook
  lblTrackHook.Caption := 'Unknown';
  lblNameHook.Caption := 'Unknown';
  lblClassHook.Caption := 'Unknown';
  lblPositionHook1.Caption := '---';
  lblPositionHook2.Caption := '---';
  lblCourseHook.Caption := '---';
  lblGround.Caption := '---';
  lblAltitude.Caption := '---';
//  lbDepth.Caption := '---';
  lblBearingHook.Caption := '---';
  lblRangeHook.Caption := '---';

//  // Details
//  lbTrackDetails.Caption := 'Unknown';
//  lbNameDetails.Caption  := 'Unknown';
//  lbClassDetails.Caption := 'Unknown';
//  lbTypeDetails.Caption  := 'Unknown';
//  lbDomain.Caption       := 'Unknown';
//  lbIdentifier.Caption   := 'Unknown';
//
//  // Detection
//  lbTrackDetection.Caption := 'Unknown';
//  lbNameDetection.Caption  := 'Unknown';
//  lbClassDetection.Caption := 'Unknown';
//
//  // IFF
//  lbTrackIff.Caption := 'Unknown';
//  lbNameIff.Caption  := 'Unknown';
//  lbClassIff.Caption := 'Unknown';
end;

procedure TfrmRightNav.pnlStatusRedClick(Sender: TObject);
var
  CmdStatus : TStatus;
begin
  pnlStatusRed.Caption := '';
  pnlStatusRed.Visible := False;
  frmToteDisplay.pnlSMS.BringToFront;
end;

procedure TfrmRightNav.Refresh_Controller(aIsGuidanceOpen: Boolean; aIsWasdal: Boolean);

begin

end;

procedure TfrmRightNav.SetControlledObject(pit: TT3PlatformInstance);
begin

end;

end.
