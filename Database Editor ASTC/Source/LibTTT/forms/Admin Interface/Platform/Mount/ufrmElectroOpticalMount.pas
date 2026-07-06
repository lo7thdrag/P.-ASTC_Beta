unit ufrmElectroOpticalMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Vcl.Imaging.pngimage,

  uDBAsset_Vehicle, uDBAsset_Sensor, uBlindZoneView;

type
  TfrmElectroOpticalMount = class(TForm)
    PageControl1: TPageControl;
    General: TTabSheet;
    lblClassName: TStaticText;
    edtClassName: TEdit;
    lblMountExtension: TStaticText;
    cbMountExtension: TComboBox;
    lblBlindZones: TStaticText;
    pnlBlindZone: TPanel;
    lblAntenna: TStaticText;
    edtAntenna: TEdit;
    lblFeetAntenna: TStaticText;
    pnlMainBackground: TPanel;
    pnl2ControlPage: TPanel;
    pnl1Title: TPanel;
    edtName: TEdit;
    pnl3Button: TPanel;
    imgExercise: TImage;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    txtClass: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    //Global
    function GetNumberOfKoma(s : string): Boolean;
    procedure edtNumeralKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBoxDataChange(Sender: TObject);
    procedure CheckBoxDataClick(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    procedure cbMountExtensionChange(Sender: TObject);
    procedure pnlBlindZoneClick(Sender: TObject);
    procedure edtAntennaKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedEO : TEOD_On_Board;

    FBlindZoneView : TBlindZoneView;

    function CekInput: Boolean;
    procedure UpdateEOData;
    procedure DrawBlindZone;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
    property SelectedEO : TEOD_On_Board read FSelectedEO write FSelectedEO;
  end;

var
  frmElectroOpticalMount: TfrmElectroOpticalMount;

implementation

uses
  uDataModuleTTT, ufrmEODOnBoardPickList, ufrmBlindZoneAttachment, uDBBlind_Zone, tttData;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmElectroOpticalMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FBlindZoneView.Free;
//  Action := cafree;
end;

procedure TfrmElectroOpticalMount.FormCreate(Sender: TObject);
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

procedure TfrmElectroOpticalMount.FormDestroy(Sender: TObject);
begin
  FBlindZoneView.Free;
end;

procedure TfrmElectroOpticalMount.FormShow(Sender: TObject);
begin
  UpdateEOData;

  with FSelectedEO.FData do
    btnApply.Enabled := EO_Instance_Index = 0;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmElectroOpticalMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

   if isOk then
    Close;
end;

procedure TfrmElectroOpticalMount.btnApplyClick(Sender: TObject);
begin
  if not CekInput then
  begin
    isOK := False;
    Exit;
  end;

  ValidationFormatInput;

  with FSelectedEO do
  begin
    LastName := edtName.Text;
    FData.Instance_Identifier := edtName.Text;
    FData.Instance_Type := cbMountExtension.ItemIndex;
    FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FData.EO_Index := FEO_Def.EO_Index;
    FData.Antenna_Height := StrToFloat(edtAntenna.Text);

    if FData.EO_Instance_Index = 0 then
      dmTTT.InsertEOOnBoard(FData)
    else
      dmTTT.UpdateEOOnBoard(FData);
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmElectroOpticalMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmElectroOpticalMount.cbMountExtensionChange(Sender: TObject);
begin
  edtName.Text := FSelectedEO.FEO_Def.Class_Identifier + ' ' +
    cbMountExtension.Text;

  btnApply.Enabled := True;
end;

function TfrmElectroOpticalMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetEOOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedEO.FData.EO_Instance_Index = 0 then
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

procedure TfrmElectroOpticalMount.DrawBlindZone;
var
  i : Integer;
  blindZone : TBlind_Zone;
  zs : TZoneSector;
begin
  FBlindZoneView.ClearZone;

  with FSelectedEO do
  begin
    dmTTT.GetBlindZone(Ord(bzcEO), FData.EO_Instance_Index,
      FBlind);

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

procedure TfrmElectroOpticalMount.edtAntennaKeyPress(Sender: TObject;var Key: Char);
begin
  if not (Key in [#48 .. #57, #8, #13, #46]) then
    Key := #0;

  if Key = #13 then
  begin
    edtAntenna.Text := FormatFloat('0.0', StrToFloat(edtAntenna.Text));
    btnApply.Enabled := True;
  end;
end;

procedure TfrmElectroOpticalMount.pnlBlindZoneClick(Sender: TObject);
begin
  if FSelectedEO.FData.EO_Instance_Index = 0 then
  begin
    ShowMessage('Simpan data terlebih dahulu sebelum mengubah nilai blind zone');
    Exit;
  end;

  frmBlindZonesAttachment := TfrmBlindZonesAttachment.Create(Self);
  try
    with frmBlindZonesAttachment do
    begin
      OnBoardType := bzcEO;
      OnBoardOwner := FSelectedEO;
      ShowModal;
      DrawBlindZone;
    end;
  finally
    frmBlindZonesAttachment.Free;
  end;

end;

procedure TfrmElectroOpticalMount.UpdateEOData;
begin
  with FSelectedEO do
  begin
    cbMountExtension.ItemIndex := FData.Instance_Type;

    if FData.EO_Instance_Index = 0 then
      edtName.Text := FEO_Def.Class_Identifier + ' ' + cbMountExtension.Text
    else
      edtName.Text := FData.Instance_Identifier;

    LastName := edtName.Text;
    edtClassName.Text := FEO_Def.Class_Identifier;

    DrawBlindZone;

    edtAntenna.Text := FormatFloat('0.0', FData.Antenna_Height);
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmElectroOpticalMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmElectroOpticalMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmElectroOpticalMount.CheckBoxDataClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmElectroOpticalMount.ComboBoxDataChange(Sender: TObject);
begin
  if TComboBox(Sender).ItemIndex = -1 then
    TComboBox(Sender).ItemIndex := 0;

  btnApply.Enabled := True;
end;

procedure TfrmElectroOpticalMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmElectroOpticalMount.ValidationFormatInput;
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
