unit ufrmSummaryTorpedo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Vcl.Imaging.pngimage, tttData,

  uDBAsset_Weapon, uDBAsset_MotionCharacteristics;

type
  TfrmSummaryTorpedo = class(TForm)
    pnl1Title: TPanel;
    lblClass: TLabel;
    edtClass: TEdit;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    lblDetectabilityType: TLabel;
    lblMaxSearchDepth: TLabel;
    lbl4: TLabel;
    grpLaunchSetting: TGroupBox;
    lblMethod: TLabel;
    lblSpeed: TLabel;
    cbbMethod: TComboBox;
    cbbSpeed: TComboBox;
    cbbDetectabilityType: TComboBox;
    grpOptimumLaunchRange: TGroupBox;
    lblNuclearSubmarine: TLabel;
    lblConventionalSubmarine: TLabel;
    lblOtherSubmarine: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    trckbrNuclearSubmarine: TTrackBar;
    edtNuclearSubmarine: TEdit;
    edtConventionalSubmarine: TEdit;
    edtOtherSubmarine: TEdit;
    trckbrConventionalSubmarine: TTrackBar;
    trckbrOtherSubmarine: TTrackBar;
    grpLethality: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    trckbrLethality: TTrackBar;
    edtLethality: TEdit;
    grpDamageSustainability: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edtDamageSustainability: TEdit;
    trckbrDamageSustainability: TTrackBar;
    grpCapabilities: TGroupBox;
    lblPrimaryTargetDomain: TLabel;
    chkAntiSubsurface: TCheckBox;
    chkAntiSurface: TCheckBox;
    cbbPrimaryTargetDomain: TComboBox;
    grpSafetyCeiling: TGroupBox;
    lblSafetyCeilingDepth: TLabel;
    lbl1: TLabel;
    chkFixDepth: TCheckBox;
    edtSafetyCeilingDepth: TEdit;
    grpActiveAccoustic: TGroupBox;
    lblPower: TLabel;
    lblFrequency: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtPower: TEdit;
    edtFrequency: TEdit;
    edtMaxSearchDepth: TEdit;
    tsPhysical: TTabSheet;
    lblMotionCharacteristic: TLabel;
    grpAirDropCapable: TGroupBox;
    lblLateralDeceleration: TLabel;
    lblDecentRate: TLabel;
    lbl15: TLabel;
    lbl16: TLabel;
    edtLateralDeceleration: TEdit;
    edtDecentRate: TEdit;
    chkAirDropCapable: TCheckBox;
    grpAcousticCrossSection: TGroupBox;
    lblAcousticFront: TLabel;
    lblAcousticSide: TLabel;
    lbl17: TLabel;
    lbl18: TLabel;
    edtAcousticFront: TEdit;
    edtAcousticSide: TEdit;
    grpAcousticIntensity: TGroupBox;
    lblMinimumSpeed: TLabel;
    lblBelowCavitation: TLabel;
    lbl19: TLabel;
    lbl20: TLabel;
    lblAboveCavitation: TLabel;
    lblMaximumSpeed: TLabel;
    lbl21: TLabel;
    lbl22: TLabel;
    lblCavitationSpeed: TLabel;
    lbl23: TLabel;
    edtMinimumSpeed: TEdit;
    edtBelowCavitation: TEdit;
    edtAboveCavitation: TEdit;
    edtMaximumSpeed: TEdit;
    edtCavitationSpeed: TEdit;
    edtMotionCharacteristics: TEdit;
    btnMotionCharacteristic: TButton;
    grpDimensions: TGroupBox;
    lblLength: TLabel;
    lbl11: TLabel;
    lblWidth: TLabel;
    lbl12: TLabel;
    lbl13: TLabel;
    lblEngagementRange: TLabel;
    lbl14: TLabel;
    lblHeight: TLabel;
    edtLength: TEdit;
    edtWidth: TEdit;
    edtHeight: TEdit;
    edtEngagementRange: TEdit;
    tsPOHModifier: TTabSheet;
    grpTorpedo: TGroupBox;
    lblWakeHoming: TLabel;
    lblWireGuided: TLabel;
    lblActiveAcoustic: TLabel;
    lblPassiveAcoustic: TLabel;
    lblActivePassiveAcoustic: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    edtWakeHoming: TEdit;
    edtActiveAcoustic: TEdit;
    edtPassiveAcoustic: TEdit;
    edtWireGuided: TEdit;
    trckbrWakeHoming: TTrackBar;
    trckbrWireGuided: TTrackBar;
    trckbrActiveAcoustic: TTrackBar;
    trckbrPassiveAcoustic: TTrackBar;
    edtActivePassiveAcoustic: TEdit;
    trckbrActivePassiveAcoustic: TTrackBar;
    tsGuidance: TTabSheet;
    lblMinimumRunoutRange: TLabel;
    lbl29: TLabel;
    lblDefaultCruiseDepth: TLabel;
    lblWireAngleOffset: TLabel;
    lbl38: TLabel;
    lbl39: TLabel;
    grpGuidance: TGroupBox;
    lblPrimary: TLabel;
    lblPursuit: TLabel;
    cbbPrimary: TComboBox;
    cbbPursuit: TComboBox;
    grpSeekerDetectionEnvelope: TGroupBox;
    lbl26: TLabel;
    lblSeekerAzimuth: TLabel;
    lbl27: TLabel;
    lblSeekerRange: TLabel;
    lblSeekerElevation: TLabel;
    lbl28: TLabel;
    edtSeekerRange: TEdit;
    edtSeekerAzimuth: TEdit;
    edtSeekerElevation: TEdit;
    edtMinimumRunoutRange: TEdit;
    grpSinuationRunout: TGroupBox;
    lbl30: TLabel;
    lblSinuationAmplitude: TLabel;
    lbl31: TLabel;
    lblSinuationPeriod: TLabel;
    edtSinuationPeriod: TEdit;
    edtSinuationAmplitude: TEdit;
    grbUseTerminalCircle: TGroupBox;
    lbl34: TLabel;
    lblRadius: TLabel;
    edtRadius: TEdit;
    chkRadiusOperatorModifable: TCheckBox;
    grpRange: TGroupBox;
    lbl32: TLabel;
    lblMaxRange: TLabel;
    lbl33: TLabel;
    lblMinRange: TLabel;
    edtMinRange: TEdit;
    edtMaxRange: TEdit;
    grpSeekerTurnOnRange: TGroupBox;
    lbl35: TLabel;
    lblSeekerTurnOnRange: TLabel;
    edtSeekerTurnOnRange: TEdit;
    chkRangeOperatorModifable: TCheckBox;
    grpRelaviteGyroAngle: TGroupBox;
    lblFirstAngle: TLabel;
    lblSecondAngle: TLabel;
    lbl36: TLabel;
    lbl37: TLabel;
    cbbFirstAngle: TComboBox;
    cbbSecondAngle: TComboBox;
    edtDefaultCruiseDepth: TEdit;
    edtWireAngleOffset: TEdit;
    grpAspectDependentPOH: TGroupBox;
    btnEditPOH: TButton;
    chkSinuationRunout: TCheckBox;
    chkUseTerminalCircle: TCheckBox;
    chkRelativeGyroAngle: TCheckBox;
    tsNotes: TTabSheet;
    mmoNotes: TMemo;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormShow(Sender: TObject);

    //Global
    function GetNumberOfKoma(s : string): Boolean;
    procedure edtNumeralKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBoxDataChange(Sender: TObject);
    procedure CheckBoxDataClick(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    //General
    procedure UpdatePrimaryTargetDomainItems(Sender: TObject);
    procedure trckbrGeneralChange(Sender: TObject);
    procedure edtGeneralChange(Sender: TObject);
    procedure edtOptimumLaunchChange(Sender: TObject);

    //Physical
    procedure btnMotionCharacteristicsClick(Sender: TObject);
    procedure chkAirDropCapableClick(Sender: TObject);

    //POH Modifier
    procedure trckbrPOHModifierChange(Sender: TObject);
    procedure edtPOHModifierChange(Sender: TObject);

    //Guidance
    procedure chkSinuationRunoutClick(Sender: TObject);
    procedure chkUseTerminalCircleClick(Sender: TObject);
    procedure chkRelativeGyroAngleClick(Sender: TObject);

    procedure btnEditPOHClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FSelectedTorpedo : TTorpedo_On_Board;
    FSelectedMotion : TMotion_Characteristics;

    function CekInput: Boolean;
    function GetWeaponCategory(sValue : string): Integer;
    function SetWeaponCategory(iValue : integer): string;

//    function GetLaunchMethod(sValue : string): Integer;
//    function SetLaunchMethod(iValue : integer): string;

    function GetPursuit(sValue : string): Integer;
    function SetPursuit(iValue : integer): string;

    procedure UpdateTorpedoData;
    procedure UpdateMotionData;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }
    LastName : string;

    property SelectedTorpedo : TTorpedo_On_Board read FSelectedTorpedo
      write FSelectedTorpedo;
  end;

var
  frmSummaryTorpedo: TfrmSummaryTorpedo;

implementation

uses
  uDataModuleTTT, ufrmMotionPickList, uProbabilityGraph, ufrmTorpedoProbabilityGraphic, uSession;

{$R *.dfm}

procedure EnableComposited(WinControl:TWinControl);
var
  i:Integer;
  NewExStyle:DWORD;
begin
  NewExStyle := GetWindowLong(WinControl.Handle, GWL_EXSTYLE) or WS_EX_COMPOSITED;
  SetWindowLong(WinControl.Handle, GWL_EXSTYLE, NewExStyle);

  for I := 0 to WinControl.ControlCount - 1 do
    if WinControl.Controls[i] is TWinControl then
      EnableComposited(TWinControl(WinControl.Controls[i]));
end;

{$REGION ' Form Handle '}

procedure TfrmSummaryTorpedo.FormCreate(Sender: TObject);
begin
  FSelectedMotion := TMotion_Characteristics.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSummaryTorpedo.FormDestroy(Sender: TObject);
begin
  FSelectedMotion.Free;
end;

procedure TfrmSummaryTorpedo.FormShow(Sender: TObject);
begin
  tsGeneral.Show;
  UpdateTorpedoData;

  with FSelectedTorpedo.FDef do
    btnApply.Enabled := Torpedo_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;

end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSummaryTorpedo.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmSummaryTorpedo.btnApplyClick(Sender: TObject);
begin

  with FSelectedTorpedo do
  begin
    if not CekInput then
    begin
      isOK := False;
      Exit;
    end;

    ValidationFormatInput;

    {$REGION ' General '}
    LastName := edtClass.Text;
    FDef.Class_Identifier := edtClass.Text;

    FDef.Launch_Method := cbbMethod.ItemIndex;
    FDef.Launch_Speed := cbbSpeed.ItemIndex;

    FDef.Active_Seeker_Power := StrToFloat(edtPower.Text);
    FDef.Active_Seeker_Freq := StrToFloat(edtFrequency.Text);

    FDef.Anti_Sur_Capable := Ord(chkAntiSurface.Checked);
    FDef.Anti_SubSur_Capable := Ord(chkAntiSubSurface.Checked);
    FDef.Primary_Target_Domain := cbbPrimaryTargetDomain.ItemIndex;

    FDef.Acoustic_Torp_Ceiling_Depth := StrToFloat(edtSafetyCeilingDepth.Text);
    FDef.Fixed_Ceiling_Depth := Ord(chkFixDepth.Checked);

    FDef.Max_Torpedo_Search_Depth := StrToFloat(edtMaxSearchDepth.Text);
    FDef.Detectability_Type := cbbDetectabilityType.ItemIndex;

    FDef.Lethality := trckbrLethality.Position;
    FDef.Damage_Capacity := trckbrDamageSustainability.Position;

    FDef.Opt_Launch_Range_Nuc_Sub := trckbrNuclearSubmarine.Position / 100;
    FDef.Opt_Launch_Range_Conv_Sub := trckbrConventionalSubmarine.Position / 100;
    FDef.Opt_Launch_Range_Other := trckbrOtherSubmarine.Position / 100;
    {$ENDREGION}

    {$REGION ' Physical '}
    FDef.Length := StrToFloat(edtLength.Text);
    FDef.Width := StrToFloat(edtWidth.Text);
    FDef.Height := StrToFloat(edtHeight.Text);
    FDef.Engagement_Range := StrToFloat(edtEngagementRange.Text);

    FDef.Air_Drop_Capable := Ord(chkAirDropCapable.Checked);
    FDef.Lateral_Deceleration := StrToFloat(edtLateralDeceleration.Text);
    FDef.Airborne_Descent_Rate := StrToFloat(edtDecentRate.Text);

    FDef.LSpeed_Acoustic_Intens := StrToFloat(edtMinimumSpeed.Text);
    FDef.HSpeed_Acoustic_Intens := StrToFloat(edtMaximumSpeed.Text);
    FDef.Cavitation_Switch_Point := StrToFloat(edtCavitationSpeed.Text);
    FDef.Below_Cav_Acoustic_Intens := StrToFloat(edtBelowCavitation.Text);
    FDef.Above_Cav_Acoustic_Intens := StrToFloat(edtAboveCavitation.Text);

    FDef.Front_Acoustic_Cross := StrToFloat(edtAcousticFront.Text);
    FDef.Side_Acoustic_Cross := StrToFloat(edtAcousticSide.Text);
    {$ENDREGION}

    {$REGION ' POH modifier '}
    FDef.WakeHome_POH_Modifier := trckbrWakeHoming.Position / 100;
    FDef.WireGuide_POH_Modifier := trckbrWireGuided.Position / 100;
    FDef.Active_Acoustic_POH_Mod := trckbrActiveAcoustic.Position / 100;
    FDef.Passive_Acoustic_POH_Mod := trckbrPassiveAcoustic.Position / 100;
    FDef.Active_Passive_POH_Mod := trckbrActivePassiveAcoustic.Position / 100;
    {$ENDREGION}

    {$REGION ' Guidance '}
    FDef.Guidance_Type := GetWeaponCategory(cbbPrimary.Text);
    FDef.Pursuit_Guidance_Type := GetPursuit(cbbPursuit.Text);

    FDef.Min_Range := StrToFloat(edtMinRange.Text);
    FDef.Max_Range := StrToFloat(edtMaxRange.Text);

    FDef.Seeker_TurnOn_Range := StrToFloat(edtSeekerTurnOnRange.Text);
    FDef.Fixed_Seeker_TurnOn_Range := Ord(chkRangeOperatorModifable.Checked);

    FDef.Term_Guide_Range := StrToFloat(edtSeekerRange.Text);
    FDef.Term_Guide_Azimuth := StrToFloat(edtSeekerAzimuth.Text);
    FDef.Term_Guide_Elevation := StrToFloat(edtSeekerElevation.Text);

    FDef.Default_Depth := StrToFloat(edtDefaultCruiseDepth.Text);
    FDef.Wire_Angle_Offset := StrToFloat(edtWireAngleOffset.Text);
    FDef.Min_Runout_Range := StrToFloat(edtMinimumRunoutRange.Text);

    FDef.Sinuation_Runout := Ord(chkSinuationRunout.Checked);
    FDef.Runout_Sinuation_Period := StrToFloat(edtSinuationPeriod.Text);
    FDef.Runout_Sinuation_Amplitude := StrToFloat(edtSinuationAmplitude.Text);

    FDef.Use_Terminal_Circle := Ord(chkUseTerminalCircle.Checked);
    FDef.Terminal_Circle_Radius := StrToFloat(edtRadius.Text);
    FDef.Fixed_Circle_Radius := Ord(chkRadiusOperatorModifable.Checked);

    {Catatan : Cheksbox untuk relative gyro angles tida ada fieldnya,
                field Max_Torpedo_Gyro_Angle tidak tahu buat apa }
    FDef.First_Relative_Gyro_Angle := cbbFirstAngle.ItemIndex;
    FDef.Second_Relative_Gyro_Angle := cbbSecondAngle.ItemIndex;
    {$ENDREGION}

    {$REGION ' Notes '}
    if Trim(uSession.CurrentUser) <> '' then
    begin
      if mmoNotes.Lines.Count > 0 then
        mmoNotes.Clear;

      mmoNotes.Lines.Add('Last Update');
      mmoNotes.Lines.Add('User : ' + uSession.CurrentName);
      mmoNotes.Lines.Add('Date : ' + FormatDateTime('dd mmm yyyy hh:nn', Now));

    end;

    FNote.Notes := mmoNotes.Text;
    {$ENDREGION}

    if FDef.Torpedo_Index = 0 then
    begin
      if dmTTT.InsertTorpedoDef(FDef) then
      begin
        dmTTT.InsertNoteStorage(4, FDef.Torpedo_Index, FNote);
        ShowMessage('Data berhasil disimpan');
      end;
    end
    else
    begin
      if dmTTT.UpdateTorpedoDef(FDef) then
      begin
        dmTTT.UpdateNoteStorage(FDef.Torpedo_Index, FNote);
        ShowMessage('Data berhasil diperbarui');
      end;
    end;
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmSummaryTorpedo.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmSummaryTorpedo.btnMotionCharacteristicsClick(Sender: TObject);
begin
frmMotionPickList := TfrmMotionPickList.Create(Self);
  try
    with frmMotionPickList do
    begin
      SelectedMotionId := FSelectedTorpedo.FDef.Motion_Index;
      ShowModal;
      FSelectedTorpedo.FDef.Motion_Index := SelectedMotionId;
    end;

  finally
    frmMotionPickList.Free;
  end;

  UpdateMotionData;
  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.btnEditPOHClick(Sender: TObject);
begin
  frmTorpedoProbabilityGraphic := TfrmTorpedoProbabilityGraphic.Create(Self);
  try
    with frmTorpedoProbabilityGraphic do
    begin
       ProbabilityGraph := pgTorpedo;
      SelectedProbObj := FSelectedTorpedo;
      ShowModal;
    end;

  finally
    frmTorpedoProbabilityGraphic.Free;
  end;

end;

procedure TfrmSummaryTorpedo.trckbrGeneralChange(Sender: TObject);
begin
  case TTrackBar(Sender).Tag of
    0: {Damage Sustainability}
    begin
      edtDamageSustainability.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    1: {Lethality}
    begin
      edtLethality.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    2: {Max Range Nuclear Submarine}
    begin
      edtNuclearSubmarine.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    3: {Max Range Conventional Submarine}
    begin
      edtConventionalSubmarine.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    4: {Max Range Other Submarine}
    begin
      edtOtherSubmarine.Text := IntToStr(TTrackBar(Sender).Position);
    end;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.edtGeneralChange(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if (StrToInt(TEdit(Sender).Text) > 100000) then
    TEdit(Sender).Text := '100000';

  if TEdit(Sender).Name = 'edtDamageSustainability' then
    trckbrDamageSustainability.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtLethality' then
    trckbrLethality.Position := StrToInt(TEdit(Sender).Text);

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.edtOptimumLaunchChange(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if (StrToInt(TEdit(Sender).Text) > 100) then
    TEdit(Sender).Text := '100';

  if TEdit(Sender).Name = 'edtNuclearSubmarine' then
    trckbrNuclearSubmarine.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtConventionalSubmarine' then
    trckbrConventionalSubmarine.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtOtherSubmarine' then
    trckbrOtherSubmarine.Position := StrToInt(TEdit(Sender).Text);

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.chkAirDropCapableClick(Sender: TObject);
begin
  grpAirDropCapable.Enabled := chkAirDropCapable.Checked;

  if not chkAirDropCapable.Checked then
  begin
    edtLateralDeceleration.Text := '0.00';
    edtDecentRate.Text := '0.00';
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.chkRelativeGyroAngleClick(Sender: TObject);
begin
  grpRelaviteGyroAngle.Enabled := chkRelativeGyroAngle.Checked;

  if not chkRelativeGyroAngle.Checked then
  begin
    cbbFirstAngle.ItemIndex := -1;
    cbbSecondAngle.ItemIndex := -1;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.chkSinuationRunoutClick(Sender: TObject);
begin
  grpSinuationRunout.Enabled := chkSinuationRunout.Checked;

  if not chkSinuationRunout.Checked then
  begin
    edtSinuationPeriod.Text := '0';
    edtSinuationAmplitude.Text := '0';
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.chkUseTerminalCircleClick(Sender: TObject);
begin
  grbUseTerminalCircle.Enabled := chkUseTerminalCircle.Checked;

  if not chkUseTerminalCircle.Checked then
  begin
    edtRadius.Text := '0.00';
    chkRadiusOperatorModifable.Checked := False;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.trckbrPOHModifierChange(Sender: TObject);
begin
  case TTrackBar(Sender).Tag of
    0: {Wake Hominh}
    begin
      edtWakeHoming.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    1: {Wire Guided}
    begin
      edtWireGuided.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    2: {Active Acoustic}
    begin
      edtActiveAcoustic.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    3: {Pasive Acoustic}
    begin
      edtPassiveAcoustic.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    4: {Active Pasive Acoustic}
    begin
      edtActivePassiveAcoustic.Text := IntToStr(TTrackBar(Sender).Position);
    end;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.edtPOHModifierChange(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if (StrToInt(TEdit(Sender).Text) > 100) then
    TEdit(Sender).Text := '100';

  if TEdit(Sender).Name = 'edtWakeHoming' then
    trckbrWakeHoming.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtWireGuided' then
    trckbrWireGuided.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtActiveAcoustic' then
    trckbrActiveAcoustic.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtPassiveAcoustic' then
    trckbrPassiveAcoustic.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtActivePassiveAcoustic' then
    trckbrActivePassiveAcoustic.Position := StrToInt(TEdit(Sender).Text);

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.UpdatePrimaryTargetDomainItems(Sender: TObject);
begin
  cbbPrimaryTargetDomain.Items.Clear;
  cbbPrimaryTargetDomain.Text := '';

  if chkAntiSurface.Checked And chkAntiSubsurface.Checked then
  begin
    cbbPrimaryTargetDomain.Items.Add('Any Within Capabilities');
    cbbPrimaryTargetDomain.Items.Add('Surface');
    cbbPrimaryTargetDomain.Items.Add('SubSurface');
  end
  else if chkAntiSurface.Checked then
  begin
    cbbPrimaryTargetDomain.Items.Add('Surface');
  end
  else if chkAntiSubsurface.Checked then
    cbbPrimaryTargetDomain.Items.Add('SubSurface');

  if cbbPrimaryTargetDomain.Items.Count > 0 then
    cbbPrimaryTargetDomain.ItemIndex := 0
  else
    cbbPrimaryTargetDomain.ItemIndex := -1;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.UpdateMotionData;
begin
  with FSelectedTorpedo do
  begin
    if dmTTT.GetMotionCharacteristicDef(FDef.Motion_Index, FSelectedMotion) then
      edtMotionCharacteristics.Text := FSelectedMotion.FData.Motion_Identifier
    else
      edtMotionCharacteristics.Text := '(None)';
  end;
end;

procedure TfrmSummaryTorpedo.UpdateTorpedoData;
begin
  with FSelectedTorpedo do
  begin
    if FDef.Torpedo_Index = 0 then
      edtClass.Text := '(Unnamed)'
    else
      edtClass.Text := FDef.Class_Identifier;

    {$REGION ' General '}
    LastName := edtClass.Text;
    cbbMethod.ItemIndex := FDef.Launch_Method;
    cbbSpeed.ItemIndex := FDef.Launch_Speed;

    edtPower.Text := FormatFloat('0', FDef.Active_Seeker_Power);
    edtFrequency.Text := FormatFloat('0', FDef.Active_Seeker_Freq);

    chkAntiSurface.Checked := Boolean(FDef.Anti_Sur_Capable);
    chkAntiSubSurface.Checked := Boolean(FDef.Anti_SubSur_Capable);
    cbbPrimaryTargetDomain.ItemIndex := FDef.Primary_Target_Domain;

    edtSafetyCeilingDepth.Text := FormatFloat('0', FDef.Acoustic_Torp_Ceiling_Depth);
    chkFixDepth.Checked := Boolean(FDef.Fixed_Ceiling_Depth);

    edtMaxSearchDepth.Text := FormatFloat('0', FDef.Max_Torpedo_Search_Depth);
    cbbDetectabilityType.ItemIndex := FDef.Detectability_Type;

    trckbrLethality.Position := FDef.Lethality;
    trckbrDamageSustainability.Position := FDef.Damage_Capacity;

    trckbrNuclearSubmarine.Position := Round(FDef.Opt_Launch_Range_Nuc_Sub * 100);
    trckbrConventionalSubmarine.Position := Round(FDef.Opt_Launch_Range_Conv_Sub * 100);
    trckbrOtherSubmarine.Position := Round(FDef.Opt_Launch_Range_Other * 100);
    {$ENDREGION}

    {$REGION ' Physical '}
    UpdateMotionData;

    edtLength.Text := FormatFloat('0', FDef.Length);
    edtWidth.Text := FormatFloat('0', FDef.Width);
    edtHeight.Text := FormatFloat('0', FDef.Height);
    edtEngagementRange.Text := FormatFloat('0', FDef.Engagement_Range);

    chkAirDropCapable.Checked := Boolean(FDef.Air_Drop_Capable);
    edtLateralDeceleration.Text := FormatFloat('0.00', FDef.Lateral_Deceleration);
    edtDecentRate.Text := FormatFloat('0.00', FDef.Airborne_Descent_Rate);

    edtMinimumSpeed.Text := FormatFloat('0.0', FDef.LSpeed_Acoustic_Intens);
    edtMaximumSpeed.Text := FormatFloat('0.0', FDef.HSpeed_Acoustic_Intens);
    edtCavitationSpeed.Text := FormatFloat('0.00', FDef.Cavitation_Switch_Point);
    edtBelowCavitation.Text := FormatFloat('0.0', FDef.Below_Cav_Acoustic_Intens);
    edtAboveCavitation.Text := FormatFloat('00.', FDef.Above_Cav_Acoustic_Intens);

    edtAcousticFront.Text := FormatFloat('0.00', FDef.Front_Acoustic_Cross);
    edtAcousticSide.Text := FormatFloat('0.00', FDef.Side_Acoustic_Cross);
    {$ENDREGION}

    {$REGION ' POH modifier '}
    trckbrWakeHoming.Position := Round(FDef.WakeHome_POH_Modifier * 100);
    trckbrWireGuided.Position := Round(FDef.WireGuide_POH_Modifier * 100);
    trckbrActiveAcoustic.Position := Round(FDef.Active_Acoustic_POH_Mod * 100);
    trckbrPassiveAcoustic.Position := Round(FDef.Passive_Acoustic_POH_Mod * 100);
    trckbrActivePassiveAcoustic.Position := Round(FDef.Active_Passive_POH_Mod * 100);
    {$ENDREGION}

    {$REGION ' Guidance '}
    cbbPrimary.Text := SetWeaponCategory(FDef.Guidance_Type);
    cbbPursuit.Text := SetPursuit(FDef.Pursuit_Guidance_Type);

    edtMinRange.Text := FormatFloat('0.00', FDef.Min_Range);
    edtMaxRange.Text := FormatFloat('0.00', FDef.Max_Range);

    edtSeekerTurnOnRange.Text := FormatFloat('0.00', FDef.Seeker_TurnOn_Range);
    chkRangeOperatorModifable.Checked := Boolean(FDef.Fixed_Seeker_TurnOn_Range);

    edtSeekerRange.Text := FormatFloat('0.00', FDef.Term_Guide_Range);
    edtSeekerAzimuth.Text := FormatFloat('0', FDef.Term_Guide_Azimuth);
    edtSeekerElevation.Text := FormatFloat('0', FDef.Term_Guide_Elevation);

    edtDefaultCruiseDepth.Text := FormatFloat('0', FDef.Default_Depth);
    edtWireAngleOffset.Text := FormatFloat('0', FDef.Wire_Angle_Offset);
    edtMinimumRunoutRange.Text := FormatFloat('0.00', FDef.Min_Runout_Range);

    chkSinuationRunout.Checked := Boolean(FDef.Sinuation_Runout);
    edtSinuationPeriod.Text := FormatFloat('0', FDef.Runout_Sinuation_Period);
    edtSinuationAmplitude.Text := FormatFloat('0', FDef.Runout_Sinuation_Amplitude);

    chkUseTerminalCircle.Checked := Boolean(FDef.Use_Terminal_Circle);
    edtRadius.Text := FormatFloat('0.00', FDef.Terminal_Circle_Radius);
    chkRadiusOperatorModifable.Checked := Boolean(FDef.Fixed_Circle_Radius);

    cbbFirstAngle.ItemIndex := FDef.First_Relative_Gyro_Angle;
    cbbSecondAngle.ItemIndex := FDef.Second_Relative_Gyro_Angle;

    btnEditPOH.Enabled := FDef.Torpedo_Index <> 0;
    {$ENDREGION}

    {$REGION ' Notes '}
    mmoNotes.Text := FNote.Notes;
    {$ENDREGION}

  end;
end;

function TfrmSummaryTorpedo.CekInput: Boolean;
var
  i, chkSpace, numSpace: Integer;
begin
  Result := False;

  {Jika inputan class name kosong}
  if (edtClass.Text = '')then
  begin
    ShowMessage('Silahkan masukkan nama class');
    Exit;
  end;

  {Jika berisi spasi semua}
  if Copy(edtClass.Text, 1, 1) = ' ' then
  begin
    chkSpace := Length(edtClass.Text);
    numSpace := 0;

    for i := 1 to chkSpace do
    begin
      if edtClass.Text[i] = #32 then
      numSpace := numSpace + 1;
    end;

    if chkSpace = numSpace then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end;
  end;

  {Jika Class Name sudah ada}
  if (dmTTT.GetTorpedoDef(edtClass.Text)>0) then
  begin
    {Jika inputan baru}
    if FSelectedTorpedo.FDef.Torpedo_Index = 0 then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end
    else if LastName <> edtClass.Text then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end;
  end;

  {Jika inputan Motion Characteristic masih kosong}
  if FSelectedTorpedo.FDef.Motion_Index = 0 then
  begin
    ShowMessage('Motion Characteristics belum dipilih');
    Exit;
  end;

  Result := True;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmSummaryTorpedo.GetNumberOfKoma(s: string): Boolean;
var
  a, i : Integer;
begin
  Result := False;
  a := 0;

  for i := 1 to length(s) do
  begin
    if s[i] = '.' then
      a := a + 1;
  end;

  if a > 0 then
    Result := True;
end;

//function TfrmSummaryTorpedo.GetLaunchMethod(sValue: string): Integer;
//begin
//  if sValue = 'Aimpoint Only Launch' then Result := Byte(tlmAimpoint)
//  else if sValue = 'Bearing Only Launch' then Result := Byte(tlmBearing)
//  else if sValue = 'Aimpoint or Bearing Launch' then Result := Byte(tlmAimBearing)
//  else if sValue = 'Direct Launch' then Result := Byte(tlmDirect)
//end;

function TfrmSummaryTorpedo.GetWeaponCategory(sValue: string): Integer;
begin
  if sValue = 'Straight' then Result := Byte(wcTorpedoStraigth)
  else if sValue = 'Active Acoustic' then Result := Byte(wcTorpedoActiveAcoustic)
  else if sValue = 'Passive Acoustic' then Result := Byte(wcTorpedoPassiveAcoustic)
  else if sValue = 'Active/Passive' then Result := Byte(wcTorpedoActivePassive)
  else if sValue = 'Wire Guided' then Result := Byte(wcTorpedoWireGuided)
  else if sValue = 'Wake Homing' then Result := Byte(wcTorpedoWakeHoming)
end;

//function TfrmSummaryTorpedo.SetLaunchMethod(iValue: integer): string;
//begin
//  case iValue of
//    Byte(tlmAimpoint) : Result := 'Aimpoint Only Launch';
//    Byte(tlmBearing) : Result := 'Bearing Only Launch';
//    Byte(tlmAimBearing) : Result := 'Aimpoint or Bearing Launch';
//    Byte(tlmDirect) : Result := 'Direct Launch';
//  end;
//end;

function TfrmSummaryTorpedo.GetPursuit(sValue: string): Integer;
begin
  if sValue = 'Lead' then Result := 2
  else if sValue = 'Pure' then Result := 3
end;

function TfrmSummaryTorpedo.SetPursuit(iValue: integer): string;
begin
  case iValue of
    2 : Result := 'Lead';
    3 : Result := 'Pure';
  end;
end;

function TfrmSummaryTorpedo.SetWeaponCategory(iValue: integer): string;
begin
  case iValue of
    Byte(wcTorpedoStraigth) : Result := 'Straight';
    Byte(wcTorpedoActiveAcoustic) : Result := 'Active Acoustic';
    Byte(wcTorpedoPassiveAcoustic) : Result := 'Passive Acoustic';
    Byte(wcTorpedoActivePassive) : Result := 'Active/Passive';
    Byte(wcTorpedoWireGuided) : Result := 'Wire Guided';
    Byte(wcTorpedoWakeHoming) : Result := 'Wake Homing';
  end;
end;

procedure TfrmSummaryTorpedo.edtNumeralKeyPress(Sender: TObject; var Key: Char);
var
  value : Double;
begin
  if not (Key in[#48 .. #57, #8, #13, #46]) then
  begin
    Key := #0;
    Exit;
  end;

  if GetNumberOfKoma(TEdit(sender).Text) then
  begin
    if Key = #46 then
      Key := #0;
  end;

  if Key = #13 then
  begin
    if TEdit(Sender).Text = '' then
      TEdit(Sender).Text := '0';

    value := StrToFloat(TEdit(Sender).Text);

    case TEdit(Sender).Tag of
      0: TEdit(Sender).Text := FormatFloat('0', value);
      1: TEdit(Sender).Text := FormatFloat('0.0', value);
      2: TEdit(Sender).Text := FormatFloat('0.00', value);
      3: TEdit(Sender).Text := FormatFloat('0.000', value);
    end;

    btnApply.Enabled := True;
  end;
end;

procedure TfrmSummaryTorpedo.CheckBoxDataClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.ComboBoxDataChange(Sender: TObject);
begin
  if TComboBox(Sender).ItemIndex = -1 then
    TComboBox(Sender).ItemIndex := 0;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSummaryTorpedo.ValidationFormatInput;
var
  i: Integer;
  value : Double;

begin
  for i:=0 to ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      if TEdit(Components[i]).Tag = 4 then
        continue;

      if TEdit(Components[i]).Text = '' then
        TEdit(Components[i]).Text := '0';

      value := StrToFloat(TEdit(Components[i]).Text);

      case TEdit(Components[i]).Tag of
        0: TEdit(Components[i]).Text := FormatFloat('0', value);
        1: TEdit(Components[i]).Text := FormatFloat('0.0', value);
        2: TEdit(Components[i]).Text := FormatFloat('0.00', value);
        3: TEdit(Components[i]).Text := FormatFloat('0.000', value);
      end;
    end;
  end;
end;

{$ENDREGION}

end.
