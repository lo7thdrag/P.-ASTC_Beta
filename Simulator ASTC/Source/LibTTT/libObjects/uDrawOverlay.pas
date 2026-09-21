unit uDrawOverlay;

interface

uses
  MapXLib_TLB, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImgList, ComCtrls, ToolWin, OleCtrls, uMapXHandler,
  uBaseCoordSystem, math, {TeCanvas,} ColorGrd, tttData, uT3Unit, uMainOverlay, uRecord,
  uMainStaticShape, uMainDynamicShape, uFormula, uDataTypes, uCoordConvertor, uGameData_TTT;

type
  TOverlayTemplateContainer = class
  private
    FConverter: TCoordConverter;
    procedure SetConverter(const Value: TCoordConverter);

  protected

  public
    Action : Byte;
    IdSelectObject, IdShape : Integer;
    IdSelectedTemplate : Integer;
    FList         : TList;
    FFormula      : TFormula;
    FSelectedDraw : TMainOverlayTemplate;
    StateOverlay  : Integer;
    NameSelectedTemplate : string;
    Editable : Boolean;
    isSelected : Boolean;

    recShapeStatic : TRecCmd_OverlayStaticShape;
    recShapeDynamic : TRecCmd_OverlayDynamicShape;

    // variabel unk membantu repos overlay dynamic
    pointParent, pointSShape, pointEShape : t2DPoint;
    idxOverlay : Integer; //untuk menandai urutan penggambaran overlay di scenario
    itemSelected        : TMainDynamicShape;
    postStartSelected : tRangeBearingPoint;  //unk mengambil nilai data ()yang akan digeser
    postEndSelected : tRangeBearingPoint; //unk mengambil nilai data ()yang akan digeser
    postCenterSelected : tRangeBearingPoint;  //unk mengambil nilai data ()yang akan digeser
    polyPointSelected : Array of TDotDynamic;

    constructor Create;
    destructor Destroy; override;

    function GetOverlayTemplate(IdOverlay: Integer): TMainOverlayTemplate;

    procedure Clear;
    procedure Draw(FCanvas: TCanvas; Map1: TMap);

    procedure AddOverlayTemplate(OvelayTemplate : TMainOverlayTemplate);
    procedure RemoveOverlayTemplate(OvelayTemplate : TMainOverlayTemplate);

    procedure ShowStreamDataDynamic(AStream: TStream; overlay :TMainOverlayTemplate);
    procedure ShowStreamDataStatic(AStream: TStream; overlay :TMainOverlayTemplate);

    procedure FindPoint(postCont: t2DPoint; var postValue : t2DPoint; vd, vi: Double);

    procedure SaveStreamDataStatic(AStream: TStream;idSelectedTemplate: Integer);
    procedure SaveStreamDataDynamic(AStream: TStream;idSelectedTemplate: Integer);

    // reposisi overlay
    procedure reposOverlayDynamic(startMoveX, startMoveY, X, Y: Integer);
    function FindParent(iParent: TT3PlatformInstance; var postValue : t2DPoint): Boolean;

    property Converter : TCoordConverter read FConverter write SetConverter;

  end;

  TDrawFlagPoint = class
  private
    FConverter: TCoordConverter;
    procedure SetConverter(const Value: TCoordConverter);

  protected

  public

    FList : TList;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Draw(FCanvas: TCanvas);

    function GetFlagPoint(FlagPointId : Integer): TFlagPoint;

    property Converter : TCoordConverter read FConverter write SetConverter;
  end;

  TDrawRuler = class
  private
    FConverter: TCoordConverter;
    procedure SetConverter(const Value: TCoordConverter);

  protected

  public
    postStart : t2DPoint;
    postEnd : t2DPoint;
    IsVisible : Boolean;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Draw(FCanvas: TCanvas);

    property Converter : TCoordConverter read FConverter write SetConverter;
  end;

  TDrawGridOrigin = class
  private
    FConverter: TCoordConverter;
    procedure SetConverter(const Value: TCoordConverter);

  protected

  public
    postCenter : t2DPoint;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Draw(FCanvas: TCanvas);

    property Converter : TCoordConverter read FConverter write SetConverter;
  end;

implementation
//uses
//  uOverlayTemplateEditor,ufTacticalDisplay, uBaseShape, uSimMgr_Client;

constructor TOverlayTemplateContainer.Create;
begin
  FList := TList.Create;
end;

destructor TOverlayTemplateContainer.Destroy;
begin
  FList.Free;
end;

procedure TOverlayTemplateContainer.Clear;
begin
  FList.Clear;
end;

procedure TOverlayTemplateContainer.AddOverlayTemplate(OvelayTemplate: TMainOverlayTemplate);
begin
  FList.Add(OvelayTemplate);
end;

procedure TOverlayTemplateContainer.RemoveOverlayTemplate(OvelayTemplate: TMainOverlayTemplate);
begin
  FList.Remove(OvelayTemplate);
end;

procedure TOverlayTemplateContainer.reposOverlayDynamic(startMoveX, startMoveY, X,
  Y: Integer);
var
  i : Integer;
  mx, my, nx, ny : Double;
  deltaMoveX, deltaMoveY : Double;
  deltaStartMoveX, deltaStartMoveY : Double;
  deltaEndMoveX, deltaEndMoveY : Double;

  // variabel pembantu text
  textRange : Double;
  textBearing : Double;

  // variabel pembantu line
  startLineRange : Double;
  startLineBearing : Double;
  endLineRange : Double;
  endLineBearing : Double;

  // Variabel pembantu rect
  rightUpperRectRange : Double;
  rightUpperRectBearing : Double;
  leftBottomRectRange : Double;
  leftBottomRectBearing : Double;
  Rx, Ry : Double;

  // variabel pembantu circle
  centerCircleRange : Double;
  centerCircleBearing : Double;

  // variabel pembantu ellipse
  centerEllipseRange : Double;
  centerEllipseBearing : Double;

  // variabel pembantu Arc
  centerArcRange : Double;
  centerArcBearing : Double;

  // variabel pembantu Sector
  centerSectorRange : Double;
  centerSectorBearing : Double;

  // variabel pembantu grid
  centerGridRange : Double;
  centerGridBearing : Double;

  // variabel pembantu polygon
  polyPointRange : Double;
  polyPointBearing : Double;

  point : TDotDynamic;
  pOffset, pSShape, pEShape : t2DPoint;
  BSShape , BEShape, BOffset : Double;

  bearingMove : Double;
begin
//  Converter.ConvertToMap(startMoveX, startMoveY, nx, ny);
//  Converter.ConvertToMap(x, y, mx, my);
//
//
//  if fmOverlayEditor.lblShape.Caption = 'Text'then
//  begin
//    deltaMoveX := pointSShape.X - nx;
//    deltaMoveY := pointSShape.Y - ny;
//
//    {Find Point offset from Ship}
//	  FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
////    {Find Shape from Point offset}
////	  BSShape := postStartSelected.Bearing + itemSelected.RotationOffset  ;
////	  FindPoint(pOffset, pSShape, postStartSelected.Range, BSShape);
//
//    {Find Shape from Ship + move}
////    rngShipToShape := CalcRange(pParent.X, pParent.Y, pSShape.X, pSShape.Y);
////    brgShipToShape := CalcBearing(pParent.X, pParent.Y, pSShape.X, pSShape.Y);
//
////    textRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    textBearing := CalcBearing(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY);
//
//    textRange := CalcRange(pOffset.X, pOffset.Y, mx + deltaMoveX, my + deltaMoveY );
//    textBearing := CalcBearing(pOffset.X, pOffset.Y,mx + deltaMoveX, my + deltaMoveY) - itemSelected.RotationOffset ;
//
//    case itemSelected.Orientation of
//      0 : textBearing := ValidateDegree(itemSelected.Parent.Heading + textBearing);
//      1 : textBearing := ValidateDegree(textBearing);
//	  end;
//
//    fmOverlayEditor.edtTextRange.Text     := FloatToStr(textRange);
//    fmOverlayEditor.edtTextBearing.Text   := FloatToStr(textBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrText;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Line' then
//  begin
//    deltaStartMoveX := pointSShape.X - nx;
//    deltaStartMoveY := pointSShape.Y - ny;
//
//    deltaEndMoveX := pointEShape.X - nx;
//    deltaEndMoveY := pointEShape.Y - ny;
//
//
//    {Find Point offset from Ship}
//	  FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
//    // Find Start Line
//    startLineRange := CalcRange(pOffset.X, pOffset.Y, mx+deltaStartMoveX, my+deltaStartMoveY);
//    startLineBearing := CalcBearing(pOffset.X, pOffset.Y, mx+deltaStartMoveX, my+deltaStartMoveY)- itemSelected.RotationOffset;
//
//    // Find End Line
//    endLineRange := CalcRange(pOffset.X, pOffset.Y, mx+deltaEndMoveX, my+deltaEndMoveY);
//    endLineBearing := CalcBearing(pOffset.X, pOffset.Y, mx+deltaEndMoveX, my+deltaEndMoveY)- itemSelected.RotationOffset;
//
//
////    {Find Shape from Point offset}
////	  BSShape := postStartSelected.Bearing + itemSelected.RotationOffset;
////	  FindPoint(pOffset, pSShape, postStartSelected.Range, BSShape);
//
////    BEShape := postEndSelected.Bearing + itemSelected.RotationOffset;
////    FindPoint(pOffset, pEShape, postEndSelected.Range, BEShape);
////    startLineRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    startLineBearing := CalcBearing(pointParent.X,pointParent.Y, pSShape.x + deltaMoveX ,pSShape.Y + deltaMoveY);
////    endLineRange := CalcRange(pointParent.X,pointParent.Y, pEShape.x + deltaMoveX ,pEShape.Y + deltaMoveY);
////    endLineBearing := CalcBearing(pointParent.X,pointParent.Y, pEShape.x + deltaMoveX ,pEShape.Y + deltaMoveY);
//
//    case itemSelected.Orientation of
//      0 :
//      begin
//        startLineBearing := ValidateDegree(itemSelected.Parent.Heading + startLineBearing);
//        endLineBearing := ValidateDegree(itemSelected.Parent.Heading + endLineBearing);
//      end;
//      1 :
//      begin
//        startLineBearing := ValidateDegree(startLineBearing);
//        endLineBearing := ValidateDegree(endLineBearing);
//      end;
//    end;
//
//    fmOverlayEditor.edtLineStartRange.Text    := FloatToStr(startLineRange);
//    fmOverlayEditor.edtLineStartBearing.Text  := FloatToStr(startLineBearing);
//    fmOverlayEditor.edtLineEndRange.Text      := FloatToStr(endLineRange);
//    fmOverlayEditor.edtLineEndBearing.Text    := FloatToStr(endLineBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrLine;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Rectangle' then
//  begin
//    deltaMoveX := mx - nx;
//    deltaMoveY := my - ny;
////    deltaStartMoveX := pointSShape.X - nx;
////    deltaStartMoveY := pointSShape.Y - ny;
//
////    deltaEndMoveX := pointEShape.X - nx;                                0
////    deltaEndMoveY := pointEShape.Y - ny;
//
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
//    {rightUpperRectRange := CalcRange(pOffset.X, pOffset.Y, pointSShape.X+deltaMoveX, pointSShape.Y+deltaMoveY);
//    rightUpperRectBearing := CalcBearing(pOffset.X, pOffset.Y, pointSShape.X+deltaMoveX, pointSShape.Y+deltaMoveY);
//    leftBottomRectRange := CalcRange(pOffset.X, pOffset.Y, pointEShape.X+deltaMoveX, pointEShape.Y+ deltaMoveY);
//    leftBottomRectBearing := CalcBearing(pOffset.X, pOffset.Y, pointEShape.X+deltaMoveX, pointEShape.Y+ deltaMoveY);
//    }
//
//    rightUpperRectRange := CalcRange(pOffset.X, pOffset.Y, pointSShape.X+deltaMoveX, pointSShape.Y+deltaMoveY);
//    rightUpperRectBearing := CalcBearing(pOffset.X, pOffset.Y, pointSShape.X+deltaMoveX, pointSShape.Y+deltaMoveY);
//    leftBottomRectRange := CalcRange(pOffset.X, pOffset.Y, pointEShape.X+deltaMoveX, pointEShape.Y+ deltaMoveY);
//    leftBottomRectBearing := CalcBearing(pOffset.X, pOffset.Y, pointEShape.X+deltaMoveX, pointEShape.Y+ deltaMoveY);
//
//    {Find Shape from Point offset}
////    BSShape := postStartSelected.Bearing;
////    BEShape := postEndSelected.Bearing;
////    FindPoint(pOffset, pSShape, postStartSelected.Range, BSShape);
////    FindPoint(pOffset, pEShape, postEndSelected.Range, BEShape);
//
////    rightUpperRectRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    rightUpperRectBearing := CalcBearing(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    leftBottomRectRange := CalcRange(pointParent.X,pointParent.Y, pEShape.x + deltaMoveX ,pEShape.Y + deltaMoveY);;
////    leftBottomRectBearing := CalcBearing(pointParent.X,pointParent.Y, pEShape.x + deltaMoveX ,pEShape.Y + deltaMoveY);
//
//    case itemSelected.Orientation of
//      0 :
//      begin
//        rightUpperRectBearing := ValidateDegree(itemSelected.Parent.Heading + rightUpperRectBearing);
//        leftBottomRectBearing := ValidateDegree(itemSelected.Parent.Heading + leftBottomRectBearing);
//      end;
//      1 :
//      begin
//        rightUpperRectBearing := ValidateDegree(rightUpperRectBearing);
//        leftBottomRectBearing := ValidateDegree(leftBottomRectBearing);
//      end;
//    end;
//
//    fmOverlayEditor.edtRecStartRange.Text   := FloatToStr(rightUpperRectRange);
//    fmOverlayEditor.edtRecStartBearing.Text := FloatToStr(rightUpperRectBearing);
//    fmOverlayEditor.edtRecEndRange.Text     := FloatToStr(leftBottomRectRange);
//    fmOverlayEditor.edtRecEndBearing.Text   := FloatToStr(leftBottomRectBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrRectangle;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Circle' then
//  begin
//    deltaMoveX := pointSShape.X - nx;
//    deltaMoveY := pointSShape.Y - ny;
//
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//    centerCircleRange := CalcRange(pOffset.X, pOffset.Y, mx + deltaMoveX, my + deltaMoveY );
//    centerCircleBearing := CalcBearing(pOffset.X, pOffset.Y,mx + deltaMoveX, my + deltaMoveY) - itemSelected.RotationOffset ;
//
//
////    {Find Shape from Point offset}
////    BSShape := postCenterSelected.Bearing + itemSelected.RotationOffset;
////    FindPoint(pOffset, pSShape, postCenterSelected.Range, BSShape);
//
////    centerCircleRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    centerCircleBearing := CalcBearing(pointParent.X,pointParent.Y, pSShape.x + deltaMoveX ,pSShape.Y + deltaMoveY);
//
//    case itemSelected.Orientation of
//      0 : BOffset := ValidateDegree(itemSelected.Parent.Heading + itemSelected.BearingOffset);
//      1 : BOffset := ValidateDegree(itemSelected.BearingOffset);
//    end;
//
//    case itemSelected.Orientation of
//      0 : centerCircleBearing := ValidateDegree(itemSelected.Parent.Heading + centerCircleBearing);
//      1 : centerCircleBearing := ValidateDegree(centerCircleBearing);
//    end;
//
//    fmOverlayEditor.edtCircleRange.Text   := FloatToStr(centerCircleRange);
//    fmOverlayEditor.edtCircleBearing.Text := FloatToStr(centerCircleBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrCircle;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Ellipse' then
//  begin
//    deltaMoveX := pointSShape.X - nx;
//    deltaMoveY := pointSShape.Y - ny;
//
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
////    {Find Shape from Point offset}
////    BSShape := postCenterSelected.Bearing + itemSelected.RotationOffset;
////    FindPoint(pOffset, pSShape, postCenterSelected.Range, BSShape);
//
//    centerEllipseRange := CalcRange(pOffset.X, pOffset.Y, mx + deltaMoveX, my + deltaMoveY );
//    centerEllipseBearing := CalcBearing(pOffset.X, pOffset.Y,mx + deltaMoveX, my + deltaMoveY) - itemSelected.RotationOffset ;
//
//    case itemSelected.Orientation of
//      0 : centerEllipseBearing := ValidateDegree(itemSelected.Parent.Heading + centerEllipseBearing);
//      1 : centerEllipseBearing := ValidateDegree(centerEllipseBearing);
//    end;
//
//    fmOverlayEditor.edtEllipseRange.Text        := FloatToStr(centerEllipseRange);
//    fmOverlayEditor.edtEllipseBearing.Text      := FloatToStr(centerEllipseBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrEllipse;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Arc' then
//  begin
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
//    {Find Shape, Start Angle, End Angle from Point offset}
//    BSShape := postCenterSelected.Bearing + itemSelected.RotationOffset;
//    FindPoint(pOffset, pSShape, postCenterSelected.Range, BSShape);
//
//    {dont know}
////    FindPoint(pSShape, IStartPoint, radius, StartAngle+ RotationOffset);
////    FindPoint(pSShape, IEndPoint, radius, EndAngle+ RotationOffset);
//
//    centerArcRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
//    centerArcBearing := CalcBearing(pointParent.X,pointParent.Y, pSShape.x + deltaMoveX ,pSShape.Y + deltaMoveY);
//
//    case itemSelected.Orientation of
//      0 :
//      begin
//        centerArcBearing := ValidateDegree(itemSelected.Parent.Heading + centerArcBearing);
//      end;
//      1 :
//      begin
//        centerArcBearing := ValidateDegree(centerArcBearing);
//      end;
//    end;
//
//    fmOverlayEditor.edtArcRange.Text        := FloatToStr(centerArcRange);
//    fmOverlayEditor.edtArcBearing.Text      := FloatToStr(centerArcBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrArc;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Sector' then
//  begin
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
//    {Find Shape, Start Angle, End Angle from Point offset}
//    BSShape := postCenterSelected.Bearing + itemSelected.RotationOffset;
//    FindPoint(pOffset, pSShape, postCenterSelected.Range, BSShape);
//
//    centerSectorRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
//    centerSectorBearing := CalcBearing(pointParent.X,pointParent.Y, pSShape.x + deltaMoveX ,pSShape.Y + deltaMoveY);
//
//    fmOverlayEditor.edtSectorRange.Text       := FloatToStr(centerSectorRange);
//    fmOverlayEditor.edtSectorBearing.Text     := FloatToStr(centerSectorBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrSector;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Grid' then
//  begin
//    deltaMoveX := pointSShape.X - nx;
//    deltaMoveY := pointSShape.Y - ny;
//
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//
////    {Find Shape, Start Angle, End Angle from Point offset}
////    BSShape := postCenterSelected.Bearing + itemSelected.RotationOffset;
////    FindPoint(pOffset, pSShape, postCenterSelected.Range, BSShape);
//
//    centerGridRange := CalcRange(pOffset.X, pOffset.Y, mx + deltaMoveX, my + deltaMoveY );
//    centerGridBearing := CalcBearing(pOffset.X, pOffset.Y,mx + deltaMoveX, my + deltaMoveY) - itemSelected.RotationOffset ;
//
////    centerGridRange := CalcRange(pointParent.X, pointParent.Y, pSShape.x + deltaMoveX, pSShape.Y + deltaMoveY );
////    centerGridBearing := CalcBearing(pointParent.X,pointParent.Y, pSShape.x + deltaMoveX ,pSShape.Y + deltaMoveY);
//
//    fmOverlayEditor.edtTableRange.Text        := FloatToStr(centerGridRange);
//    fmOverlayEditor.edtTableBearing.Text      := FloatToStr(centerGridBearing);
//
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrGrid;
//    Exit;
//  end
//  else if fmOverlayEditor.lblShape.Caption = 'Polygon' then
//  begin
//    {Find Point offset from Ship}
//    FindPoint(pointParent, pOffset, itemSelected.RangeOffset, itemSelected.BearingOffset);
//    fmOverlayEditor.lvPolyVertexD.Clear;
//
//    for I := 0 to Length(polyPointSelected) - 1 do
//    begin
//      point := polyPointSelected[i];
//
//      {Find Shape from Point offset}
//      BSShape := point.Bearing + itemSelected.RotationOffset;
//      FindPoint(pOffset, pSShape, point.Range, BSShape);
//
//      {Find Shape from Ship}
//      polyPointRange := CalcRange(pointParent.X, pointParent.Y, pSShape.X, pSShape.Y);
//      polyPointBearing := CalcBearing(pointParent.X, pointParent.Y, pSShape.X, pSShape.Y);
//
//      case itemSelected.Orientation of
//        0 : polyPointBearing := ValidateDegree(itemSelected.Parent.Heading + polyPointBearing);
//        1 : polyPointBearing := ValidateDegree(polyPointBearing);
//      end;
//
//      with fmOverlayEditor.lvPolyVertexD.Items[I] do
//      begin
//        SubItems[0] := FloatToStr(polyPointRange);
//        SubItems[1] := FloatToStr(polyPointBearing);
//      end;
//
//    end;
//    fmOverlayEditor.Action := 2;
//    fmOverlayEditor.GbrPolygon;
//    Exit;
//  end;
end;

procedure TOverlayTemplateContainer.Draw(FCanvas: TCanvas; Map1: TMap);
var
  i : Integer;
  item : TMainOverlayTemplate;
begin
  for i := 0 to FList.Count - 1 do
  begin
    item := FList[i];
    item.Draw(FCanvas, Map1);
  end;
end;

function TOverlayTemplateContainer.FindParent(iParent: TT3PlatformInstance; var postValue: t2DPoint): Boolean;
begin
  Result := False;
  if not Assigned(iParent) then
    Exit;

  if (iParent.Dormant) or (iParent.FreeMe) then
    Exit;

  postValue.X := iParent.PosX;
  postValue.Y := iParent.PosY;

  Result := True;
end;

procedure TOverlayTemplateContainer.FindPoint(postCont: t2DPoint; var postValue: t2DPoint;
  vd, vi: Double);
var
  dx, dy : Double;
begin
  RangeBearingToCoord(vd, vi, dx, dy);
  postValue.X := postCont.X + dx;
  postValue.Y := postCont.Y + dy;
end;

function TOverlayTemplateContainer.GetOverlayTemplate(IdOverlay: Integer): TMainOverlayTemplate;
var
  i : Integer;
  temp : TMainOverlayTemplate;

begin
  Result := nil;

  for i := 0 to FList.Count - 1 do
  begin
    temp := TMainOverlayTemplate(FList.Items[i]);

    if temp.OverlayIndex = IdOverlay then
    begin
      Result := temp;
    end;
  end;
end;

procedure TOverlayTemplateContainer.SaveStreamDataDynamic(AStream: TStream;
  idSelectedTemplate: Integer);
var
  i, j : Integer;

//  HeaderData  : TFileHeader;
  TextData    : TTextRecord;
  LineData    : TLineRecord;
  RectData    : TRectRecord;
  ArcData     : TArcRecord;
  CircleData  : TCircleRecord;
  EllipseData : TEllipseRecord;
  SectorData  : TSectorRecord;
  GridData    : TGridRecord;
  PolygonData : TPolygonRecord;

  TextShape       : TTextDynamic;
  LineShape       : TLineDynamic;
  RectangleShape  : TRectangleDynamic;
  CircleShape     : TCircleDynamic;
  EllipseShape    : TEllipseDynamic;
  ArcShape        : TArcDynamic;
  SectorShape     : TSectorDynamic;
  GridShape       : TGridDynamic;
  PolygonShape    : TPolygonDynamic;
  point           : TDotDynamic;
  item            : TMainDynamicShape;
  OverlayTemplate : TMainOverlayTemplate;
begin
  AStream.Position := 0;

  OverlayTemplate := FList.Items[idSelectedTemplate];

  for i := 0 to OverlayTemplate.DynamicList.Count - 1 do
  begin
    item := OverlayTemplate.DynamicList[i];

    if item is TTextDynamic then
    begin
      TextShape := TTextDynamic(item);

      TextData.postStart       := FFormula.RangeBearingTop2D(TextShape.postStart);
      TextData.size            := TextShape.size;
      TextData.words           := TextShape.words;
      TextData.color           := TextShape.color;
      TextData.isSelected      := TextShape.isSelected;

      TextData.header.ID       := ovText;
      TextData.header.Exclude  := 'Text';
      TextData.header.Size     := sizeof(TTextRecord);

      AStream.Write(TextData, SizeOf(TTextRecord));
    end
    else if item is TLineDynamic then
    begin
      LineShape := TLineDynamic(item);

      LineData.postStart       := FFormula.RangeBearingTop2D(LineShape.postStart);
      LineData.postEnd         := FFormula.RangeBearingTop2D(LineShape.postEnd);
      LineData.color           := LineShape.color;
      LineData.isSelected      := LineShape.isSelected;
      LineData.weight          := LineShape.Weight;
      LineData.lineType        := LineShape.LineType;

      LineData.header.ID       := ovLine;
      LineData.header.Exclude  := 'Line';
      LineData.header.Size     := sizeof(TLineRecord);

      AStream.Write(LineData, SizeOf(TLineRecord));
    end
    else if item is TRectangleDynamic then
    begin
      RectangleShape := TRectangleDynamic(item);

      RectData.postStart       := FFormula.RangeBearingTop2D(RectangleShape.postStart);
      RectData.postEnd         := FFormula.RangeBearingTop2D(RectangleShape.postEnd);
      RectData.color           := RectangleShape.color;
      RectData.isSelected      := RectangleShape.isSelected;
      RectData.weight          := RectangleShape.Weight;
      RectData.lineType        := RectangleShape.LineType;
      RectData.brushStyle      := RectangleShape.BrushStyle;
      RectData.fillColor       := RectangleShape.ColorFill;

      RectData.header.ID       := ovRectangle;
      RectData.header.Exclude  := 'Rectangle';
      RectData.header.Size     := sizeof(TRectRecord);

      AStream.Write(RectData, SizeOf(TRectRecord));
    end
    else if item is TCircleDynamic then
    begin
      CircleShape := TCircleDynamic(item);

      CircleData.postCenter     := FFormula.RangeBearingTop2D(CircleShape.postCenter);
      CircleData.radius         := CircleShape.radius;
      CircleData.color          := CircleShape.color;
      CircleData.isSelected     := CircleShape.isSelected;
      CircleData.weight         := CircleShape.Weight;
      CircleData.lineType       := CircleShape.LineType;
      CircleData.brushStyle     := CircleShape.BrushStyle;
      CircleData.fillColor      := CircleShape.ColorFill;

      CircleData.header.ID      := ovCircle;
      CircleData.header.Exclude := 'Circle';
      CircleData.header.Size    := sizeof(TCircleRecord);

      AStream.Write(CircleData, SizeOf(TCircleRecord));
    end
    else if item is TEllipseDynamic then
    begin
      EllipseShape := TEllipseDynamic(item);

      EllipseData.postCenter     := FFormula.RangeBearingTop2D(EllipseShape.postCenter);
      EllipseData.Hradius        := EllipseShape.Hradius;
      EllipseData.Vradius        := EllipseShape.Vradius;
      EllipseData.color          := EllipseShape.color;
      EllipseData.isSelected     := EllipseShape.isSelected;
      EllipseData.weight         := EllipseShape.Weight;
      EllipseData.lineType       := EllipseShape.LineType;
      EllipseData.brushStyle     := EllipseShape.BrushStyle;
      EllipseData.fillColor      := EllipseShape.ColorFill;

      EllipseData.header.ID       := ovEllipse;
      EllipseData.header.Exclude  := 'Ellipse';
      EllipseData.header.Size     := sizeof(TEllipseRecord);

      AStream.Write(EllipseData, SizeOf(TEllipseRecord));
    end
    else if item is TArcDynamic then
    begin
      ArcShape := TArcDynamic(item);

      ArcData.postCenter      := FFormula.RangeBearingTop2D(ArcShape.postCenter);
      ArcData.radius          := ArcShape.radius;
      ArcData.startAngle      := ArcShape.startAngle;
      ArcData.endAngle        := ArcShape.endAngle;
      ArcData.color           := ArcShape.color;
      ArcData.isSelected      := ArcShape.isSelected;
      ArcData.weight          := ArcShape.Weight;
      ArcData.lineType        := ArcShape.LineType;

      ArcData.header.ID       := ovArc;
      ArcData.header.Exclude  := 'Arc';
      ArcData.header.Size     := sizeof(TArcRecord);

      AStream.Write(ArcData, SizeOf(TArcRecord));
    end
    else if item is TSectorDynamic then
    begin
      SectorShape := TSectorDynamic(item);

      SectorData.postCenter      := FFormula.RangeBearingTop2D(SectorShape.postCenter);
      SectorData.Oradius         := SectorShape.Oradius;
      SectorData.Iradius         := SectorShape.Iradius;
      SectorData.startAngle      := SectorShape.startAngle;
      SectorData.endAngle        := SectorShape.endAngle;
      SectorData.color           := SectorShape.color;
      SectorData.isSelected      := SectorShape.isSelected;
      SectorData.weight          := SectorShape.Weight;
      SectorData.lineType        := SectorShape.LineType;
      SectorData.brushStyle      := SectorShape.BrushStyle;
      SectorData.fillColor       := SectorShape.ColorFill;

      SectorData.header.ID       := ovSector;
      SectorData.header.Exclude  := 'Sector';
      SectorData.header.Size     := sizeof(TSectorRecord);

      AStream.Write(SectorData, SizeOf(TSectorRecord));
    end
    else if item is TGridDynamic then
    begin
      GridShape := TGridDynamic(item);

      GridData.postCenter      := FFormula.RangeBearingTop2D(GridShape.postCenter);
      GridData.HCount          := GridShape.HCount;
      GridData.WCount          := GridShape.WCount;
      GridData.Height          := GridShape.Height;
      GridData.Width           := GridShape.Width;
      GridData.Rotation        := GridShape.Rotation;
      GridData.color           := GridShape.color;
      GridData.isSelected      := GridShape.isSelected;
      GridData.weight          := GridShape.Weight;
      GridData.lineType        := GridShape.LineType;

      GridData.header.ID       := ovGrid;
      GridData.header.Exclude  := 'Grid';
      GridData.header.Size     := sizeof(TGridRecord);

      AStream.Write(GridData, SizeOf(TGridRecord));
    end
    else if item is TPolygonDynamic then
    begin
      PolygonShape := TPolygonDynamic(item);

//      SetLength(PolygonData.postStart, PolygonShape.polyList.Count);
      for j := 0 to PolygonShape.polyList.Count - 1 do
      begin
        point := PolygonShape.polyList.Items[j];

        PolygonData.postStart[j].X := point.Range;
        PolygonData.postStart[j].Y := point.Bearing;
      end;

      PolygonData.LengthArray     := j;
      PolygonData.color           := PolygonShape.color;
      PolygonData.isSelected      := PolygonShape.isSelected;
      PolygonData.weight          := PolygonShape.Weight;
      PolygonData.lineType        := PolygonShape.LineType;
      PolygonData.brushStyle      := PolygonShape.BrushStyle;
      PolygonData.fillColor       := PolygonShape.ColorFill;

      PolygonData.header.ID       := ovPolygon;
      PolygonData.header.Exclude  := 'Polygon';
      PolygonData.header.Size     := sizeof(TPolygonRecord) +
                                     sizeOf(t2DPoint)* length(PolygonData.postStart);

      AStream.Write(PolygonData, SizeOf(TPolygonRecord));

      for j := 0 to PolygonShape.polyList.Count - 1 do
      begin
         AStream.Write(PolygonData.postStart[j].X, SizeOf(tempPos));
         AStream.Write(PolygonData.postStart[j].Y, SizeOf(tempPos));
      end;
    end;
  end;
end;

procedure TOverlayTemplateContainer.SaveStreamDataStatic(AStream: TStream;
  idSelectedTemplate: Integer);
var
  i, j : Integer;

//  HeaderData  : TFileHeader;
  TextData    : TTextRecord;
  LineData    : TLineRecord;
  RectData    : TRectRecord;
  ArcData     : TArcRecord;
  CircleData  : TCircleRecord;
  EllipseData : TEllipseRecord;
  SectorData  : TSectorRecord;
  GridData    : TGridRecord;
  PolygonData : TPolygonRecord;

  TextShape       : TTextStatic;
  LineShape       : TLineStatic;
  RectangleShape  : TRectangleStatic;
  CircleShape     : TCircleStatic;
  EllipseShape    : TEllipseStatic;
  ArcShape        : TArcStatic;
  SectorShape     : TSectorStatic;
  GridShape       : TGridStatic;
  PolygonShape    : TPolygonStatic;
  point           : TDotStatic;
  item            : TMainStaticShape;
  OverlayTemplate : TMainOverlayTemplate;
begin
  AStream.Position := 0;

  OverlayTemplate := FList.Items[idSelectedTemplate];

  for i := 0 to OverlayTemplate.StaticList.Count - 1 do
  begin
    item := OverlayTemplate.StaticList[i];

    if item is TTextStatic then
    begin
      TextShape := TTextStatic(item);

      TextData.postStart       := TextShape.postStart;
      TextData.size            := TextShape.size;
      TextData.words           := TextShape.words;
      TextData.color           := TextShape.color;
      TextData.isSelected      := TextShape.isSelected;

      TextData.header.ID       := ovText;
      TextData.header.Exclude  := 'Text';
      TextData.header.Size     := sizeof(TTextRecord);

      AStream.Write(TextData, SizeOf(TTextRecord));
    end
    else if item is TLineStatic then
    begin
      LineShape := TLineStatic(item);

      LineData.postStart       := LineShape.postStart;
      LineData.postEnd         := LineShape.postEnd;
      LineData.color           := LineShape.color;
      LineData.isSelected      := LineShape.isSelected;
      LineData.weight          := LineShape.Weight;
      LineData.lineType        := LineShape.LineType;

      LineData.header.ID       := ovLine;
      LineData.header.Exclude  := 'Line';
      LineData.header.Size     := sizeof(TLineRecord);

      AStream.Write(LineData, SizeOf(TLineRecord));
    end
    else if item is TRectangleStatic then
    begin
      RectangleShape := TRectangleStatic(item);

      RectData.postStart       := RectangleShape.postStart;
      RectData.postEnd         := RectangleShape.postEnd;
      RectData.color           := RectangleShape.color;
      RectData.isSelected      := RectangleShape.isSelected;
      RectData.weight          := RectangleShape.Weight;
      RectData.lineType        := RectangleShape.LineType;
      RectData.brushStyle      := RectangleShape.BrushStyle;
      RectData.fillColor       := RectangleShape.ColorFill;

      RectData.header.ID       := ovRectangle;
      RectData.header.Exclude  := 'Rectangle';
      RectData.header.Size     := sizeof(TRectRecord);

      AStream.Write(RectData, SizeOf(TRectRecord));
    end
    else if item is TCircleStatic then
    begin
      CircleShape := TCircleStatic(item);

      CircleData.postCenter     := CircleShape.postCenter;
      CircleData.radius         := CircleShape.radius;
      CircleData.color          := CircleShape.color;
      CircleData.isSelected     := CircleShape.isSelected;
      CircleData.weight         := CircleShape.Weight;
      CircleData.lineType       := CircleShape.LineType;
      CircleData.brushStyle     := CircleShape.BrushStyle;
      CircleData.fillColor      := CircleShape.ColorFill;

      CircleData.header.ID      := ovCircle;
      CircleData.header.Exclude := 'Circle';
      CircleData.header.Size    := sizeof(TCircleRecord);

      AStream.Write(CircleData, SizeOf(TCircleRecord));
    end
    else if item is TEllipseStatic then
    begin
      EllipseShape := TEllipseStatic(item);

      EllipseData.postCenter     := EllipseShape.postCenter;
      EllipseData.Hradius        := EllipseShape.Hradius;
      EllipseData.Vradius        := EllipseShape.Vradius;
      EllipseData.color          := EllipseShape.color;
      EllipseData.isSelected     := EllipseShape.isSelected;
      EllipseData.weight         := EllipseShape.Weight;
      EllipseData.lineType       := EllipseShape.LineType;
      EllipseData.brushStyle     := EllipseShape.BrushStyle;
      EllipseData.fillColor      := EllipseShape.ColorFill;

      EllipseData.header.ID       := ovEllipse;
      EllipseData.header.Exclude  := 'Ellipse';
      EllipseData.header.Size     := sizeof(TEllipseRecord);

      AStream.Write(EllipseData, SizeOf(TEllipseRecord));
    end
    else if item is TArcStatic then
    begin
      ArcShape := TArcStatic(item);

      ArcData.postCenter      := ArcShape.postCenter;
      ArcData.radius          := ArcShape.radius;
      ArcData.startAngle      := ArcShape.startAngle;
      ArcData.endAngle        := ArcShape.endAngle;
      ArcData.color           := ArcShape.color;
      ArcData.isSelected      := ArcShape.isSelected;
      ArcData.weight          := ArcShape.Weight;
      ArcData.lineType        := ArcShape.LineType;

      ArcData.header.ID       := ovArc;
      ArcData.header.Exclude  := 'Arc';
      ArcData.header.Size     := sizeof(TArcRecord);

      AStream.Write(ArcData, SizeOf(TArcRecord));
    end
    else if item is TSectorStatic then
    begin
      SectorShape := TSectorStatic(item);

      SectorData.postCenter      := SectorShape.postCenter;
      SectorData.Oradius         := SectorShape.Oradius;
      SectorData.Iradius         := SectorShape.Iradius;
      SectorData.startAngle      := SectorShape.startAngle;
      SectorData.endAngle        := SectorShape.endAngle;
      SectorData.color           := SectorShape.color;
      SectorData.isSelected      := SectorShape.isSelected;
      SectorData.weight          := SectorShape.Weight;
      SectorData.lineType        := SectorShape.LineType;
      SectorData.brushStyle      := SectorShape.BrushStyle;
      SectorData.fillColor       := SectorShape.ColorFill;

      SectorData.header.ID       := ovSector;
      SectorData.header.Exclude  := 'Sector';
      SectorData.header.Size     := sizeof(TSectorRecord);

      AStream.Write(SectorData, SizeOf(TSectorRecord));
    end
    else if item is TGridStatic then
    begin
      GridShape := TGridStatic(item);

      GridData.postCenter      := GridShape.postCenter;
      GridData.HCount          := GridShape.HCount;
      GridData.WCount          := GridShape.WCount;
      GridData.Height          := GridShape.Height;
      GridData.Width           := GridShape.Width;
      GridData.Rotation        := GridShape.Rotation;
      GridData.color           := GridShape.color;
      GridData.isSelected      := GridShape.isSelected;
      GridData.weight          := GridShape.Weight;
      GridData.lineType        := GridShape.LineType;

      GridData.header.ID       := ovGrid;
      GridData.header.Exclude  := 'Grid';
      GridData.header.Size     := sizeof(TGridRecord);

      AStream.Write(GridData, SizeOf(TGridRecord));
    end
    else if item is TPolygonStatic then
    begin
      PolygonShape := TPolygonStatic(item);

//      SetLength(PolygonData.postStart, PolygonShape.polyList.Count);
      for j := 0 to PolygonShape.polyList.Count - 1 do
      begin
        point := PolygonShape.polyList.Items[j];

        PolygonData.postStart[j].X := point.X;
        PolygonData.postStart[j].Y := point.Y;
      end;

      PolygonData.LengthArray     := j;
      PolygonData.color           := PolygonShape.color;
      PolygonData.isSelected      := PolygonShape.isSelected;
      PolygonData.weight          := PolygonShape.Weight;
      PolygonData.lineType        := PolygonShape.LineType;
      PolygonData.brushStyle      := PolygonShape.BrushStyle;
      PolygonData.fillColor       := PolygonShape.ColorFill;

      PolygonData.header.ID       := ovPolygon;
      PolygonData.header.Exclude  := 'Polygon';
      PolygonData.header.Size     := sizeof(TPolygonRecord) +
                                     sizeOf(t2DPoint)* length(PolygonData.postStart);

      AStream.Write(PolygonData, SizeOf(TPolygonRecord));

      for j := 0 to PolygonShape.polyList.Count - 1 do
      begin
         AStream.Write(PolygonData.postStart[j].X, SizeOf(tempPos));
         AStream.Write(PolygonData.postStart[j].Y, SizeOf(tempPos));
      end;
    end;
  end;
end;

procedure TOverlayTemplateContainer.SetConverter(const Value: TCoordConverter);
begin
  FConverter := Value;
end;

procedure TOverlayTemplateContainer.ShowStreamDataDynamic(AStream: TStream; overlay: TMainOverlayTemplate);
var
  I           : integer;
  lastPos     : int64;

  HeaderData  : TFileHeader;
  TextData    : TTextRecord;
  LineData    : TLineRecord;
  RectData    : TRectRecord;
  ArcData     : TArcRecord;
  CircleData  : TCircleRecord;
  EllipseData : TEllipseRecord;
  SectorData  : TSectorRecord;
  GridData    : TGridRecord;
  PolygonData : TPolygonRecord;

  Point           : TDotDynamic;
  TextShape       : TTextDynamic;
  LineShape       : TLineDynamic;
  RectangleShape  : TRectangleDynamic;
  CircleShape     : TCircleDynamic;
  EllipseShape    : TEllipseDynamic;
  ArcShape        : TArcDynamic;
  SectorShape     : TSectorDynamic;
  GridShape       : TGridDynamic;
  PolygonShape    : TPolygonDynamic;

  OverlayTemplate : TMainOverlayTemplate;

begin
  OverlayTemplate := overlay;
  OverlayTemplate.DynamicList.Clear;

  AStream.Position := 0;
  lastPos := AStream.Position;

  while AStream.Position < AStream.Size do
  begin
    AStream.Read(HeaderData, SizeOf(HeaderData));
    AStream.Seek(lastPos, TSeekOrigin.soBeginning);

    with HeaderData do
    begin
      case ID of
        ovText :
        begin
          AStream.Read(TextData, SizeOf(TextData));

          TextShape := TTextDynamic.Create(Converter);
          TextShape.postStart := FFormula.p2DToRangeBearing(TextData.postStart);
          TextShape.size := TextData.Size;
          TextShape.words := TextData.Words;
          TextShape.Color := TextData.color;
          TextShape.isSelected := False;

          OverlayTemplate.DynamicList.Add(TextShape)
        end;
        ovLine :
        begin
          AStream.Read(LineData, SizeOf(LineData));

          LineShape := TLineDynamic.Create(Converter);
          LineShape.postStart := FFormula.p2DToRangeBearing(LineData.postStart);
          LineShape.postEnd := FFormula.p2DToRangeBearing(LineData.postEnd);
          LineShape.Color := LineData.color;
          LineShape.isSelected := False;
          LineShape.weight          := LineData.weight;
          LineShape.lineType        := LineData.lineType;

          OverlayTemplate.DynamicList.Add(LineShape)
        end;
        ovRectangle :
        begin
          AStream.Read(RectData, SizeOf(RectData));

          RectangleShape := TRectangleDynamic.Create(Converter);
          RectangleShape.postStart := FFormula.p2DToRangeBearing(RectData.postStart);
          RectangleShape.postEnd := FFormula.p2DToRangeBearing(RectData.postEnd);
          RectangleShape.Color := RectData.color;
          RectangleShape.isSelected := RectData.isSelected;
          RectangleShape.weight          := RectData.Weight;
          RectangleShape.lineType        := RectData.LineType;
          RectangleShape.brushStyle      := RectData.BrushStyle;
          RectangleShape.ColorFill       := RectData.fillColor;

          OverlayTemplate.DynamicList.Add(RectangleShape)
        end;
        ovCircle :
        begin
          AStream.Read(CircleData, SizeOf(CircleData));

          CircleShape := TCircleDynamic.Create(Converter);
          CircleShape.postCenter := FFormula.p2DToRangeBearing(CircleData.postCenter);
          CircleShape.radius := CircleData.radius;
          CircleShape.Color := CircleData.color;
          CircleShape.isSelected := False;
          CircleShape.weight          := CircleData.Weight;
          CircleShape.lineType        := CircleData.LineType;
          CircleShape.ColorFill       := CircleData.fillColor;
          CircleShape.brushStyle      := CircleData.BrushStyle;

          OverlayTemplate.DynamicList.Add(CircleShape)
        end;
        ovEllipse :
        begin
          AStream.Read(EllipseData, SizeOf(EllipseData));

          EllipseShape := TEllipseDynamic.Create(Converter);
          EllipseShape.postCenter := FFormula.p2DToRangeBearing(EllipseData.postCenter);
          EllipseShape.Hradius := EllipseData.Hradius;
          EllipseShape.Vradius := EllipseData.Vradius;
          EllipseShape.Color := EllipseData.color;
          EllipseShape.isSelected := False;
          EllipseShape.weight          := EllipseData.Weight;
          EllipseShape.lineType        := EllipseData.LineType;
          EllipseShape.brushStyle      := EllipseData.BrushStyle;
          EllipseShape.ColorFill       := EllipseData.fillColor;

          OverlayTemplate.DynamicList.Add(EllipseShape)
        end;
        ovArc :
        begin
          AStream.Read(ArcData, SizeOf(ArcData));

          ArcShape := TArcDynamic.Create(Converter);
          ArcShape.postCenter := FFormula.p2DToRangeBearing(ArcData.postCenter);
          ArcShape.radius := ArcData.radius;
          ArcShape.StartAngle := ArcData.startAngle;
          ArcShape.EndAngle := ArcData.endAngle;
          ArcShape.Color := ArcData.color;
          ArcShape.isSelected := False;
          ArcShape.weight          := ArcData.Weight;
          ArcShape.lineType        := ArcData.LineType;

          OverlayTemplate.DynamicList.Add(ArcShape)
        end;
        ovSector :
        begin
          AStream.Read(SectorData, SizeOf(SectorData));

          SectorShape := TSectorDynamic.Create(Converter);
          SectorShape.postCenter := FFormula.p2DToRangeBearing(SectorData.postCenter);
          SectorShape.Oradius := SectorData.Oradius;
          SectorShape.Iradius := SectorData.Iradius;
          SectorShape.StartAngle:= SectorData.StartAngle;
          SectorShape.EndAngle := SectorData.EndAngle;
          SectorShape.Color := SectorData.color;
          SectorShape.isSelected := False;
          SectorShape.weight          := SectorData.Weight;
          SectorShape.lineType        := SectorData.LineType;
          SectorShape.brushStyle      := SectorData.BrushStyle;
          SectorShape.ColorFill       := SectorData.fillColor;

          OverlayTemplate.DynamicList.Add(SectorShape)
        end;
        ovGrid :
        begin
          AStream.Read(GridData, SizeOf(GridData));

          GridShape := TGridDynamic.Create(Converter);
          GridShape.postCenter := FFormula.p2DToRangeBearing(GridData.postCenter);
          GridShape.HCount := GridData.HCount;
          GridShape.WCount := GridData.WCount;
          GridShape.Height := GridData.Height;
          GridShape.Rotation := GridData.Rotation;
          GridShape.Width := GridData.Width;
          GridShape.Color := GridData.color;
          GridShape.isSelected := False;
          GridShape.weight          := GridData.Weight;
          GridShape.lineType        := GridData.LineType;

          OverlayTemplate.DynamicList.Add(GridShape)
        end;
        ovPolygon :
        begin
          AStream.Read(PolygonData, SizeOf(PolygonData));

          PolygonShape := TPolygonDynamic.Create(Converter);

//          SetLength(PolygonData.postStart, PolygonData.LengthArray);
          for I := 0 to PolygonData.LengthArray - 1 do
          begin
            AStream.Read(PolygonData.postStart[I].X, SizeOf(tempPos));
            AStream.Read(PolygonData.postStart[I].Y, SizeOf(tempPos));

            Point := TDotDynamic.Create;

            Point.Range   := PolygonData.postStart[I].X;
            Point.Bearing := PolygonData.postStart[I].Y;
            PolygonShape.polyList.Add(Point);
          end;
          PolygonShape.Color := PolygonData.color;
          PolygonShape.isSelected := False;
          PolygonShape.weight          := PolygonData.Weight;
          PolygonShape.lineType        := PolygonData.LineType;
          PolygonShape.brushStyle      := PolygonData.BrushStyle;
          PolygonShape.ColorFill      := PolygonData.fillColor;

          OverlayTemplate.DynamicList.Add(PolygonShape)
        end;
      end;
    end;
    lastPos := AStream.Position;
  end;
end;

procedure TOverlayTemplateContainer.ShowStreamDataStatic(AStream: TStream; overlay: TMainOverlayTemplate);
var
  I           : integer;
  lastPos     : int64;

  HeaderData  : TFileHeader;
  TextData    : TTextRecord;
  LineData    : TLineRecord;
  RectData    : TRectRecord;
  ArcData     : TArcRecord;
  CircleData  : TCircleRecord;
  EllipseData : TEllipseRecord;
  SectorData  : TSectorRecord;
  GridData    : TGridRecord;
  PolygonData : TPolygonRecord;

  Point           : TDotStatic;
  TextShape       : TTextStatic;
  LineShape       : TLineStatic;
  RectangleShape  : TRectangleStatic;
  CircleShape     : TCircleStatic;
  EllipseShape    : TEllipseStatic;
  ArcShape        : TArcStatic;
  SectorShape     : TSectorStatic;
  GridShape       : TGridStatic;
  PolygonShape    : TPolygonStatic;
  OverlayTemplate : TMainOverlayTemplate;

begin
  OverlayTemplate := overlay;
  OverlayTemplate.StaticList.Clear;

  { AStream.Size = size of all stream -> bytes }
  AStream.Position := 0;
  lastPos := AStream.Position;

  while AStream.Position < AStream.Size do
  begin
    AStream.Read(HeaderData, SizeOf(HeaderData));
    AStream.Seek(lastPos, TSeekOrigin.soBeginning);
    with HeaderData do
    begin
      case ID of
        ovText :
        begin
          AStream.Read(TextData, SizeOf(TextData));

          TextShape := TTextStatic.Create(Converter);
          TextShape.postStart := TextData.postStart;
          TextShape.size := TextData.Size;
          TextShape.words := TextData.Words;
          TextShape.Color := TextData.color;
          TextShape.isSelected := False;

          OverlayTemplate.StaticList.Add(TextShape)
        end;
        ovLine :
        begin
          AStream.Read(LineData, SizeOf(LineData));

          LineShape := TLineStatic.Create(Converter);
          LineShape.postStart := LineData.postStart;
          LineShape.postEnd := LineData.postEnd;
          LineShape.Color := LineData.color;
          LineShape.isSelected := False;
          LineShape.weight          := LineData.Weight;
          LineShape.lineType        := LineData.LineType;

          OverlayTemplate.StaticList.Add(LineShape)
        end;
        ovRectangle :
        begin
          AStream.Read(RectData, SizeOf(RectData));

          RectangleShape := TRectangleStatic.Create(Converter);
          RectangleShape.postStart := RectData.postStart;
          RectangleShape.postEnd := RectData.postEnd;
          RectangleShape.Color := RectData.color;
          RectangleShape.isSelected := False;
          RectangleShape.weight          := RectData.Weight;
          RectangleShape.lineType        := RectData.LineType;
          RectangleShape.brushStyle      := RectData.BrushStyle;
          RectangleShape.ColorFill       := RectData.fillColor;

          OverlayTemplate.StaticList.Add(RectangleShape)
        end;
        ovCircle :
        begin
          AStream.Read(CircleData, SizeOf(CircleData));

          CircleShape := TCircleStatic.Create(Converter);
          CircleShape.postCenter := CircleData.postCenter;
          CircleShape.radius := CircleData.radius;
          CircleShape.Color := CircleData.color;
          CircleShape.isSelected := False;
          CircleShape.weight         := CircleData.Weight;
          CircleShape.lineType       := CircleData.LineType;
          CircleShape.brushStyle     := CircleData.BrushStyle;
          CircleShape.ColorFill      := CircleData.fillColor;

          OverlayTemplate.StaticList.Add(CircleShape)
        end;
        ovEllipse :
        begin
          AStream.Read(EllipseData, SizeOf(EllipseData));

          EllipseShape := TEllipseStatic.Create(Converter);
          EllipseShape.postCenter := EllipseData.postCenter;
          EllipseShape.Hradius := EllipseData.Hradius;
          EllipseShape.Vradius := EllipseData.Vradius;
          EllipseShape.Color := EllipseData.color;
          EllipseShape.isSelected := False;
          EllipseShape.weight         := EllipseData.Weight;
          EllipseShape.lineType       := EllipseData.LineType;
          EllipseShape.brushStyle     := EllipseData.BrushStyle;
          EllipseShape.ColorFill     := EllipseData.fillColor ;

          OverlayTemplate.StaticList.Add(EllipseShape)
        end;
        ovArc :
        begin
          AStream.Read(ArcData, SizeOf(ArcData));

          ArcShape := TArcStatic.Create(Converter);
          ArcShape.postCenter := ArcData.postCenter;
          ArcShape.radius := ArcData.radius;
          ArcShape.StartAngle := ArcData.startAngle;
          ArcShape.EndAngle := ArcData.endAngle;
          ArcShape.Color := ArcData.color;
          ArcShape.isSelected := False;
          ArcShape.weight          := ArcData.Weight;
          ArcShape.lineType        := ArcData.LineType;

          OverlayTemplate.StaticList.Add(ArcShape)
        end;
        ovSector :
        begin
          AStream.Read(SectorData, SizeOf(SectorData));

          SectorShape := TSectorStatic.Create(Converter);
          SectorShape.postCenter := SectorData.postCenter;
          SectorShape.Oradius := SectorData.Oradius;
          SectorShape.Iradius := SectorData.Iradius;
          SectorShape.StartAngle:= SectorData.StartAngle;
          SectorShape.EndAngle := SectorData.EndAngle;
          SectorShape.Color := SectorData.color;
          SectorShape.isSelected := False;
          SectorShape.weight          := SectorData.Weight;
          SectorShape.lineType        := SectorData.LineType;
          SectorShape.brushStyle      := SectorData.BrushStyle;
          SectorShape.ColorFill       := SectorData.fillColor;

          OverlayTemplate.StaticList.Add(SectorShape)
        end;
        ovGrid :
        begin
          AStream.Read(GridData, SizeOf(GridData));

          GridShape := TGridStatic.Create(Converter);
          GridShape.postCenter := GridData.postCenter;
          GridShape.HCount := GridData.HCount;
          GridShape.WCount := GridData.WCount;
          GridShape.Height := GridData.Height;
          GridShape.Rotation := GridData.Rotation;
          GridShape.Width := GridData.Width;
          GridShape.Color := GridData.color;
          GridShape.isSelected := False;
          GridShape.weight          := GridData.Weight;
          GridShape.lineType        := GridData.LineType;

          OverlayTemplate.StaticList.Add(GridShape)
        end;
        ovPolygon :
        begin
          AStream.Read(PolygonData, SizeOf(PolygonData));

          PolygonShape := TPolygonStatic.Create(Converter);

//          SetLength(PolygonData.postStart, PolygonData.LengthArray);
          for I := 0 to PolygonData.LengthArray - 1 do
          begin
            AStream.Read(PolygonData.postStart[I].X, SizeOf(tempPos));
            AStream.Read(PolygonData.postStart[I].Y, SizeOf(tempPos));

            Point := TDotStatic.Create;
            Point.X := PolygonData.postStart[I].X;
            Point.Y := PolygonData.postStart[I].Y;
            PolygonShape.polyList.Add(Point);
          end;
          PolygonShape.Color := PolygonData.color;
          PolygonShape.isSelected := False;
          PolygonShape.weight          := PolygonData.Weight;
          PolygonShape.lineType        := PolygonData.LineType;
          PolygonShape.brushStyle      := PolygonData.BrushStyle;
          PolygonShape.ColorFill       := PolygonData.fillColor;

          OverlayTemplate.StaticList.Add(PolygonShape)
        end;
      end;
    end;
    lastPos := AStream.Position;
  end;
end;


{ TDrawFlagPoint }

procedure TDrawFlagPoint.Clear;
begin
  FList.Clear;
end;

constructor TDrawFlagPoint.Create;
begin
  FList := TList.Create;
end;

destructor TDrawFlagPoint.Destroy;
begin
  FList.Free;
end;

procedure TDrawFlagPoint.Draw(FCanvas: TCanvas);
var
  i : Integer;
  item : TFlagPoint;
begin
  for i := 0 to FList.Count - 1 do
  begin
    item := FList[i];
    item.Draw(FCanvas);
  end;
end;

function TDrawFlagPoint.GetFlagPoint(FlagPointId: Integer): TFlagPoint;
var
  i : Integer;
  item : TFlagPoint;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
  begin
    item := FList[i];

    if item.PointId = FlagPointId then
    begin
      Result := item;
      Exit;
    end;
  end;
end;

procedure TDrawFlagPoint.SetConverter(const Value: TCoordConverter);
begin
  FConverter := Value;
end;

{ TDrawRuler }

procedure TDrawRuler.Clear;
begin

end;

constructor TDrawRuler.Create;
begin

end;

destructor TDrawRuler.Destroy;
begin

  inherited;
end;

procedure TDrawRuler.Draw(FCanvas: TCanvas);
var
  sx, sy, ex, ey: Integer;
begin
  inherited;

  Converter.ConvertToScreen(postStart.X, postStart.Y, sx, sy);
  Converter.ConvertToScreen(postEnd.X, postEnd.Y, ex, ey);

  with FCanvas do
  begin
    Brush.Style := bsClear;

    Pen.Style := psDash;
    Pen.Width := 2;
    Pen.color := clYellow;
    if not IsVisible then
      Exit;
    MoveTo(sx, sy);
    LineTo(ex, ey);
    Pen.Color := clGreen;
    Rectangle(sx-1,sy-1,sx+1,sy+1);
    Pen.Color := clRed;
    Rectangle(ex-1,ey-1,ex+1,ey+1);
  end;
end;

procedure TDrawRuler.SetConverter(const Value: TCoordConverter);
begin
  FConverter := Value;
end;

{ TDrawGridOrigin }

procedure TDrawGridOrigin.Clear;
begin
//
end;

constructor TDrawGridOrigin.Create;
begin
 //
end;

destructor TDrawGridOrigin.Destroy;
begin

  inherited;
end;

procedure TDrawGridOrigin.Draw(FCanvas: TCanvas);
var
  cx, cy,
  rx, ry, wx, wy, bx, by, gx, gy: Integer;
begin
  inherited;

  Converter.ConvertToScreen(postCenter.X, postCenter.Y, cx, cy);

  with FCanvas do
  begin

    Brush.Style := bsClear;

    Pen.Style := psSolid;
    Pen.Width := 2;

    {$REGION ' Red '}
    Pen.color := clRed;

    rx := cx - 5;
    ry := cy - 5;

    MoveTo(rx, ry);
    LineTo(rx - 25, ry);
    MoveTo(rx, ry);
    LineTo(rx, ry - 25);
    {$ENDREGION}

    {$REGION ' White '}
    Pen.color := clWhite;

    wx := cx + 5;
    wy := cy - 5;

    MoveTo(wx, wy);
    LineTo(wx + 25, wy);
    MoveTo(wx, wy);
    LineTo(wx, wy - 25);
    {$ENDREGION}

    {$REGION ' Blue '}
    Pen.color := clBlue;

    bx := cx + 5;
    by := cy + 5;

    MoveTo(bx, by);
    LineTo(bx + 25, by);
    MoveTo(bx, by);
    LineTo(bx, by + 25);
    {$ENDREGION}

    {$REGION ' Green '}
    Pen.color := clGreen;

    gx := cx - 5;
    gy := cy + 5;

    MoveTo(gx, gy);
    LineTo(gx - 25, gy);
    MoveTo(gx, gy);
    LineTo(gx, gy + 25);
    {$ENDREGION}

  end;
end;

procedure TDrawGridOrigin.SetConverter(const Value: TCoordConverter);
begin
  FConverter := Value;
end;

end.
