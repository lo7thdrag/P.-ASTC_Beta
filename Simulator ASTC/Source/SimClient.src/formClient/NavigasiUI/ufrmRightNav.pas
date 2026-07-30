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
    pnlShipController: TPanel;
    Image2: TImage;
    Label10: TLabel;
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
    pnlPlatformGuidance: TPanel;
    fmPlatformGuidance1: TfmPlatformGuidance;
    pnlGameStatus: TPanel;
    lbl1: TLabel;
    pnlGameState: TPanel;
    pnlSensor: TPanel;
    fmSensor1: TfmSensor;
    imgMainBackgorund: TImage;
    pnlSparator2: TPanel;
    Image4: TImage;
    Label21: TLabel;
    Image1: TImage;
    Image3: TImage;
    procedure THButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fmPlatformGuidance1SpeedButton2Click(aTrack: TSimObject; Sender: TObject);
    procedure fmPlatformGuidance1whHeadingChange(Sender: TObject);
    procedure fmPlatformGuidance1edtStraightLineOrderedHeadingKeyPress(
      Sender: TObject; var Key: Char);
    procedure fmPlatformGuidance1edtStraightLineOrderedGroundSpeedKeyPress(
      Sender: TObject; var Key: Char);
    procedure fmPlatformGuidance1edOrderAltitudeKeyPress(Sender: TObject;
      var Key: Char);
    procedure pnlGameStateClick(Sender: TObject);
    procedure pnlStatusRedClick(Sender: TObject);
    procedure pnlStatusYellowClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fmPlatformGuidance1btnWaypointClick(Sender: TObject);
  protected
    FControlled: TObject;

  private
    { Private declarations }
  public
  focusedTrack: TSimObject;
  statusR_List,statusY_List : TList;

    procedure updateStatus;
    procedure updateStatus_Yellow;
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

procedure TfrmRightNav.UpdateFormData;
begin
  {Update Guidance}
  fmPlatformGuidance1.Refresh_VisibleTab();

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

  if pnlTabDetails.Tag = 1 then
    DisplayTabDetail(Sender);

  if pnlTabDetection.Tag = 1 then
    DisplayTabDetection(Sender);

  if pnlTabIFF.Tag = 1 then
    DisplayTabIFF(Sender);
end;

procedure TfrmRightNav.updateStatus;
begin
//  if statusR_List.Count > 0 then
//  begin
////    pnlStatusRed.Visible := true;
////    pnlStatusYellow.Visible := true;
////    pnlStatusRed.Caption := TStatus(statusR_List[statusR_List.Count-1]).state;
//  end
//  else
//  begin
////    pnlStatusRed.Visible  := false;
////    if statusY_List.Count <= 0 then
////    pnlStatusYellow.Visible := false
//  end;
end;

procedure TfrmRightNav.updateStatus_Yellow;
begin
//  if statusY_List.Count > 0 then
//  begin
//    pnlStatusYellow.Visible := true;
//    pnlStatusYellow.Caption := TStatus(statusY_List[statusY_List.Count-1]).state;
//  end
//  else
//    pnlStatusYellow.Visible := false;
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
  idCoordinat := fSettingCoordinate.IdCoordinat;

  if Assigned(sender) then     //mk
  begin
    if Sender is TT3PlatformInstance then
      v := TT3PlatformInstance(Sender)
    else
    if Sender is TT3DetectedTrack then
    begin
      det := TT3DetectedTrack(Sender);

      if Assigned(det.MergedESM) then
      begin
        lbTrackHook.Caption:= (det.MergedESM.TrackNumber);
        lbNameHook.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lbClassHook.Caption:= TT3Radar(det.MergedESM.TrackObject).
                               RadarDefinition.FDef.Radar_Emitter;
        lbBearingHook.Caption := FormatFloat('000.0', det.MergedESM.Bearing);

        StaticText6.Caption := 'Origin';
        lbPositionHook1.Caption := formatDMS_long(det.MergedESM.DetectBy.PosX);
        lbPositionHook2.Caption := formatDMS_latt(det.MergedESM.DetectBy.PosY);

        Exit;
      end;

      v := TT3PlatformInstance(det.TrackObject);
    end
    else if Sender is TT3ESMTrack then
    begin
      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lbTrackHook.Caption      := esm.TrackNumber
      else
        lbTrackHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lbNameHook.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lbNameHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lbClassHook.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lbClassHook.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Bearing_Data_Capability then
        lbBearingHook.Caption      := FormatFloat('000.0', esm.Bearing)
      else
        lbBearingHook.Caption      := '---';

      StaticText6.Caption := 'Origin';
      lbPositionHook1.Caption := formatDMS_long(TT3ESMTrack(sender).DetectBy.PosX);
      lbPositionHook2.Caption := formatDMS_latt(TT3ESMTrack(sender).DetectBy.PosY);

      Exit;
    end;
  end;

  b := 0;
  d := 0;

  if v <> nil then
  begin
    if simMgrClient.ControlledPlatform <> nil then
    begin
      ct := TT3PlatformInstance(simMgrClient.ControlledPlatform);
      b := CalcBearing(ct.getPositionX, ct.getPositionY, v.getPositionX,
           v.getPositionY);
      d := CalcRange(ct.getPositionX, ct.getPositionY, v.getPositionX,
           v.getPositionY);
    end;
  end;

  if det <> nil then
  begin
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
      lb5.Caption := 'Depth';
      lb4.Caption := 'meter';

      if v.Altitude <> 0 then
        lbAltitude.Caption    := FormatAltitude(v.Altitude)
      else
        lbAltitude.Caption := '0'; // 05/ 04/ 2012
    end
    else
    begin
      lb5.Caption := 'Altitude';
      lb4.Caption := 'feet';

      if v.Altitude <> 0 then
       lbAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
      else
       lbAltitude.Caption := '0'; // 05/ 04/ 2012
    end;

    if Assigned(v) then
    begin
//      if det.IsDetailViewed then
//      begin
        if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
        begin
//          lbNameHook.Caption      := v.InstanceName;
          lbNameHook.Caption      := det.TrackName;
        end
        else
        begin
//          lbNameHook.Caption      := 'Unknown';
          lbNameHook.Caption      := det.TrackName;
        end;

        if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
        begin
//          lbClassHook.Caption     := v.InstanceClass;
          lbClassHook.Caption      := det.TrackClass;
        end
        else
        begin
//          lbClassHook.Caption     := 'Unknown';
          lbClassHook.Caption      := det.TrackClass;
        end;

        if det.DetailedDetectionShowed.Heading_Data_Capability then
          lbCourseHook.Caption    := FormatCourse(v.Course)
        else
          lbCourseHook.Caption    := '---';

        if det.DetailedDetectionShowed.Ground_Speed_Data_Capability then
          lbGround.Caption        := FormatSpeed(v.Speed)
        else
          lbGround.Caption        := '---';

        if det.DetailedDetectionShowed.Altitude_Data_Capability then
        begin
          if (det.TrackDomain = vhdSubsurface) then
          begin
            lb5.Caption := 'Depth';
            lb4.Caption := 'meter';

            if v.Altitude <> 0 then
              lbAltitude.Caption    := FormatAltitude(v.Altitude)
            else
              lbAltitude.Caption := '0';
          end
          else
          begin
            lb5.Caption := 'Altitude';
            lb4.Caption := 'feet';

            if v.Altitude <> 0 then
             lbAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
            else
             lbAltitude.Caption := '0';
          end;
        end
        else
          lbAltitude.Caption    := '---';
//      end;

      if det.DetailedDetectionShowed.Track_ID then
        lbTrackHook.Caption := FormatTrackNumber(det.trackNumber)
      else
        lbTrackHook.Caption   := 'Unknown';
    end
    else
    begin
      lbNameHook.Caption := 'Unknown';
      lbClassHook.Caption := 'Unknown';
    end;

    lbFormation.Caption     := '---';
    if Assigned(v) then
    begin
      lbDamage.Caption        := IntToStr(100 - Round(v.HealthPercent)) + '%';
    end;
  end
  else
  begin
    if Assigned(v) then
    begin
      if v is TT3NonRealVehicle then
        lbTrackHook.Caption := IntToStr(v.TrackNumber)
      else
        lbTrackHook.Caption := v.Track_ID;

      lbNameHook.Caption := v.InstanceName;

      if v is TT3Vehicle then
        lbClassHook.Caption := TVehicle_Definition(v.UnitDefinition)
          .FData.Vehicle_Identifier;

      if v is TT3Missile then
        lbClassHook.Caption := TMissile_On_Board(v.UnitDefinition)
          .FDef.Class_Identifier;

      if v is TT3Torpedo then
        lbClassHook.Caption := TTorpedo_On_Board(v.UnitDefinition)
          .FDef.Class_Identifier;

      if v is TT3Chaff then lbClassHook.Caption := 'Chaff';

      if v is TT3AirBubble then lbClassHook.Caption := 'Air Bubble';

      if v is TT3Decoy then lbClassHook.Caption := 'Decoy';

      if v is TT3Sonobuoy then lbClassHook.Caption := 'Sonobuoy';

      if v is TT3Mine then lbClassHook.Caption := 'Mine';

      if (v.PlatformDomain = vhdSubsurface) then
      begin
        lb5.Caption := 'Depth';
        lb4.Caption := 'meter';

        if v.Altitude <> 0 then
          lbAltitude.Caption    := FormatAltitude(v.Altitude)
        else
          lbAltitude.Caption := '0'; // 05/ 04/ 2012
      end
      else
      begin
        lb5.Caption := 'Altitude';
        lb4.Caption := 'feet';

        if v.Altitude <> 0 then
         lbAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
        else
         lbAltitude.Caption := '0'; // 05/ 04/ 2012
      end;

      lbCourseHook.Caption    := FormatCourse(v.Course);
      lbGround.Caption        := FormatSpeed(v.Speed);
      lbFormation.Caption     := '---';

      lbDamage.Caption        := IntToStr(100 - Round(v.HealthPercent)) + '%';
    end;
  end;

  long := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Long;
  lat := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Lat;
  StaticText6.Caption := 'Position';

  case idCoordinat of
    1:
    begin
      if Assigned(v) then
      begin
        lbPositionHook1.Caption := formatDMS_long(v.getPositionX);
        lbPositionHook2.Caption := formatDMS_latt(v.getPositionY);
      end;
    end;
    2:
    begin
      pX := CalcMove(v.getPositionX, long);
      pY := CalcMove(v.getPositionY, lat);

      if (pX >= 0) and (pY >=0) then
      begin
        lbPositionHook1.Caption := 'White ' + FormatFloat('0.00', Abs(pX));  //kuadran 1
      end;
      if (pX <= 0) and (pY >=0) then
      begin
        lbPositionHook1.Caption := 'Red ' + FormatFloat('0.00', Abs(pX));   //kuadran 2
      end;
      if (pX < 0) and (pY < 0) then
      begin
        lbPositionHook1.Caption := 'Green ' + FormatFloat('0.00', Abs(pX)); //kuadran 3
      end;
      if (pX >= 0) and (pY <= 0) then
      begin
        lbPositionHook1.Caption := 'Blue ' + FormatFloat('0.00', Abs(pX));  //kuadran 4
      end;

      lbPositionHook2.Caption := FormatFloat('0.00', Abs(pY));
    end;
    3:
    begin
      if Assigned(v) then
      begin
        lbPositionHook1.Caption := ConvDegree_To_Georef(v.getPositionX, v.getPositionY);
      end;
    end;
    4:
    begin
      begin
        ConvDegree_To_UTM_and_MGRS(lat, long, hasilUTM, hasilMGRS);
        lbPositionHook1.Caption := hasilUTM ;   //dng
        lbPositionHook2.Caption := '';
      end;
    end;
    5:
    begin
        ConvDegree_To_UTM_and_MGRS(lat, long, hasilUTM, hasilMGRS);
        lbPositionHook1.Caption := hasilMGRS ;   //dng
        lbPositionHook2.Caption := '';
    end;
    6:
    begin
      if Assigned(v) then
      begin
        VSimMap.GetValLayerKarvak(v.getPositionX, v.getPositionY, largeLtr, smallLtr, horizontalNumb, verticalNumb);
        ConvDegree_To_Karvak(v.getPositionX, v.getPositionY, horzPoint, vertPoint);
        lbPositionHook1.Caption :=  largeLtr+horizontalNumb + horzPoint + verticalNumb + vertPoint;
        lbPositionHook2.Caption := '';
      end;
    end;
  end;

  lbBearingHook.Caption   := FormatCourse(b); ;
  lbRangeHook.Caption     := FormatFloat('000.00', d);
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
        lbMergeStatus.Caption := 'Merged';
        lbTrackDetails.Caption := (det.MergedESM.TrackNumber);
        lbNameDetails.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lbClassDetails.Caption := TT3Radar(det.MergedESM.TrackObject).RadarDefinition.FDef.Radar_Emitter;
        lbTypeDetails.Caption := 'Other';
        lbDoppler.Caption := '[None]';
        lbTrackType.Caption := 'Real Time Bearing Track';
        {Navigasi}

        if TT3ESMTrack(Sender).IsMerged then
          lbMergeStatus.Caption := 'Merged'
        else
          lbMergeStatus.Caption := 'Not Merged';

        Exit;
      end
      else
        lbMergeStatus.Caption := 'Not Merged';

      v := TT3PlatformInstance(det.TrackObject);
      {$ENDREGION}
    end
    else if Sender is TT3ESMTrack then
    begin
      {$REGION ' ESM Track '}
      esm := TT3ESMTrack(Sender);

      if esm.DetailedDetectionShowedESM.Track_ID then
        lbTrackDetails.Caption      := esm.TrackNumber
      else
        lbTrackDetails.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lbNameDetails.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lbNameDetails.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lbClassDetails.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lbClassDetails.Caption      := 'Unknown';

      lbIdentifier.Caption  := getIdentStr(esm.TrackIdent);
      lbDomain.Caption      := getDomain(esm.TrackDomain);
      lbTypeDetails.Caption := 'Other';
      lbDoppler.Caption     := '[None]';
      lbTrackType.Caption   := 'Real Time Bearing Track';

      if esm.IsMerged then
        lbMergeStatus.Caption := 'Merged'
      else
        lbMergeStatus.Caption := 'Not Merged';

      Exit;

      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      GetNameAndClass(det, dName, dClass);

      lbTrackDetails.Caption := FormatTrackNumber(det.trackNumber);
      lbNameDetails.Caption  := det.TrackName;
      lbClassDetails.Caption := det.TrackClass;
      lbTypeDetails.Caption := 'Unknown';

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

      lbIdentifier.Caption  := getIdentStr(det.TrackIdent);
      lbDomain.Caption      := getDomain(det.TrackDomain);
      lbTrackType.Caption   := 'Real Time Point Track';
      {$ENDREGION}
    end
    else
    begin
      {$REGION ' Jk yg di hook selain detected track  '}
      if v is TT3NonRealVehicle then
      begin
        lbTrackDetails.Caption := IntToStr(v.TrackNumber);
        lbTypeDetails.Caption  := 'Other';
        lbIdentifier.Caption    := getIdentStr(v.TrackIdent);
        lbDomain.Caption        := getDomain(v.TrackDomain);
        lbTrackType.Caption     := getNRTrackTypeStr(TT3NonRealVehicle(v).NRPType);
      end
      else
      begin
        lbTrackDetails.Caption := v.Track_ID;
        lbTypeDetails.Caption := getVehicleTypestr(v.PlatformDomain, v.PlatformCategory, v.PlatformType);

        case v.Force_Designation of
          1 : lbIdentifier.Caption := 'Red Force';
          2 : lbIdentifier.Caption := 'Yellow Force';
          3 : lbIdentifier.Caption := 'Blue Force';
          4 : lbIdentifier.Caption := 'Green Force';
          5 : lbIdentifier.Caption := 'White Force';
          6 : lbIdentifier.Caption := 'Black Force';
        else
          lbIdentifier.Caption := 'White Force';
        end;

        lbDomain.Caption    := getDomain(v.PlatformDomain);
        lbTrackType.Caption := 'Real Time Point Track';
      end;

      lbNameDetails.Caption   := v.InstanceName;
      lbClassDetails.Caption  := v.InstanceClass;

      if v is TT3Missile then lbClassDetails.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then lbClassDetails.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lbClassDetails.Caption := 'Chaff';

      if v is TT3AirBubble then lbClassDetails.Caption := 'Air Bubble';

      if v is TT3Decoy then lbClassDetails.Caption := 'Decoy';

      if v is TT3Sonobuoy then lbClassDetails.Caption := 'Sonobuoy';

      if v is TT3Mine then lbClassDetails.Caption := 'Mine';
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
        lbTrackDetection.Caption := (det.MergedESM.TrackNumber);
        lbNameDetection.Caption := TT3PlatformInstance(det.MergedESM.TrackObject).InstanceName;
        lbClassDetection.Caption := TT3Radar(det.MergedESM.TrackObject).RadarDefinition.FDef.Radar_Emitter;
        lbFirstDetected.Caption := FormatDateTime('ddhhnn', det.MergedESM.FirstDetected)
        + 'Z ' + FormatDateTime(' mmm yyyy', det.MergedESM.FirstDetected);
        lbLastDetected.Caption := FormatDateTime('ddhhnn', det.MergedESM.LastDetected)
        + 'Z ' + FormatDateTime(' mmm yyyy', det.MergedESM.LastDetected);
        lbDetectionDetectionType.Caption := 'Merged Track';
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
        lbTrackDetection.Caption      := esm.TrackNumber
      else
        lbTrackDetection.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lbNameDetection.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lbNameDetection.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lbClassDetection.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lbClassDetection.Caption      := 'Unknown';

      lbFirstDetected.Caption := FormatDateTime('ddhhnn', esm.FirstDetected)
            + 'Z ' + FormatDateTime(' mmm yyyy', esm.FirstDetected);
      lbLastDetected.Caption := FormatDateTime('ddhhnn', esm.LastDetected)
            + 'Z ' + FormatDateTime(' mmm yyyy', esm.LastDetected);
      lbDetectionDetectionType.Caption := 'ESM';

      Exit;
      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      GetNameAndClass(det, dName, dClass);

      lbTrackDetection.Caption := FormatTrackNumber(det.trackNumber);
      lbNameDetection.Caption  := det.TrackName;
      lbClassDetection.Caption := det.TrackClass;

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
        lbTrackDetection.Caption := IntToStr(v.TrackNumber)
      else
        lbTrackDetection.Caption := v.Track_ID;

      lbNameDetection.Caption := v.InstanceName;
      lbClassDetection.Caption := v.InstanceClass;

      if v is TT3Missile then lbClassDetection.Caption := TMissile_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Torpedo then lbClassDetection.Caption := TTorpedo_On_Board(v.UnitDefinition).FDef.Class_Identifier;

      if v is TT3Chaff then lbClassDetection.Caption := 'Chaff';

      if v is TT3AirBubble then lbClassDetection.Caption := 'Air Bubble';

      if v is TT3Decoy then lbClassDetection.Caption := 'Decoy';

      if v is TT3Sonobuoy then lbClassDetection.Caption := 'Sonobuoy';

      if v is TT3Mine then lbClassDetection.Caption := 'Mine';

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
        lbTrackIff.Caption      := esm.TrackNumber
      else
        lbTrackIff.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Name_Data_Capability then
        lbNameIff.Caption      := TT3PlatformInstance(esm.TrackObject).InstanceName
      else
        lbNameIff.Caption      := 'Unknown';

      if esm.DetailedDetectionShowedESM.Class_Data_Capability then
        lbClassIff.Caption      := TT3Radar(esm.TrackObject).RadarDefinition.FDef.Radar_Emitter
      else
        lbClassIff.Caption      := 'Unknown';

      exit;
      {$ENDREGION}
    end;

    if v = nil then
      exit;

    if det <> nil then
    begin
      {$REGION ' Jk yg di hook detected track '}
      lbTrackIff.Caption := FormatTrackNumber(det.trackNumber);
      lbNameIff.Caption  := det.TrackName;
      lbClassIff.Caption := det.TrackClass;

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

      lbMode1Iff.Caption := det.TransMode1Detected;
      lbMode2Iff.Caption := det.TransMode2Detected;
      lbMode3Iff.Caption := det.TransMode3Detected;
      lbMode3CIff.Caption := det.TransMode3CDetected;

      if det.TransMode1Detected = '' then
      lbMode1Iff.Caption := '---';

      if det.TransMode2Detected = '' then
      lbMode2Iff.Caption := '---';

      if det.TransMode3Detected = '' then
      lbMode3Iff.Caption := '---';

      if det.TransMode3CDetected = '' then
      lbMode3CIff.Caption := '---';
      {$ENDREGION}
    end
    else
    begin
      {$REGION ' Jk yg di hook selain detected track  '}
      if v is TT3NonRealVehicle then
      begin
        lbTrackIff.Caption := IntToStr(v.TrackNumber);
      end
      else
      begin
        lbTrackIff.Caption := v.Track_ID;
      end;

      lbNameIff.Caption := v.InstanceName;
      lbClassIff.Caption := v.InstanceClass;

      if v is TT3Missile then
        lbClassIff.Caption := TMissile_On_Board(v.UnitDefinition)
          .FDef.Class_Identifier;

      if v is TT3Torpedo then
        lbClassIff.Caption := TTorpedo_On_Board(v.UnitDefinition)
          .FDef.Class_Identifier;

      if v is TT3Chaff then lbClassIff.Caption := 'Chaff';

      if v is TT3AirBubble then lbClassIff.Caption := 'Air Bubble';

      if v is TT3Decoy then lbClassIff.Caption := 'Decoy';

      if v is TT3Sonobuoy then lbClassIff.Caption := 'Sonobuoy';

      if v is TT3Mine then lbClassIff.Caption := 'Mine';

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

procedure TfrmRightNav.FormCreate(Sender: TObject);
begin
  statusR_List := TList.Create;
  fmPlatformGuidance1.InitCreate(self);
end;

procedure TfrmRightNav.FormDestroy(Sender: TObject);
begin
  ClearAndFreeItems(statusR_List);
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
  lbTrackHook.Caption := 'Unknown';
  lbNameHook.Caption := 'Unknown';
  lbClassHook.Caption := 'Unknown';
  lbPositionHook1.Caption := '---';
  lbPositionHook2.Caption := '---';
  lbCourseHook.Caption := '---';
  lbGround.Caption := '---';
  lbAltitude.Caption := '---';
//  lbDepth.Caption := '---';
  lbBearingHook.Caption := '---';
  lbRangeHook.Caption := '---';

  // Details
  lbTrackDetails.Caption := 'Unknown';
  lbNameDetails.Caption  := 'Unknown';
  lbClassDetails.Caption := 'Unknown';
  lbTypeDetails.Caption  := 'Unknown';
  lbDomain.Caption       := 'Unknown';
  lbIdentifier.Caption   := 'Unknown';

  // Detection
  lbTrackDetection.Caption := 'Unknown';
  lbNameDetection.Caption  := 'Unknown';
  lbClassDetection.Caption := 'Unknown';

  // IFF
  lbTrackIff.Caption := 'Unknown';
  lbNameIff.Caption  := 'Unknown';
  lbClassIff.Caption := 'Unknown';
end;

procedure TfrmRightNav.pnlGameStateClick(Sender: TObject);
var
  CmdStatus : TStatus;
begin
  if statusR_List.Count > 0 then
  begin
    CmdStatus := TStatus(statusR_List.Items[statusR_List.Count-1]);
    if LowerCase(CmdStatus.state) = 'receive message' then
    begin
      frmToteDisplay.gbMessageHandlingSystem.BringToFront;
      frmToteDisplay.pnlTabReceived.Color := RGB(44, 127, 161);
      frmToteDisplay.pnlContentReceived.BringToFront;
      frmToteDisplay.pnlTabReceived.Tag := 1;
      frmToteDisplay.pnlTabDraft.Tag := 0;
      frmToteDisplay.pnlTabDraft.Color := RGB(29, 81, 103);
      frmToteDisplay.pnlTabSent.Tag := 0;
      frmToteDisplay.pnlTabSent.Color := RGB(29, 81, 103);

//      frmToteDisplay.pcReceived.ActivePageIndex := 0;
    end;

    statusR_List.Delete(statusR_List.Count-1);
    updateStatus;
  end;
end;

procedure TfrmRightNav.pnlStatusRedClick(Sender: TObject);
var
  CmdStatus : TStatus;
begin
  if statusR_List.Count > 0 then
  begin
    CmdStatus := TStatus(statusR_List.Items[statusR_List.Count-1]);
    if LowerCase(CmdStatus.state) = 'receive message' then
    begin
      frmToteDisplay.gbMessageHandlingSystem.BringToFront;
      frmToteDisplay.pnlTabReceived.Color := RGB(44, 127, 161);
      frmToteDisplay.pnlContentReceived.BringToFront;
      frmToteDisplay.pnlTabReceived.Tag := 1;
      frmToteDisplay.pnlTabDraft.Tag := 0;
      frmToteDisplay.pnlTabDraft.Color := RGB(29, 81, 103);
      frmToteDisplay.pnlTabSent.Tag := 0;
      frmToteDisplay.pnlTabSent.Color := RGB(29, 81, 103);

//      frmToteDisplay.pcReceived.ActivePageIndex := 0;
    end;

    statusR_List.Delete(statusR_List.Count-1);
    updateStatus;
  end;
end;


procedure TfrmRightNav.pnlStatusYellowClick(Sender: TObject);
begin
  if statusY_List.Count > 0 then
  begin
    statusY_List.Delete(statusY_List.Count-1);
    updateStatus_Yellow;
  end;
end;

procedure TfrmRightNav.Refresh_Controller(aIsGuidanceOpen: Boolean; aIsWasdal: Boolean);

begin

end;

procedure TfrmRightNav.SetControlledObject(pit: TT3PlatformInstance);
begin

end;

end.
