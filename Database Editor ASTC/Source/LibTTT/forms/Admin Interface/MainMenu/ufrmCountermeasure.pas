unit ufrmCountermeasure;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TfrmCountermeasure = class(TForm)
    imgBackground: TImage;
    pnlMainBackground: TPanel;
    imgAccousticDecoy: TImage;
    imgAirBubble: TImage;
    imgChaff: TImage;
    imgFloatingDecoy: TImage;
    imgInfraredDecoy: TImage;
    imgRadarNoiseJammer: TImage;
    imgSelfDefensiveJammer: TImage;
    imgTowedJammerIDecoy: TImage;
    lblAccousticDecoyCount: TLabel;
    lblAirBubbleCount: TLabel;
    lblChaffCount: TLabel;
    lblFloatingDecoyCount: TLabel;
    lblInfraredDecoyCount: TLabel;
    lblRadarJammerCount: TLabel;
    lblSelfDefensiveCount: TLabel;
    lblTowedJammerCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountContermeasures;

  public
    { Public declarations }
  end;

var
  frmCountermeasure: TfrmCountermeasure;

implementation

uses
  ufrmUserMainForm, ufrmAvailableAcousticDecoy, ufrmAvailableAirBubble, ufrmAvailableChaff, ufrmAvailableInfraredDecoy,
  ufrmAvailableFloatingDecoy, ufrmAvailableSelfDefensiveJammer, ufrmAvailableTowedJammerDecoy, ufrmAvailableRadarNoiseJammer,
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

procedure TfrmCountermeasure.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmCountermeasure.FormShow(Sender: TObject);
begin
  UpdateCountContermeasures;
end;

procedure TfrmCountermeasure.IconLoad;
begin
  if iconName = 'imgAccousticDecoy' then
  begin
    imgAccousticDecoy.Picture.LoadFromFile(filePath + 'imgAccousticDecoy' + imgChoice);
  end
  else if iconName = 'imgAirBubble' then
  begin
    imgAirBubble.Picture.LoadFromFile(filePath + 'imgAirBubble' + imgChoice);
  end
  else if iconName = 'imgChaff' then
  begin
    imgChaff.Picture.LoadFromFile(filePath + 'imgChaff' + imgChoice);
  end
  else if iconName = 'imgFloatingDecoy' then
  begin
    imgFloatingDecoy.Picture.LoadFromFile(filePath + 'imgFloatingDecoy' + imgChoice);
  end
  else if iconName = 'imgInfraredDecoy' then
  begin
    imgInfraredDecoy.Picture.LoadFromFile(filePath + 'imgInfraredDecoy' + imgChoice);
  end
  else if iconName = 'imgRadarNoiseJammer' then
  begin
    imgRadarNoiseJammer.Picture.LoadFromFile(filePath + 'imgRadarNoiseJammer' + imgChoice);
  end
  else if iconName = 'imgSelfDefensiveJammer' then
  begin
    imgSelfDefensiveJammer.Picture.LoadFromFile(filePath + 'imgSelfDefensiveJammer' + imgChoice);
  end
  else if iconName = 'imgTowedJammerIDecoy' then
  begin
    imgTowedJammerIDecoy.Picture.LoadFromFile(filePath + 'imgTowedJammerIDecoy' + imgChoice);
  end
end;

procedure TfrmCountermeasure.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Countermeasure\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmCountermeasure.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Countermeasure\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmCountermeasure.SubMenuClick(Sender: TObject);
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

procedure TfrmCountermeasure.UpdateCountContermeasures;
begin
  {$REGION ' Acoustic Decoy '}
  lblAccousticDecoyCount.Caption := IntToStr(dmTTT.GetAllAcousticDecoyCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Air Bubble '}
  lblAirBubbleCount.Caption := IntToStr(dmTTT.GetAllAirBubbleCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Chaff '}
  lblChaffCount.Caption := IntToStr(dmTTT.GetAllChaffCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Infrared Decoy '}
  lblInfraredDecoyCount.Caption := IntToStr(dmTTT.GetAllInfraredDecoyCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Towed Jammer '}
  lblTowedJammerCount.Caption := IntToStr(dmTTT.GetAllTowedJammerCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Radar Jammer '}
  lblRadarJammerCount.Caption := IntToStr(dmTTT.GetAllRadarJammerCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Self Defensive '}
  lblSelfDefensiveCount.Caption := IntToStr(dmTTT.GetAllSelfDefensiveCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Floating Decoy '}
  lblFloatingDecoyCount.Caption := IntToStr(dmTTT.GetAllFloatingDecoyCount) + ' Data';
  {$ENDREGION}
end;

end.
