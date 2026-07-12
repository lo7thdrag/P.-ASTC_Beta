unit ufrmOther;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TfrmOther = class(TForm)
    pnlMainBackground: TPanel;
    imgGameDefault: TImage;
    imgGraphicalOverlay: TImage;
    imgMotion: TImage;
    imgRuntimePlatfromLibrary: TImage;
    imgSNR: TImage;
    lblGameDefaultCount: TLabel;
    lblGraphicalOverlayCount: TLabel;
    lblMotionCount: TLabel;
    lblRPLCount: TLabel;
    lblSNRvsPODCount: TLabel;
    imgWaypoint: TImage;
    imgGameArea: TImage;
    imgBackground: TImage;
    imgLogistic: TImage;
    imgTransport: TImage;
    lblLogisticCount: TLabel;
    lblGameAreaCount: TLabel;
    lblWaypointCount: TLabel;
    lblTransportCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountOther;

  public
    { Public declarations }
  end;

var
  frmOther: TfrmOther;

implementation

uses
  ufrmUserMainForm, {ufrmAvailableRPL, ufrmAvailableGrapicalOverlay, ufrmAvailableStudentRoles, ufrmAvailableGameDefaults,
  ufrmAvailableSNRvsPODCurve, ufrmAvailableRadarActivationIntervals,} uDataModuleTTT, tttData;

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

procedure TfrmOther.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmOther.FormShow(Sender: TObject);
begin
  UpdateCountOther;
end;

procedure TfrmOther.IconLoad;
begin
  if iconName = 'imgGameDefault' then
  begin
    imgGameDefault.Picture.LoadFromFile(filePath + 'imgGameDefault' + imgChoice);
  end
  else if iconName = 'imgGraphicalOverlay' then
  begin
    imgGraphicalOverlay.Picture.LoadFromFile(filePath + 'imgGraphicalOverlay' + imgChoice);
  end
  else if iconName = 'imgMotion' then
  begin
    imgMotion.Picture.LoadFromFile(filePath + 'imgMotion' + imgChoice);
  end
  else if iconName = 'imgRuntimePlatfromLibrary' then
  begin
    imgRuntimePlatfromLibrary.Picture.LoadFromFile(filePath + 'imgRuntimePlatfromLibrary' + imgChoice);
  end
  else if iconName = 'imgSNR' then
  begin
    imgSNR.Picture.LoadFromFile(filePath + 'imgSNR' + imgChoice);
  end
  else if iconName = 'imgWaypoint' then
  begin
    imgWaypoint.Picture.LoadFromFile(filePath + 'waypoint' + imgChoice);
  end
  else if iconName = 'imgTransport' then
  begin
    imgTransport.Picture.LoadFromFile(filePath + 'transport' + imgChoice);
  end
  else if iconName = 'imgGameArea' then
  begin
    imgGameArea.Picture.LoadFromFile(filePath + 'gamearea' + imgChoice);
  end
  else if iconName = 'imgLogistic' then
  begin
    imgLogistic.Picture.LoadFromFile(filePath + 'logistic' + imgChoice);
  end
end;

procedure TfrmOther.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Other\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmOther.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Other\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmOther.SubMenuClick(Sender: TObject);
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

procedure TfrmOther.UpdateCountOther;
begin
  {$REGION ' Game Default '}
//  lblGameDefaultCount.Caption := IntToStr(dmTTT.GetAllGameDefaultsCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Graphical Overlay '}
//  lblGraphicalOverlayCount.Caption := IntToStr(dmTTT.GetAllGraphicalOverlayCount) + ' Data';
  {$ENDREGION}

  {$REGION ' RPL '}
//  lblRPLCount.Caption := IntToStr(dmTTT.GetAllRPLCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Motion '}
//  lblMotionCount.Caption := IntToStr(dmTTT.GetAllMotionCount) + ' Data';
  {$ENDREGION}

  {$REGION ' SNR vs POD Curve '}
//  lblSNRvsPODCount.Caption := IntToStr(dmTTT.GetAllSNRvsPODCount) + ' Data';
  {$ENDREGION}
end;

end.
