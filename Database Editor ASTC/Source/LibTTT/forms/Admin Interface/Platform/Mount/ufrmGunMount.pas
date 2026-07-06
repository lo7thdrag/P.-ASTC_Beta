unit ufrmGunMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uDBAsset_Weapon, uDBBlind_Zone,
  uBlindZoneView, uDBAsset_Fitted, uDBAsset_Vehicle, Vcl.Imaging.pngimage;

type
  TfrmGunMount = class(TForm)
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
    pnlBlindZone: TPanel;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

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
    procedure edtQuantityChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedGun : TGun_Definition;

    FBlindZoneView : TBlindZoneView;

    function CekInput: Boolean;
    procedure UpdateGunData;
    procedure DrawBlindZone;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
    property SelectedGun : TGun_Definition read FSelectedGun write FSelectedGun;
  end;

var
  frmGunMount: TfrmGunMount;

implementation

uses
  uDataModuleTTT, ufrmAvailableVehicle, ufrmSummaryVehicle,
  ufrmMissileOnBoardPickList, ufrmBlindZoneAttachment, ufrmGunOnBoardPickList, tttData;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmGunMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmGunMount.FormCreate(Sender: TObject);
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
end;

procedure TfrmGunMount.FormDestroy(Sender: TObject);
begin
  FBlindZoneView.Free;
end;

procedure TfrmGunMount.FormShow(Sender: TObject);
begin
  UpdateGunData;

  with FSelectedGun.FPoint.FData do
    btnApply.Enabled := Point_Effect_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmGunMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

   if isOk then
    Close;
end;

procedure TfrmGunMount.btnApplyClick(Sender: TObject);
begin
  if not CekInput then
  begin
    isOK := False;
    Exit;
  end;

  ValidationFormatInput;

  with FSelectedGun do
  begin
    LastName := edtName.Text;
    FPoint.FData.Instance_Identifier := edtName.Text;
    FPoint.FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FPoint.FData.Mount_Type := cbMountExtension.ItemIndex;
    FPoint.FData.Quantity := StrToInt(edtQuantity.Text);
    FPoint.FData.Gun_Index := FData.Gun_Index;

    if FPoint.FData.Point_Effect_Index = 0 then
      dmTTT.InsertPointEffectOnBoard(1, FPoint.FData)
    else
      dmTTT.UpdatePointEffectOnBoard(1, FPoint.FData);
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmGunMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmGunMount.cbMountExtensionChange(Sender: TObject);
begin
  edtName.Text := FSelectedGun.FData.Gun_Identifier + ' ' +
    cbMountExtension.Text;

  btnApply.Enabled := True;
end;

function TfrmGunMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetPointEffectOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedGun.FPoint.FData.Point_Effect_Index = 0 then
    begin
      ShowMessage('Mount Extension sudah digunakan, silahkan gunakan Mount Extension lain.');
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

procedure TfrmGunMount.DrawBlindZone;
var
  i : Integer;
  blindZone : TBlind_Zone;
  zs : TZoneSector;
begin
  FBlindZoneView.ClearZone;

  with FSelectedGun.FPoint do
  begin
    dmTTT.GetBlindZone(Ord(bzcPointEffect), FData.Point_Effect_Index, FBlind);

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
      zs := FBlindZoneView.AddZone;
      zs.StartAngle := FBZone_1.Start_Angle;
      zs.EndAngle := FBZone_1.End_Angle;
    end;

    if (FBZone_2.BlindZone_Number <> 0) and
      (FBZone_2.Start_Angle <> FBZone_2.End_Angle) then
    begin
      zs := FBlindZoneView.AddZone;
      zs.StartAngle := FBZone_2.Start_Angle;
      zs.EndAngle := FBZone_2.End_Angle;
    end;
  end;

  FBlindZoneView.Repaint;
end;

procedure TfrmGunMount.pnlBlindZoneClick(Sender: TObject);
begin
  if FSelectedGun.FPoint.FData.Point_Effect_Index = 0 then
  begin
    ShowMessage('Simpan data terlebih dahulu sebelum mengubah nilai blind zone');
    Exit;
  end;

  frmBlindZonesAttachment := TfrmBlindZonesAttachment.Create(Self);
  try
    with frmBlindZonesAttachment do
    begin
      OnBoardType := bzcPointEffect;
      OnBoardOwner := FSelectedGun;
      ShowModal;
      DrawBlindZone;
    end;

    btnApply.Enabled := frmBlindZonesAttachment.AfterClose;
    btnCancel.Enabled := not frmBlindZonesAttachment.AfterClose;

  finally
    frmBlindZonesAttachment.Free;
  end;

end;

procedure TfrmGunMount.UpdateGunData;
begin
  with FSelectedGun do
  begin
    cbMountExtension.ItemIndex := FPoint.FData.Mount_Type;

    if FPoint.FData.Point_Effect_Index = 0 then
      edtName.Text := FData.Gun_Identifier + ' ' + cbMountExtension.Text
    else
      edtName.Text := FPoint.FData.Instance_Identifier;

    LastName := edtName.Text;
    edtClassName.Text := FData.Gun_Identifier;

    DrawBlindZone;

    edtQuantity.Text := IntToStr(FPoint.FData.Quantity);
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmGunMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmGunMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmGunMount.edtQuantityChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmGunMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmGunMount.ValidationFormatInput;
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
