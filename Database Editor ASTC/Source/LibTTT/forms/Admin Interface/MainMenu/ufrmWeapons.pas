unit ufrmWeapons;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TfrmWeapons = class(TForm)
    imgBackground: TImage;
    pnlMainBackground: TPanel;
    imgBomb: TImage;
    imgGun: TImage;
    imgMine: TImage;
    imgMissile: TImage;
    imgTorpedo: TImage;
    lblBombCount: TLabel;
    lblGunCount: TLabel;
    lblMineCount: TLabel;
    lblMissileCount: TLabel;
    lblTorpedoCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountWeapon;

  public
    { Public declarations }
  end;

var
  frmWeapons: TfrmWeapons;

implementation

uses
  ufrmUserMainForm, ufrmAvailableMissile, ufrmAvailableTorpedo, ufrmAvailableMine, ufrmAvailableGun, ufrmAvailableBomb, uDataModuleTTT,
  tttData;


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

procedure TfrmWeapons.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmWeapons.FormShow(Sender: TObject);
begin
  UpdateCountWeapon;
end;

procedure TfrmWeapons.IconLoad;
begin
  if iconName = 'imgMissile' then
  begin
    imgMissile.Picture.LoadFromFile(filePath + 'imgMissile' + imgChoice);
  end
  else if iconName = 'imgTorpedo' then
  begin
    imgTorpedo.Picture.LoadFromFile(filePath + 'imgTorpedo' + imgChoice);
  end
  else if iconName = 'imgGun' then
  begin
    imgGun.Picture.LoadFromFile(filePath + 'imgGun' + imgChoice);
  end
  else if iconName = 'imgMine' then
  begin
    imgMine.Picture.LoadFromFile(filePath + 'imgMine' + imgChoice);
  end
  else if iconName = 'imgBomb' then
  begin
    imgBomb.Picture.LoadFromFile(filePath + 'imgBomb' + imgChoice);
  end;
end;

procedure TfrmWeapons.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Weapon\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmWeapons.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Weapon\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmWeapons.SubMenuClick(Sender: TObject);
var
  subMenuTemp : Integer;

begin
  if Sender is TImage then
    subMenuTemp := TLabel(sender).Tag
  else
    Exit;

//  frmUserMainForm.LoadImageVariasi(0);
  frmUserMainForm.FormFactory(E_FormType(subMenuTemp),True);
end;

procedure TfrmWeapons.UpdateCountWeapon;
begin
  {$REGION ' Gun '}
//  lblGunCount.Caption := IntToStr(dmTTT.GetAllGunCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Missile '}
//  lblMissileCount.Caption := IntToStr(dmTTT.GetAllMissileCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Mine '}
//  lblMineCount.Caption := IntToStr(dmTTT.GetAllMineCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Bomb '}
//  lblBombCount.Caption := IntToStr(dmTTT.GetAllBombCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Torpedo '}
//  lblTorpedoCount.Caption := IntToStr(dmTTT.GetAllTorpedoCount) + ' Data';
  {$ENDREGION}
end;

end.
