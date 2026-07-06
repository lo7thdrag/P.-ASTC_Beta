unit ufrmRoleSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls,

  uLibSettingTTT, ufMainGC;

type
  TfrmRoleSetting = class(TForm)
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    cbbRole: TComboBox;
    lblRole: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    cbTacticalSreen: TComboBox;
    cbToteScreen: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbTacticalSreenChange(Sender: TObject);
    procedure cbToteScreenChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRoleSetting: TfrmRoleSetting;

implementation

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

procedure TfrmRoleSetting.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRoleSetting.btnOKClick(Sender: TObject);
begin
//   if cbTacticalSreen.ItemIndex =
//     cbToteScreen.ItemIndex then
//  begin
//    ShowMessage(
//      'Tactical Screen dan Tote Screen tidak boleh menggunakan monitor yang sama');
//    Exit;
//  end;

  {Set Nilai Role}
  vGameDataSetting.Role := cbbRole.ItemIndex;
  frmMainGC.lblrole.Caption := cbbRole.Text;

  {Set Nilai Monitor Screen}
  vGameDataSetting.TacticalScreen := cbTacticalSreen.ItemIndex;
  vGameDataSetting.ToteScreen := cbToteScreen.ItemIndex;

  {Menyimpan ke setting.ini}
  SaveFF_GameSetting(vSettingFile, vGameDataSetting);

  Close
end;


procedure TfrmRoleSetting.cbTacticalSreenChange(Sender: TObject);
begin
//   if cbTacticalSreen.ItemIndex =
//     cbToteScreen.ItemIndex then
//  begin
//    ShowMessage(
//      'Tactical Screen dan Tote Screen harus berbeda');
//    cbTacticalSreen.ItemIndex := -1;
//  end;
end;

procedure TfrmRoleSetting.cbToteScreenChange(Sender: TObject);
begin
//    if cbTacticalSreen.ItemIndex =
//     cbToteScreen.ItemIndex then
//  begin
//    ShowMessage(
//      'Tactical Screen dan Tote Screen harus berbeda');
//    cbToteScreen.ItemIndex := -1;
//end;
end;

procedure TfrmRoleSetting.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  EnableComposited(pnlMainBackground);

  cbTacticalSreen.Clear;
  cbToteScreen.Clear;

  for I := 0 to Screen.MonitorCount - 1 do
  begin
    cbTacticalSreen.Items.Add(
      Format('Monitor %d', [I + 1]));

    cbToteScreen.Items.Add(
      Format('Monitor %d', [I + 1]));
  end;

  cbTacticalSreen.ItemIndex := 0;

  if Screen.MonitorCount > 1 then
    cbToteScreen.ItemIndex := 1
  else
    cbToteScreen.ItemIndex := 0;
end;

end.
