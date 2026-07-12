unit ufrmSensors;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TfrmSensors = class(TForm)
    imgBackground: TImage;
    pnlMainBackground: TPanel;
    imgEOD: TImage;
    imgESM: TImage;
    imgMAD: TImage;
    imgRadar: TImage;
    imgSonar: TImage;
    imgSonobuoy: TImage;
    lblEODCount: TLabel;
    lblESMCount: TLabel;
    lblMADCount: TLabel;
    lblRadarCount: TLabel;
    lblSonarCount: TLabel;
    lblSonobuoyCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountSensor;

  public
    { Public declarations }
  end;

var
  frmSensors: TfrmSensors;

implementation

uses
  ufrmUserMainForm, ufrmAvailableRadar, ufrmAvailableSonar, ufrmAvailableESM, ufrmAvailableEOD, ufrmAvailableMAD, ufrmAvailableSonobuoy,
  uDataModuleTTT, tttData;

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

procedure TfrmSensors.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmSensors.FormShow(Sender: TObject);
begin
  UpdateCountSensor;
end;

procedure TfrmSensors.IconLoad;
begin
  if iconName = 'imgEOD' then
  begin
    imgEOD.Picture.LoadFromFile(filePath + 'imgEOD' + imgChoice);
  end
  else if iconName = 'imgESM' then
  begin
    imgESM.Picture.LoadFromFile(filePath + 'imgESM' + imgChoice);
  end
  else if iconName = 'imgMAD' then
  begin
    imgMAD.Picture.LoadFromFile(filePath + 'imgMAD' + imgChoice);
  end
  else if iconName = 'imgRadar' then
  begin
    imgRadar.Picture.LoadFromFile(filePath + 'imgRadar' + imgChoice);
  end
  else if iconName = 'imgSonar' then
  begin
    imgSonar.Picture.LoadFromFile(filePath + 'imgSonar' + imgChoice);
  end
  else if iconName = 'imgSonobuoy' then
  begin
    imgSonobuoy.Picture.LoadFromFile(filePath + 'imgSonobuoy' + imgChoice);
  end;
end;

procedure TfrmSensors.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Sensors\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmSensors.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Sensors\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmSensors.SubMenuClick(Sender: TObject);
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

procedure TfrmSensors.UpdateCountSensor;
begin
  {$REGION ' Radar '}
//  lblRadarCount.Caption := IntToStr(dmTTT.GetAllRadarCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Sonar '}
//  lblSonarCount.Caption := IntToStr(dmTTT.GetAllSonarCount) + ' Data';
  {$ENDREGION}

  {$REGION ' EOD '}
//  lblEODCount.Caption := IntToStr(dmTTT.GetAllEODCount) + ' Data';
  {$ENDREGION}

  {$REGION ' MAD '}
//  lblMADCount.Caption := IntToStr(dmTTT.GetAllMADCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Sonobuoy '}
//  lblSonobuoyCount.Caption := IntToStr(dmTTT.GetAllRSonobuoyCount) + ' Data';
  {$ENDREGION}

  {$REGION ' ESM '}
//  lblESMCount.Caption := IntToStr(dmTTT.GetAllESMCount) + ' Data';
  {$ENDREGION}
end;

end.
