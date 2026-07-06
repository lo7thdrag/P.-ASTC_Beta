unit ufrmRealTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uVirtualTime;

type
  TufRealTime = class(TForm)
    lblRTCaption: TLabel;
    Timer1: TTimer;
    lblRealDate: TLabel;
    Image1: TImage;
    Label1: TLabel;
    lblJamStart: TLabel;
    Label3: TLabel;
    lblDurasiSebenarnya: TLabel;
    pnlMainBackground: TPanel;
    lblRealTime: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bntMinimizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    FDurasiSebenarnya : TVirtualTime;
    first  : boolean;

    procedure SetDurasiSebenarnya(const gt: tDateTime);
//     procedure SetGameTime(const gt: tDateTime);
     procedure SetServerTime(const gt: tDateTime);
     procedure SetGameDate(const gt: TDateTime);
  end;

var
  ufRealTime: TufRealTime;

implementation

uses
  uLibSettingTTT;
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

procedure TufRealTime.bntMinimizeClick(Sender: TObject);
begin
//   WindowState := wsMinimized;
end;

procedure TufRealTime.FormCreate(Sender: TObject);
begin
  LoadFF_GameSetting(vSettingFile, vGameDataSetting);

  FDurasiSebenarnya := TVirtualTime.Create;
  FDurasiSebenarnya.DateTimeOffset := 0;

  EnableComposited(pnlMainBackground)
end;

procedure TufRealTime.FormDestroy(Sender: TObject);
begin
  FDurasiSebenarnya.Free;
end;

procedure TufRealTime.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Application.Minimize
  end;
end;

procedure TufRealTime.FormResize(Sender: TObject);
begin
//  lblRTCaption.Left := ((Width - lblRTCaption.Width) div 2);
//  lblRTCaption.Top := Round(Height * 0.1);
//
//  lblServerTIME.Left := ((Width - lblServerTIME.Width) div 2);
//  lblServerTIME.Top := Round(Height * 0.45);

//  lblGameDate.Left := ((Width - lblGameDate.Width) div 2);
//  lblGameDate.Top  := lblServerTIME.Top + lblServerTIME.Height + 45;
end;

procedure TufRealTime.FormShow(Sender: TObject);
begin
   if Screen.MonitorCount > 1 then
  begin
    Width := Screen.Monitors[vGameDataSetting.ToteScreen].Width;
    Height := Screen.Monitors[vGameDataSetting.ToteScreen].Height;
    Left := Screen.Monitors[vGameDataSetting.ToteScreen].Left;
    Top := Screen.Monitors[vGameDataSetting.ToteScreen].Top;
  end
  else
  begin
    Width := Screen.Monitors[0].Width;
    Height := Screen.Monitors[0].Height;
    Left := Screen.Monitors[0].Left;
    Top := Screen.Monitors[0].Top;
  end;

  SetGameDate(Now);
end;

procedure TufRealTime.SetDurasiSebenarnya(const gt: tDateTime);
begin
  lblDurasiSebenarnya.Caption := FormatDateTime(' hh : nn : ss ', gt)
end;

procedure TufRealTime.SetGameDate(const gt: TDateTime);
begin
    lblRealDate.Caption := FormatDateTime('dd mmmm yyyy', gt);
end;

procedure TufRealTime.SetServerTime(const gt: tDateTime);
begin
  lblRealTIME.Caption := FormatDateTime(' hh : nn : ss ', gt)
end;

procedure TufRealTime.Timer1Timer(Sender: TObject);
begin
  SetServerTime(Now);
  SetGameDate(Now);
  SetDurasiSebenarnya(FDurasiSebenarnya.GetTime)
end;

end.
