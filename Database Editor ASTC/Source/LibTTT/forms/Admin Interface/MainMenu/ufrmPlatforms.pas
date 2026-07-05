unit ufrmPlatforms;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls;

type
  TfrmPlatforms = class(TForm)
    imgBackground: TImage;
    pnlMainBackground: TPanel;
    imgVehicle: TImage;
    lblVehicleCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountPlatform;

  public
    { Public declarations }

  end;

var
  frmPlatforms: TfrmPlatforms;

implementation

uses
  ufrmUserMainForm, ufrmAvailableVehicle, uDataModuleTTT, tttData;

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

procedure TfrmPlatforms.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmPlatforms.FormShow(Sender: TObject);
begin
  UpdateCountPlatform;
end;

procedure TfrmPlatforms.IconLoad;
begin
  if iconName = 'imgVehicle' then
  begin
    imgVehicle.Picture.LoadFromFile(filePath + 'imgVehicle' + imgChoice);
  end
end;

procedure TfrmPlatforms.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Platform\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmPlatforms.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Platform\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmPlatforms.SubMenuClick(Sender: TObject);
var
  subMenuTemp : Integer;

begin
  if Sender is TImage then
    subMenuTemp := TLabel(sender).Tag
  else
    Exit;

  frmUserMainForm.LoadImageVariasi(0);
  frmUserMainForm.FormFactory(E_FormType(subMenuTemp),True);
end;

procedure TfrmPlatforms.UpdateCountPlatform;
begin
  {$REGION ' Vehicle '}
//  lblVehicleCount.Caption := IntToStr(dmTTT.GetAllVehicleCount) + ' Data';
  {$ENDREGION}
end;

end.
