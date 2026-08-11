unit ufrmUserMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.jpeg,

  tttData,uDBAsset_UserLogin, uDataModuleTTT ;

type
  TfrmUserMainForm = class(TForm)
    Timer1: TTimer;
    pnlMainBackground: TPanel;
    pnlFooter: TPanel;
    img4: TImage;
    pnlHeader: TPanel;
    img3: TImage;
    pnlHome: TPanel;
    s: TImage;
    pnlLeft: TPanel;
    pnl1ExerciseBody: TPanel;
    Image3: TImage;
    Image4: TImage;
    img1: TImage;
    img2: TImage;
    mnEnvironment: TLabel;
    mnGameArea11: TLabel;
    mnResourceAllocation: TLabel;
    mnScenario: TLabel;
    pnl1Exercise: TPanel;
    imgExercise: TImage;
    pnl2Platforms: TPanel;
    imgPlatforms: TImage;
    pnl2PlatformsBody: TPanel;
    Image1: TImage;
    Image6: TImage;
    mnSatelite: TLabel;
    mnVehicle: TLabel;
    pnl1ExerciseSparator: TPanel;
    pnl2PlatformsSparator: TPanel;
    pnl3SensorsBody: TPanel;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image9: TImage;
    mnElectroOpticalDetector: TLabel;
    mnESM: TLabel;
    mnMAD: TLabel;
    mnRadar: TLabel;
    mnSonar: TLabel;
    mnSonobuoy: TLabel;
    pnl3SensorsSparator: TPanel;
    pnl4Weapons: TPanel;
    imgWeapons: TImage;
    pnl4WeaponsBody: TPanel;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    mnBomb: TLabel;
    mnGun: TLabel;
    mnMine: TLabel;
    mnMissile: TLabel;
    mnTorpedo: TLabel;
    pnl4WeaponsSparator: TPanel;
    pnl5Countermeasur: TPanel;
    imgCountermeasures: TImage;
    pnl5CountermeasuresBody: TPanel;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    mnAcousticDecoy: TLabel;
    mnAirBubble: TLabel;
    mnChaff: TLabel;
    mnFloatingDecoy: TLabel;
    mnInfraredDecoy: TLabel;
    mnRadarNoiseJammer: TLabel;
    mnSelfDefensiveJammer: TLabel;
    mnTowedJammerDecoy: TLabel;
    pnl5CountermeasuresSparator: TPanel;
    pnl6Other: TPanel;
    imgOther: TImage;
    pnl6OtherBody: TPanel;
    Image48: TImage;
    Image49: TImage;
    Image50: TImage;
    Image51: TImage;
    Image52: TImage;
    mnGameDefaults: TLabel;
    mnGraphicalOverlays: TLabel;
    mnRuntimePlatformLibrary: TLabel;
    mnSNRvsPODCurve: TLabel;
    mnGameArea: TLabel;
    Image15: TImage;
    mnWaypoint: TLabel;
    Image7: TImage;
    mnMotion: TLabel;
    pnl6OtherSparator: TPanel;
    pnl8Shutdown: TPanel;
    imgShutdown: TImage;
    pnl8ShutdownBody: TPanel;
    Image66: TImage;
    mnShutdownDatabaseEditor: TLabel;
    pnl8ShutdownSparator: TPanel;
    pnl3Sensors: TPanel;
    imgSensors: TImage;
    pnlSparatorFooter: TPanel;
    pnlSparatorHeader: TPanel;
    pnlSparatorLeft: TPanel;
    pnlSparatorCenterLeft: TPanel;
    imgBackground: TImage;
    img5: TImage;
    mnTransport: TLabel;
    img6: TImage;
    mnLogistic: TLabel;
    pnlUserLogin: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    btnUserLogin: TImage;
    edtUsername: TEdit;
    edtPasword: TEdit;
    btnShowPassword: TImage;
    lbl5: TLabel;
    pnlLogin: TPanel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    btnEdit: TImage;
    btnLogOut: TImage;
    lbl10: TLabel;
    lblUsername: TLabel;
    lblStatus: TLabel;
    img7: TImage;
    img8: TImage;
    btnRegister: TImage;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure LoginImageMouseEnter(sender : TObject);
    procedure LoginImageMouseLeave(sender : TObject);

    {$REGION ' Navbar Section '}

    procedure Timer1Timer(Sender: TObject);
    procedure CollapseMenuClick(Sender: TObject);
    procedure UnCollapseMenuClick();
    procedure MainMenuClick(Sender: TObject);

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);
    procedure SubMenuMouseEnter(Sender: TObject);
    procedure SuMenuMouseLeave(Sender: TObject);
    procedure ShutdownDatabaseEditor1Click(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnShowPasswordClick(Sender: TObject);
    procedure btnUserLoginClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);


    {$ENDREGION}

  private
    CurrentForm: TForm;
    isFold : boolean;
    pnlActive : Integer;

    IsLogin: Boolean;

    iconName : string;
    filePath, imgChoice : string;

    FDockedForm : TForm;

    CurrentUser : TUser_Login;

    procedure IconLoad;
    procedure DockForm(aForm: TForm);
    procedure Privilege;


  public
     UserLogin : TUser_Login;

//    procedure LoadImageVariasi(i : byte);
    procedure FormFactory(aFormType: E_FormType; aDocked: Boolean = False);
  end;

var
  frmUserMainForm: TfrmUserMainForm;

implementation

uses
  ufrmExercise, ufrmPlatforms, ufrmSensors, ufrmWeapons, ufrmCountermeasure, ufrmOther, ufrmShutDown,

  ufrmAvailableScenario, ufrmAvailableResourceAllocation, {ufrmAvailableEnvironments,}

  ufrmAvailableVehicle,

  ufrmAvailableRadar, ufrmAvailableSonar,ufrmAvailableESM, ufrmAvailableEOD,
  ufrmAvailableSonobuoy,ufrmAvailableMAD,

  ufrmAvailableMissile, ufrmAvailableTorpedo,ufrmAvailableMine, ufrmAvailableGun,
  ufrmAvailableBomb,

  ufrmAvailableAcousticDecoy, ufrmAvailableAirBubble, ufrmAvailableChaff,
  ufrmAvailableInfraredDecoy, ufrmAvailableFloatingDecoy, ufrmAvailableSelfDefensiveJammer,
  ufrmAvailableTowedJammerDecoy, ufrmAvailableRadarNoiseJammer,

  ufrmAvailableRuntimePlatformLibrary, ufrmAvailableOverlay, ufrmAvailableLogistic,
  ufrmAvailableTransport, ufrmAvailableWaypoint, ufrmAvailableGameArea, ufrmAvailableMotion,
  ufrmAvailableGameDefault, ufrmAvailableSNRvsPOD, uUserLogin, uSession;

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

{$Region ' Form Handle '}

procedure TfrmUserMainForm.FormCreate(Sender: TObject);
begin
  CurrentUser := TUser_Login.Create;

  IsLogin := False;

  EnableComposited(pnlMainBackground);
  EnableComposited(pnlLeft);

  pnl1ExerciseBody.Height := 0;
  pnl2PlatformsBody.Height := 0;
  pnl3SensorsBody.Height := 0;
  pnl4WeaponsBody.Height := 0;
  pnl5CountermeasuresBody.Height := 0;
  pnl6OtherBody.Height := 0;
  pnl8ShutdownBody.Height := 0;

end;

procedure TfrmUserMainForm.FormDestroy(Sender: TObject);
begin
   CurrentUser.Free;
end;

procedure TfrmUserMainForm.FormShow(Sender: TObject);
begin
 pnlUserLogin.Top := 685;
 pnlLogin.Top := 685;
end;

{$ENDREGION}

{$REGION ' Menu Section '}

procedure TfrmUserMainForm.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Main\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmUserMainForm.LoginImageMouseEnter(sender: TObject);
begin
  if Sender = btnRegister then
    btnRegister.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\rgstr2.png')
  else if Sender = btnEdit then
    btnEdit.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\edt6.png')
  else if sender = btnUserLogin then
    btnUserLogin.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\lgn2.png')
  else if sender = btnLogOut then
    btnLogOut.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\lgt2.png');
end;

procedure TfrmUserMainForm.LoginImageMouseLeave(sender: TObject);
begin
   if Sender = btnRegister then
    btnRegister.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\rgstr (1).png')
   else if Sender = btnEdit then
    btnEdit.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\edt5 (1).png')
   else if sender = btnUserLogin then
    btnUserLogin.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\lgn (1).png')
    else if sender = btnLogOut then
    btnLogOut.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\lgt (1).png');
end;

procedure TfrmUserMainForm.btnEditClick(Sender: TObject);
begin
  frmUserLogin := TfrmUserLogin.Create(nil);
  try
    frmUserLogin.isNew := False;

    with frmUserLogin.UserLogin.FData do
    begin
      Login_Index := CurrentUser.FData.Login_Index;
      Name := CurrentUser.FData.Name;
      Username := CurrentUser.FData.Username;
      Password := CurrentUser.FData.Password;
      Privilege := CurrentUser.FData.Privilege;
    end;

    if CurrentUser.FData.Privilege = 'Admin' then
    begin
      frmUserLogin.cbbPrivilege.Items.Clear;
      frmUserLogin.cbbPrivilege.Items.Add('Admin');
      frmUserLogin.cbbPrivilege.ItemIndex := 0;
      frmUserLogin.cbbPrivilege.Enabled := False;
    end;

    if frmUserLogin.ShowModal = mrOK then
    begin
      if CurrentUser.FData.Privilege = 'Admin System' then
        frmUserLogin.UserLogin.FData.Privilege := 'Admin System'
      else if CurrentUser.FData.Privilege = 'Admin' then
        frmUserLogin.UserLogin.FData.Privilege := 'Admin';

      CurrentUser.FData := frmUserLogin.UserLogin.FData;

      lblUsername.Caption := CurrentUser.FData.Username;
      lblStatus.Caption := CurrentUser.FData.Privilege;
    end;
  finally
    FreeAndNil(frmUserLogin);
  end;
end;

procedure TfrmUserMainForm.btnLogOutClick(Sender: TObject);
begin
  MainMenuClick(imgShutdown);

  IsLogin := False;

  uSession.CurrentUser := '';
  uSession.CurrentName := '';

  edtUsername.Clear;
  edtPasword.Clear;

  lblUsername.Caption := '';
  lblStatus.Caption := '';

  pnlUserLogin.BringToFront;
end;

procedure TfrmUserMainForm.btnRegisterClick(Sender: TObject);
begin
  frmUserLogin := TfrmUserLogin.Create(nil);
  try
    frmUserLogin.isNew := True;
    frmUserLogin.ShowModal;
  finally
    FreeAndNil(frmUserLogin);
  end;
end;

procedure TfrmUserMainForm.btnUserLoginClick(Sender: TObject);
begin
  if Trim(edtUsername.Text) = '' then
  begin
    ShowMessage('Silahkan masukkan username.');
    edtUsername.SetFocus;
    Exit;
  end;

  if Trim(edtPasword.Text) = '' then
  begin
    ShowMessage('Silahkan masukkan Password.');
    edtPasword.SetFocus;
    Exit;
  end;

  if dmTTT.GetValidasiUserLogin(edtUsername.Text,edtPasword.Text,CurrentUser) then
  begin
    IsLogin := True;

    uSession.CurrentUser := CurrentUser.FData.Username;
    uSession.CurrentName := CurrentUser.FData.Name;

    pnlLogin.BringToFront;

    lblUsername.Caption := CurrentUser.FData.Username;
    lblStatus.Caption := CurrentUser.FData.Privilege;

    if CurrentUser.FData.Privilege = 'Admin' then
    begin
      btnEdit.Left    := 162;
      btnLogOut.Left  := 62;
      btnRegister.Visible := False;
    end
    else
    begin
      btnEdit.Left    := 113;
      btnLogOut.Left  := 13;
      btnRegister.Visible := True;
    end;
//    ShowMessage('Login Berhasil!');
  end
  else
  begin
    ShowMessage('Username atau password salah');
  end;

end;

procedure TfrmUserMainForm.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Main\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmUserMainForm.MainMenuClick(Sender: TObject);
begin
   if Sender is TImage then
    pnlActive := TImage(Sender).Tag
  else if Sender is TPanel then
    pnlActive := TPanel(Sender).Tag
  else
    Exit;


  // CEK LOGIN DULU
  if (pnlActive in [1,2,3,4]) and (not IsLogin) then
  begin
    ShowMessage('Silakan login terlebih dahulu.');
    pnlUserLogin.BringToFront;
    Exit;
  end;


  // BARU BUKA FORM
  FormFactory(E_FormType(pnlActive),True);

  CollapseMenuClick(Sender);
end;

procedure TfrmUserMainForm.Privilege;
//var
//  i : Integer;
begin
//  if aNamePrivilege = 'Admin System' then
//  begin
//     for I := 0 to frmAdminMainForm.MainMenu1.Items.Count - 1 do
//    begin
//      frmAdminMainForm.MainMenu1.Items[i].Enabled := True;
//    end;
//    fVehicleSelect.btnNew.Enabled := True;
//    fVehicleSelect.btnCopy.Enabled := True;
//    fVehicleSelect.btnEdit.Enabled := True;

//  end
//  else if aNamePrivilege = 'Scenario Builder' then
//  begin
////    for I := 0 to frmAdminMainForm.MainMenu1.Items.Count - 1 do
////    begin
////      frmAdminMainForm.MainMenu1.Items[i].Enabled := False;
////    end;
//
////    frmAdminMainForm.MainMenu1.Items[9].Enabled := True;
//    fVehicleSelect.btnNew.Enabled := False;
//    fVehicleSelect.btnCopy.Enabled := False;
//    fVehicleSelect.btnEdit.Enabled := False;
//
//  end
end;

procedure TfrmUserMainForm.SuMenuMouseLeave(Sender: TObject);
begin
  TLabel(sender).Font.Color := clWhite;
end;

procedure TfrmUserMainForm.SubMenuMouseEnter(Sender: TObject);
begin
  TLabel(sender).Font.Color := clAqua;
end;

procedure TfrmUserMainForm.SubMenuClick(Sender: TObject);
var
  subMenuTemp : Integer;

begin
  if Sender is TLabel then
    subMenuTemp := TLabel(sender).Tag
  else
    Exit;

//  LoadImageVariasi(1);
  FormFactory(E_FormType(subMenuTemp),True);
end;

procedure TfrmUserMainForm.ShutdownDatabaseEditor1Click(Sender: TObject);
var warning : Integer;
begin
  warning := MessageDlg('Shutdown Database Editor?',mtWarning,[mbYes,mbNo],0);
  if warning = mrYes then
  begin
    try
      Self.Close;
    finally
      free;
    end;
  end;
end;

{$ENDREGION}

{$REGION ' Navbar Section '}

//procedure TfrmUserMainForm.LoadImageVariasi(i: byte);
//begin
////  pnlVariasi.Visible := i = 0;
////  pnlVariasi.Visible := False;
//end;

procedure TfrmUserMainForm.DockForm(aForm: TForm);
begin
  if Assigned(FDockedForm) and (FDockedForm <> aForm) then
    FDockedForm.Hide;

  FDockedForm := aForm;

  with FDockedForm do
  begin
    Left := 0;
    Top := 0;
    Position := poDefault;
    BorderStyle := bsNone;
    ParentColor := True;
    Parent := pnlHome;
    Align := alClient;
//    OnClose := FormOnClose;
    Show;
  end;
end;

procedure TfrmUserMainForm.FormFactory(aFormType: E_FormType; aDocked: Boolean);
var
  aForm : TForm;
begin
  aForm := nil;

  case aFormType of

    {$REGION ' Main Menu '}
    ftfrmSensor :
    begin
      if not Assigned(frmSensors) then
          frmSensors := TfrmSensors.Create(self);

      aForm := frmSensors;
    end;
    ftfrmWeapon :
    begin
      if not Assigned(frmWeapons) then
          frmWeapons := TfrmWeapons.Create(self);

      aForm := frmWeapons;
    end;
    ftfrmCountermaesure :
    begin
      if not Assigned(frmCountermeasure) then
          frmCountermeasure := TfrmCountermeasure.Create(self);

      aForm := frmCountermeasure;
    end;
    ftfrmPlatform :
    begin
      if not Assigned(frmPlatforms) then
          frmPlatforms := TfrmPlatforms.Create(self);

      aForm := frmPlatforms;
    end;
    ftfrmOther :
    begin
      if not Assigned(frmOther) then
          frmOther := TfrmOther.Create(self);

      aForm := frmOther;
    end;
    ftfrmExercise :
    begin
      if not Assigned(frmExercise) then
          frmExercise := TfrmExercise.Create(self);

      aForm := frmExercise;
    end;
    ftShutdown :
    begin
      if not Assigned(frmShutDown) then
          frmShutDown := TfrmShutDown.Create(self);

      aForm := frmShutDown;
//      frmShutDown.BringToFront;
//      Exit
    end;
    {$ENDREGION}

    {$REGION ' Sensor Sub Menu '}
    ftfrmAvailableRadar :
    begin
      if not Assigned(frmAvailableRadar) then
          frmAvailableRadar := TfrmAvailableRadar.Create(self);

      aForm := frmAvailableRadar;
    end;
    ftfrmAvailableSonar :
    begin
      if not Assigned(frmAvailableSonar) then
          frmAvailableSonar := TfrmAvailableSonar.Create(self);

      aForm := frmAvailableSonar;
    end;
    ftfrmAvailableESM :
    begin
      if not Assigned(frmAvailableESM) then
          frmAvailableESM := TfrmAvailableESM.Create(self);

      aForm := frmAvailableESM;
    end;
    ftfrmAvailableEOD :
    begin
      if not Assigned(frmAvailableEOD) then
          frmAvailableEOD := TfrmAvailableEOD.Create(self);

      aForm := frmAvailableEOD;
    end;
    ftfrmAvailableMAD :
    begin
      if not Assigned(frmAvailableMAD) then
          frmAvailableMAD := TfrmAvailableMAD.Create(self);

      aForm := frmAvailableMAD;
    end;
    ftfrmAvailableSonobuoy :
    begin
      if not Assigned(frmAvailableSonobuoy) then
          frmAvailableSonobuoy := TfrmAvailableSonobuoy.Create(self);

      aForm := frmAvailableSonobuoy;
    end;
    {$ENDREGION}

    {$REGION ' Weapon Sub Menu '}
    ftfrmAvailableMissile :
    begin
      if not Assigned(frmAvailableMissile) then
          frmAvailableMissile := TfrmAvailableMissile.Create(self);

      aForm := frmAvailableMissile;
    end;
    ftfrmAvailableTorpedo :
    begin
      if not Assigned(frmAvailableTorpedo) then
          frmAvailableTorpedo := TfrmAvailableTorpedo.Create(self);

      aForm := frmAvailableTorpedo;
    end;
    ftfrmAvailableMine :
    begin
      if not Assigned(frmAvailableMine) then
          frmAvailableMine := TfrmAvailableMine.Create(self);

      aForm := frmAvailableMine;
    end;
    ftfrmAvailableGun :
    begin
      if not Assigned(frmAvailableGun) then
          frmAvailableGun := TfrmAvailableGun.Create(self);

      aForm := frmAvailableGun;
    end;
    ftfrmAvailableBomb :
    begin
      if not Assigned(frmAvailableBomb) then
          frmAvailableBomb := TfrmAvailableBomb.Create(self);

      aForm := frmAvailableBomb;
    end;
    {$ENDREGION}

    {$REGION ' Countermeasure Sub Menu '}
    ftfrmAvailableAcousticDecoy :
    begin
      if not Assigned(frmAvailableAcousticDecoy) then
          frmAvailableAcousticDecoy := TfrmAvailableAcousticDecoy.Create(self);

      aForm := frmAvailableAcousticDecoy;
    end;
    ftfrmAvailableAirBubble :
    begin
      if not Assigned(frmAvailableAirBubble) then
          frmAvailableAirBubble := TfrmAvailableAirBubble.Create(self);

      aForm := frmAvailableAirBubble;
    end;
    ftfrmAvailableChaff :
    begin
      if not Assigned(frmAvailableChaff) then
          frmAvailableChaff := TfrmAvailableChaff.Create(self);

      aForm := frmAvailableChaff;
    end;
    ftfrmAvailableSelfDefensiveJammer :
    begin
      if not Assigned(frmAvailableSelfDefensiveJammer) then
          frmAvailableSelfDefensiveJammer := TfrmAvailableSelfDefensiveJammer.Create(self);

      aForm := frmAvailableSelfDefensiveJammer;
    end;
    ftfrmAvailableInfraredDecoy :
    begin
      if not Assigned(frmAvailableInfraredDecoy) then
          frmAvailableInfraredDecoy := TfrmAvailableInfraredDecoy.Create(self);

      aForm := frmAvailableInfraredDecoy;
    end;
    ftfrmAvailableTowedJammerDecoy :
    begin
      if not Assigned(frmAvailableTowedJammerDecoy) then
          frmAvailableTowedJammerDecoy := TfrmAvailableTowedJammerDecoy.Create(self);

      aForm := frmAvailableTowedJammerDecoy;
    end;
    ftfrmAvailableRadarNoiseJammer :
    begin
      if not Assigned(frmAvailableRadarNoiseJammer) then
          frmAvailableRadarNoiseJammer := TfrmAvailableRadarNoiseJammer.Create(self);

      aForm := frmAvailableRadarNoiseJammer;
    end;
    ftfrmAvailableFloatingDecoy :
    begin
      if not Assigned(frmAvailableFloatingDecoy) then
          frmAvailableFloatingDecoy := TfrmAvailableFloatingDecoy.Create(self);

      aForm := frmAvailableFloatingDecoy;
    end;
    {$ENDREGION}

    {$REGION ' Platform Sub Menu '}
    ftfrmAvailableVehicle :
    begin
      if not Assigned(frmAvailableVehicle) then
          frmAvailableVehicle := TfrmAvailableVehicle.Create(self);

      aForm := frmAvailableVehicle;
    end;
    {$ENDREGION}

    {$REGION ' Other Sub Menu '}
    ftfrmAvailableRuntimePlatformLibrary : //26
    begin
      if not Assigned(frmAvailableRuntimePlatformLibrary) then
          frmAvailableRuntimePlatformLibrary := TfrmAvailableRuntimePlatformLibrary.Create(self);

      aForm := frmAvailableRuntimePlatformLibrary;
    end;
    ftfrmAvailableGrapicalOverlay :  //27
    begin
      if not Assigned(frmAvailableOverlay) then
          frmAvailableOverlay := TfrmAvailableOverlay.Create(self);

      aForm := frmAvailableOverlay;
    end;
    ftfrmAvailableWaypoint : //28
    begin
      if not Assigned(frmAvailableWaypoint) then
          frmAvailableWaypoint := TfrmAvailableWaypoint.Create(self);

      aForm := frmAvailableWaypoint;
    end;
    ftfrmAvailableGameArea :  //29
    begin
      if not Assigned(frmAvailableGameArea) then
          frmAvailableGameArea := TfrmAvailableGameArea.Create(self);

      aForm := frmAvailableGameArea;
    end;
    ftfrmAvailableMotion :    //30
    begin
      if not Assigned(frmAvailableMotion) then
          frmAvailableMotion := TfrmAvailableMotion.Create(self);

      aForm := frmAvailableMotion;
    end;
    ftfrmAvailableSNRvsPODCurve :  //31
    begin
      if not Assigned(frmAvailableSNRvsPOD) then
          frmAvailableSNRvsPOD := TfrmAvailableSNRvsPOD.Create(self);

      aForm := frmAvailableSNRvsPOD;
    end;
    ftfrmAvailableGameDefaults :     //32
    begin
      if not Assigned(frmAvailableGameDefault) then
          frmAvailableGameDefault := TfrmAvailableGameDefault.Create(self);

      aForm := frmAvailableGameDefault;   //33
    end;
    ftfrmAvailableTransport :
    begin
      if not Assigned(frmAvailableTransport) then
          frmAvailableTransport := TfrmAvailableTransport.Create(self);

      aForm := frmAvailableTransport;
    end;
    ftfrmAvailableLogistic :    //34
    begin
      if not Assigned(frmAvailableLogistic) then
          frmAvailableLogistic := TfrmAvailableLogistic.Create(self);

      aForm := frmAvailableLogistic;
    end;
    {$ENDREGION}

    {$REGION ' Exercise Sub Menu '}
    ftfrmAvailableScenario :
    begin
      if not Assigned(frmAvailableScenario) then   //35
          frmAvailableScenario := TfrmAvailableScenario.Create(self);

      aForm := frmAvailableScenario;
    end;
    ftfrmAvailableResourceAllocation :
    begin
      if not Assigned(frmAvailableResourceAllocation) then
          frmAvailableResourceAllocation := TfrmAvailableResourceAllocation.Create(self);

      aForm := frmAvailableResourceAllocation;
    end;
    ftfrmAvailableEnvironments :
    begin
//      if not Assigned(frmAvailableEnvironments) then
//          frmAvailableEnvironments := TfrmAvailableEnvironments.Create(self);
//
//      aForm := frmAvailableEnvironments;
    end;
    {$ENDREGION}

  end;

  if Assigned(aForm) and aDocked then
    DockForm(aForm);
end;

procedure TfrmUserMainForm.IconLoad;
begin
  if iconName = 'imgExercise' then
  begin
    imgExercise.Picture.LoadFromFile(filePath + 'imgExercise' + imgChoice);
  end
  else if iconName = 'imgPlatforms' then
  begin
    imgPlatforms.Picture.LoadFromFile(filePath + 'imgPlatforms' + imgChoice);
  end
  else if iconName = 'imgSensors' then
  begin
    imgSensors.Picture.LoadFromFile(filePath + 'imgSensors' + imgChoice);
  end
  else if iconName = 'imgWeapons' then
  begin
    imgWeapons.Picture.LoadFromFile(filePath + 'imgWeapons' + imgChoice);
  end
  else if iconName = 'imgCountermeasures' then
  begin
    imgCountermeasures.Picture.LoadFromFile(filePath + 'imgCountermeasures' + imgChoice);
  end
  else if iconName = 'imgOther' then
  begin
    imgOther.Picture.LoadFromFile(filePath + 'imgOther' + imgChoice);
  end
  else if iconName = 'imgShutdown' then
  begin
    imgShutdown.Picture.LoadFromFile(filePath + 'imgShutdown' + imgChoice);
  end;
end;

procedure TfrmUserMainForm.btnShowPasswordClick(Sender: TObject);
begin
    if (edtPasword.PasswordChar = '*') then
  begin
    btnShowPassword.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnShowPassword.png');
    edtPasword.PasswordChar := #0;
  end
  else
  begin
    btnShowPassword.Picture.LoadFromFile('data\Image DBEditor\Interface\User Login\btnHidePassword.png');
    edtPasword.PasswordChar := '*';
  end;
end;

procedure TfrmUserMainForm.CollapseMenuClick(Sender: TObject);
begin

  case pnlActive of
    0: if pnl1ExerciseBody.Height <> 0 then exit;
    1: if pnl2PlatformsBody.Height <> 0 then exit;
    2: if pnl3SensorsBody.Height <> 0 then exit;
    3: if pnl4WeaponsBody.Height <> 0 then exit;
    4: if pnl5CountermeasuresBody.Height <> 0 then exit;
    5: if pnl6OtherBody.Height <> 0 then exit;
    7: if pnl8ShutdownBody.Height <> 0 then exit;
  end;

  UnCollapseMenuClick;

  Timer1.Enabled := True;
  isFold := true;
end;

procedure TfrmUserMainForm.UnCollapseMenuClick;
begin
  pnl1ExerciseBody.Height := 0;
  pnl2PlatformsBody.Height := 0;
  pnl3SensorsBody.Height := 0;
  pnl4WeaponsBody.Height := 0;
  pnl5CountermeasuresBody.Height := 0;
  pnl6OtherBody.Height := 0;
  pnl8ShutdownBody.Height := 0;
end;

procedure TfrmUserMainForm.Timer1Timer(Sender: TObject);
begin
  if not Timer1.Enabled then
    Exit;

  if not isFold then
    Exit;

  case pnlActive of
    0:
    begin
      if pnl1ExerciseBody.Height < (mnScenario.Top + 38) then //160 then
        pnl1ExerciseBody.Height := pnl1ExerciseBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
    1:
    begin
      if pnl2PlatformsBody.Height < (mnVehicle.Top + 38) then
        pnl2PlatformsBody.Height := pnl2PlatformsBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
    2:
    begin
      if pnl3SensorsBody.Height < (mnSonobuoy.Top + 38) then
        pnl3SensorsBody.Height := pnl3SensorsBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
    3:
    begin
      if pnl4WeaponsBody.Height < (mnBomb.Top + 38) then
        pnl4WeaponsBody.Height := pnl4WeaponsBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
    4:
    begin
      if pnl5CountermeasuresBody.Height < (mnRadarNoiseJammer.Top + 38) then
        pnl5CountermeasuresBody.Height := pnl5CountermeasuresBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
     5:
    begin
      if pnl6OtherBody.Height < (mnLogistic.Top + 38) then
        pnl6OtherBody.Height := pnl6OtherBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
    38:
    begin
      if pnl8ShutdownBody.Height < (mnShutdownDatabaseEditor.Top + 38) then
        pnl8ShutdownBody.Height := pnl8ShutdownBody.Height + 2
      else
      begin
        Timer1.Enabled := false;
      end;
    end;
  end;
end;

{$ENDREGION}

end.
