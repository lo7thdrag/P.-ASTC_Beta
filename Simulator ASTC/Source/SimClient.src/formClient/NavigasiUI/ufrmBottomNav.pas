unit ufrmBottomNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, RzBmpBtn;

type
  TfrmBottomNav = class(TForm)
    pnlContainerBottom: TPanel;
    ZoomOut: TRzBmpButton;
    btnCenterGame: TRzBmpButton;
    btnCenterHook: TRzBmpButton;
    btnFilterRings: TRzBmpButton;
    btnRuler: TRzBmpButton;
    btnZoomIn: TRzBmpButton;
    btnPan: TRzBmpButton;
    btnMapTools: TRzBmpButton;
    cbSetScale: TComboBox;
    btnZoomIn1: TRzBmpButton;
    btnRangeRingsonHook: TRzBmpButton;
    procedure btnCenterHookClick(Sender: TObject);
    procedure btnCenterGameClick(Sender: TObject);
    procedure btnFilterRingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var                                                                                                                          frmBottomNav: TfrmBottomNav;

implementation

uses
  ufTacticalDisplay, ufrmLeftNav, ufrmTopNav, ufrmRightNav,
  uSimMgr_Client, uMapXHandler, Math;

{$R *.dfm}

const
  cWidth = 186;
  CMin_Z = 0;
  CMax_Z = 14;

  function ZoomIndexToScale(const i: Integer): double;
begin
  if i < -3 then
    result := 0.125
  else if i > 14 then
    result := 2500.0
  else
    result := Power(2.0, (i - 3));
end;

function FindClosestZoomIndex(const z: double): Integer;
var
  i: Integer;
begin
  if z >= 2500 then
    result := CMax_Z
  else if z <= 0.125 then
    result := CMin_Z
  else
  begin
    i := Round(Log2(z));
    result := i + 3;
  end;
end;

function FixMapZoom(z: double): double;
begin
  if z >= 1.0 then
    result := Round(z)
  else
    result := 0.001 * Round(z * 1000);
end;

procedure TfrmBottomNav.btnCenterGameClick(Sender: TObject);
var
  long, lat: double;
begin
  long := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Long;
  lat := simMgrClient.GameEnvironment.FGameArea.Game_Centre_Lat;
  VSimMap.SetMapCenter(long, lat);

  frmTacticalDisplay.StatusBar1.Panels[0].Text := TRzBmpButton(Sender).Hint;
  btnCenterGame.Down := False;

  if btnCenterHook.Down then
  begin
    btnCenterHook.Down := False;
    frmTacticalDisplay.FHookOnPlatform := not frmTacticalDisplay.FHookOnPlatform;
  end;
end;

procedure TfrmBottomNav.btnCenterHookClick(Sender: TObject);
begin
  with frmTacticalDisplay do
  begin
    if focusedTrack = nil then   //mk
      exit;

    FHookOnPlatform := not FHookOnPlatform;
    btnCenterHook.Down := FHookOnPlatform;

    if FHookOnPlatform then
    begin
      try
        simMgrClient.MyCenterHookedPlatfom := focusedTrack;

        VSimMap.SetMapCenter(simMgrClient.MyCenterHookedPlatfom.getPositionX,
              simMgrClient.MyCenterHookedPlatfom.getPositionY);
//        FLastMapCenterY := simMgrClient.MyCenterHookedPlatfom.getPositionY;
//        FLastMapCenterX := simMgrClient.MyCenterHookedPlatfom.getPositionX;
      except
        focusedTrack := nil;
        simMgrClient.MyCenterHookedPlatfom := nil;
      end;
    end
    else
    begin
      simMgrClient.MyCenterHookedPlatfom := nil;
    end;

    StatusBar1.Panels[0].Text := btnCenterHook.Hint;
  end;
end;

procedure TfrmBottomNav.btnFilterRingsClick(Sender: TObject);
var
  i: Integer;
  rrVis: Boolean;
  z: double;
begin
  rrVis := btnFilterRings.Down;

  // toolBtnFilterRangeRings.Down := FRangeRingVisible;
  if rrVis then
  begin
    z := FixMapZoom(VSimMap.FMap.Zoom);
    i := FindClosestZoomIndex(z);
    z := ZoomIndexToScale(i);
    simMgrClient.RangeRing.Interval := 0.125 * z;
  end;

  if Assigned(frmTacticalDisplay.focusedTrack) then
    simMgrClient.MyRingHookedPlatfom := frmTacticalDisplay.focusedTrack;

  if Assigned(simMgrClient.MyRingHookedPlatfom)then
  begin
    simMgrClient.RangeRing.mX := simMgrClient.MyRingHookedPlatfom.getPositionX;
    simMgrClient.RangeRing.mY := simMgrClient.MyRingHookedPlatfom.getPositionY;
    simMgrClient.RangeRing.Visible := rrVis;
  end;

  frmTacticalDisplay.StatusBar1.Panels[0].Text := TRzBmpButton(Sender).Hint;
end;

end.
