unit ufrmTopNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzBmpBtn, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, System.DateUtils, Vcl.Buttons;

type
  TfrmTopNav = class(TForm)
    Timer1: TTimer;
    tmr2: TTimer;
    tmrUTC: TTimer;
    Panel1: TPanel;
    Panel10: TPanel;
    pnlTop: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    lblClass: TLabel;
    lblDate: TLabel;
    lblLMT: TLabel;
    lblName: TLabel;
    lblTime: TLabel;
    lblTrackID: TLabel;
    Image2: TImage;
    btnPlatformOp: TSpeedButton;
    Label2: TLabel;
    lblLong1: TLabel;
    lbl1: TLabel;
    lblLat1: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    procedure Timer1Timer(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure tmrUTCTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTopNav: TfrmTopNav;

implementation

uses
  ufTacticalDisplay, ufrmRightNav;

{$R *.dfm}


procedure TfrmTopNav.Timer1Timer(Sender: TObject);
begin
  lblLMT.Caption := FormatDateTime('hh:nn:ss', Now);
end;

procedure TfrmTopNav.tmr2Timer(Sender: TObject);
begin
  lblDate.Caption := FormatDateTime('dddd, dd mmmm yyyy', Now);
end;

procedure TfrmTopNav.tmrUTCTimer(Sender: TObject);
var
  WaktuUTC: TDateTime;
begin
  WaktuUTC := TTimeZone.Local.ToUniversalTime(Now);
  lblTime.Caption := FormatDateTime('HH:nn:ss', WaktuUTC);
end;

end.
