unit ufrmShutDown;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TfrmShutDown = class(TForm)
    pnlShutDown: TPanel;
    imgShutDown: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShutDown: TfrmShutDown;

implementation

{$R *.dfm}

end.
