unit ufMainGTV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uVirtualTime, uThreadTimer,  ExtCtrls, uNetUDPNode;

type
  TfrmMainGT = class(TForm)
    lblGTCaption: TLabel;
    Timer1: TTimer;
    lblGameTime: TLabel;
    lblGameDate: TLabel;
    lblGameSpeed: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblDurasiPermainan: TLabel;
    pnlMainBackground: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FTT : TMSTimer;
    FLastRecvMS : LongWord;

    procedure netRecv_GameTime(apRec: PAnsiChar; aSize: Word);
    procedure netRecv_CmdGameControl(apRec: PAnsiChar; aSize: Word);
    procedure netRecv_GameControlInfo(apRec: PAnsiChar; aSize: Word);

    procedure RunningThread(const dt: double);

    { Private declarations }
  public
    { Public declarations }
    FUDPNode    : TNetUDPNode;
    FVTime      : TVirtualTime;
    FDurasiPermainan : TVirtualTime;

    first  : boolean;

    GameSPEED: Double;
    FTimeFlag   : Word;
    FTimeReq    : LongWord;

    procedure SetGameTime(const gt: tDateTime);
    procedure SetGameDate(const gt: TDateTime);
    procedure SetServerTime(const gt: tDateTime);
    procedure SetDurasiPermainan(const gt: tDateTime);
    procedure SetGameSpeed(const i: Integer);

  end;

  function  InitiateSystemShutdown(
   lpMachineName,  lpMessage:  PANSIChar;
   dwTimeout: LongWord;  bForceAppsClosed,
   bRebootAfterShutdown : boolean): boolean;
   stdcall;  external advapi32 name 'InitiateSystemShutdownA';

  function  AbortSystemShutdown(
   lpMachineName:  PANSIChar): boolean;
   stdcall;  external advapi32 name 'AbortSystemShutdownA';

var
  frmMainGT: TfrmMainGT;

implementation
uses
  uLibSettingTTT, uGameData_TTT, ufrmRealTime;

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

{
var err: LongWord;
begin
  if not InitiateSystemShutdown(
    PAnsiChar('127.0.0.1'),
    'matilah kau...',
    20,
    true,
    false
) then begin
    err := GetLastError;
    ShowMessage(IntToStr(err));
  end;
end;
}

procedure TfrmMainGT.Button1Click(Sender: TObject);
var err: LongWord;
begin
  if not InitiateSystemShutdown(
    PAnsiChar('127.0.0.1'),
     'matilah kau...',
    20,
    true,
    false) then begin
    err := GetLastError;
    ShowMessage(IntToStr(err));
  end;

end;

procedure TfrmMainGT.Button2Click(Sender: TObject);
var err: LongWord;
begin
if not AbortSystemShutdown( PAnsiChar('127.0.0.1')) then begin
    err := GetLastError;
    ShowMessage(IntToStr(err));
 end;
end;

procedure TfrmMainGT.FormCreate(Sender: TObject);
begin
//
  GameSPEED := 1.0;
  SetServerTime(Now);

  first := true;
  vSettingFile := getFileSetting;
  LoadFF_NetSetting(vSettingFile, vNetSetting);
  LoadFF_GameSetting(vSettingFile, vGameDataSetting);

  LoadFF_NetClientSetting(vSettingFile, vNetClientSetting);

  FVTime := TVirtualTime.Create;
  FVTime.DateTimeOffset := 0;

  FDurasiPermainan := TVirtualTime.Create;
  FDurasiPermainan.DateTimeOffset := 0;

  {$REGION ' StartNetworking '}
  FUDPNode := TNetUDPNode.Create;
  FUDPNode.Port  := vNetSetting.GamePort;

  FUDPNode.RegisterProcedure(CPID_GAMETIME, netRecv_GameTime, SizeOf(TRecUDP_GameTime));
  FUDPNode.RegisterProcedure(CPID_CMD_GAME_CTRL, netRecv_CmdGameControl, SizeOf(TRecCmd_GameCtrl));
  FUDPNode.RegisterProcedure(CPID_UDP_GAMECTRL_INFO, netRecv_GameControlInfo, SizeOf(TRecUDP_GameCtrl_Info));
  FUDPNode.RegisterProcedure(CPID_TCP_REQUEST, nil, SizeOf(TRecTCP_Request));

  FUDPNode.Listen(IntToStr(vNetSetting.GamePort));

  {$ENDREGION}

  FTT := TMSTimer.Create;
//  FTT.OnRunning := RunningThread;
  FTT.OnRunning := nil;
  FTT.Interval  := 200;
  FTT.Enabled   := true;
  FLastRecvMS   := 0;

  EnableComposited(pnlMainBackground)
//  DoubleBuffered := true;

end;

procedure TfrmMainGT.FormDestroy(Sender: TObject);
begin
  FVTime.Free;
  FDurasiPermainan.Free;
  FTT.Free;
end;

procedure TfrmMainGT.FormResize(Sender: TObject);
begin
//  lblRTCaption.Left := ((Width - lblRTCaption.Width) div 2);
//  lblRTCaption.Top := Round(Height * 0.1);

//  lblServerTIME.Left := ((Width - lblServerTIME.Width) div 2);
//  lblServerTIME.Top := Round(Height * 0.25);

//  lblGTCaption.Left := ((Width - lblGTCaption.Width) div 2);
//  lblGTCaption.Top := Round(Height * 0.1);
//
//  lblGameTime.Left := ((Width - lblGameTime.Width) div 2);
//  lblGameTime.Top  := Round(Height * 0.45);

//  lblGameDate.Left := ((Width - lblGameDate.Width) div 2);
//  lblGameDate.Top  := lblGameTime.Top + lblGameTime.Height + 45;


//  Bevel2.Height := Height div 2;
end;

procedure TfrmMainGT.FormShow(Sender: TObject);
begin
  if Screen.MonitorCount > 1 then
  begin
    Width := Screen.Monitors[vGameDataSetting.TacticalScreen].Width;
    Height := Screen.Monitors[vGameDataSetting.TacticalScreen].Height;
    Left := Screen.Monitors[vGameDataSetting.TacticalScreen].Left;
    Top := Screen.Monitors[vGameDataSetting.TacticalScreen].Top;
  end
  else
  begin
    Width := Screen.Monitors[0].Width;
    Height := Screen.Monitors[0].Height;
    Left := Screen.Monitors[0].Left;
    Top := Screen.Monitors[0].Top;
  end;

  ufRealTime.Show
end;

procedure TfrmMainGT.netRecv_GameTime(apRec: PAnsiChar; aSize: Word);
var
  vdt: TDateTime;
  aRec: ^TRecUDP_GameTime;
  vMSDelta: Integer;
  st : TSystemTime;

begin
  aRec := @apRec^;


  FVTime.SetMilliSecond(aRec^.GameMS);

  if first then
  begin
    DateTimeToSystemTime(aRec^.ServerTime, st);
    SetLocalTime(st);

    FVTime.DateTimeOffset := aRec.GameStart;

    first := false;
  end;
end;

procedure TfrmMainGT.netRecv_CmdGameControl(apRec: PAnsiChar; aSize: Word);
var
  r: ^TRecCmd_GameCtrl;

begin
  r := @apRec^;

  case r^.GameCtrl of
    CORD_ID_start :
    begin
      GameSPEED := 1.0;

      //GameStart;
      FTT.OnRunning := RunningThread;

      if first then
      begin
        ufRealTime.lblJamStart.Caption := FormatDateTime(' hh : nn : ss ', now);
        SetGameSpeed(Round(GameSPEED))
      end;
    end;
    CORD_ID_pause :
    begin

      FTT.OnRunning := nil;

//      GamePause;
      GameSPEED := 0.0;
    end;
    CORD_ID_game_speed :
    begin;
      GameSPEED :=  r^.GameSpeed;
      SetGameSpeed(Round(GameSPEED))

    end;
  end;
end;

procedure TfrmMainGT.netRecv_GameControlInfo(apRec: PAnsiChar; aSize: Word);
type
  TGamePlayState = (gsStop, gsPlaying, gsTerminated );

var rec: ^TRecUDP_GameCtrl_Info;
    dtNow : LongWord;
    dt: integer;
    gs : TGamePlayState;
begin
  rec := @apRec^;

  FVTime.SetMilliSecond(rec^.GameTimeMS);
  gs := TGamePlayState(rec^.GameState);

  case gs of
    gsStop        : FTT.OnRunning := nil;
    gsPlaying     : FTT.OnRunning := RunningThread;
  end;

  if abs(rec^.GameSpeed - GameSPEED) > 0.01  then
    GameSPEED := rec^.GameSpeed;
end;

procedure TfrmMainGT.RunningThread(const dt: double);
begin
  FVTime.IncreaseMillisecond(GameSPEED * dt * 1000.0);
  FDurasiPermainan.IncreaseMillisecond(GameSPEED * dt * 1000.0);
  ufRealTime.FDurasiSebenarnya.IncreaseMillisecond(dt * 1000.0);
end;

procedure TfrmMainGT.SetDurasiPermainan(const gt: tDateTime);
begin
  lblDurasiPermainan.Caption := FormatDateTime(' hh : nn : ss ', gt);
end;

procedure TfrmMainGT.SetGameDate(const gt: TDateTime);
begin
   lblGameDate.Caption := FormatDateTime('dd mmmm yyyy', gt);
end;

procedure TfrmMainGT.SetGameSpeed(const i: Integer);
begin
  lblGameSpeed.Caption := IntToStr(i)+ 'x'
end;

procedure TfrmMainGT.SetGameTime(const gt: tDateTime);
begin
  lblGameTime.Caption := FormatDateTime(' hh : nn : ss ', gt);
end;

procedure TfrmMainGT.SetServerTime(const gt: tDateTime);
begin
//  lblServerTIME.Caption := FormatDateTime(' hh : nn : ss ', gt)
end;

procedure TfrmMainGT.Timer1Timer(Sender: TObject);
begin
  if not first then
  begin
    SetGameTime(FVTime.GetTime);
    SetGameDate(FVTime.GetTime);
    SetDurasiPermainan(FDurasiPermainan.GetTime)
  end;
end;

end.
