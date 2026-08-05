unit uUserLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_UserLogin, uAdministrator,
  Vcl.Imaging.pngimage;

type
  TfrmUserLogin = class(TForm)
    pnl2: TPanel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl4: TLabel;
    bvl1: TBevel;
    lbl8: TLabel;
    bvl2: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    cbbPrivilege: TComboBox;
    edtConfirmPassword: TEdit;
    edtPassword: TEdit;
    edtUser: TEdit;
    lbl1: TLabel;
    edtName: TEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    btnShowPassword: TImage;
    btnShowPassword2: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnShowPasswordClick(Sender: TObject);
    procedure btnShowPassword2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure getData;

  public
    { Public declarations }
    isNew : Boolean;
    UserLogin : TUser_Login;
  end;

var
  frmUserLogin: TfrmUserLogin;

implementation

uses uDataModuleTTT;


{$R *.dfm}

procedure TfrmUserLogin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUserLogin.btnOKClick(Sender: TObject);
begin
  if not (edtPassword.Text = edtConfirmPassword.Text) then
  begin
    ShowMessage('confirm password invalid!!');
    Exit;
  end;

  getData;

  if isNew then
  begin
    if dmTTT.CekUserLoginNameAlreadyExist(edtUser.Text) then
    begin
      ShowMessage('Already exist username!!');
      Exit;
    end;
    dmTTT.InsertUserLogin(UserLogin);
    isNew := False;
    ShowMessage('Successfully saved.');
  end
  else
  begin
    dmTTT.UpdateUserLogin(UserLogin);
  end;

  ModalResult := mrOK;
//  Exit;
//  frmAdministrator.refresh;
end;

procedure TfrmUserLogin.FormCreate(Sender: TObject);
begin
  UserLogin := TUser_Login.Create;

end;

procedure TfrmUserLogin.FormDestroy(Sender: TObject);
begin
  UserLogin.Free;
  frmUserLogin := nil;
end;

procedure TfrmUserLogin.FormShow(Sender: TObject);
begin
  if isNew then
  begin
    edtName.Text := '';
    edtUser.Text := '';
    edtPassword.Text := '';
    edtConfirmPassword.Text := '';
    cbbPrivilege.ItemIndex := 0;
  end
  else
  begin
    with UserLogin.FData do
    begin
      edtName.Text := Name;
      edtUser.Text := Username;
      edtPassword.Text := Password;
      edtConfirmPassword.Text := Password;

      if Privilege = 'Admin System' then
       cbbPrivilege.ItemIndex := 0
      else if Privilege = 'Scenario Builder'  then
        cbbPrivilege.ItemIndex := 1
      else if Privilege = 'Data Modifier'  then
        cbbPrivilege.ItemIndex := 2

    end;
  end;
end;

procedure TfrmUserLogin.getData;
begin

  with UserLogin.FData do
  begin
    Name := edtName.Text;
    Username := edtUser.Text;
    Password := edtPassword.Text;
    Privilege := cbbPrivilege.Text;
  end;


end;

procedure TfrmUserLogin.btnShowPassword2Click(Sender: TObject);
begin
  if (edtConfirmPassword.PasswordChar = '*') then
  begin
    btnShowPassword2.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnShowPassword.png');
    edtConfirmPassword.PasswordChar := #0;
  end
  else
  begin
    btnShowPassword2.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnHidePassword.png');
    edtConfirmPassword.PasswordChar := '*';
  end;
end;

procedure TfrmUserLogin.btnShowPasswordClick(Sender: TObject);
begin
  if (EdtPassword.PasswordChar = '*') then
  begin
    btnShowPassword.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnShowPassword.png');
    EdtPassword.PasswordChar := #0;
  end
  else
  begin
    btnShowPassword.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnHidePassword.png');
    EdtPassword.PasswordChar := '*';
  end
end;

end.
