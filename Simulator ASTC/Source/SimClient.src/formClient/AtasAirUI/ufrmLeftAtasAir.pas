unit ufrmLeftAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmLeftAtasAir = class(TForm)
    Panel1: TPanel;
    img1: TImage;
    pnlContact: TPanel;
    pnlTrackSheet: TPanel;
    pnlTabTrackControl: TPanel;
    pnlTabTrackTable: TPanel;
    pnlTrackInformationBody: TPanel;
    pnlTrackControl: TPanel;
    lvTrackControl: TListView;
    pnlTrackTable: TPanel;
    lvTrackTable: TListView;
    lbl1: TLabel;
    Image1: TImage;
    pnlSensor: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLeftAtasAir: TfrmLeftAtasAir;

implementation

{$R *.dfm}

end.
