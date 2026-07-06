unit ufrmAccousticDecoyMount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uDBAsset_Vehicle,
  uDBAsset_Countermeasure, Vcl.Imaging.pngimage;

type
  TfrmAccousticDecoyMount = class(TForm)
    pgc1: TPageControl;
    tsGeneral: TTabSheet;
    txtQuantity: TStaticText;
    edtQuantity: TEdit;
    pnlMainBackground: TPanel;
    pnl2ControlPage: TPanel;
    pnl1Title: TPanel;
    txtClass: TLabel;
    edtName: TEdit;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnOK: TButton;
    btnCancel: TButton;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    //Global
    function GetNumberOfKoma(s : string): Boolean;
    procedure edtNumeralKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBoxDataChange(Sender: TObject);
    procedure CheckBoxDataClick(Sender: TObject);
    procedure edtChange(Sender: TObject);
    procedure ValidationFormatInput();

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

  private
    FSelectedVehicle : TVehicle_Definition;
    FSelectedAcousticDecoy : TAcoustic_Decoy_On_Board;

    function CekInput: Boolean;
    procedure UpdateAcouticDecoyData;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    LastName : string;

    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
    property SelectedAcousticDecoy : TAcoustic_Decoy_On_Board read FSelectedAcousticDecoy write FSelectedAcousticDecoy;
  end;

var
  frmAccousticDecoyMount: TfrmAccousticDecoyMount;

implementation

uses
  uDataModuleTTT;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmAccousticDecoyMount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
end;

procedure TfrmAccousticDecoyMount.FormShow(Sender: TObject);
begin
  UpdateAcouticDecoyData;

  with FSelectedAcousticDecoy.FData do
    btnApply.Enabled := Acoustic_Instance_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAccousticDecoyMount.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmAccousticDecoyMount.btnApplyClick(Sender: TObject);
begin
  with FSelectedAcousticDecoy do
  begin
    LastName := edtName.Text;
    FData.Instance_Identifier := edtName.Text;
    FData.Instance_Type := 0;
    FData.Quantity := StrToInt(edtQuantity.Text);
    FData.Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
    FData.Decoy_Index := FAccousticDecoy_Def.Decoy_Index;

    if FData.Acoustic_Instance_Index = 0 then
      dmTTT.InsertAcousticDecoyOnBoard(FData)
    else
      dmTTT.UpdateAcousticDecoyOnBoard(FData);
  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmAccousticDecoyMount.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

function TfrmAccousticDecoyMount.CekInput: Boolean;
begin
  Result := False;

  {Jika Mount Name sudah ada}
  if dmTTT.GetAcousticDecoyOnBoardCount(FSelectedVehicle.FData.Vehicle_Index, edtName.Text) then
  begin
    {Jika inputan baru}
    if FSelectedAcousticDecoy.FData.Acoustic_Instance_Index = 0 then
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

procedure TfrmAccousticDecoyMount.UpdateAcouticDecoyData;
begin
  with FSelectedAcousticDecoy do
  begin
    if FData.Acoustic_Instance_Index = 0 then
      edtName.Text := FAccousticDecoy_Def.Decoy_Identifier
    else
      edtName.Text := FData.Instance_Identifier;

     LastName := edtName.Text;

    edtQuantity.Text := IntToStr(FData.Quantity);
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

function TfrmAccousticDecoyMount.GetNumberOfKoma(s: string): Boolean;
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

procedure TfrmAccousticDecoyMount.edtNumeralKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmAccousticDecoyMount.CheckBoxDataClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmAccousticDecoyMount.ComboBoxDataChange(Sender: TObject);
begin
  if TComboBox(Sender).ItemIndex = -1 then
    TComboBox(Sender).ItemIndex := 0;

  btnApply.Enabled := True;
end;

procedure TfrmAccousticDecoyMount.edtChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmAccousticDecoyMount.ValidationFormatInput;
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
