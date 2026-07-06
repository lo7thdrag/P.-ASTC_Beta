unit ufrmSummaryTowedJammerDecoy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Mask, Vcl.Imaging.pngimage,
  uDBAsset_Countermeasure;

type
  TfrmSummaryTowedJammerDecoy = class(TForm)
    pnl1Title: TPanel;
    lblClass: TLabel;
    edtClass: TEdit;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    lblECMType: TLabel;
    lblActivationControlDelay: TLabel;
    lbl8: TLabel;
    lblTowLength: TLabel;
    lbl9: TLabel;
    grbRadarCross: TGroupBox;
    lblSideRadarCross: TLabel;
    lblFrontRadarCross: TLabel;
    edtFrontRadarCross: TEdit;
    edtSideRadarCross: TEdit;
    cbFrontRadarCross: TComboBox;
    cbSideRadarCross: TComboBox;
    grbDimensions: TGroupBox;
    lbl1: TLabel;
    lblWidth: TLabel;
    lbl2: TLabel;
    lblLength: TLabel;
    lblHeight: TLabel;
    lbl3: TLabel;
    edtLengthDimensions: TEdit;
    edtWidththDimensions: TEdit;
    edtHeigthDimensions: TEdit;
    grbAcousticCross: TGroupBox;
    lbl4: TLabel;
    lbl5: TLabel;
    lblFrontAcousticCross: TLabel;
    lblSideAcousticCross: TLabel;
    edtFrontAcousticCross: TEdit;
    edtSideAcousticCross: TEdit;
    grbVisualCross: TGroupBox;
    lbl6: TLabel;
    lbl7: TLabel;
    lblSideVisualCross: TLabel;
    lblFrontVisualCross: TLabel;
    edtFrontVisualCross: TEdit;
    edtSideVisualCross: TEdit;
    grbTargetSelection: TGroupBox;
    cbxTARHMissiles: TCheckBox;
    cbxFireControlRadars: TCheckBox;
    cbbECMType: TComboBox;
    edtTowLength: TEdit;
    grbProbOfSuccess: TGroupBox;
    lblTypeA: TLabel;
    mnlbl10: TLabel;
    mnlbl11: TLabel;
    lblTypeB: TLabel;
    mnlbl12: TLabel;
    mnlbl13: TLabel;
    lblTypeC: TLabel;
    mnlbl14: TLabel;
    mnlbl15: TLabel;
    edtTypeA: TEdit;
    TrackBarTypeA: TTrackBar;
    edtTypeB: TEdit;
    TrackBarTypeB: TTrackBar;
    edtTypeC: TEdit;
    TrackBarTypeC: TTrackBar;
    medtActivationControlDelay: TMaskEdit;
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
    procedure CheckBoxDataClick(Sender: TObject);
    procedure ComboBoxDataChange(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    //General
    procedure trckbrGeneralChange(Sender: TObject);
    procedure edtGeneralChange(Sender: TObject);
    procedure CbbGeneralDataChange(Sender: TObject);

//    procedure edtLengthDimensionsKeyPress(Sender: TObject; var Key: Char);
//    procedure edtWidththDimensionsKeyPress(Sender: TObject; var Key: Char);
//    procedure edtHeigthDimensionsKeyPress(Sender: TObject; var Key: Char);
//    procedure edtFrontRadarCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure cbFrontRadarCrossChange(Sender: TObject);
//    procedure edtSideRadarCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure cbSideRadarCrossChange(Sender: TObject);
//    procedure edtFrontAcousticCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure edtSideAcousticCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure edtFrontVisualCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure edtSideVisualCrossKeyPress(Sender: TObject; var Key: Char);
//    procedure TargetSelectionOnClick(Sender: TObject);
//    procedure cbbECMTypeChange(Sender: TObject);
//    procedure medtActivationControlDelayKeyPress(Sender: TObject; var Key: Char);
//    procedure edtTowLengthKeyPress(Sender: TObject; var Key: Char);
//    procedure TrackBarProbOfSuccessChange(Sender: TObject);
//    procedure edtProbOfSuccessKeyPress(Sender: TObject; var Key: Char);

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    FSelectedTowedJammerDecoy : TTowed_Jammer_Decoy_On_Board;

    function CekInput: Boolean;
    procedure UpdateTowedJammerDecoyData;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }
    LastName : string;

    property SelectedTowedJammerDecoy : TTowed_Jammer_Decoy_On_Board
      read FSelectedTowedJammerDecoy write FSelectedTowedJammerDecoy;
  end;

var
  frmSummaryTowedJammerDecoy: TfrmSummaryTowedJammerDecoy;

implementation

uses
  uDataModuleTTT, Math;

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

procedure TfrmSummaryTowedJammerDecoy.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmSummaryTowedJammerDecoy.FormShow(Sender: TObject);
begin
  tsGeneral.Show;
  UpdateTowedJammerDecoyData;

  with FSelectedTowedJammerDecoy.FData do
    btnApply.Enabled := Towed_Decoy_Instance_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSummaryTowedJammerDecoy.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmSummaryTowedJammerDecoy.btnApplyClick(Sender: TObject);
var
  second : Integer;
begin
  if not CekInput then
    Exit;
  with FSelectedTowedJammerDecoy do
  begin
    if not CekInput then
    begin
      isOK := False;
      Exit;
    end;

    ValidationFormatInput;

    {$REGION ' General '}
    LastName := edtClass.Text;
    FDef.Towed_Decoy_Identifier := edtClass.Text;

    FDef.ECM_Type := cbbECMType.ItemIndex;

    TimeToSecond(medtActivationControlDelay.Text, second);
    FDef.Activation_Control_Delay := second;

    FDef.Tow_Length := StrToFloat(edtTowLength.Text);

    FDef.Decoy_TARH_Capable := Ord(cbxTARHMissiles.Checked);
    FDef.Decoy_SARH_Capable := Ord(cbxFireControlRadars.Checked);

    FDef.Length := StrToFloat(edtLengthDimensions.Text);
    FDef.Width := StrToFloat(edtWidththDimensions.Text);
    FDef.Height := StrToFloat(edtHeigthDimensions.Text);

    {Catatan : Tidak ada field untuk menyimpan nilai comboboxnya}
    FDef.Front_Radar_Cross := StrToFloat(edtFrontRadarCross.Text);
    FDef.Side_Radar_Cross := StrToFloat(edtSideRadarCross.Text);

    FDef.Front_Acoustic_Cross := StrToFloat(edtFrontAcousticCross.Text);
    FDef.Side_Acoustic_Cross := StrToFloat(edtSideAcousticCross.Text);

    FDef.Front_Visual_Cross := StrToFloat(edtFrontVisualCross.Text);
    FDef.Side_Visual_Cross := StrToFloat(edtSideVisualCross.Text);

    FDef.Type_A_Seducing_Prob := TrackBarTypeA.Position / 100;
    FDef.Type_B_Seducing_Prob := TrackBarTypeB.Position / 100;
    FDef.Type_C_Seducing_Prob := TrackBarTypeC.Position / 100;
    {$ENDREGION}

    {$REGION ' Notes '}
    FNote.Notes := mmoNotes.Text;
    {$ENDREGION}

    if FDef.Towed_Decoy_Index = 0 then
    begin
      if dmTTT.InsertTowedJammerDef(FDef) then
      begin
        dmTTT.InsertNoteStorage(17, FDef.Towed_Decoy_Index, FNote);
        ShowMessage('Data berhasil disimpan');
      end;
    end
    else
    begin
      if dmTTT.UpdateTowedJammerDef(FDef) then
      begin
        dmTTT.UpdateNoteStorage(FDef.Towed_Decoy_Index, FNote);
        ShowMessage('Data berhasil diperbarui');
      end;
    end;
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmSummaryTowedJammerDecoy.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmSummaryTowedJammerDecoy.edtGeneralChange(Sender: TObject);
begin
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';

  if (StrToInt(TEdit(Sender).Text) > 100) then
    TEdit(Sender).Text := '100';

  if TEdit(Sender).Name = 'edtTypeA' then
    TrackBarTypeA.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtTypeB' then
    TrackBarTypeB.Position := StrToInt(TEdit(Sender).Text)
  else if TEdit(Sender).Name = 'edtTypeC' then
    TrackBarTypeC.Position := StrToInt(TEdit(Sender).Text);

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.trckbrGeneralChange(Sender: TObject);
begin
  case TTrackBar(Sender).Tag of
    0: {TypeA}
    begin
      edtTypeA.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    1: {TypeB}
    begin
      edtTypeB.Text := IntToStr(TTrackBar(Sender).Position);
    end;
    2: {TypeC}
    begin
      edtTypeC.Text := IntToStr(TTrackBar(Sender).Position);
    end;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.CbbGeneralDataChange(Sender: TObject);
var
  value : Double;

begin
  if TComboBox(Sender).ItemIndex = -1 then
    TComboBox(Sender).ItemIndex := 0;

  case TComboBox(Sender).Tag of
    0: {Front}
    begin
      if edtFrontRadarCross.Text = '' then
        edtFrontRadarCross.Text := '0';

      value := StrToFloat(edtFrontRadarCross.Text);

      {Catatan : Rumus dibawah sepertinya tidak valid}
      case TComboBox(Sender).ItemIndex of
        0: edtFrontRadarCross.Text := FormatFloat('0.00', value);
        1: edtFrontRadarCross.Text := FormatFloat('0.00', Power(10, (value / 10)));
      end;
    end;
    1: {Side}
    begin
      if edtSideRadarCross.Text = '' then
        edtSideRadarCross.Text := '0';

      value := StrToFloat(edtSideRadarCross.Text);

      case TComboBox(Sender).ItemIndex of
        0: edtSideRadarCross.Text := FormatFloat('0.00', value);
        1: edtSideRadarCross.Text := FormatFloat('0.00', Power(10, (value / 10)));
      end;
    end;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.UpdateTowedJammerDecoyData;
var
  timeStr : string;
begin
  with FSelectedTowedJammerDecoy do
  begin
    if FDef.Towed_Decoy_Index = 0 then
      edtClass.Text := '(Unnamed)'
    else
      edtClass.Text := FDef.Towed_Decoy_Identifier;

    {$REGION ' General '}
    LastName := edtClass.Text;

    cbbECMType.ItemIndex := FDef.ECM_Type;

    SecondToTime(Round(FDef.Activation_Control_Delay), timeStr);
    medtActivationControlDelay.Text := timeStr;

    edtTowLength.Text := FloatToStr(FDef.Tow_Length);

    cbxTARHMissiles.Checked := Boolean(FDef.Decoy_TARH_Capable);
    cbxFireControlRadars.Checked := Boolean(FDef.Decoy_SARH_Capable);

    TrackBarTypeA.Position := Round(FDef.Type_A_Seducing_Prob * 100);
    TrackBarTypeB.Position := Round(FDef.Type_B_Seducing_Prob * 100);
    TrackBarTypeC.Position := Round(FDef.Type_C_Seducing_Prob * 100);

    edtLengthDimensions.Text := FormatFloat('0', FDef.Length);
    edtWidththDimensions.Text := FormatFloat('0', FDef.Width);
    edtHeigthDimensions.Text := FormatFloat('0', FDef.Height);

    edtFrontRadarCross.Text := FormatFloat('0.00', FDef.Front_Radar_Cross);
    edtSideRadarCross.Text := FormatFloat('0.00', FDef.Side_Radar_Cross);

    edtFrontAcousticCross.Text := FormatFloat('0.00', FDef.Front_Acoustic_Cross);
    edtSideAcousticCross.Text := FormatFloat('0.00', FDef.Side_Acoustic_Cross);

    edtFrontVisualCross.Text := FormatFloat('0.0', FDef.Front_Visual_Cross);
    edtSideVisualCross.Text := FormatFloat('0.0', FDef.Side_Visual_Cross);
    {$ENDREGION}

    {$REGION ' Notes '}
    mmoNotes.Text := FNote.Notes;
    {$ENDREGION}

  end;
end;

function TfrmSummaryTowedJammerDecoy.CekInput: Boolean;
var
  i, chkSpace, numSpace: Integer;
  second : Integer;
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
  if (dmTTT.GetTowedJammerDecoyDef(edtClass.Text)>0) then
  begin
    {Jika inputan baru}
    if FSelectedTowedJammerDecoy.FDef.Towed_Decoy_Index = 0 then
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

  TimeToSecond(medtActivationControlDelay.Text, second);
  if second > 32400 then
  begin
    ShowMessage('Activation Control Delay Terlalu Lama');
    Exit;
  end;

  Result := True;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmSummaryTowedJammerDecoy.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmSummaryTowedJammerDecoy.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmSummaryTowedJammerDecoy.CheckBoxDataClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.ComboBoxDataChange(Sender: TObject);
begin
  if TComboBox(Sender).ItemIndex = -1 then
    TComboBox(Sender).ItemIndex := 0;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSummaryTowedJammerDecoy.ValidationFormatInput;
var
  i, j: Integer;
  value : Double;
  hStr, mStr, sStr, hmSeparator, msSeparator : string;
  h, m, s : Integer;
  aTimeStr : string;
  flag : Boolean;

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

    if Components[i] is TMaskEdit then
    begin
      aTimeStr := TMaskEdit(Components[i]).Text;
      flag := False;

      hStr := Copy(aTimeStr, 1, 2);
      TryStrToInt(hStr, h);

      mStr := Copy(aTimeStr, 4, 2);
      TryStrToInt(mStr, m);

      sStr := Copy(aTimeStr, 7, 2);
      TryStrToInt(sStr, s);

      if h > 23 then
      begin
        hStr := '23';
        flag := True;
      end;

      if m > 59 then
      begin
        mStr := '59';
        flag := True;
      end;

      if s > 59 then
      begin
        sStr := '59';
        flag := True;
      end;

      if flag then
        TMaskEdit(Components[i]).Text := hStr + ':' + mStr + ':' + sStr;

    end;
  end;
end;

{$ENDREGION}

end.
