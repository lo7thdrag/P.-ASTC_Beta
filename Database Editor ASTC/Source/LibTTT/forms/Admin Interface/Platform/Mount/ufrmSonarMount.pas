unit ufrmSonarMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Vcl.Imaging.pngimage,
  uDBBlind_Zone, uBlindZoneView, tttData, uDBAsset_Vehicle,
  uDBAsset_Sonar, Vcl.Mask ;

type
  TfrmSonarMount = class(TForm)
    pnl1Title: TPanel;
    edtName: TEdit;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    General: TTabSheet;
    lblClassName: TStaticText;
    edtClassName: TEdit;
    lblMountExtension: TStaticText;
    cbMountExtension: TComboBox;
    lblBlindZones: TStaticText;
    lblHullMounted: TStaticText;
    edtHullMounted: TEdit;
    lblDeployTime: TStaticText;
    lblStowTime: TStaticText;
    lblFeetHullMounted: TStaticText;
    txtDeployTime: TStaticText;
    txtStowTime: TStaticText;
    pnlBlindZone: TPanel;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    edtDeployTime: TMaskEdit;
    edtStowTime: TMaskEdit;
    txtClass: TLabel;
    pnlMainBackground: TPanel;
    imgBackground: TImage;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    //Global
    function GetNumberOfKoma(s : string): Boolean;
    procedure edtNumeralKeyPress(Sender: TObject; var Key: Char);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    procedure cbMountExtensionChange(Sender: TObject);
    procedure pnlBlindZoneClick(Sender: TObject);

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedSonar : TSonar_On_Board;

    FBlindZoneView : TBlindZoneView;

    function CekInput: Boolean;
    procedure UpdateSonarData;
    procedure DrawBlindZone;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle  write FSelectedVehicle;
    property SelectedSonar : TSonar_On_Board read FSelectedSonar  write FSelectedSonar;
  end;

var
  frmSonarMount: TfrmSonarMount;

implementation

uses
  ufrmSummaryVehicle, uDataModuleTTT, ufrmBlindZoneAttachment,
  ufrmSonarOnBoardPickList, uVehicleSelect;

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

procedure TfrmSonarMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FBlindZoneView.Free;
end;

procedure TfrmSonarMount.FormCreate(Sender: TObject);
begin
  FBlindZoneView := TBlindZoneView.Create(Self);

  with FBlindZoneView do
  begin
    Parent := pnlBlindZone;
    Left := 0;
    Top := 0;
    Height := pnlBlindZone.Height;
    Width := pnlBlindZone.Width;
    OnClick := pnlBlindZoneClick;
  end;
  EnableComposited(pnlMainBackground);
end;

procedure TfrmSonarMount.FormDestroy(Sender: TObject);
begin
  FBlindZoneView.Free;
end;

procedure TfrmSonarMount.FormShow(Sender: TObject);
begin
  UpdateSonarData;

  with FSelectedSonar.FData do
    btnApply.Enabled := Sonar_Instance_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSonarMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmSonarMount.btnApplyClick(Sender: TObject);
var
  second : Integer;
begin
  if not CekInput then
  begin
    isOK := False;
    Exit;
  end;

  ValidationFormatInput;

  with FSelectedSonar do
  begin
    LastName := edtName.Text;
    FData.Instance_Identifier := edtName.Text;
    FData.Instance_Type := cbMountExtension.ItemIndex;
    FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FData.Sonar_Index := FDef.Sonar_Index;
    FData.Minimum_Depth := StrToFloat(edtHullMounted.Text);

    TimeToSecond(edtDeployTime.Text, second);
    FData.Time_2_Deploy := second;

    TimeToSecond(edtStowTime.Text, second);
    FData.Time_2_Stow := second;

    if FData.Sonar_Instance_Index = 0 then
      dmTTT.InsertSonarOnBoard(FData)
    else
      dmTTT.UpdateSonarOnBoard(FData);
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmSonarMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmSonarMount.cbMountExtensionChange(Sender: TObject);
begin
  edtName.Text := FSelectedSonar.FDef.Sonar_Identifier + ' ' +
    cbMountExtension.Text;

  btnApply.Enabled := True;
end;

function TfrmSonarMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetSonarOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedSonar.FData.Sonar_Instance_Index = 0 then
    begin
      ShowMessage('Mount Name sudah digunakan, silahkan gunakan Mount Name lain.');
      Exit;
    end
    else if LastName <> edtName.Text then
    begin
      ShowMessage('Mount Name sudah pernah digunakan, silahkan gunakan Mount Name lain');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmSonarMount.DrawBlindZone;
var
  i : Integer;
  blindZone : TBlind_Zone;
  zoneSector : TZoneSector;
begin
  FBlindZoneView.ClearZone;

  with FSelectedSonar do
  begin
    dmTTT.GetBlindZone(Ord(bzcSonar), FData.Sonar_Instance_Index, FBlind);

    blindZone := TBlind_Zone.Create;
    FBZone_1 := blindZone.FData;
    FBZone_2 := blindZone.FData;
    blindZone.Free;

    for i := 0 to FBlind.Count - 1 do
    begin
      blindZone := FBlind.Items[i];

      case blindZone.FData.BlindZone_Number of
        1: FBZone_1 := blindZone.FData;
        2: FBZone_2 := blindZone.FData;
      end;
    end;

    if (FBZone_1.BlindZone_Number <> 0) and
      (FBZone_1.Start_Angle <> FBZone_1.End_Angle) then
    begin
      zoneSector := FBlindZoneView.AddZone;
      zoneSector.StartAngle := FBZone_1.Start_Angle;
      zoneSector.EndAngle := FBZone_1.End_Angle;
    end;

    if (FBZone_2.BlindZone_Number <> 0) and
      (FBZone_2.Start_Angle <> FBZone_2.End_Angle) then
    begin
      zoneSector := FBlindZoneView.AddZone;
      zoneSector.StartAngle := FBZone_2.Start_Angle;
      zoneSector.EndAngle := FBZone_2.End_Angle;
    end;
  end;

  FBlindZoneView.Repaint;
end;

procedure TfrmSonarMount.pnlBlindZoneClick(Sender: TObject);
begin
  if FSelectedSonar.FData.Sonar_Instance_Index = 0 then
  begin
    ShowMessage('Simpan data terlebih dahulu sebelum mengubah nilai blind zone');
    Exit;
  end;

  frmBlindZonesAttachment := TfrmBlindZonesAttachment.Create(Self);
  try
    with frmBlindZonesAttachment do
    begin
      OnBoardType := bzcSonar;
      OnBoardOwner := FSelectedSonar;
      ShowModal;
    end;

    btnApply.Enabled := frmBlindZonesAttachment.AfterClose;
    btnCancel.Enabled := not frmBlindZonesAttachment.AfterClose;
  finally
    frmBlindZonesAttachment.Free;
  end;

  DrawBlindZone;
end;

procedure TfrmSonarMount.UpdateSonarData;
var
  timeStr : string;
begin
  with FSelectedSonar do
  begin
    cbMountExtension.ItemIndex := FData.Instance_Type;

    if FData.Sonar_Instance_Index = 0 then
      edtName.Text := FDef.Sonar_Identifier + ' ' + cbMountExtension.Text
    else
      edtName.Text := FData.Instance_Identifier;

    LastName := edtName.Text;
    edtClassName.Text := FDef.Sonar_Identifier;

    DrawBlindZone;

    edtHullMounted.Text := FormatFloat('0', FData.Minimum_Depth);
    SecondToTime(FData.Time_2_Deploy, timeStr);
    edtDeployTime.Text := timeStr;
    SecondToTime(FData.Time_2_Stow, timeStr);
    edtStowTime.Text := timeStr;
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmSonarMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmSonarMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmSonarMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSonarMount.ValidationFormatInput;
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
