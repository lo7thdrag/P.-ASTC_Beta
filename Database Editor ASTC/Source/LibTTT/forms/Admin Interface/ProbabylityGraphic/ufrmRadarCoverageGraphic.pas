unit ufrmRadarCoverageGraphic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, ExtCtrls, uDBAssetObject,
  Buttons, math, System.ImageList,

  uDBAsset_Radar, uSimContainers, Vcl.Imaging.pngimage;

type
  E_VerticalCoverageCurve = (vcCurve1 = 1, vcCurve2);
  E_ElevationState = (esMin = 1, esMax);

  TProbabilityGrid = record
    Top : Integer;
    Left : Integer;
    Bottom : Integer;
    Right : Integer;
    Height : Integer;
    Width : Integer;
    CenterX : Integer;
    CenterY : Integer;
  end;

  TfrmRadarCoverageGraphic = class(TForm)
    pnlButton: TPanel;
    imgGraph: TImage;
    grp1: TGroupBox;
    lbllb1: TLabel;
    lbllb2: TLabel;
    lblCursorRange: TLabel;
    lblCursorElevation: TLabel;
    grp2: TGroupBox;
    lbllb5: TLabel;
    lbllb6: TLabel;
    lblSelectedRange: TLabel;
    lblSelectedElevation: TLabel;
    grp3: TGroupBox;
    lbllb3: TLabel;
    lbllb4: TLabel;
    lbllb7: TLabel;
    lbllb8: TLabel;
    edtRangeMin: TEdit;
    edtRangeMax: TEdit;
    grp4: TGroupBox;
    lbllb9: TLabel;
    lbllb10: TLabel;
    lbllb11: TLabel;
    lbllb12: TLabel;
    edtElevationMin: TEdit;
    edtElevationMax: TEdit;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    pnlToolbar: TPanel;
    tlb1: TToolBar;
    btnSelect: TToolButton;
    btnAdd: TToolButton;
    btn4: TToolButton;
    btnDelete: TToolButton;
    il2: TImageList;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    pnlMainGrafik: TPanel;
    pnlGrafik: TPanel;
    pnlAlignToolBar: TPanel;
    il1: TImageList;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure imgGraphMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgGraphMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgGraphMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);

    procedure edtRangeMinKeyPress(Sender: TObject; var Key: Char);
    procedure edtRangeMaxKeyPress(Sender: TObject; var Key: Char);
    procedure edtElevationMinKeyPress(Sender: TObject; var Key: Char);
    procedure edtElevationMaxKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
//    procedure btnSelectClick(Sender: TObject);

  private
    FSelectedRadar : TRadar_On_Board;
    FSelectedCurve : E_VerticalCoverageCurve;
    FSelectedElevation : E_ElevationState;

    FVerticalCoverageList : TList;
//    FDeletedVerticalCoverageList : TList;
    FSelectedPoint : TObject;
    FSelectedPointIdDelete : integer;

    FRangeMin : Double;
    FRangeMax : Double;
    FElevationMin : Double;
    FElevationMax : Double;

    FGrid : TProbabilityGrid;
    //draw variable
    posBatasKiri, posBatasKanan : Integer;
    posBatasAtas, posBatasBawah, y0 : Integer;
    xRatio, yRatio : Double;

    FIsMouseDown : Boolean;
    FIsDragPoint : Boolean;

    procedure UpdateRadarVerticalCoverageForm;
    procedure ClearCanvas;
    procedure DrawGrid;
    procedure DrawPoint;

    procedure ConvertPositionToValue(const aX, aY: Integer; var aRange, aElevation: Double);
    procedure ConvertValueToPosition(const aRange, aElevation: Double; var aX, aY: Integer);
    function GetPointPosition(const aAspect, aProbability: Double): Integer;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }
    property SelectedRadar : TRadar_On_Board read FSelectedRadar write FSelectedRadar;
    property SelectedCurve : E_VerticalCoverageCurve read FSelectedCurve write FSelectedCurve;

  end;

var
  frmRadarCoverageGraphic: TfrmRadarCoverageGraphic;

implementation

uses
  uDataModuleTTT, ufrmSummaryRadar, uFormula, tttData;

{$R *.dfm}

{ TRadarCoverage }

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

{$REGION ' Form Handle '}

procedure TfrmRadarCoverageGraphic.FormCreate(Sender: TObject);
begin
  FVerticalCoverageList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmRadarCoverageGraphic.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FVerticalCoverageList);
end;

procedure TfrmRadarCoverageGraphic.FormShow(Sender: TObject);
begin

  FSelectedPoint := nil;

  btnSelect.Down := True;

  FRangeMin := 0;
  FRangeMax := 500;
  FElevationMin := -300000;
  FElevationMax := 300000;

  FGrid.CenterX := imgGraph.Width div 2;
  FGrid.CenterY := imgGraph.Height div 2;

  FGrid.Height := Round(imgGraph.Height);
  FGrid.Width := Round(imgGraph.Width);

  FGrid.Top := Round(FGrid.CenterY - (FGrid.Height / 2));
  FGrid.Left := Round(FGrid.CenterX - (FGrid.Width / 2));
  FGrid.Bottom := Round(FGrid.CenterY + (FGrid.Height / 2));
  FGrid.Right := Round(FGrid.CenterX + (FGrid.Width / 2));

  with FSelectedRadar.FDef do
  begin
    Caption := 'Vertical Coverage Curve ' + IntToStr(Ord(FSelectedCurve)) + ' for ' + Radar_Identifier;
    dmTTT.GetRadarVerticalCoverage(FSelectedRadar.FDef.Radar_Index, Ord(FSelectedCurve), FVerticalCoverageList);
  end;

  UpdateRadarVerticalCoverageForm;
  btnApply.Enabled := False;

end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmRadarCoverageGraphic.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOK then
    Close;
end;

procedure TfrmRadarCoverageGraphic.btnApplyClick(Sender: TObject);
var
  i : Integer;
  dataTemp : TRadar_Vertical;
begin

  {Hapus dulu yang lama}
  dmTTT.DeleteRadar_Vertical_Coverage(1, FSelectedRadar.FDef.Radar_Index, Ord(FSelectedCurve));

  for i := 0 to FVerticalCoverageList.Count - 1 do
  begin
    dataTemp := TRadar_Vertical(FVerticalCoverageList.Items[i]);

    if Assigned(dataTemp) then
    begin
      dmTTT.InsertRadarNew_Vertical_Coverage(dataTemp);
    end;

  end;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmRadarCoverageGraphic.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmRadarCoverageGraphic.btnDeleteClick(Sender: TObject);
var
  i : Integer;
  data : TObject;
begin
  if not Assigned(FSelectedPoint) then
    Exit;

  for i := FVerticalCoverageList.Count - 1 downto 0 do
  begin
    data := FVerticalCoverageList.Items[i];

    if TRadar_Vertical(data).FRadar_Coverage.Coverage_Index = TRadar_Vertical(FSelectedPoint).FRadar_Coverage.Coverage_Index then
    begin
      FVerticalCoverageList.Delete(i);
      FSelectedPoint := nil;
      break;
    end;
  end;

  UpdateRadarVerticalCoverageForm;
  btnApply.Enabled := True;
end;

procedure TfrmRadarCoverageGraphic.UpdateRadarVerticalCoverageForm;
begin
  btnDelete.Enabled := Assigned(FSelectedPoint);

  if Assigned(FSelectedPoint) then
  begin
    with TRadar_Vertical(FSelectedPoint).FRadar_Coverage do
    begin
      lblSelectedRange.Caption := FormatFloat('0.00', Vert_Coverage_Range);
      lblSelectedElevation.Caption := FormatFloat('0', Vert_Cover_Max_Elevation);
    end;
  end
  else
  begin
    lblSelectedRange.Caption := '-';
    lblSelectedElevation.Caption := '-';
  end;

  edtRangeMin.Text := FormatFloat('0.00', FRangeMin);
  edtRangeMax.Text := FormatFloat('0.00', FRangeMax);
  edtElevationMin.Text := FormatFloat('0', FElevationMin);
  edtElevationMax.Text := FormatFloat('0', FElevationMax);

  ClearCanvas;
  DrawGrid;
  DrawPoint;
end;

procedure TfrmRadarCoverageGraphic.imgGraphMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, posX, posY, pointIndex : Integer;
  data : TObject;
  aRange, aElevation : Double;
begin
  {Biar tidak susah nyelect di badian tepinya, ini di comment dulu}
//  if (X < FGrid.Left) or (X > FGrid.Right) or (Y < FGrid.Top) or (Y > FGrid.Bottom) then
//    Exit;

  FIsMouseDown := True;
  FSelectedPoint := nil;

  if btnSelect.Down then
  begin
    for i := 0 to FVerticalCoverageList.Count - 1 do
    begin
      data := FVerticalCoverageList.Items[i];

      with TRadar_Vertical(data).FRadar_Coverage do
      begin
        if (Vert_Coverage_Range < FRangeMin) or (Vert_Coverage_Range > FRangeMax) or (Vert_Cover_Min_Elevation < FElevationMin) or
           (Vert_Cover_Max_Elevation > FElevationMax) then
          Continue;

        ConvertValueToPosition(Vert_Coverage_Range, Vert_Cover_Min_Elevation, posX, posY);

        if (X >= posX - 3) and (X <= posX + 4) and (Y >= posY - 3) and (Y <= posY + 4) then
        begin
//          FSelectedPointIdDelete := i;
          FSelectedPoint := data;
          FSelectedElevation := esMin;
          Break;
        end;

        ConvertValueToPosition(Vert_Coverage_Range, Vert_Cover_Max_Elevation, posX, posY);
        if (X >= posX - 3) and (X <= posX + 4) and (Y >= posY - 3) and (Y <= posY + 4) then
        begin
//          FSelectedPointIdDelete := i;
          FSelectedPoint := data;
          FSelectedElevation := esMax;
          Break;
        end;
      end;
    end;
  end
  else if btnAdd.Down then
  begin
    ConvertPositionToValue(X, Y, aRange, aElevation);
    pointIndex := GetPointPosition(aRange, aRange);

    FSelectedPoint := TRadar_Vertical.Create;
    with TRadar_Vertical(FSelectedPoint).FRadar_Coverage do
    begin
      Radar_Index := SelectedRadar.FDef.Radar_Index;
      Coverage_Diagram := Ord(FSelectedCurve);
      Vert_Coverage_Range := aRange;

      if aElevation > 0 then
      begin
        Vert_Cover_Min_Elevation := aElevation * -1;
        Vert_Cover_Max_Elevation := aElevation;
      end
      else
      begin
        Vert_Cover_Min_Elevation := aElevation;
        Vert_Cover_Max_Elevation := aElevation * -1;
      end;
    end;

    FVerticalCoverageList.Insert(pointIndex, TRadar_Vertical(FSelectedPoint));

    btnApply.Enabled := True;
  end;
end;

procedure TfrmRadarCoverageGraphic.imgGraphMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  range, elevation : Double;
begin
  if (X < posBatasKiri) or (X > posBatasKanan) or (Y < posBatasAtas) or (Y > posBatasBawah) then
  begin
    lblCursorRange.Caption := '-';
    lblCursorElevation.Caption := '-';
  end
  else
  begin
    ConvertPositionToValue(X, Y, range, elevation);

    lblCursorRange.Caption := FormatFloat('0.00', range);
    lblCursorElevation.Caption := FormatFloat('0', elevation);
  end;

  FIsDragPoint := btnSelect.Down and FIsMouseDown and Assigned(FSelectedPoint);
end;

procedure TfrmRadarCoverageGraphic.imgGraphMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  newAspect, newProbability : Double;
  pointIndex, i, j : Integer;
  data : TObject;
begin
  UpdateRadarVerticalCoverageForm;
end;

{$ENDREGION}

{$REGION ' Filter User Handle '}

procedure TfrmRadarCoverageGraphic.edtRangeMaxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if StrToFloat(edtRangeMax.Text) <= FRangeMin  then
    begin
      ShowMessage('Invalid value');
      edtRangeMax.Text := FormatFloat('0.00', FRangeMax);
      Exit;
    end;

    FRangeMax := StrToInt(edtRangeMax.Text);
    UpdateRadarVerticalCoverageForm;
  end;
end;

procedure TfrmRadarCoverageGraphic.edtRangeMinKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if StrToFloat(edtRangeMin.Text) >= FRangeMax  then
    begin
      ShowMessage('Invalid value');
      edtRangeMin.Text := FormatFloat('0.00', FRangeMin);
      Exit;
    end;

    FRangeMin := StrToInt(edtRangeMin.Text);
    UpdateRadarVerticalCoverageForm;
  end;
end;

procedure TfrmRadarCoverageGraphic.edtElevationMaxKeyPress(Sender: TObject;   var Key: Char);
begin
  if Key = #13 then
  begin
    if StrToFloat(edtElevationMax.Text) <= FElevationMin  then
    begin
      ShowMessage('Invalid value');
      edtElevationMax.Text := FormatFloat('0', FElevationMax);
      Exit;
    end;

    FElevationMax := StrToInt(edtElevationMax.Text);
    UpdateRadarVerticalCoverageForm;
  end;
end;

procedure TfrmRadarCoverageGraphic.edtElevationMinKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if StrToFloat(edtElevationMin.Text) >= FElevationMax  then
    begin
      ShowMessage('Invalid value');
      edtElevationMin.Text := FormatFloat('0', FElevationMin);
      Exit;
    end;

    FElevationMin := StrToInt(edtElevationMin.Text);
    UpdateRadarVerticalCoverageForm;
  end;
end;

{$ENDREGION}

{$REGION ' Function Handle '}

procedure TfrmRadarCoverageGraphic.ClearCanvas;
begin
  with imgGraph.Canvas do
  begin
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    Rectangle(0, 0, imgGraph.Width - 1, imgGraph.Height - 1);
  end;
end;

procedure TfrmRadarCoverageGraphic.DrawGrid;
var
  i,
  tempX, tempY,
  tempRange, tempElevation : Integer;
  rvcData : TRadar_Vertical;
  aspectDiffMode, probabilityDiffMode : Integer;
  aspectDiff, probabilityDiff, diffX, diffY : Double;
  valueStr, probabilityLabel, aspectLabel : string;
begin
  with imgGraph.Canvas do
  begin
    {background}
    Pen.Color := clWhite;
    Pen.Style := psSolid;
    Brush.Color := clWhite;
    Brush.Style := bsSolid;

    {Batasan Grid}
    posBatasKiri := FGrid.Left + 60; {ditambah 60 untuk tempat textout sebelah kiri}
    posBatasKanan := FGrid.Left + FGrid.Width - 2;

    posBatasAtas := FGrid.Top + 50; {ditambah 50 untuk tempat textout sebelah atas}
    posBatasBawah := FGrid.Top + FGrid.Height - 2;

    xRatio := (posBatasKanan-posBatasKiri) / ((FRangeMax - FRangeMin) / 100);
    yRatio := (posBatasBawah-posBatasAtas) / ((FElevationMax - FElevationMin) / 50000);

    tempRange := Round (FRangeMin);
    tempElevation := Round(FElevationMax);

    {$REGION ' Menggambar Garis Horizontal '}
    tempY := posBatasKiri;
    while tempElevation >= FElevationMin do
    begin
      {Menggambar garis y = 0}
      if tempElevation = 0 then
      begin
        Pen.Color := clBlack;
        Pen.Style := psSolid;
        MoveTo(posBatasKiri, tempY);
        LineTo(posBatasKanan, tempY);

        TextOut(posBatasKiri - 15, tempY - 4, IntToStr(tempElevation));
        y0 := tempY;
      end
      {Menggambar selain garis y = 0, dari atas kebawah}
      else
      begin
        Pen.Color := clGray;
        Pen.Style := psDot;
        MoveTo(posBatasKiri, tempY);
        LineTo(posBatasKanan, tempY);

        TextOut(posBatasKiri - 45, tempY - 4, IntToStr(tempElevation));
      end;

      {update posisi Y, dari top ke bottom}
      tempY := tempY + Round(yRatio);
      tempElevation := tempElevation - 50000;
    end;
    {$ENDREGION}

    {$REGION ' Menggambar Garis Vertical '}
    tempX := posBatasKiri;
    while tempRange <= FRangeMax do
    begin
      {Menggambar garis x = 0}
      if tempRange = 0 then
      begin
        Pen.Color := clBlack;
        Pen.Style := psSolid;

        MoveTo(tempX, posBatasAtas);
        LineTo(tempX, posBatasBawah);

        MoveTo(tempX, y0);
        LineTo(tempX, y0 + 5);
      end
      {Menggambar selain garis x = 0, dari kiri ke kanan}
      else
      begin
        Pen.Color := clGray;
        Pen.Style := psDot;
        MoveTo(tempX, posBatasAtas);
        LineTo(tempX, posBatasBawah);

        Pen.Color := clBlack;
        Pen.Style := psSolid;
        MoveTo(tempX - Round(xRatio / 2), y0);
        LineTo(tempX - Round(xRatio / 2), y0 + 5);
        MoveTo(tempX, y0);
        LineTo(tempX, y0 + 5);

        TextOut(tempX - 10, y0 + 8, IntToStr(tempRange));
      end;

      tempX := tempX + Round(xRatio);
      tempRange := tempRange + 100;
    end;
    {$ENDREGION}

    TextOut(40, 20, 'Elevation (Feet)');
    TextOut(280, y0 + 25, 'Range (nm)');
  end;
end;

procedure TfrmRadarCoverageGraphic.DrawPoint;
var
  pointID, i, x, yMin, yMax, oldMin, oldMax : Integer;
  rvcData : TRadar_Vertical;
begin
  if FVerticalCoverageList.Count = 0 then
    Exit;

  with imgGraph.Canvas do
  begin

    Pen.Style := psSolid;
    Pen.Color := clBlack;
    Brush.Style := bsClear;

    {$REGION ' Draw max curve '}
    pointID := 0;
    for i := 0 to FVerticalCoverageList.Count - 1 do
    begin
      rvcData := FVerticalCoverageList.Items[i];

      x := Round(rvcData.FRadar_Coverage.Vert_Coverage_Range * xRatio / 100) + posBatasKiri;
      yMax := y0 - Round(rvcData.FRadar_Coverage.Vert_Cover_Max_Elevation / 50000 * yRatio);

      if Assigned(FSelectedPoint) and (rvcData = FSelectedPoint) then
      begin
        Brush.Color := clBlack;
        Brush.Style := bsSolid;
      end
      else
        Brush.Style := bsClear;

      Ellipse(x - 3, yMax - 3, x + 3, yMax + 3);

      if pointID = 0 then
      begin
        oldMax := yMax;
        MoveTo(x, oldMax);
      end
      else
      begin
        LineTo(x, yMax);
        oldMax := yMax;
        MoveTo(x, oldMax);
      end;

      Inc(pointID);
    end;
    {$ENDREGION}

    {$REGION ' Draw min curve '}
    pointID := 0;
    for i := 0 to FVerticalCoverageList.Count - 1 do
    begin
      rvcData := FVerticalCoverageList.Items[i];

      x := Round(rvcData.FRadar_Coverage.Vert_Coverage_Range * xRatio / 100) + posBatasKiri;
      yMin := y0 - Round(rvcData.FRadar_Coverage.Vert_Cover_Min_Elevation / 50000 * yRatio);

      if Assigned(FSelectedPoint) and (rvcData = FSelectedPoint) then
      begin
        Brush.Color := clBlack;
        Brush.Style := bsSolid;
      end
      else
        Brush.Style := bsClear;

      Ellipse(x - 3, yMin - 3, x + 3, yMin + 3);

      if pointID = 0 then
      begin
        oldMin := yMin;
        MoveTo(x, oldMin);
      end
      else
      begin
        LineTo(x, yMin);
        oldMin := yMin;
        MoveTo(x, oldMin);
      end;

      Inc(pointID);
    end;
    {$ENDREGION}

  end;
end;

procedure TfrmRadarCoverageGraphic.ConvertPositionToValue(const aX, aY: Integer; var aRange, aElevation: Double);
var
  posPercent : Double;
begin
  posPercent := (aX - posBatasKiri) / (posBatasKanan - posBatasKiri);
  aRange := FRangeMin + ((FRangeMax - FRangeMin) * posPercent);

  posPercent := (aY - y0) / (posBatasBawah - posBatasAtas);
  aElevation := (FElevationMin - FElevationMax) * posPercent;
end;

procedure TfrmRadarCoverageGraphic.ConvertValueToPosition(const aRange, aElevation: Double; var aX, aY: Integer);
var
  posPercent : Double;
begin
  posPercent := (aRange-FRangeMin)/(FRangeMax-FRangeMin);
  aX := Round((posPercent * (posBatasKanan - posBatasKiri)) +  posBatasKiri);

  posPercent := aElevation / (FElevationMin - FElevationMax);
  aY := Round((posPercent * (posBatasBawah - posBatasAtas)) + y0) ;

end;

function TfrmRadarCoverageGraphic.GetPointPosition(const aAspect, aProbability: Double): Integer;
var
  i : Integer;
  data : TObject;
begin
  Result := 0;

  for i := 0 to FVerticalCoverageList.Count - 1 do
  begin
    data := FVerticalCoverageList.Items[i];

    with TRadar_Vertical(data).FRadar_Coverage do
    begin
      if aAspect <  Vert_Coverage_Range then
      begin
        Result := i;
        Break;
      end;
    end;

    if i = FVerticalCoverageList.Count - 1 then
      Result := FVerticalCoverageList.Count;
  end;
end;

{$ENDREGION}
end.
