unit ufrmWaypointEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.OleCtrls, MapXLib_TLB, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ColorGrd, Vcl.Menus, System.ImageList, Vcl.ImgList, uCoordConvertor,
  uBaseCoordSystem, uDBAssetObject, uSimContainers, uDataModuleTTT, ufrmGameAreaPickList, ufrmRuler,
  tttData, uDrawOverlay, uMainStaticShape, uDBEditSetting;

type

  TfrmWaypointEditor = class(TForm)
    pnlMainBackground: TPanel;
    pnl2Editor: TPanel;
    pnl3Map: TPanel;
    Map1: TMap;
    pnlToolBar: TPanel;
    pnlAlignToolBar: TPanel;
    ToolBar1: TToolBar;
    btnIncrease: TToolButton;
    cbbScale: TComboBox;
    btnDecrease: TToolButton;
    btnZoom: TToolButton;
    btnPan: TToolButton;
    btnCenterOnGame: TToolButton;
    pnlCursorPosition: TPanel;
    pnl4Bottom: TPanel;
    Button2: TButton;
    pmenuAction: TPopupMenu;
    mniContinueonlastheadingandgroundspeed1: TMenuItem;
    mniContinueonterminalheading1: TMenuItem;
    mniRepeatthepatternusingthecurrentpositionastheanchorpoint1: TMenuItem;
    mniRepeatthepatternreusingtheexistingwaypointpositions1: TMenuItem;
    mniReturntolaunchingbase1: TMenuItem;
    mniRemoveplatformfromexercise1: TMenuItem;
    mniStoponlastwaypoint1: TMenuItem;
    btnSelect: TToolButton;
    btngamearea1: TToolButton;
    btnruler: TToolButton;
    imgBackground: TImage;
    ilToolbar: TImageList;
    pnlListWP: TPanel;
    lvWaypoint: TListView;
    pnlTermination: TPanel;
    lbl7: TLabel;
    bvl2: TBevel;
    lbl8: TLabel;
    edtTermination: TEdit;
    btnAction: TSpeedButton;
    pnl1Header: TPanel;
    Panel4: TPanel;
    btnClose: TButton;
    btnSave: TButton;
    pnlWPDetail: TPanel;
    Label3: TLabel;
    Bevel1: TBevel;
    lbl2: TLabel;
    edtLat: TEdit;
    btnControlComboInterval: TSpeedButton;
    lbl1: TLabel;
    edtLong: TEdit;
    lbl3: TLabel;
    edtSpeed: TEdit;
    lbl4: TLabel;
    lbl6: TLabel;
    edtAltitude: TEdit;
    lbl5: TLabel;
    btnUpdate: TSpeedButton;
    pnlVertical1: TPanel;
    pnlVertical2: TPanel;
    pnlVertical3: TPanel;
    pnlOverlayEditor: TPanel;
    pnl2SparatorHor1: TPanel;
    pnl2SparatorHor2: TPanel;
    pnl3SparatorHor1: TPanel;
    pnl3SparatorHor2: TPanel;
    mn1: TLabel;
    mn2: TLabel;
    mn3: TLabel;
    mn4: TLabel;
    mn5: TLabel;
    mnlbl47: TLabel;
    lblBearingFCenter: TLabel;
    lblDistanceFCenter: TLabel;
    lblGridLat: TLabel;
    lblGridLong: TLabel;
    lblPosLong: TLabel;
    lblPosLat: TLabel;
    pnl1: TPanel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    btnDeleteAll: TSpeedButton;
    btnLayerTool: TToolButton;
    procedure btnIncreaseClick(Sender: TObject);
    procedure cbbScaleChange(Sender: TObject);
    procedure btnDecreaseClick(Sender: TObject);
    procedure btnZoomClick(Sender: TObject);
    procedure btnPanClick(Sender: TObject);
    procedure btnCenterOnGameClick(Sender: TObject);
    procedure Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch;
      hOutputDC, hAttributeDC: Integer; const RectFull, RectInvalid: IDispatch);
    procedure Map1MapViewChanged(Sender: TObject);
    procedure Map1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Map1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnControlComboIntervalClick(Sender: TObject);
    procedure btnWaypointHadleClick(Sender: TObject);
    procedure lvWaypointClick(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    procedure MenuItemOnClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btngamearea1Click(Sender: TObject);
    procedure btnrulerClick(Sender: TObject);

    procedure UpdateCursorPositionData(const X, Y: Integer);
    procedure btnLayerToolClick(Sender: TObject);

  private
    xx: Double;
    yy: Double;

    FCanvas : TCanvas;
    FLyrDraw : CMapXLayer;
    FConverter : TCoordConverter;
    FListWpData : TList;

    FCentLong  : double;
    FCentLatt  : double;

    FSelectedWaypoint : TWaypoint_Def;
    FSelectedWaypointData : TWaypoint_Data;
    FMapRulerCursor : E_RulerMapCursor;

    TerminationIndex : Integer;

    DrawFlagPoint: TDrawFlagPoint;

    procedure RefreshCursor;
    procedure RefreshListWaypoint;
    procedure getTermination(TerminationIndex : Integer);
    procedure ClearDataForm;

    procedure UpAllToolbarButton;
    procedure UpdateSelectedWaypointData;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }

    procedure LoadMap(Geoset: String);
    procedure OnSelectedWaypoint(Long,Lat : double);
    procedure OnAddWaypoint(Long,Lat : double);
    procedure OnAddRuller(Long,Lat : double);
    procedure GbrFlagPoint(mx, my: Double);
    procedure EditFlagPoint(id: Integer; mx, my: Double);

    property MapRulerCursor: E_RulerMapCursor read FMapRulerCursor write FMapRulerCursor;
    property SelectedWaypoint : TWaypoint_Def read FSelectedWaypoint write FSelectedWaypoint;
  end;

var
  frmWaypointEditor: TfrmWaypointEditor;

implementation

{$R *.dfm}

procedure InitOleVariant(var TheVar: OleVariant);
begin
  TVarData(TheVar).vType  := varError;
  TVarData(TheVar).vError := DISP_E_PARAMNOTFOUND;
end;

{$REGION ' Form Handle '}

procedure TfrmWaypointEditor.FormCreate(Sender: TObject);
begin
  btnSelectClick(nil);

  FCanvas  := TCanvas.Create;
  FConverter := TCoordConverter.Create;
  FConverter.FMap := Map1;

  FListWpData := TList.Create;

  DrawFlagPoint := TDrawFlagPoint.Create;
  DrawFlagPoint.Converter := FConverter;

  btnSave.Enabled := false;
end;

procedure TfrmWaypointEditor.FormDestroy(Sender: TObject);
begin
  FCanvas.Free;
  FConverter.Free;

  FreeItemsAndFreeList(FListWpData);
  DrawFlagPoint.Free;
end;

procedure TfrmWaypointEditor.FormResize(Sender: TObject);
begin
  pnlAlignToolBar.Width := round((pnlToolBar.Width - 433) / 2);
end;

procedure TfrmWaypointEditor.FormShow(Sender: TObject);
begin
  LoadMap(vAppDBSetting.MapOverlayStatic);

  cbbScale.ItemIndex := cbbScale.Items.Count -1;
  cbbScaleChange(Sender);

  cbbScale.Text := cbbScale.Items.Strings[cbbScale.ItemIndex];

  FCentLong := 116.357322793642;
  FCentLatt := -0.328853651464508;

  UpdateSelectedWaypointData;
end;

procedure TfrmWaypointEditor.getTermination(TerminationIndex: Integer);
begin
  case TerminationIndex of
    0: edtTermination.Text := 'Continue on last heading' ;
    1: edtTermination.Text := 'Continue on terminal heading' ;
    2: edtTermination.Text := 'Repeat the pattern, using the current position as the anchor point' ;
    3: edtTermination.Text := 'Repeat the pattern, reusing the existing waypoint positions'  ;
    4: edtTermination.Text := 'Return to launching base' ;
    5: edtTermination.Text := 'Remove platform from exercise' ;
    6: edtTermination.Text := 'Stop on last waypoint' ;
  end;

end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmWaypointEditor.btnWaypointHadleClick(Sender: TObject);
var
  i: Integer;
begin
  case TSpeedButton(Sender).Tag of
    1 :
    begin
      if TSpeedButton(Sender).Down then
      begin
        btnZoom.Down := False;
        btnPan.Down := False;
        btnSelect.Down := False;

        Map1.CurrentTool := miArrowTool;
        Map1.MousePointer := miCrossCursor;

        FMapRulerCursor := mcAdd;
      end
      else
      begin
        RefreshCursor;
      end;
    end;
    2 :
    begin
      RefreshCursor;
      btnZoom.Down := False;
      btnPan.Down := False;

      if lvWaypoint.Selected = nil then
        Exit;

      FListWpData.Delete(lvWaypoint.Selected.Index);
      RefreshListWaypoint;
      Map1.Repaint;

      btnSave.Enabled := true;

//      pnlWPDetail.Visible := False;
    end;
    3 :
    begin
      RefreshCursor;

      for I := FListWpData.Count - 1 downto 0 do
      begin
        FListWpData.Delete(i);
      end;

      RefreshListWaypoint;
      Map1.Repaint;

      btnSave.Enabled := true;
    end;
  end;
end;

procedure TfrmWaypointEditor.btnControlComboIntervalClick(Sender: TObject);
begin
  RefreshCursor;
  btnZoom.Down := False;
  btnPan.Down := False;
  btnSelect.Down := False;

  Map1.CurrentTool := miArrowTool;
  Map1.MousePointer := miCrossCursor;

  FMapRulerCursor := mcEdit;
end;

{$ENDREGION}

{$REGION ' Map Handle '}

procedure TfrmWaypointEditor.LoadMap(Geoset: String);
var
  I: Integer;
  z: OleVariant;
  mInfo: CMapXLayerInfo;
begin
  if Map1 = nil then
    Exit;

  InitOleVariant(z);
  Map1.Layers.RemoveAll;

  Map1.Geoset := Geoset;

  if name <> '' then
  begin
    for I := 1 to Map1.Layers.Count do
    begin
      Map1.Layers.Item(I).Selectable := false;
      Map1.Layers.Item(I).Editable   := false;
    end;

    mInfo := CoLayerInfo.Create;
    mInfo.type_ := miLayerInfoTypeUserDraw;
    mInfo.AddParameter('Name', 'LYR_DRAW');
    FLyrDraw := Map1.Layers.add(mInfo, 1);

    Map1.Layers.AnimationLayer := FLyrDraw;
    Map1.MapUnit := miUnitNauticalMile;
  end;

  Map1.BackColor := RGB(192, 224, 255);
end;

procedure TfrmWaypointEditor.lvWaypointClick(Sender: TObject);
var
  aWpData : TWaypoint_Data;
begin
  if lvWaypoint.Selected = nil then
  begin
    Exit;
  end;

  btnSelect.Down := true;
  btnZoom.Down := False;
  btnPan.Down := False;
  btnCenterOnGame.Down := False;

  RefreshCursor;
  FSelectedWaypointData := TWaypoint_Data(lvWaypoint.Selected.Data);

  edtLat.Text := formatDMS_latt(FSelectedWaypointData.FData.Waypoint_Latitude);
  edtLong.Text := formatDMS_long(FSelectedWaypointData.FData.Waypoint_Longitude);

  edtSpeed.Text := FormatFloat('0.00', FSelectedWaypointData.FData.Speed);
  edtAltitude.Text := FormatFloat('0.00', FSelectedWaypointData.FData.Altitude);

end;

procedure TfrmWaypointEditor.Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch; hOutputDC, hAttributeDC: Integer; const RectFull,
  RectInvalid: IDispatch);
var
   I : Integer;
   aWaypointData : TWaypoint_Data;
   xWPPoint, yWPPoint : Single;
   intWPPointX, intWPPointY : Integer;
  sx, sy, ex, ey: Integer;
  itemStart, itemEnd  : TFlagPoint;

begin
  if not Assigned(FCanvas) then
    Exit;
  FCanvas.Handle := hOutputDC;

  FCanvas.Pen.Width := 2  ;
  FCanvas.Pen.Style := psSolid;
  FCanvas.Pen.Color := clWhite;
  FCanvas.Font.Name := 'Courier';
  FCanvas.Brush.Style := bsClear;
  FCanvas.Font.Size := 12;
  FCanvas.Font.Color := clGray;

  if FListWpData.Count > 1 then
  begin
    for I := 0 to FListWpData.Count - 2 do
    begin
      aWaypointData := TWaypoint_Data(FListWpData.Items[i]);
      Map1.ConvertCoord(xWPPoint, yWPPoint, aWaypointData.FData.Waypoint_Longitude, aWaypointData.FData.Waypoint_Latitude, miMapToScreen);
      intWPPointX := Round(xWPPoint);
      intWPPointY := Round(yWPPoint);
      FCanvas.MoveTo(intWPPointX, intWPPointY);

      aWaypointData := TWaypoint_Data(FListWpData.Items[i+1]);
      Map1.ConvertCoord(xWPPoint, yWPPoint, aWaypointData.FData.Waypoint_Longitude, aWaypointData.FData.Waypoint_Latitude, miMapToScreen);
      intWPPointX := Round(xWPPoint);
      intWPPointY := Round(yWPPoint);
      FCanvas.LineTo(intWPPointX, intWPPointY);
    end;
  end;

  for I := 0 to FListWpData.Count - 1 do
  begin
    aWaypointData := TWaypoint_Data(FListWpData.Items[i]);
    Map1.ConvertCoord(xWPPoint, yWPPoint, aWaypointData.FData.Waypoint_Longitude, aWaypointData.FData.Waypoint_Latitude, miMapToScreen);
    intWPPointX := Round(xWPPoint);
    intWPPointY := Round(yWPPoint);
    FCanvas.TextOut(intWPPointX, intWPPointY,IntToStr(i+1));
  end;

  {$REGION ' Menggambar Ruler '}
  if frmRuler.isshow then
  begin
    DrawFlagPoint.Draw(FCanvas);

    if DrawFlagPoint.FList.Count = 2 then
    begin
      itemStart := DrawFlagPoint.FList[0];
      itemEnd := DrawFlagPoint.FList[1];

      FConverter.ConvertToScreen(itemStart.Post.X, itemStart.Post.Y, sx, sy);
      FConverter.ConvertToScreen(itemEnd.Post.X, itemEnd.Post.Y, ex, ey);

      with FCanvas do
      begin
        Brush.Style := bsClear;
        Pen.Color := clYellow  ;
        Pen.Width:= 2;
        MoveTo(sx, sy);
        LineTo(ex, ey);
      end;
    end;
  end;
  {$ENDREGION}
end;

procedure TfrmWaypointEditor.Map1MapViewChanged(Sender: TObject);
var
  tempZoom : Double;
begin
  if (Map1.CurrentTool = miZoomInTool)  or (Map1.CurrentTool = miZoomOutTool) then
  begin
     if Map1.Zoom <= 0.125 then tempZoom := 0.125;
     if (Map1.Zoom > 0.125) AND (Map1.Zoom < 1) then tempZoom := Map1.Zoom;
     if (Map1.Zoom >= 1) AND (Map1.Zoom <= 3500) then tempZoom := round(Map1.Zoom);
     if Map1.Zoom > 3500 then tempZoom := 3500;

     Map1.OnMapViewChanged := nil;
     Map1.ZoomTo(tempZoom, Map1.CenterX, Map1.CenterY);

     if (Map1.Zoom > 0.125) AND (Map1.Zoom < 0.25) then
     begin
       cbbScale.Text := FormatFloat('0.000', tempZoom);
     end
     else if (Map1.Zoom >= 0.25) AND (Map1.Zoom < 0.5) then
     begin
       cbbScale.Text := FormatFloat('0.00', tempZoom);
     end
     else if (Map1.Zoom >= 0.5) AND (Map1.Zoom < 1) then
     begin
       cbbScale.Text := FormatFloat('0.0', tempZoom);
     end
     else
       cbbScale.Text := floattostr(tempZoom);

     Map1.OnMapViewChanged := Map1MapViewChanged;
  end;
end;

procedure TfrmWaypointEditor.Map1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pos : TPoint;
  mx, my : double;

begin
  FConverter.ConvertToMap(x, y, mx, my);

  if FMapRulerCursor = mcEdit then
  begin
    OnSelectedWaypoint(mx,my);
    btnSave.Enabled := True;
    map1.Repaint;
  end
  else if  FMapRulerCursor = mcAdd then
  begin
    OnAddWaypoint(mx,my);
    btnSave.Enabled := True;
    map1.Repaint;
  end
  else if  FMapRulerCursor = mcRullerStart then
  begin
    OnAddRuller(mx,my);
    frmRuler.Show;
    map1.Repaint;
  end
  else if  FMapRulerCursor = mcRullerEnd then
  begin
    OnAddRuller(mx,my);
    frmRuler.Show;
    map1.Repaint;
  end
end;

procedure TfrmWaypointEditor.Map1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  UpdateCursorPositionData(X, Y);
end;

procedure TfrmWaypointEditor.MenuItemOnClick(Sender: TObject);
begin
  if sender is TMenuItem then
  begin
    TerminationIndex := TMenuItem(sender).Tag;
    getTermination(TerminationIndex);

    btnSave.Enabled := True;
  end;
end;

procedure TfrmWaypointEditor.OnAddRuller(Long, Lat: double);
begin

  if DrawFlagPoint.FList.Count = 0 then
  begin
    GbrFlagPoint(Lat, Long);
    GbrFlagPoint(Lat, Long);

    frmRuler.edtRulerStartPosLat.Text := formatDMS_latt(Lat);
    frmRuler.edtRulerStartPosLong.Text := formatDMS_long(Long);
    EditFlagPoint(0, Long, Lat)    ;
    frmRuler.edtRulerEndPosLat.Text := formatDMS_latt(Lat);
    frmRuler.edtRulerEndPosLong.Text := formatDMS_long(Long);
    EditFlagPoint(1, Long, Lat)
  end
  else
  begin
    if FMapRulerCursor = mcRullerStart then
    begin
      frmRuler.edtRulerStartPosLat.Text := formatDMS_latt(Lat);
      frmRuler.edtRulerStartPosLong.Text := formatDMS_long(Long);
      EditFlagPoint(0, Long, Lat)
    end
    else
    begin
      frmRuler.edtRulerEndPosLat.Text := formatDMS_latt(Lat);
      frmRuler.edtRulerEndPosLong.Text := formatDMS_long(Long);
      EditFlagPoint(1, Long, Lat)
    end;
  end;

end;

procedure TfrmWaypointEditor.OnAddWaypoint(Long, Lat: double);
var
  i : integer;
  recWpData: TWaypoint_Data;
begin
  recWpData := TWaypoint_Data.Create;

  with recWpData.FData do
  begin
    Waypoint_Latitude := Lat;
    Waypoint_Longitude := Long;

    Speed := 0;
    Altitude := 0;
  end;

  FListWpData.Add(recWpData);

  lvWaypoint.Clear;

  RefreshListWaypoint;
end;

procedure TfrmWaypointEditor.OnSelectedWaypoint(Long, Lat: double);
var
  aIndex : integer;
begin
  if lvWaypoint.Selected = nil then
    Exit;

  aIndex := lvWaypoint.Selected.Index;
  with TWaypoint_Data(FListWpData.Items[aIndex]).FData do
  begin
    Waypoint_Latitude := Lat;
    Waypoint_Longitude := Long;
  end;

  lvWaypoint.Clear;

  RefreshListWaypoint;

  lvWaypoint.Items[aIndex].Selected := True;
  lvWaypoint.SetFocus;
  lvWaypoint.OnClick(lvWaypoint.Items[aIndex]);
end;

procedure TfrmWaypointEditor.RefreshCursor;
begin
  btnAdd.Down := False;
  Map1.CurrentTool := miSelectTool;
  Map1.MousePointer := miDefaultCursor;

  FMapRulerCursor := mcSelect;
end;

procedure TfrmWaypointEditor.RefreshListWaypoint;
var
  i : integer;

begin
  lvWaypoint.Clear;
  for I := 0 to FListWpData.Count - 1 do
  begin
    with lvWaypoint.Items.Add do
    begin
      Data := FListWpData.Items[i];
      Caption := IntToStr(i + 1);
      SubItems.Add(formatDMS_latt(TWaypoint_Data(FListWpData.Items[i]).FData.Waypoint_Latitude));
      SubItems.Add(formatDMS_long(TWaypoint_Data(FListWpData.Items[i]).FData.Waypoint_Longitude));
      SubItems.Add(FormatFloat('0.00',(TWaypoint_Data(FListWpData.Items[i]).FData.Speed)));
      SubItems.Add(FormatFloat('0.00',(TWaypoint_Data(FListWpData.Items[i]).FData.Altitude)));
    end;
  end;

end;

procedure TfrmWaypointEditor.UpAllToolbarButton;
begin
  btnSelect.Down := False;
  btnCenterOnGame.Down := False;
  btnZoom.Down := False;
  btnPan.Down := False;
  btnLayerTool.Down := False;
  btnRuler.Down := False;

  Map1.CurrentTool  := miArrowTool;
  Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmWaypointEditor.UpdateCursorPositionData(const X, Y: Integer);
var
  dx, dy, diffX, diffY : Double;
begin

  FConverter.ConvertToMap(X, Y, dx, dy);

  {Bearing From Center}
  lblBearingFCenter.Caption := FormatFloat('0.00', CalcBearing(Map1.CenterX, Map1.CenterY, dx, dy));

  {Distance From Center}
  lblDistanceFCenter.Caption := FormatFloat('0.00', CalcRange(Map1.CenterX, Map1.CenterY, dx, dy));

  {Corsor in Position}
  lblPosLat.Caption := formatDM_latitude(dy);
  lblPosLong.Caption := formatDM_longitude(dx);

  {Cursor in Grid}
  diffX := Abs(dx - Map1.CenterX) * 60;
  diffY := Abs(dy - Map1.CenterY) * 60;

  if dy < Map1.CenterX then
    lblGridLat.Caption := FormatFloat('0.00', diffY) + ' nm S'
  else
    lblGridLat.Caption := FormatFloat('0.00', diffY) + ' nm N';

  if dx < Map1.CenterY then
    lblGridLong.Caption := FormatFloat('0.00', diffX) + ' nm W'
  else
    lblGridLong.Caption := FormatFloat('0.00', diffX) + ' nm E';

end;

procedure TfrmWaypointEditor.UpdateSelectedWaypointData;
var
  i : Integer;
begin
  lvWaypoint.Clear;

  dmTTT.GetWaypointData(FSelectedWaypoint.FData.Waypoint_Index, FListWpData);

  for I := 0 to FListWpData.Count - 1 do
  begin
    with lvWaypoint.Items.Add do
    begin
      Data := FListWpData.Items[i];
      Caption := IntToStr(i + 1);
      SubItems.Add(formatDMS_latt(TWaypoint_Data(FListWpData.Items[i]).FData.Waypoint_Latitude));
      SubItems.Add(formatDMS_long(TWaypoint_Data(FListWpData.Items[i]).FData.Waypoint_Longitude));
      SubItems.Add(FormatFloat('0.00',(TWaypoint_Data(FListWpData.Items[i]).FData.Speed)));
      SubItems.Add(FormatFloat('0.00',(TWaypoint_Data(FListWpData.Items[i]).FData.Altitude)));
    end;
  end;

  getTermination(FSelectedWaypoint.FData.Termination);
end;

procedure TfrmWaypointEditor.GbrFlagPoint(mx, my: Double);
var
  ObjectFlagPoint: TFlagPoint;
begin
  ObjectFlagPoint := TFlagPoint.Create(FConverter);
  ObjectFlagPoint.Post.X := mx;
  ObjectFlagPoint.Post.Y := my;
  DrawFlagPoint.FList.Add(ObjectFlagPoint);
end;

procedure TfrmWaypointEditor.EditFlagPoint(id: Integer; mx, my: Double);
var
  ObjectFlagPoint: TFlagPoint;
begin
  ObjectFlagPoint := TFlagPoint.Create(FConverter);
  ObjectFlagPoint.Post.X := mx;
  ObjectFlagPoint.Post.Y := my;

  if id = 1 then
  begin
    DrawFlagPoint.FList.Delete(0);
    DrawFlagPoint.FList.Insert(0, ObjectFlagPoint);
  end
  else
  begin
    DrawFlagPoint.FList.Delete(1);
    DrawFlagPoint.FList.Insert(1, ObjectFlagPoint);
  end;
end;

{$ENDREGION}

{$REGION ' Toolbar Handle '}

procedure TfrmWaypointEditor.btnDecreaseClick(Sender: TObject);
begin
  if cbbScale.ItemIndex = 16 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex + 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmWaypointEditor.btnGameArea1Click(Sender: TObject);
begin
  UpAllToolbarButton;

  frmGameAreaPickList := TfrmGameAreaPickList.Create(Self);
  try
    with frmGameAreaPickList do
    begin
      ShowModal;
      LoadMap('D:\Map\GST_GAME\AOTC\'+ SelectedGameAreaName+'\' +SelectedGameAreaName+'.gst');

    end;
  finally
    frmGameAreaPickList.Free;
  end;

end;

procedure TfrmWaypointEditor.btnIncreaseClick(Sender: TObject);
begin
  if cbbScale.ItemIndex = 0 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex - 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmWaypointEditor.btnLayerToolClick(Sender: TObject);
var
  vHelpFile, vHelpID : OleVariant;
begin
  UpAllToolbarButton;

  Map1.Layers.LayersDlg(vHelpFile, vHelpID);
end;

procedure TfrmWaypointEditor.btnPanClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnPan.Down := True;

  Map1.CurrentTool := miPanTool;
  Map1.MousePointer := miPanCursor;

  FMapRulerCursor := mcSelect;
end;


procedure TfrmWaypointEditor.btnrulerClick(Sender: TObject);
begin
  btnruler.Down := not btnruler.Down;

  if btnruler.Down then
  begin
    with frmRuler do
    begin
      IDForm := 0;
      Show;
    end;
  end
  else
  begin

    frmRuler.Hide;
    Map1.Repaint;
  end;

end;

procedure TfrmWaypointEditor.btnSaveClick(Sender: TObject);
var
  i: Integer;
  recWpData: TWaypoint_Data;
  data : TObject;
begin
  if edtTermination.Text = '' then
  begin
    ShowMessage('Termination belum dipilih');
    Exit;
  end;

  if FSelectedWaypoint.FData.Waypoint_Index <> 0 then
  begin
    dmTTT.DeleteWaypointData(FSelectedWaypoint.FData.Waypoint_Index);
  end;

  for i := 0 to FListWpData.Count -1 do
  begin
    data := FListWpData.Items[i];

    with TWaypoint_Data(data) do
    begin
      TWaypoint_Data(data).FData.Waypoint_Index := FSelectedWaypoint.FData.Waypoint_Index;
      TWaypoint_Data(data).FData.Scripted_Event_Index := i + 1;
      dmTTT.InsertWaypointData(i, FData)
    end;
  end;

  with FSelectedWaypoint do
  begin
    FData.Termination := TerminationIndex;

    if FData.Waypoint_Index = 0 then
    begin
      dmTTT.InsertWaypointDef(FData);
      ShowMessage('Data berhasil disimpan');
    end
    else
    begin
      dmTTT.UpdateWaypointDef(FData);
      ShowMessage('Data berhasil diperbarui');
    end;
  end;

  RefreshCursor;
  btnSelect.Down := true;

  btnSave.Enabled := False;
  isOK := True;
  AfterClose := True;
  Close;
end;

procedure TfrmWaypointEditor.btnSelectClick(Sender: TObject);
begin
  UpAllToolbarButton;

  btnSelect.Down := True;

  if btnAdd.Down = true then
    btnAdd.Down := false;

  Map1.CurrentTool := miSelectTool;
  Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmWaypointEditor.btnUpdateClick(Sender: TObject);
var
  mx, my : Double;
begin
  mx := dmsToLong(edtLong.Text);
  my := dmsToLatt(edtLat.Text);


  FSelectedWaypointData.FData.Speed := StrToFloat(edtSpeed.Text);
  FSelectedWaypointData.FData.Altitude := StrToFloat(edtAltitude.Text);
                 OnSelectedWaypoint(mx,my);
  btnSave.Enabled := true;
  map1.Repaint;
//  ShowMessage('Data has been updated to current point');
end;

procedure TfrmWaypointEditor.btnZoomClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnZoom.Down := True;

  Map1.CurrentTool  := miZoomInTool;
  Map1.MousePointer := miZoomInCursor;

  FMapRulerCursor := mcSelect;
end;

procedure TfrmWaypointEditor.cbbScaleChange(Sender: TObject);
var
  z: Double;
  s: string;
begin
  Map1.OnMapViewChanged := nil;

  if cbbScale.ItemIndex < 0 then
    Exit;

  if (cbbScale.ItemIndex <= 16) then
  begin
    s := cbbScale.Items[cbbScale.ItemIndex];
    try
      z := StrToFloat(s);
      Map1.ZoomTo(z, Map1.CenterX, Map1.CenterY);
    finally

    end;
  end
  else
    cbbScale.ItemIndex  := cbbScale.ItemIndex - 1;

  Map1.OnMapViewChanged   := Map1MapViewChanged;
end;

procedure TfrmWaypointEditor.ClearDataForm;
var
  i : Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      TEdit(Components[i]).Text := '';
    end;
  end;
end;

procedure TfrmWaypointEditor.btnActionClick(Sender: TObject);
var
  point : Winapi.Windows.TPoint;
begin
  GetCursorPos(point);
  pmenuAction.Popup(point.X,point.Y);
end;

procedure TfrmWaypointEditor.btnCenterOnGameClick(Sender: TObject);
begin
  UpAllToolbarButton;

  Map1.CenterX := FCentLong;
  Map1.CenterY := FCentLatt;
end;

procedure TfrmWaypointEditor.btnCloseClick(Sender: TObject);
begin
  AfterClose := false;
  RefreshCursor;
  btnSelect.Down := true;
  btnSave.Enabled := false;
  Close;
end;

{$ENDREGION}

end.
