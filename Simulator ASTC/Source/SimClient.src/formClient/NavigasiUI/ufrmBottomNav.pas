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
    cbbSetScale: TComboBox;
    btnZoomIn1: TRzBmpButton;
    btnRangeRingsonHook: TRzBmpButton;
    lblRangeRings: TLabel;
    procedure btnCenterHookClick(Sender: TObject);
    procedure btnCenterGameClick(Sender: TObject);
    procedure btnFilterRingsClick(Sender: TObject);
    procedure btnPanClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure cbbSetScaleChange(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnMapToolsClick(Sender: TObject);
    procedure btnRangeRingsonHookClick(Sender: TObject);
    procedure btnRulerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnZoomIn1Click(Sender: TObject);
    procedure UpAllToolbarButton;
  private
//    FMapRulerCursor: E_RulerMapCursor;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBottomNav: TfrmBottomNav;

implementation

uses
  ufTacticalDisplay, ufrmLeftNav, ufrmTopNav, ufrmRightNav,
  uSimMgr_Client, uMapXHandler, Math, uRuler, MapXLib_TLB, tttData;

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

procedure TfrmBottomNav.btnMapToolsClick(Sender: TObject);
var
  vHelpFile, vHelpID : OleVariant;
begin
  VSimMap.FMap.Layers.LayersDlg(vHelpFile, vHelpID);
end;

procedure TfrmBottomNav.btnPanClick(Sender: TObject);
begin
  if Assigned(frmRuler) then
  frmRuler.Hide;   // atau Close jika Action := caHide

  frmTacticalDisplay.Map1.CurrentTool := miPanTool;
  frmTacticalDisplay.Map1.MousePointer := miPanCursor;
  frmTacticalDisplay.Map1.IsPan := False;
end;

procedure TfrmBottomNav.btnRangeRingsonHookClick(Sender: TObject);
begin
  with frmTacticalDisplay do
  begin
    FRangeRingOnHook := btnRangeRingsonHook.Down;

    if FRangeRingOnHook then
      simMgrClient.MyRingHookedPlatfom := focusedTrack;

    if FRangeRingOnHook and (simMgrClient.MyRingHookedPlatfom <> nil) then
    begin
      simMgrClient.RangeRing.mx := simMgrClient.MyRingHookedPlatfom.getPositionX;
      simMgrClient.RangeRing.my := simMgrClient.MyRingHookedPlatfom.getPositionY;
    end;

    StatusBar1.Panels[0].Text := TRzBmpButton(Sender).Hint;
  end;
end;

procedure TfrmBottomNav.btnRulerClick(Sender: TObject);
begin
  with frmTacticalDisplay do
  begin
    if btnRuler.Down then
    begin
//      Map1.CurrentTool := mtRuler;
      Map1.CurrentTool := miSelectTool;
      StatusBar1.Panels[0].Text := TRzBmpButton(Sender).Hint;

      frmRuler.Color := RGB (21, 33, 41);
      frmRuler.Show;
//
//      {Untuk mengembalikan tomol pan ke semula}
      btnPan.Down := False;
      Map1.IsPan := True;
////      simMgrClient.LineVisual.Visible := True;
////      simMgrClient.LineVisual.ShowRangeBearing := True;
    end
    else
    begin
      Map1.CurrentTool := mtSelectObject;
      StatusBar1.Panels[0].Text := 'Select';

//      simMgrClient.LineVisual.Visible := False;
    end;
    btnRuler.Down := False;
  end;
end;

procedure TfrmBottomNav.btnZoomIn1Click(Sender: TObject);
begin
//  UpAllToolbarButton;
//  btnZoomIn1.Down := True;
//
//  frmTacticalDisplay.Map1.CurrentTool := miZoomInTool;
//  frmTacticalDisplay.Map1.MousePointer := miZoomInCursor;
//
//  FMapRulerCursor := mcSelect;
end;

procedure TfrmBottomNav.btnZoomInClick(Sender: TObject);
begin
  if cbbSetScale.Text = '25' then
  begin
    cbbSetScale.ItemIndex := 9;
    cbbSetScaleChange(nil);
    Exit
  end;

  cbbSetScale.ItemIndex := cbbSetScale.ItemIndex + 1;
  cbbSetScaleChange(nil);
end;

procedure TfrmBottomNav.cbbSetScaleChange(Sender: TObject);
var
  z: double;
  s: string;
  i: Integer;
  rrVis: Boolean;
begin
  if cbbSetScale.ItemIndex < 0 then
    exit;

  s := cbbSetScale.Items[cbbSetScale.ItemIndex];
  try
    z := StrToFloat(s);
    VSimMap.SetMapZoom(z * 2);
    frmTacticalDisplay.lblRangeScale.Caption := cbbSetScale.Text;
    lblRangeRings.Caption := '1 : ' + FloatToStr(z/4);

    // Set Range Ring
    rrVis := btnFilterRings.down;
    if rrVis then
    begin
      z := FixMapZoom(VSimMap.FMap.Zoom);
      i := FindClosestZoomIndex(z);
      z := ZoomIndexToScale(i);
      simMgrClient.RangeRing.Interval := 0.125 * z;
    end;
  finally

  end;
end;

procedure TfrmBottomNav.FormCreate(Sender: TObject);
var
  i : integer;
  z : Double;
begin
  cbbSetScale.Items.Clear;

  for i := CMin_Z to CMax_Z do
  begin
    z := ZoomIndexToScale(i);
    cbbSetScale.Items.Add(FloatToStr(z));
  end;

//  cbbSetScale.ItemIndex := 8;
  cbbSetScale.Text := '25';
  lblRangeRings.Caption := '1 : 6.25';
//  cbbSetScaleChange(nil);
end;

procedure TfrmBottomNav.UpAllToolbarButton;
begin
  btnCenterGame.Down := False;
  btnZoomIn1.Down := False;
  btnPan.Down := False;
  btnMapTools.Down := False;

  frmTacticalDisplay.Map1.CurrentTool  := miArrowTool;
  frmTacticalDisplay.Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmBottomNav.ZoomOutClick(Sender: TObject);
begin
  if cbbSetScale.Text = '25' then
  begin
    cbbSetScale.ItemIndex := 7;
    cbbSetScaleChange(nil);
    Exit
  end;

  cbbSetScale.ItemIndex := cbbSetScale.ItemIndex - 1;
  cbbSetScaleChange(nil);
end;

end.
