unit ufMainGC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Buttons, StdCtrls, uExecuter, uTCPClient, ExtCtrls,
  VrControls, VrButtons, {acPNG,} Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,{ RzBmpBtnng.jpeg,}
  RzBmpBtn{, Vcl.Imaging.jpeg};

type

  TfrmMainGC = class(TForm)
    MainMenu1: TMainMenu;
    mnSession: TMenuItem;
    mnStart1: TMenuItem;
    mnConnect1: TMenuItem;
    mnTerminate1: TMenuItem;
    mnDelete1: TMenuItem;
    mnDevelopment1: TMenuItem;
    mnExplorer1: TMenuItem;
    mnLogOut1: TMenuItem;
    mnHelp: TMenuItem;
    mnStartDatabaseDeveloper1: TMenuItem;
    mnPreplay1: TMenuItem;
    mnStartStudentpreplay1: TMenuItem;
    mnStudentPreplayStatus1: TMenuItem;
    mnStartExplorer1: TMenuItem;
    mnLogout2: TMenuItem;
    mnContent1: TMenuItem;
    mnAbout: TMenuItem;
    imgClose: TImage;
    pnlBackground: TPanel;
    imgBackground: TImage;
    lblConsoleName: TLabel;
    btnEditor: TRzBmpButton;
    btnConnect: TRzBmpButton;
    btnTerminate: TRzBmpButton;
    btnStart: TRzBmpButton;
    pnlButton: TPanel;
    imgSetting: TImage;
    lblRole: TLabel;
    procedure mnStart1Click(Sender: TObject);
    procedure mnConnect1Click(Sender: TObject);
    procedure mnTerminate1Click(Sender: TObject);
    procedure mnDelete1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnStartDatabaseDeveloper1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlDragWindowMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCloseClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure imgSettingClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    isCtrl: Boolean;
    isStartedReplay : Boolean ;
    DBEditRun: boolean;
    FIsStartingSession: boolean;

    FAppReplay    : TAppExecute;

    FNetTCPStub  : TTCPClient;
    FStubPort     : integer;
    FStubAddr   :  string;

    FConnectTimer : TTimer;
    procedure OnConnectTimer(Sender : TObject);

  public
    { Public declarations }
    procedure EventOnReceiveSession(Sender: TObject);
    procedure EventOnExecuteApp(Sender: TObject);
    procedure EventOnTerminateApp(Sender: TObject);

    procedure ApplySetting;
  end;

var
  frmMainGC: TfrmMainGC;

implementation

uses
  uNetSessionClient, ufStartSession, ufConnectTerminate, ufStartExerciseWizard,
  uLibSettingTTT , ufStartReplayRecorded, uGamePlayType, uSRRFunction, uSnapshotGCRec,
  uGameData_TTT, ufrmRoleSetting;

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

procedure TfrmMainGC.mnStart1Click(Sender: TObject);
var
   mr: integer;
   mapData : TRec_MapData;
begin
  FIsStartingSession := false;
  frmStartSession.DisplaySenarioList;

  mr := frmStartSession.ShowModal;

  if (mr = mrOK) then
  begin
    theClient.RequestOnlineList;

    frmStartExerciseWizard.ExerciseName := frmStartSession.SelectedName;
    frmConnectTerminate.ExerciseName    := frmStartSession.SelectedName;

    if Length(frmStartSession.SelectedRecsDisplayName)> 0 then
       isStartedReplay := True
    else
       isStartedReplay := False;

    if Length(frmStartSession.SelectedSnapshotDisplayName)> 0 then
       frmStartExerciseWizard.isSnapshot := true
    else
       frmStartExerciseWizard.isSnapshot := false ;

    if isStartedReplay then
       frmStartExerciseWizard.isReplay := true
    else
       frmStartExerciseWizard.isReplay := false;


    if frmStartExerciseWizard.StartNewExercise(
      frmStartSession.SelectedSCID)  then begin

      vGameDataSetting.ScenarioID       := frmStartSession.SelectedSCID;
      vGameDataSetting.SnapshotName     := frmStartSession.SelectedSnapshotFileName;
      vGameDataSetting.OwnShipPlatfomID := frmStartExerciseWizard.selectedPlatform;

      if frmStartExerciseWizard.recording then
        vGameDataSetting.GamePlayMode.GameType := byte(gpmScenAndRecord)
      else if Length(frmStartSession.SelectedRecsDisplayName)> 0 then
        vGameDataSetting.GamePlayMode.GameType  := byte(gpmReplay)
      else
        vGameDataSetting.GamePlayMode.GameType := byte(gpmScenario);

      vGameDataSetting.GamePlayMode.RecFileName :=
         frmStartSession.SelectedRecsDisplayName;

      SaveFF_GameSetting(vSettingFile, vGameDataSetting);

      FIsStartingSession := true;

      if isStartedReplay then begin
        FAppReplay.Executes;
        {exit ASAP}
        Exit;
      end;

      theClient.SendStartGameSession(frmStartSession.SelectedSCID,
        frmStartExerciseWizard.ExerciseName,
        frmStartSession.SelectedSnapshotFileName,
        byte(vGameDataSetting.GamePlayMode.GameType),
        frmStartSession.SelectedRecsDisplayName );


      // send info to mapstub
      with mapData do begin
        SessionID   := 0;
        PlatformID  := 0;
        OrderID     := CORD_CHANGE_MAPS;
        dMin        := 0;
        dMax        := 0;
        elev        := 0;
        X           := 0;
        Y           := 0;
        ScenarioID  := frmStartSession.SelectedSCID;
      end;

      if FNetTCPStub.Connected then begin
        FNetTCPStub.SendData(CPID_CMD_MAPS,@mapData);
      end;

      if frmStartExerciseWizard.isReplay then
      begin
        Sleep(50);
        frmConnectTerminate.SetAsConnect;
        frmConnectTerminate.UpdateSession;
      end;

      btnTerminate.Visible := True;
      btnStart.Visible := False;

    end
    else
      ShowMessage('Scenario selection has been canceled by user.');

  end;
end;

procedure TfrmMainGC.mnStartDatabaseDeveloper1Click(Sender: TObject);
begin
  DBEditRun       := true;

  if theClient.StartDBEditSession  then begin
    //minimize di event

  end;
end;

procedure TfrmMainGC.mnTerminate1Click(Sender: TObject);
var mr: integer;
begin
  FIsStartingSession := false;
  frmConnectTerminate.SetAsTerminate;

  mr := frmConnectTerminate.ShowModal;

  if frmConnectTerminate.OKTerminate then
  begin
    theClient.SendTerminateGameSession;

    btnTerminate.Visible := False;
    btnStart.Visible := True;
  end;

end;

procedure TfrmMainGC.OnConnectTimer(Sender: TObject);
begin
  if not FNetTCPStub.Connected then
    FNetTCPStub.Connect(vNetSetting.MapStubAddr,IntToStr(vNetSetting.MapStubGCPort));

end;

procedure TfrmMainGC.pnlDragWindowMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmMainGC.mnConnect1Click(Sender: TObject);
begin
  frmConnectTerminate.SetAsConnect;
  frmConnectTerminate.UpdateSession;

  frmConnectTerminate.ShowModal;

  if frmConnectTerminate.OKConnect then begin
    theClient.ConnectGameSession;
  end;

end;

procedure TfrmMainGC.ApplySetting;
var i: integer;
begin
  Caption := theClient.ConsoleName;
  lblConsoleName.Caption := theClient.ConsoleName;

  isStartedReplay := False;
  isCtrl := theClient.IsController;

  mnSession.Enabled := true;
    mnStart1.Enabled      := isCtrl;
    mnConnect1.Enabled    := true;
    mnTerminate1.Enabled  := isCtrl;
    mnDelete1.Enabled     := isCtrl;

  mnDevelopment1.Enabled  := isCtrl;
    mnStartDatabaseDeveloper1.Enabled := isCtrl;
    mnPreplay1.Enabled                := false;
      mnStartStudentpreplay1.Enabled  := false;
      mnStudentPreplayStatus1.Enabled := false;

  mnExplorer1.Enabled := true;
    mnStartExplorer1.Enabled := false;

  mnLogOut1.Enabled := true;
    mnLogout2.Enabled := true;

  mnHelp.Enabled := true;
    mnContent1.Enabled := true;
    mnAbout.Enabled := true;

  DefaultMonitor := dmPrimary;

  {$REGION 'Hide Menu'}
  mnSession.Visible := False;
    mnStart1.Visible      := False;
    mnConnect1.Visible    := False;
    mnTerminate1.Visible  := False;
    mnDelete1.Visible     := False;

  mnDevelopment1.Visible  := False;
    mnStartDatabaseDeveloper1.Visible := False;
    mnPreplay1.Visible                := false;
    mnStartStudentpreplay1.Visible    := false;
    mnStudentPreplayStatus1.Visible   := false;

  mnExplorer1.Visible := False;
    mnStartExplorer1.Visible := False;

  mnLogOut1.Visible := False;
    mnLogout2.Visible := False;

  mnHelp.Visible := False;
    mnContent1.Visible := False;
    mnAbout.Visible := False;
  {$ENDREGION}
//  if theClient.IsController then begin
//    Left    := Screen.Monitors[0].Left;
//    Width   := Screen.Monitors[0].Width div 2;
//
//    Top     := Screen.Monitors[0].Top;
//    Height  := Screen.Monitors[0].Height;
//  end
//  else begin
//    if Screen.MonitorCount > 1 then
//      i := 1
//    else
//      i := 0;
//    Left    := Screen.Monitors[i].Left;
//    Height  := Screen.Monitors[i].Height div 2;
//    Top     := Screen.Monitors[i].BoundsRect.Bottom - Height;
//    Width   := Screen.Monitors[i].Width;
//  end;

  btnStart.Visible := False;
  btnConnect.Visible := True;
  btnEditor.Visible := False;
  imgSetting.Visible := True;
  lblRole.Visible := True;
//  btnTerminate.Visible := False;

  if theClient.IsController then
  begin
    btnStart.Visible := True;
    btnConnect.Visible := True;
    btnEditor.Visible := True;
    imgSetting.Visible := False;
    lblRole.Visible := False;
//    btnTerminate.Visible := True;
  end;
end;

procedure TfrmMainGC.Button1Click(Sender: TObject);
begin
//  theclient.
end;

procedure TfrmMainGC.mnDelete1Click(Sender: TObject);
begin
  //  delete snapshot or recorded scenario
end;


procedure TfrmMainGC.EventOnReceiveSession(Sender: TObject);
begin
//  mnStart1.Enabled      := not theClient.GameSessionExist;
//  mnConnect1.Enabled    := theClient.GameSessionExist;
//  mnTerminate1.Enabled  := theClient.GameSessionExist;

  if theClient.IsController then begin
    frmConnectTerminate.UpdateSession;
    if isStartedReplay then begin
       theClient.ConnectGameSession;
       isStartedReplay := False;
    end;

    if FIsStartingSession then begin

       if theClient.GameSessionExist then begin
          theClient.ConnectGameSession;

       end;

       FIsStartingSession := false;
    end;
  end
  else begin
//    if theClient.GameSessionExist then

  end;

end;

procedure TfrmMainGC.EventOnExecuteApp(Sender: TObject);
begin
//   ShowMessage('EX e cute.. ');
  mnConnect1.Enabled := false;
  mnStartDatabaseDeveloper1.Enabled := false;
  Application.Minimize;
end;

procedure TfrmMainGC.EventOnTerminateApp(Sender: TObject);
begin
   //ShowMessage('Ter mi nate.. ');

  mnConnect1.Enabled := true;
  mnStartDatabaseDeveloper1.Enabled := true;

  isStartedReplay := False;

  if DBEditRun then begin

    theClient.SendRequestSynchMap;
    DBEditRun := false;

  end;
  Application.Restore;

end;

procedure TfrmMainGC.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
var
  tempTop : Integer;
begin
  lblConsoleName.Left := (pnlBackground.Width-lblConsoleName.Width)div 2;
  lblConsoleName.Top := (pnlBackground.Height-lblConsoleName.Height)div 4;

  lblRole.Left := (pnlBackground.Width-lblConsoleName.Width)div 2;
  lblRole.Top := (pnlBackground.Height-lblConsoleName.Height)div 7;

  pnlButton.Left := (pnlBackground.Width-pnlButton.Width)div 2;

  tempTop := (pnlBackground.Height-pnlButton.Height)div 4;
  pnlButton.Top := tempTop * 3;

//  imgClose.Left := pnlBackground.Width-50;
end;

procedure TfrmMainGC.FormCreate(Sender: TObject);
begin
  DefaultMonitor  := dmPrimary;

  DBEditRun       := false;

  vSettingFile    := getFileSetting;

  LoadFF_GameSetting(vSettingFile, vGameDataSetting);
  LoadFF_AppSetting(vSettingFile,vAppSetting);
  LoadFF_NetSetting(vSettingFile,vNetSetting);

  FAppReplay    := TAppExecute.Create;
  FAppReplay.OnStartExecute := nil;
  FAppReplay.OnEndExecute   := nil;
  FAppReplay.FExecFname     := vAppSetting.GameReplayName;

  FNetTCPStub := TTCPClient.Create;
  FNetTCPStub.RegisterProcedure(CPID_CMD_MAPS,nil,SizeOf(TRec_MapData));

  FConnectTimer := TTImer.Create(Self);
  FConnectTimer.Interval := 5000;
  FConnectTimer.OnTimer := OnConnectTimer;
  FConnectTimer.Enabled := true;

  EnableComposited(pnlBackground);
  EnableComposited(pnlButton);
end;

procedure TfrmMainGC.FormDestroy(Sender: TObject);
begin
  if FAppReplay.Active then
     FAppReplay.Terminates;

  FAppReplay.Free;
end;

procedure TfrmMainGC.FormShow(Sender: TObject);
var
  FileName: string;
begin
  {ExtractFile dari Folder}
  FileName := ExtractFilePath(ParamStr(0)) + 'Setting.ini';
  if LoadFF_GameSetting(FileName, vGameDataSetting) then
  begin
    case vGameDataSetting.Role of
        0: lblrole.Caption := 'Plotter';
        1: lblrole.Caption := 'Navigasi';
        2: lblrole.Caption := 'Atas Air';
        3: lblrole.Caption := 'BawahAir';
        4: lblrole.Caption := 'General';
    end;
  end;
end;

procedure TfrmMainGC.imgCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainGC.imgSettingClick(Sender: TObject);
begin
  if not Assigned(frmRoleSetting) then
  begin
    frmRoleSetting := TfrmRoleSetting.Create(Application);
  end;
  frmRoleSetting.Show;
end;

end.

