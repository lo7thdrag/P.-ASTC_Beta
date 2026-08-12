unit ufrmLeftAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.ComCtrls, ufmControlled, ufmSensor, ufmPlatformGuidance,
  ufmCounterMeasure,

  uT3Unit,uSimObjects;

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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

    focusedTrack: TSimObject;
    procedure SetControlledObject(pit: TT3PlatformInstance);
    procedure UpdateHookedInfo(Sender: TObject);
    procedure InitTabHookedInfo;
    procedure DisplayTabHooked(Sender: TObject);
    procedure UpdateTabHooked(aTrack: TSimObject);

    procedure UpdateFormData;

    { Public declarations }
  end;

var
  frmLeftAtasAir: TfrmLeftAtasAir;

implementation

uses
  ufTacticalDisplay, ufToteDisplay, uT3DetectedTrack, uSettingCoordinate, uT3Radar,
  uBaseCoordSystem, uSimMgr_Client, tttData, uT3Vehicle, uDBAsset_Vehicle, uT3Torpedo, uT3Missile,
  uDBAsset_Weapon, uT3Sonobuoy, uT3Mine, uT3CounterMeasure, uMapXHandler, uT3Common, uT3OtherSensor, ufrmGuidance,
  ufrmWeapon, ufrmRadar, uT3SimManager, ufrmTrackDetails, uSimContainers;

{$R *.dfm}

{ TfrmLeftAtasAir }

procedure TfrmLeftAtasAir.DisplayTabHooked(Sender: TObject);
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
      lbl5.Caption := 'Depth';
      lbl4.Caption := 'meter';

      if v.Altitude <> 0 then
        lblAltitude.Caption := FormatAltitude(v.Altitude)
      else
        lblAltitude.Caption := '0';
    end
    else
    begin
      lbl5.Caption := 'Altitude';
      lbl4.Caption := 'feet';

      if v.Altitude <> 0 then
       lblAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
      else
       lblAltitude.Caption := '0';
    end;

    if Assigned(v) then
    begin
      if det.IsDetailViewed then
      begin
        if det.DetailedDetectionShowed.Plat_Name_Recog_Capability then
        begin
//          lbNameHook.Caption      := v.InstanceName;
          lblNameHook.Caption      := det.TrackName;
        end
        else
        begin
//          lbNameHook.Caption      := 'Unknown';
          lblNameHook.Caption      := det.TrackName;
        end;

        if det.DetailedDetectionShowed.Plat_Class_Recog_Capability then
        begin
          lblClassHook.Caption     := v.InstanceClass;
//          lblClassHook.Caption      := det.TrackClass;
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
            lbl5.Caption := 'Depth';
            lbl4.Caption := 'meter';

            if v.Altitude <> 0 then
              lblAltitude.Caption    := FormatAltitude(v.Altitude)
            else
              lblAltitude.Caption := '0';
          end
          else
          begin
            lbl5.Caption := 'Altitude';
            lbl4.Caption := 'feet';

            if v.Altitude <> 0 then
             lblAltitude.Caption    := FormatAltitude(v.Altitude * C_Meter_To_Feet)
            else
             lblAltitude.Caption := '0';
          end;
        end
        else
          lblAltitude.Caption    := '---';
      end;

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

procedure TfrmLeftAtasAir.FormShow(Sender: TObject);
begin
   if focusedTrack <> nil then
    TT3PlatformInstance(focusedTrack).Selected := True;
end;

procedure TfrmLeftAtasAir.InitTabHookedInfo;
begin
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

end;

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
procedure TfrmLeftAtasAir.UpdateFormData;
begin
//   fmPlatformGuidance1.Refresh_VisibleTab();

  if focusedTrack <> nil then
  begin
    UpdateHookedInfo(focusedTrack);
  end
  else
  begin
    InitTabHookedInfo;
  end;
end;

procedure TfrmLeftAtasAir.UpdateHookedInfo(Sender: TObject);
begin
   InitTabHookedInfo;

  if not Assigned(Sender) then
    exit;

  if pnlTabHook.Tag = 1 then
    DisplayTabHooked(Sender);

end;

procedure TfrmLeftAtasAir.UpdateTabHooked(aTrack: TSimObject);
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

end.
