unit ufrmExercise;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.StdCtrls;

type
  TfrmExercise = class(TForm)
    imgBackground: TImage;
    pnlMainBackground: TPanel;
    imgEnvironment: TImage;
    imgGameArea: TImage;
    imgResourceAllocation: TImage;
    imgScenario: TImage;
    lblEnvironmentCount: TLabel;
    lblGameAreaCount: TLabel;
    lblResourceCount: TLabel;
    lblScenarioCount: TLabel;

    procedure IconMouseEnter(Sender: TObject);
    procedure IconMouseLeave(Sender: TObject);

    procedure SubMenuClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

   private
    iconName : string;
    filePath, imgChoice : string;

    procedure IconLoad;
    procedure UpdateCountExercise;

  public
    { Public declarations }
  end;

var
  frmExercise: TfrmExercise;

implementation

uses
  ufDBEditor, ufrmAvailableScenario, ufrmAvailableResourceAllocation, ufrmAvailableEnvironments,
  ufrmAvailableGameArea, uDataModuleTTT, tttData;

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

procedure TfrmExercise.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmExercise.FormShow(Sender: TObject);
begin
  UpdateCountExercise;
end;

procedure TfrmExercise.IconLoad;
begin
  if iconName = 'imgEnvironment' then
  begin
    imgEnvironment.Picture.LoadFromFile(filePath + 'imgEnvironment' + imgChoice);
  end
  else if iconName = 'imgGameArea' then
  begin
    imgGameArea.Picture.LoadFromFile(filePath + 'imgGameArea' + imgChoice);
  end
  else if iconName = 'imgResourceAllocation' then
  begin
    imgResourceAllocation.Picture.LoadFromFile(filePath + 'imgResourceAllocation' + imgChoice);
  end
  else if iconName = 'imgScenario' then
  begin
    imgScenario.Picture.LoadFromFile(filePath + 'imgScenario' + imgChoice);
  end

end;

procedure TfrmExercise.IconMouseEnter(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Exercise\';
  imgChoice := '_Select.PNG';

  IconLoad;
end;

procedure TfrmExercise.IconMouseLeave(Sender: TObject);
begin
  iconName := TImage(sender).Name;
  filePath := 'data\Image DBEditor\Interface\Exercise\';
  imgChoice := '.PNG';

  IconLoad;
end;

procedure TfrmExercise.SubMenuClick(Sender: TObject);
var
  subMenuTemp : Integer;

begin
  if Sender is TImage then
    subMenuTemp := TLabel(sender).Tag
  else
    Exit;

  fDBEditor.LoadImageVariasi(0);
  fDBEditor.FormFactory(E_FormType(subMenuTemp),True);
end;

procedure TfrmExercise.UpdateCountExercise;
begin
  {$REGION ' Scenario '}
  lblScenarioCount.Caption := IntToStr(dmTTT.GetAllScenarioCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Game Area '}
  lblGameAreaCount.Caption := IntToStr(dmTTT.GetAllGameAreaCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Resource '}
  lblResourceCount.Caption := IntToStr(dmTTT.GetAllResourceCount) + ' Data';
  {$ENDREGION}

  {$REGION ' Environment '}
  lblEnvironmentCount.Caption := IntToStr(dmTTT.GetAllEnvironmentCount) + ' Data';
  {$ENDREGION}
end;

end.
