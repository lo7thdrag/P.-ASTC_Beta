unit ufrmBombDepthChargeMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Weapon,
  Vcl.Imaging.pngimage;

type
  TfrmBombDepthChargeMount = class(TForm)
    PageControl1: TPageControl;
    General: TTabSheet;
    lblClassName: TStaticText;
    edtClassName: TEdit;
    lblMountExtension: TStaticText;
    cbMountExtension: TComboBox;
    lblQuantity: TStaticText;
    edtQuantity: TEdit;
    pnlMainBackground: TPanel;
    pnl2ControlPage: TPanel;
    pnl1Title: TPanel;
    edtName: TEdit;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    txtClass: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    //Global
    function GetNumberOfKoma(s : string): Boolean;
    procedure edtNumeralKeyPress(Sender: TObject; var Key: Char);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    procedure cbMountExtensionChange(Sender: TObject);

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedBomb : TBomb_Definition;

    function CekInput: Boolean;
    procedure UpdateBombData;
  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
    property SelectedBomb : TBomb_Definition read FSelectedBomb write FSelectedBomb;
  end;

var
  frmBombDepthChargeMount: TfrmBombDepthChargeMount;

implementation

uses
  uDataModuleTTT, ufrmAvailableVehicle, ufrmSummaryVehicle,
  uMissileLaunchers, ufrmMissileOnBoardPickList, ufrmBombOnBoardPickList;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmBombDepthChargeMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
end;

procedure TfrmBombDepthChargeMount.FormShow(Sender: TObject);
begin
  UpdateBombData;

  with FSelectedBomb.FPoint.FData do
    btnApply.Enabled := Point_Effect_Index = 0;

    isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmBombDepthChargeMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmBombDepthChargeMount.btnApplyClick(Sender: TObject);
begin
  if not CekInput then
  begin
    isOK := False;
    Exit;
  end;

  ValidationFormatInput;

  with FSelectedBomb do
  begin
    LastName := edtName.Text;
    FPoint.FData.Instance_Identifier := edtName.Text;
    FPoint.FData.Instance_Type := FData.Bomb_Type;
    FPoint.FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FPoint.FData.Mount_Type := cbMountExtension.ItemIndex;
    FPoint.FData.Quantity := StrToInt(edtQuantity.Text);
    FPoint.FData.Bomb_Index := FData.Bomb_Index;

    if FPoint.FData.Point_Effect_Index = 0 then
      dmTTT.InsertPointEffectOnBoard(2, FPoint.FData)
    else
      dmTTT.UpdatePointEffectOnBoard(2, FPoint.FData);
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmBombDepthChargeMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmBombDepthChargeMount.cbMountExtensionChange(Sender: TObject);
begin
  edtName.Text := FSelectedBomb.FData.Bomb_Identifier + ' ' + cbMountExtension.Text;

  btnApply.Enabled := True;
end;

function TfrmBombDepthChargeMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetPointEffectOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedBomb.FPoint.FData.Point_Effect_Index = 0 then
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

procedure TfrmBombDepthChargeMount.UpdateBombData;
begin
  with FSelectedBomb do
  begin
    cbMountExtension.ItemIndex := FPoint.FData.Mount_Type;

    if FPoint.FData.Point_Effect_Index = 0 then
      edtName.Text := FData.Bomb_Identifier + ' ' + cbMountExtension.Text
    else
      edtName.Text := FPoint.FData.Instance_Identifier;

    LastName := edtName.Text;

    edtClassName.Text := FData.Bomb_Identifier;
    edtQuantity.Text := IntToStr(FPoint.FData.Quantity);
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmBombDepthChargeMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmBombDepthChargeMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmBombDepthChargeMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmBombDepthChargeMount.ValidationFormatInput;
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
