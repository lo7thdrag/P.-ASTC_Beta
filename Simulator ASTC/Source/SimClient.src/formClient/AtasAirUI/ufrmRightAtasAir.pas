unit ufrmRightAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufmControlled,
  ufmPlatformGuidance, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  VrControls, VrBlinkLed, ufmSensor, Vcl.Menus, Vcl.ComCtrls,

   ufmWeapon,uT3Unit;

type
  TfrmRightAtasAir = class(TForm)
    pnlContainer: TPanel;
    pnlWeaponController: TPanel;
    Label10: TLabel;
    pmModeSonobuoy: TPopupMenu;
    pnlContact: TPanel;
    lbl1: TLabel;
    pnlTrackInformationBody: TPanel;
    pnlTrackControl: TPanel;
    lvTrackControl: TListView;
    pnlTrackTable: TPanel;
    lvTrackTable: TListView;
    pnlTrackSheet: TPanel;
    pnlTabTrackControl: TPanel;
    pnlTabTrackTable: TPanel;
    imgMainBackgorundContact: TImage;
    imgMainBackgorundController: TImage;
    pnlGameStatus: TPanel;
    Image4: TImage;
    Label1: TLabel;
    pnlGameState: TPanel;
    fmWeapon1: TfmWeapon;
    procedure TTButtonClick(Sender: TObject);
    procedure fmWeapon1btnWeaponClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateFormData;

    { Public declarations }
  end;

var
  frmRightAtasAir: TfrmRightAtasAir;

implementation

{$R *.dfm}

procedure TfrmRightAtasAir.fmWeapon1btnWeaponClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmWeapon1.btnWeaponClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.TTButtonClick(Sender: TObject);
var
  PanelTag: integer;
  Panel: Tpanel;
begin
  panel := Sender as Tpanel;
  PanelTag := panel.Tag;

  if panel = pnlTabTrackTable then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackTable.Color := RGB(29, 81, 103);
      pnlTrackTable.BringToFront;
      pnlTabTrackTable.Tag := 1;
      pnlTabTrackControl.Tag := 0;
      pnlTabTrackControl.Color := RGB(16, 46, 58);
    end;
  end;

  if panel = pnlTabTrackControl then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackControl.Color := RGB(29, 81, 103);
      pnlTrackControl.BringToFront;
      pnlTabTrackControl.Tag := 1;
      pnlTabTrackTable.Tag := 0;
      pnlTabTrackTable.Color := RGB(16, 46, 58);
    end;
  end;
end;

procedure TfrmRightAtasAir.UpdateFormData;
begin
    fmWeapon1.Refresh_VisibleTab;
end;

end.
