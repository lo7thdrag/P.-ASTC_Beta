unit ufrmMissileMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uDBAsset_Vehicle, uDBAsset_Weapon,
  uDBBlind_Zone, uBlindZoneView, uDBAsset_Fitted, Vcl.Imaging.pngimage, Vcl.Mask;

type
  TfrmMissileMount = class(TForm)
    pnl1Title: TPanel;
    txtClass: TLabel;
    edtName: TEdit;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    General: TTabSheet;
    lblClassName: TStaticText;
    edtClassName: TEdit;
    lblMountExtension: TStaticText;
    cbMountExtension: TComboBox;
    lblBlindZones: TStaticText;
    lblQuantity: TStaticText;
    edtQuantity: TEdit;
    lblReload: TStaticText;
    lblHourReload: TStaticText;
    btnEditLaunchers: TButton;
    pnlBlindZone: TPanel;
    edtReload: TMaskEdit;
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;

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
    procedure btnEditLaunchersClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);


  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedMissile : TMissile_On_Board;

    FBlindZoneView : TBlindZoneView;

    function CekInput: Boolean;
    procedure UpdateMissileData;
    procedure DrawBlindZone;
  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
    property SelectedMissile : TMissile_On_Board read FSelectedMissile write FSelectedMissile;
  end;

var
  frmMissileMount: TfrmMissileMount;

implementation

uses
  uDataModuleTTT, ufrmBlindZoneAttachment, ufrmLauncherList, newClassASTT, tttData;

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

procedure TfrmMissileMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FBlindZoneView.Free;
//  Action := cafree;
end;

procedure TfrmMissileMount.FormCreate(Sender: TObject);
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

procedure TfrmMissileMount.FormDestroy(Sender: TObject);
begin
  FBlindZoneView.Free;
end;

procedure TfrmMissileMount.FormShow(Sender: TObject);
begin
  UpdateMissileData;

  with FSelectedMissile.FData do
    btnApply.Enabled := Fitted_Weap_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmMissileMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmMissileMount.btnApplyClick(Sender: TObject);
var
  reloadTime : Integer;
begin
  if not CekInput then
  begin
    isOK := False;
    Exit;
  end;

  ValidationFormatInput;

  with FSelectedMissile do
  begin
    LastName := edtName.Text;
    FData.Instance_Identifier := edtName.Text;
    FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FData.Mount_Type := cbMountExtension.ItemIndex;
    FData.Quantity := StrToInt(edtQuantity.Text);

    TimeToSecond(edtReload.Text, reloadTime);
    FData.Firing_Delay := reloadTime;

    FData.Missile_Index := FDef.Missile_Index;

    if FData.Fitted_Weap_Index = 0 then
      dmTTT.InsertFittedWeaponOnBoard(1, FData)
    else
      dmTTT.UpdateFittedWeaponOnBoard(1, FData);
  end;

  UpdateMissileData;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmMissileMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmMissileMount.btnEditLaunchersClick(Sender: TObject);
begin
  frmLauncherList := TfrmLauncherList.Create(Self);
  try
    with frmLauncherList do
    begin
      LauncherOwner := loMissile;
      SelectedWeapon := FSelectedMissile;
      ShowModal ;
    end;
    AfterClose := frmLauncherList.AfterClose;
  finally
    frmLauncherList.Free;
  end;

  btnCancel.Enabled := not AfterClose;
  btnApply.Enabled := AfterClose;
end;

procedure TfrmMissileMount.cbMountExtensionChange(Sender: TObject);
begin
  edtName.Text := FSelectedMissile.FDef.Class_Identifier + ' ' +
    cbMountExtension.Text;

  btnApply.Enabled := True;
end;

function TfrmMissileMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetFittedWeaponOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedMissile.FData.Fitted_Weap_Index = 0 then
    begin
      ShowMessage('Mount Name sudah digunakan, silahkan gunakan Mount Name lain.');
      Exit;
    end
    else if LastName <> edtName.Text then {dicopy}
    begin
      ShowMessage('Mount Name sudah pernah digunakan, silahkan gunakan Mount Name lain');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmMissileMount.DrawBlindZone;
var
  i : Integer;
  blindZone : TBlind_Zone;
  zoneSector : TZoneSector;

begin
  FBlindZoneView.ClearZone;

  with FSelectedMissile do
  begin
    dmTTT.GetBlindZone(Ord(bzcWeapon), FData.Fitted_Weap_Index, FBlind);

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

procedure TfrmMissileMount.pnlBlindZoneClick(Sender: TObject);
begin
  if FSelectedMissile.FData.Fitted_Weap_Index = 0 then
  begin
    ShowMessage('Simpan data terlebih dahulu sebelum mengubah nilai blind zone');
    Exit;
  end;

  frmBlindZonesAttachment := TfrmBlindZonesAttachment.Create(Self);
  try
    with frmBlindZonesAttachment do
    begin
      OnBoardType := bzcWeapon;
      OnBoardOwner := FSelectedMissile;
      ShowModal;
    end;

    btnApply.Enabled := frmBlindZonesAttachment.AfterClose;
    btnCancel.Enabled := not frmBlindZonesAttachment.AfterClose;

  finally
    frmBlindZonesAttachment.Free;
  end;

  DrawBlindZone;
end;

procedure TfrmMissileMount.UpdateMissileData;
var
  timeStr : string;
begin
  with FSelectedMissile do
  begin
    cbMountExtension.ItemIndex := FData.Mount_Type;

    if FData.Fitted_Weap_Index = 0 then
      edtName.Text := FDef.Class_Identifier + ' ' + cbMountExtension.Text
    else
      edtName.Text := FData.Instance_Identifier;

    LastName := edtName.Text;
    edtClassName.Text := FDef.Class_Identifier;

    DrawBlindZone;

    edtQuantity.Text := IntToStr(FData.Quantity);
    SecondToTime(Round(FData.Firing_Delay), timeStr);
    edtReload.Text := timeStr;

    btnEditLaunchers.Enabled := FData.Fitted_Weap_Index <> 0;
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmMissileMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmMissileMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmMissileMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmMissileMount.ValidationFormatInput;
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
