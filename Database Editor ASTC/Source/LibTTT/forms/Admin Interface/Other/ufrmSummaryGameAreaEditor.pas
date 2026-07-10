unit ufrmSummaryGameAreaEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, MapXLib_TLB, Vcl.ExtCtrls, Vcl.CheckLst,
  Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, Vcl.Imaging.pngimage, Types, math,

  uDBAsset_GameEnvironment, uCoordConvertor, uDBEditSetting, ufrmPickPoint, uBaseCoordSystem, uSimContainers;

type

//  E_MapCursor = (mcSelect, mcMultiSelect, mcZoom, mcGameCenter, mcPan);

  TfrmSummaryGameAreaEditor = class(TForm)
    pnl3Map: TPanel;
    Map1: TMap;
    ProgressBar1: TProgressBar;
    pnlMainBackground: TPanel;
    ilToolbar: TImageList;
    Image1: TImage;
    pnl1Header: TPanel;
    pnl2Editor: TPanel;
    pnlListMap: TPanel;
    pnlVertical1: TPanel;
    pnlName: TPanel;
    pnlCheckList: TPanel;
    Label1: TLabel;
    edtName: TEdit;
    chklstArea: TCheckListBox;
    pnlCaption: TPanel;
    lbl2: TLabel;
    lblWidth: TLabel;
    pnlSearch: TPanel;
    lblSearch: TLabel;
    edtSearch: TEdit;
    pnlVertical2: TPanel;
    pnl3SparatorHor1: TPanel;
    pnlToolbar: TPanel;
    pnlAlignToolBar: TPanel;
    btnCenterOnGameCenter1: TImage;
    btnDecrease1: TImage;
    btnIncrease1: TImage;
    btnPan1: TImage;
    btnSelect1: TImage;
    btnZoom1: TImage;
    cbbScale1: TComboBox;
    Image7: TImage;
    ToolBar1: TToolBar;
    btnIncreaseScale: TToolButton;
    cbbScale: TComboBox;
    btnDecreaseScale: TToolButton;
    btnSelect: TToolButton;
    btnMultiSelect: TToolButton;
    btnZoomTool: TToolButton;
    btnPan: TToolButton;
    btnCenterHook: TToolButton;
    pnlVertical3: TPanel;
    pnl4Bottom: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    pnl3SparatorHor2: TPanel;
    pnlCursorPosition: TPanel;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lblBearingFCenter: TLabel;
    lblDistanceFCenter: TLabel;
    lblGridLat: TLabel;
    lblGridLong: TLabel;
    lblPosLat: TLabel;
    lblPosLong: TLabel;
    pnlGameAreaEditor: TPanel;
    pnl2SparatorHor1: TPanel;
    pnl2SparatorHor2: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch;hOutputDC, hAttributeDC: Integer; const RectFull, RectInvalid: IDispatch);
    procedure Map1MapViewChanged(Sender: TObject);
    procedure Map1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Map1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Map1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);

    procedure btnCancelClick(Sender: TObject);
    procedure cbbScale1Change(Sender: TObject);
    procedure chklstAreaClickCheck(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncrease1Click(Sender: TObject);
    procedure btnDecrease1Click(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnZoom1Click(Sender: TObject);
    procedure btnCenterHookClik(Sender: TObject);
    procedure btnPan1Click(Sender: TObject);
    procedure cbbScaleChange(Sender: TObject);
    procedure btnMultiSelectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblWidthClick(Sender: TObject);

  private
    FSelectedGameArea : TGame_Environment_Definition;

    FListMapIndex : TStringList;
    FListFiltered : TStringList;
    FIsMouseDown : Boolean;

    startX, startY, endX, endY : Single;
    squareLeftLong, squareTopLatt, squareRightLong, squareBottomLatt : Double;

    FSelectionRectStart : TPoint;
    FSelectionRectEnd : TPoint;
    FZoomRectStart : TPoint;
    FZoomRectEnd : TPoint;

    FCanvas : TCanvas;
    FConverter : TCoordConverter;
    FLyrDraw : CMapXLayer;
    FMap1 : TMap;

    FMapCursor : E_MapCursor;

    procedure LoadList;
    procedure SetChecked;
    procedure SetMapArea;
    procedure DrawCheckedLayer;
    procedure SelectionArea;
    procedure CreateGeosetFile;
    procedure UpdateGeosetFile;
    procedure DeleteGameAreaDirectory(const aPathName, aFileName: string);

    procedure LoadMap(ENCGeoset: string);
    procedure UpAllToolbarButton;

  public
    xx, yy : Double;
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }
    LastName : string;

    centLong, centLatt: Double;

    procedure setCBScale(max : Integer);
    procedure UpdateCursorPositionData(const X, Y: Integer);

    function CekInput: Boolean;

    property SelectedGameArea : TGame_Environment_Definition read FSelectedGameArea write FSelectedGameArea;
  end;

const
  DIMENSION = 1024;

var
  frmSummaryGameAreaEditor: TfrmSummaryGameAreaEditor;

implementation

uses
  uDataModuleTTT;

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

procedure InitOleVariant(var TheVar: OleVariant);
begin
  TVarData(TheVar).VType := varError;
  TVarData(TheVar).vError := DISP_E_PARAMNOTFOUND;
end;

function SeparateString(const s: string; del: char; var s1, s2: string): boolean;
var
  i, l: integer;
begin
  result := false;
  l := Length(s);
  i := Pos(del, s);

  if (l < 2) or (i < 1) then
    Exit;

  s1 := Copy(s, 1, i - 1);
  s2 := Copy(s, i + 1, l - i);

  s1 := Trim(s1);
  s2 := Trim(s2);
  result := (s1 <> '') and (s2 <> '');
end;

{$REGION ' Form Handle '}

procedure TfrmSummaryGameAreaEditor.FormCreate(Sender: TObject);
var
  itemMaxWidth, i, itemWidth : Integer;
begin
  FCanvas := TCanvas.Create;
  FConverter := TCoordConverter.Create;
  FConverter.FMap := Map1;
  FMap1 := TMap.Create(Self);

  FListMapIndex := TStringList.Create;
  FListFiltered := TStringList.Create;

  FListMapIndex.LoadFromFile(vAppDBSetting.MapSourcePathENC + '\ENC\' + 'mapindex.ini');
  chklstArea.Items := FListMapIndex;

  //Set Checklist Area Width
  itemMaxWidth := 0;
  for i := 0 to chklstArea.Items.Count - 1 do
  begin
    itemWidth := chklstArea.Canvas.TextWidth(chklstArea.Items.Strings[i]);

    if itemWidth > itemMaxWidth then
      itemMaxWidth := itemWidth;
  end;
  SendMessage(chklstArea.Handle, LB_SETHORIZONTALEXTENT, itemMaxWidth + 20, 0);

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSummaryGameAreaEditor.FormDestroy(Sender: TObject);
begin
  if Assigned(FListMapIndex) then
    FreeAndNil(FListMapIndex);

  if Assigned(FListFiltered) then
    FreeAndNil(FListFiltered);

  FMap1.Free;
  FCanvas.Free;
  FConverter.Free;
end;

procedure TfrmSummaryGameAreaEditor.FormShow(Sender: TObject);
var
  i, itemMaxWidth, itemWidth : Integer;
  sourceCopy, destCopy : string;

begin

  LoadMap(vAppDBSetting.MapSourceGeosetENC);

  setCBScale(3500);
  btnSelectClick(nil);
  cbbScale.ItemIndex := cbbScale.Items.Count - 1;
  cbbScaleChange(cbbScale);

  centLong := 116.357322793642;
  centLatt := -0.328853651464508;

  with FSelectedGameArea.FGameArea do
  begin
    if Game_Area_Index = 0 then
      edtName.Text := '(Unnamed)'
    else
      edtName.Text := Game_Area_Identifier;

    LastName := edtName.Text;
  end;

  edtSearch.Text := '';

  ProgressBar1.Visible := True;

  ProgressBar1.Position := 0;
  for i := 0 to Random(80) do
    ProgressBar1.Position := i;

  LoadList;
  chklstArea.Items := FListMapIndex;
  SetChecked;
  SetMapArea;
  ProgressBar1.Position := 90;
  DrawCheckedLayer;

  ProgressBar1.Position := 100;
  ProgressBar1.Visible := False;
end;

procedure TfrmSummaryGameAreaEditor.lblWidthClick(Sender: TObject);
begin
  if lblWidth.Caption = '>>>' then
  begin
    lblWidth.Caption := '<<<';
//    lblWidth.Left := 662;
    pnl2Editor.Width := 700;
    edtSearch.Width := 619;
    edtName.Width := 680;

    pnlAlignToolBar.Width := round((pnlToolBar.Width - 219) / 2);
  end
  else
  begin
    lblWidth.Caption := '>>>';
//    lblWidth.Left := 347;
    pnl2Editor.Width := 385;
    edtSearch.Width := 304;
    edtName.Width := 365;

    pnlAlignToolBar.Width := round((pnlToolBar.Width - 219) / 2);
  end;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSummaryGameAreaEditor.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSummaryGameAreaEditor.btnOkClick(Sender: TObject);
begin
  with FSelectedGameArea do
  begin
    if not CekInput  then
      Exit;

    if (FGameArea.Game_Centre_Lat = 0) or (FGameArea.Game_Centre_Long = 0) then
    begin
      ShowMessage('Game Center has not been set.');
      Exit;
    end;

    FGameArea.Game_Area_Identifier := edtName.Text;
    FGameArea.Game_X_Dimension := DIMENSION;
    FGameArea.Game_Y_Dimension := DIMENSION;
    FGameArea.Use_Real_World := 0;
    FGameArea.Use_Artificial_Landmass := 0;
    FGameArea.Detail_Map := 'ENC';

    {Buat Game Area Baru}
    if FGameArea.Game_Area_Index = 0 then
    begin
      dmTTT.InsertGameAreaDef(FGameArea);
      CreateGeosetFile;
    end
    {Update Game Area}
    else
    begin
      dmTTT.UpdateGameAreaDef(FGameArea);
      UpdateGeosetFile;
    end;
  end;

  AfterClose := True;
  Close;
end;

function TfrmSummaryGameAreaEditor.CekInput: Boolean;
var
  i, chkSpace, numSpace: Integer;
begin
  Result := False;

  {Jika inputan class name kosong}
  if (edtName.Text = '')then
  begin
    ShowMessage('Please insert class name');
    Exit;
  end;

  {Jika berisi spasi semua}
  if Copy(edtName.Text, 1, 1) = ' ' then
  begin
    chkSpace := Length(edtName.Text);
    numSpace := 0;

    for i := 1 to chkSpace do
    begin
      if edtName.Text[i] = #32 then
      numSpace := numSpace + 1;
    end;

    if chkSpace = numSpace then
    begin
      ShowMessage('Please use another class name');
      Exit;
    end;
  end;

  {Jika Class Name sudah ada}
  if (dmTTT.GetGameAreaDef(edtName.Text)>0) then
  begin
    {Jika inputan baru}
    if FSelectedGameArea.FGameArea.Game_Area_Index = 0 then
    begin
      ShowMessage('Please use another class name');
      Exit;
    end
    else if LastName <> edtName.Text then
    begin
      ShowMessage('Please use another class name');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmSummaryGameAreaEditor.chklstAreaClickCheck(Sender: TObject);
var
  layerStr, layerID, layerName : string;
  i, foundIndex : Integer;
  layer : CMapXLayer;
begin
  layerStr := chklstArea.Items[chklstArea.ItemIndex];
  SeparateString(layerStr, '=', layerID, layerName);

  if FListFiltered.Find(layerID, foundIndex) then
    FListFiltered.Delete(foundIndex)
  else
    FListFiltered.Add(layerID);

  SetMapArea;
end;

{$ENDREGION}

{$REGION ' ToolBar Handle '}

procedure TfrmSummaryGameAreaEditor.btnIncrease1Click(Sender: TObject);
begin
  if cbbScale.ItemIndex = 0 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex - 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmSummaryGameAreaEditor.btnMultiSelectClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnMultiSelect.Down := True;

  Map1.CurrentTool := miArrowTool;
  Map1.MousePointer := miArrowCursor;
end;

procedure TfrmSummaryGameAreaEditor.btnDecrease1Click(Sender: TObject);
begin
  if cbbScale.ItemIndex = 17 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex + 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmSummaryGameAreaEditor.cbbScale1Change(Sender: TObject);
var
  z : Double;
  s : string;
begin
  Map1.OnMapViewChanged := nil;

  if cbbScale.ItemIndex < 0  then Exit;

  if (cbbScale.ItemIndex <= 500) then
  begin
   s := cbbScale.Items[cbbScale.ItemIndex];
   try
     z := StrToFloat(s);
     Map1.ZoomTo(z, Map1.CenterX, Map1.CenterY);
   finally

   end;
  end
  else cbbScale.ItemIndex := cbbScale.ItemIndex -1 ;
//  ENCmap.OnMapViewChanged := ENCmapMapViewChanged;
end;

procedure TfrmSummaryGameAreaEditor.cbbScaleChange(Sender: TObject);
var
  z : Double;
  s : string;

begin
  Map1.OnMapViewChanged := nil;

  if cbbScale.ItemIndex < 0  then Exit;

  if (cbbScale.ItemIndex <= 500) then
  begin
    s := cbbScale.Items[cbbScale.ItemIndex];
    try
      z := StrToFloat(s);
      Map1.ZoomTo(z, Map1.CenterX, Map1.CenterY);
    finally

    end;
  end
  else
    cbbScale.ItemIndex := cbbScale.ItemIndex -1 ;

  Map1.OnMapViewChanged := Map1MapViewChanged;
 end;

procedure TfrmSummaryGameAreaEditor.btnSelectClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnSelect.Down := True;

  Map1.CurrentTool := miSelectTool;
  Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmSummaryGameAreaEditor.btnZoom1Click(Sender: TObject);
begin
  UpAllToolbarButton;
  btnZoomTool.Down := True;

  Map1.CurrentTool := miZoomInTool;
  Map1.MousePointer := miZoomInCursor;
end;

procedure TfrmSummaryGameAreaEditor.btnCenterHookClik(Sender: TObject);
begin
  UpAllToolbarButton;
  btnCenterHook.Down := True;
  FMapCursor := mcGameCenter;

  Map1.CurrentTool := miArrowTool;
  Map1.MousePointer := miCrossCursor;


//  btnCenterOnGameCenter.Picture.LoadFromFile('data\Image DBEditor\Interface\Button\btnCenterOnHook_Select.PNG');
end;

procedure TfrmSummaryGameAreaEditor.btnPan1Click(Sender: TObject);
begin
  UpAllToolbarButton;
  btnPan.Down := True;

  Map1.CurrentTool := miPanTool;
  Map1.MousePointer := miPanCursor;
end;

{$ENDREGION}

{$REGION ' Map Handle '}

procedure TfrmSummaryGameAreaEditor.SelectionArea;
var
  startX, startY, endX, endY,
  i, foundIndex : Integer;
  startLat, startLong, endLat, endLong : Double;
  layer : CMapXLayer;
  layerID, layerName : string;
begin

  {$REGION ' Validation Point Cursor '}
  if FSelectionRectStart.X < FSelectionRectEnd.X then
  begin
    startX := Round(FSelectionRectStart.X);
    endX := Round(FSelectionRectEnd.X);
  end
  else
  begin
    startX := Round(FSelectionRectEnd.X);
    endX := Round(FSelectionRectStart.X);
  end;

  if FSelectionRectStart.Y < FSelectionRectEnd.Y then
  begin
    startY := Round(FSelectionRectStart.Y);
    endY := Round(FSelectionRectEnd.Y);
  end
  else
  begin
    startY := Round(FSelectionRectEnd.Y);
    endY := Round(FSelectionRectStart.Y);
  end;

  FConverter.ConvertToMap(startX, startY, startLong, startLat);
  FConverter.ConvertToMap(endX, endY, endLong, endLat);

  {$ENDREGION}

  {$REGION ' Select Area '}

  for i := 1 to Map1.Layers.Count do
  begin
    layer := Map1.Layers.Item(i);

    if (layer.Name = 'Indonesia_Coastline_Darat') or (layer.Name = 'LYR_DRAW') or (layer.Name = 'ID2000_land')then
      Continue;

    {$REGION ' Select Single Area '}
    if btnSelect.Down then
    begin
      if (startLong >= layer.Bounds.XMin) and (startLat <= layer.Bounds.YMax) and
        (endLong <= layer.Bounds.XMax) and (endLat >= layer.Bounds.YMin) then
      begin
        SeparateString(layer.Name, '_', layerID, layerName);

        if FListFiltered.Find(layerID, foundIndex) then
          FListFiltered.Delete(foundIndex)
        else
          FListFiltered.Add(layerID);
      end;

    end;
    {$ENDREGION}

    {$REGION ' Select Multi Area '}
    if btnMultiSelect.Down then
    begin
      if (layer.Bounds.XMin >= startLong) and (layer.Bounds.YMax <= startLat) and
        (layer.Bounds.XMax <= endLong) and (layer.Bounds.YMin >= endLat) then
      begin
        SeparateString(layer.Name, '_', layerID, layerName);

        if FListFiltered.Find(layerID, foundIndex) then
          FListFiltered.Delete(foundIndex)
        else
          FListFiltered.Add(layerID);
      end;
    end;
    {$ENDREGION}

  end;
  {$ENDREGION}

  SetChecked;
  SetMapArea;
end;

procedure TfrmSummaryGameAreaEditor.setCBScale(max: Integer);
var
  widthNM: Integer;
  limitWidth: Array [0 .. 15] of Double;
  arrayTemp: Array [0 .. 30] of Double;
  arrayStringTemp: Array [0 .. 30] of String;
  resultTemp: Array [0 .. 30] of String;
  a, b: Integer;
begin
  widthNM := floor(max);
  // isi combo box
  cbbScale.Clear;
  // widthNM := strtoint(ExerciseAreaForm.edtMaximum.Text);

  limitWidth[0] := 0.125;
  limitWidth[1] := 0.25;
  limitWidth[2] := 0.5;
  limitWidth[3] := 1;
  limitWidth[4] := 2;
  limitWidth[5] := 4;
  limitWidth[6] := 8;
  limitWidth[7] := 16;
  limitWidth[8] := 32;
  limitWidth[9] := 64;
  limitWidth[10] := 128;
  limitWidth[11] := 256;
  limitWidth[12] := 512;
  limitWidth[13] := 1024;
  limitWidth[14] := 2048;
  limitWidth[15] := 2500;

  a := 0;
  while limitWidth[a] < widthNM do
  begin
    arrayTemp[a] := limitWidth[a];
    a := a + 1;
  end;
  arrayTemp[a] := widthNM;

  for b := 0 to a do
    arrayStringTemp[b] := floattostr(arrayTemp[b]);

  for b := 0 to a do
  begin
    resultTemp[b] := arrayStringTemp[b];
    cbbScale.Items.add(resultTemp[b]);
  end;
end;

procedure TfrmSummaryGameAreaEditor.SetChecked;
var
  i, j : Integer;
  layerStr, layerID, layerName : string;
  checked : Boolean;
begin
  for i := 0 to chklstArea.Count - 1 do
  begin
    layerStr := chklstArea.Items[i];
    SeparateString(layerStr, '=', layerID, layerName);

    checked := False;
    for j := 0 to FListFiltered.Count - 1 do
    begin
      if FListFiltered[j] = layerID then
      begin
        checked := True;
        Break;
      end;
    end;

    chklstArea.Checked[i] := checked;
  end;
end;

procedure TfrmSummaryGameAreaEditor.SetMapArea;
var
  i, foundIndex : Integer;
  layerID, layerName : string;
  layer : CMapXLayer;
begin
  FListFiltered.Sort;

  for i := 1 to Map1.Layers.Count do
  begin
    layer := Map1.Layers.Item(i);

    if (layer.Name = 'Indonesia_Coastline_Darat') or (layer.Name = 'LYR_DRAW') or (layer.Name = 'ID2000_land') then
      Continue;

    SeparateString(layer.Name, '_', layerID, layerName);

    if FListFiltered.Find(layerID, foundIndex) then
    begin
      layer.OverrideStyle := True;
      layer.Style.RegionColor := clRed;
    end
    else
      layer.OverrideStyle := False;
  end;
end;

procedure TfrmSummaryGameAreaEditor.UpAllToolbarButton;
begin
  btnSelect.Down := False;
  btnMultiSelect.Down := False;
  btnZoomTool.Down := False;
  btnPan.Down := False;
  btnCenterHook.Down := False;

  Map1.CurrentTool  := miArrowTool;
  Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmSummaryGameAreaEditor.UpdateCursorPositionData(const X, Y: Integer);
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

procedure TfrmSummaryGameAreaEditor.UpdateGeosetFile;
var
  MapDirPath : string;
begin
  MapDirPath := vAppDBSetting.MapGSTGame + '\' + LastName;
  DeleteGameAreaDirectory(MapDirPath, MapDirPath);
  CreateGeosetFile;
end;

procedure TfrmSummaryGameAreaEditor.CreateGeosetFile;
var
  myFile : TextFile;
  i, j : Integer;
  fileSource, fileDest : string;
  dirP   : string;

  indx   : string;
  mtype  : string;
  ProgressPos : Integer;

begin
  AssignFile(myFile, 'ConfigureLayerENC.txt');
  ReWrite(myFile);

  for i := 0 to FListFiltered.Count - 1 do
    Writeln(myFile, FListFiltered[i]);

  CloseFile(myFile);

  dirP := vAppDBSetting.MapGSTGame + '\' + edtName.Text;
  CreateDir(dirP);

  fileSource := ExtractFilePath(ParamStr(0)) + '\ConfigureLayerENC.txt';
  fileDest := dirP + '\' + edtName.Text + '.txt';

  CopyFile(PChar(fileSource), PChar(fileDest), False);

  FMap1.Layers.RemoveAll;

  ProgressBar1.Visible := True;
  ProgressBar1.Position := 0;

  if FListFiltered.Count > 0 then
    ProgressPos := Round(100/FListFiltered.Count)
  else
  begin
    for j := 0 to Random(80) do
      ProgressBar1.Position := j;
  end;

  {Memaksa memberi background indonesia}
  fileDest := vAppDBSetting.MapSourcePathENC + '\Indonesia.gst' ;
  FMap1.Layers.AddGeoSetLayers(fileDest);

  for i := 0 to FListFiltered.Count - 1 do
  begin
    if SeparateString(FListFiltered.Strings[I], '\', indx, mtype)then
    begin
      fileDest := vAppDBSetting.MapSourcePathENC + '\ENC\' + mtype + '\' + indx + '\' + indx + '.gst';
    end
    else
    begin
      fileDest := vAppDBSetting.MapSourcePathENC + '\ENC\' + FListFiltered[i] + '\' + FListFiltered[i] + '.gst';
    end;

    FMap1.Layers.AddGeoSetLayers(fileDest);

    ProgressBar1.Position := ProgressBar1.Position + ProgressPos;
  end;

  fileDest := dirP + '\' + edtName.Text + '.gst';
  FMap1.SaveMapAsGeoset('final', fileDest);

  ProgressBar1.Position := 100;
  ProgressBar1.Visible := False;
end;

procedure TfrmSummaryGameAreaEditor.DeleteGameAreaDirectory(const aPathName, aFileName: string);
var
  F : TSearchRec;
begin
  if FindFirst(aFileName + '*.*', faAnyFile, F) = 0 then
  begin
    try
      repeat
        if (F.Attr and faDirectory <> 0) then
        begin
          if (F.Name <> '.') and (F.Name <> '..') then
            DeleteGameAreaDirectory(aPathName, aFileName + '\' + F.Name);
        end
        else
          DeleteFile(aPathName + '\' + F.Name);
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;

    RemoveDir(aPathName);
  end;
end;

procedure TfrmSummaryGameAreaEditor.DrawCheckedLayer;
var
  i, j : Integer;
  layer : CMapXLayer;
  layerID, layerName : string;
begin
  for i := 1 to Map1.Layers.Count do
  begin
    layer := Map1.Layers.Item(i);

    if (layer.Name = 'Indonesia_Coastline_Darat') or
      (layer.Name = 'LYR_DRAW') then
      Continue;

    if SeparateString(layer.Name, '_', layerID, layerName) then
    begin
      for j := 0 to FListFiltered.Count - 1 do
      begin
        if FListFiltered[j] = layerID then
        begin
          layer.OverrideStyle := True;
          layer.Style.RegionColor := clRed;
        end;
      end;
    end;
  end;
end;

procedure TfrmSummaryGameAreaEditor.edtSearchKeyPress(Sender: TObject; var Key: Char);
var
  i : Integer;
  str_details, str_id : string;
begin
  if Key = #13 then
  begin
    chklstArea.Items.Clear;

    if edtSearch.Text = '' then
      chklstArea.Items := FListMapIndex
    else
    begin
      for i := 0 to FListMapIndex.Count - 1 do
      begin
        if Pos(edtSearch.Text, FListMapIndex[i]) <> 0 then
          chklstArea.Items.Add(FListMapIndex[i]);
      end;
    end;
    SetChecked;
  end;
end;

procedure TfrmSummaryGameAreaEditor.Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch; hOutputDC, hAttributeDC: Integer; const RectFull, RectInvalid: IDispatch);
begin
  with FCanvas do
  begin
    Handle := hOutputDC;

    if FIsMouseDown then
    begin
      Pen.Color := clYellow;
      Pen.Width := 3;
      Brush.Style := bsClear;
      Rectangle(FSelectionRectStart.X, FSelectionRectStart.Y, FSelectionRectEnd.X, FSelectionRectEnd.Y);
    end;

    if FIsMouseDown and btnZoomTool.Down then
    begin
      Pen.Color := clWhite;
      Pen.Width := 1;
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(FZoomRectStart.X, FZoomRectStart.Y, FZoomRectEnd.X, FZoomRectEnd.Y);
    end;
  end;
end;

procedure TfrmSummaryGameAreaEditor.Map1MapViewChanged(Sender: TObject);
var
  tempZoom : double;
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

procedure TfrmSummaryGameAreaEditor.Map1MouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  castX, castY : single;
  i : Integer;
  layer : CMapXLayer;
begin

  {$Region ' Select '}
  if btnSelect.Down then
  begin
    FSelectionRectStart := Point(X, Y);
    FSelectionRectEnd := Point(X, Y);
  end;
  {$ENDREGION}

  {$Region ' Multiselect '}
  if btnMultiSelect.Down  then
  begin
    FIsMouseDown := True;

    FListFiltered.Clear;

    FSelectionRectStart := Point(X, Y);
    FSelectionRectEnd := Point(X, Y);
  end;
  {$ENDREGION}

  {$Region ' Set Zoom '}
  if btnZoomTool.Down then
  begin
    FIsMouseDown := True;

    FZoomRectStart := Point(X, Y);
    FZoomRectEnd := Point(X, Y);
  end;
  {$ENDREGION}

  {$Region ' Set Game Center '}

  if btnCenterHook.Down then
  begin
    FConverter.ConvertToMap(X, Y, FSelectedGameArea.FGameArea.Game_Centre_Long, FSelectedGameArea.FGameArea.Game_Centre_Lat);

    pickpoint := Tpickpoint.Create(Self);
    try
      with pickpoint do
      begin
        edtlattitude.Text := formatDMS_latt(FSelectedGameArea.FGameArea.Game_Centre_Lat);
        edtlongtitude.Text := formatDMS_long(FSelectedGameArea.FGameArea.Game_Centre_Long);

        ShowModal;

        if not isCancel then
        begin
          FSelectedGameArea.FGameArea.Game_Centre_Lat := dmsToLatt(edtlattitude.Text);
          FSelectedGameArea.FGameArea.Game_Centre_Long := dmsToLong(edtlongtitude.Text);

          ShowMessage('Game Center telah berhasil diset');
        end;
      end;
    finally
      pickpoint.Free;
    end;

  end;

  {$ENDREGION}
end;

procedure TfrmSummaryGameAreaEditor.Map1MouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
begin
  UpdateCursorPositionData(X, Y);

  {$Region ' Set Multi Select '}
  if btnMultiSelect.Down and FIsMouseDown then
  begin
    FSelectionRectEnd := Point(X, Y);
    Map1.Repaint;
  end;
  {$ENDREGION}

  {$Region ' Set Zoom '}
  if btnZoomTool.Down and FIsMouseDown then
  begin
    FZoomRectEnd := Point(X, Y);
    Map1.Repaint;
  end;
  {$ENDREGION}
end;

procedure TfrmSummaryGameAreaEditor.Map1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$Region ' Set Select '}
  if btnSelect.Down then
  begin
    SelectionArea;
    Map1.Repaint;
  end;
  {$ENDREGION}

  if btnMultiSelect.Down and FIsMouseDown then
  begin
    FIsMouseDown := False;
    FSelectionRectEnd := Point(X, Y);
    SelectionArea;
    Map1.Repaint;
  end;
  {$ENDREGION}

  {$Region ' Set Zoom '}
  if btnZoomTool.Down and FIsMouseDown then
  begin
    FIsMouseDown := False;
    FZoomRectEnd:= Point(X, Y);
    Map1.OnMapViewChanged := Map1MapViewChanged;
    Map1.Repaint;
  end;
  {$ENDREGION}
end;

procedure TfrmSummaryGameAreaEditor.LoadMap(ENCGeoset: string);
var
  z : OleVariant;
  i : Integer;
  mInfo : CMapXLayerInfo;
begin
  if Map1 = nil then
    Exit;

  InitOleVariant(z);
  Map1.Layers.RemoveAll;
  Map1.Geoset := ENCGeoset;

  if ENCGeoset <> '' then
  begin
    for i := 1 to Map1.Layers.Count do
    begin
      Map1.Layers.Item(i).Selectable := False;
      Map1.Layers.Item(i).Editable := False;
    end;

    mInfo := CoLayerInfo.Create;
    mInfo.type_ := miLayerInfoTypeUserDraw;
    mInfo.AddParameter('Name', 'LYR_DRAW');
    FLyrDraw := Map1.Layers.Add(mInfo, 1);

    Map1.Layers.AnimationLayer := FLyrDraw;
    Map1.MapUnit := miUnitNauticalMile;
  end;

  Map1.BackColor := RGB(192, 224, 255);
end;

{$ENDREGION}

{$REGION ' File Handle '}

procedure TfrmSummaryGameAreaEditor.LoadList;
var
  pathConFile, nameGameArea : string;
begin
  FListFiltered.Clear;

  if Assigned(FSelectedGameArea) then
  begin
    nameGameArea := FSelectedGameArea.FGameArea.Game_Area_Identifier;
    pathConFile := vAppDBSetting.MapDestPathENC + '\' + nameGameArea;

    if FileExists(pathConFile + '\' + nameGameArea  + '.txt') then
      FListFiltered.LoadFromFile(pathConFile + '\' + nameGameArea  + '.txt');
  end;
end;

{$ENDREGION}

end.
