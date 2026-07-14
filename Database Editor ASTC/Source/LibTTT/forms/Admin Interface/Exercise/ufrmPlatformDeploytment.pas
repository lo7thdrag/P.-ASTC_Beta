unit ufrmPlatformDeploytment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, ImgList, OleCtrls, MapXLib_TLB,
  ComCtrls, ToolWin, Vcl.Imaging.pngimage, System.ImageList, System.Math,

  uDBAsset_Deploy, uDBAssetObject, uDBAsset_GameEnvironment, uCoordConvertor, uObjectVisuals, uDBAsset_Base, newClassASTT, tttData, uDBEditSetting,
  uBaseCoordSystem, uSimContainers, uSimDBEditor, uVectorVisual, uDBAsset_FontTaktis, ufrmRuler, uDrawOverlay, uMainStaticShape;

type
  E_MapCursor = (mceHook, mceMove, mceApproximatePosition, mceTargetingPlatform, mceTargetingPosition, mceScreenCapture);

  {$REGION 'TSymbolsProp tidak jadi dipakai'}
  TSymbolsProp = class
  private
    FisSelected : Boolean;
    procedure SetisSelected(const Value: Boolean);

  public
    bmp : TBitmapSymbol;
    Fplatform :  TPlatform_Instance;
    x, y : Double;
    color : TColor;
    idPlatform, platformDomain, forcePlatform : Integer;
    patchBmp : string;
    FontTaktis : TFontTaktis;
    procedure LoadBitmapSymbols(nameBitmap: string; colorBitmap: Integer);
    constructor firstBmp(file_bitmap: string);

    property isSelected : Boolean read FisSelected write SetisSelected;
  end;
  {$ENDREGION}

  TfrmPlatformDeploytment = class(TForm)
    pnl3Map: TPanel;
    Map1: TMap;
    pnlMainBackground: TPanel;
    ilToolbar: TImageList;
    pnl1Header: TPanel;
    pnlVertical1: TPanel;
    imgBackground: TImage;
    pnl2Editor: TPanel;
    pnlListPlatform: TPanel;
    pnlSelectedPlatform: TPanel;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    tsPlatforms: TTabSheet;
    lvPlatform: TListView;
    tsBases: TTabSheet;
    lvBase: TListView;
    tsOverlays: TTabSheet;
    lvOverlay: TListView;
    Panel1: TPanel;
    Label27: TLabel;
    lbl2: TLabel;
    lbDeskripsi: TLabel;
    gbBases: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblBaseNameDetail: TLabel;
    edtBaseLat: TEdit;
    edtBaseLong: TEdit;
    btnBaseUpdate: TButton;
    gbPlatform: TGroupBox;
    lblPlatformNameDetail: TLabel;
    btnUpdate: TButton;
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label9: TLabel;
    Label14: TLabel;
    lbHorizontal: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    lbSatuan: TLabel;
    edtLat: TEdit;
    edtLong: TEdit;
    edtCourse: TEdit;
    cbbGroundSpeed: TComboBox;
    edtAltitude: TEdit;
    TabSheet2: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label33: TLabel;
    Label37: TLabel;
    lbSetDefault: TLabel;
    edtFoodRemaining: TEdit;
    edtFreshwaterRemaining: TEdit;
    edtFuelRemaining: TEdit;
    edtLubricantsRemaining: TEdit;
    edtWaterRemaining: TEdit;
    TabSheet3: TTabSheet;
    lvTransport: TListView;
    Panel2: TPanel;
    Label10: TLabel;
    btnEmbarkPlatform: TButton;
    pnlVertical2: TPanel;
    pnlToolBar: TPanel;
    ToolBar1: TToolBar;
    btnIncreaseScale: TToolButton;
    cbbScale: TComboBox;
    btnDecreaseScale: TToolButton;
    btnRightSeparator: TToolButton;
    btnSelect: TToolButton;
    btnZoom: TToolButton;
    btnPan: TToolButton;
    btnCenterOnGame: TToolButton;
    btnRuler: TToolButton;
    btnLayerTool: TToolButton;
    pnlAlignToolBar: TPanel;
    pnl3SparatorHor1: TPanel;
    pnlCursorPosition: TPanel;
    pnl4Bottom: TPanel;
    btnScreenCapture: TButton;
    btnClose: TButton;
    btnOk: TButton;
    pnlVertical3: TPanel;
    pnlPlatformEditor: TPanel;
    pnl2SparatorHor1: TPanel;
    pnl1HeaderPlatform: TPanel;
    lblBearingFCenter: TLabel;
    lblDistanceFCenter: TLabel;
    lblGridLat: TLabel;
    lblGridLong: TLabel;
    lblPosLat: TLabel;
    lblPosLong: TLabel;
    lblmn1: TLabel;
    lblmn2: TLabel;
    lblmn3: TLabel;
    lblmn4: TLabel;
    lblmn5: TLabel;
    lblmnlbl47: TLabel;
    pnl3SparatorHor2: TPanel;
    btnTacticalSymbol: TToolButton;
    btnDimensionSymbol: TToolButton;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure edLatPositionKeyPress(Sender: TObject; var Key: Char);
    procedure edLongPositionKeyPress(Sender: TObject; var Key: Char);
    procedure edVertKeyPress(Sender: TObject; var Key: Char);
    procedure edHorzKeyPress(Sender: TObject; var Key: Char);
    procedure dtpActivationTimeKeyPress(Sender: TObject; var Key: Char);

    procedure PlatformDataChange(Sender: TObject);
    procedure PlatformDataClick(Sender: TObject);
    procedure PlatformDataKeyPress(Sender: TObject; var Key: Char);

    procedure spbtnAngularOffset_PatternOnSelfGuidanceClick(Sender: TObject);
    procedure spbtnPredefinedPattern_PatternOnTargetGuidanceClick( Sender: TObject);
    procedure spbtnPredefinedPattern_PatternOnPointGuidanceClick( Sender: TObject);

    procedure Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch; hOutputDC, hAttributeDC: Integer; const RectFull, RectInvalid: IDispatch);
    procedure Map1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Map1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Map1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure Map1MapViewChanged(Sender: TObject);
    procedure Map1DblClick(Sender: TObject);

    procedure btnApplyClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnScreenCaptureClick(Sender: TObject);
    procedure btnRulerClick(Sender: TObject);
    procedure btnHookClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnDecreaseScaleClick(Sender: TObject);
    procedure cbbScaleChange(Sender: TObject);
    procedure btnIncreaseScaleClick(Sender: TObject);
    procedure btnZoomClick(Sender: TObject);
    procedure btnCenterHookClick(Sender: TObject);
    procedure lvPlatformClick(Sender: TObject);
    procedure ImgFinishClick(Sender: TObject);
    procedure lvBaseClick(Sender: TObject);
    procedure lbSetDefaultClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnCenterOnGameClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnBaseUpdateClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnEmbarkPlatformClick(Sender: TObject);
    procedure btnLayerToolClick(Sender: TObject);
    procedure btnPanClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlMainBackgroundClick(Sender: TObject);
    procedure btnTacticalSymbolClick(Sender: TObject);
    procedure btnDimensionSymbolClick(Sender: TObject);


  private
    isPlatformPinPoint : boolean;
    isBasePinPoint : boolean;

    FMapCursor : E_MapCursor;
    FMapRulerCursor : E_RulerMapCursor;

    FSelectedAssetDeployment : TAsset_Deployment;
    FSelectedResourceAlloc : TResource_Allocation;
    FSelectedEnviArea : TGame_Environment_Definition;

    FPlatformActivationList : TList;
    FPlatformInstanceOnScenarioList : TList;
    FBaseList : TList;
    FOverlayList : TList;

    FHookedPlatform : TPlatform_Instance;
    FSelectedPlatform : TPlatform_Instance;
    FOriginalPlatform : TPlatform_Instance;

    FHookedBase : TResource_Base_Mapping;
    FSelectedBase : TResource_Base_Mapping;
    FDrawBase : TDrawBase;

    FMapMouseDownTime : TDateTime;
//    symbolBmp : TSymbolsProp;
    FBmpSym : TBitmapSymbol;

    FCanvas : TCanvas;
    FConverter : TCoordConverter;
    FLyrDraw : CMapXLayer;
    FMouseDown : Boolean;

    FPointX, FPointY : Integer;
    FS_PointXObj, FS_PointYObj, FE_PointXObj, FE_PointYObj : Integer;
    FModeTag : Byte;

    DrawFlagPoint: TDrawFlagPoint;

    procedure DeployPlatformInstance;
    procedure DeployBase;

    procedure UpAllToolbarButton;
    procedure UpdateCursorPositionData(const X, Y: Integer);
    procedure UpdatePlatformActivationList;
    procedure UpdateHookedPlatformData;
    procedure UpdateSelectedPlatformData;
    procedure UpdateSelectedBaseData;
    procedure UpdateSelectedPlatformLateralData;

    function FindNearestPlatform(const X, Y: Integer): TPlatform_Instance;
    function FindNearestBase(const X, Y: Integer): TResource_Base_Mapping;

    procedure ScreenShot(const DestBitmap : TBitmap);

    procedure LoadMap(aGeoset: string);
//    procedure LoadENC(aGeoset: string);
    function GetSymbol(const aType, aDomain: Integer): string;
    function GetColor(const aForce: Integer): TColor;

    procedure LoadAllPlatformInstance;
    procedure LoadAllBase;
    procedure LoadAllOverlay;
    procedure LoadAllWaypoint;

  public
    procedure OnAddRuller(Long,Lat : double);
    procedure GbrFlagPoint(mx, my: Double);
    procedure EditFlagPoint(id: Integer; mx, my: Double);

    property MapRulerCursor: E_RulerMapCursor read FMapRulerCursor write FMapRulerCursor;
    property MapCursor: E_MapCursor read FMapCursor write FMapCursor;
    property SelectedAssetDeployment : TAsset_Deployment read FSelectedAssetDeployment write FSelectedAssetDeployment;
    property SelectedResourceAlloc : TResource_Allocation read FSelectedResourceAlloc write FSelectedResourceAlloc;
    property SelectedEnviArea : TGame_Environment_Definition read FSelectedEnviArea write FSelectedEnviArea;

  end;

var
  frmPlatformDeploytment: TfrmPlatformDeploytment;

implementation

uses
  uDataModuleTTT, uScrCapture, uDBPattern, ufrmEmbarkedFromScenario;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmPlatformDeploytment.FormCreate(Sender: TObject);
begin
  FPlatformInstanceOnScenarioList := TList.Create;
  FPlatformActivationList := TList.Create;
  FBaseList := TList.Create;
  FOverlayList := TList.Create;

  FCanvas := TCanvas.Create;
  FConverter := TCoordConverter.Create;
  FBmpSym := TBitmapSymbol.Create;

  DrawFlagPoint := TDrawFlagPoint.Create;
  DrawFlagPoint.Converter := FConverter;

  FDrawBase := TDrawBase.Create;
  FDrawBase.Converter := FConverter;
  FModeTag := 0;//initials value tactical view
end;

procedure TfrmPlatformDeploytment.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FPlatformInstanceOnScenarioList);
  FreeItemsAndFreeList(FPlatformActivationList);
  FreeItemsAndFreeList(FBaseList);
  FreeItemsAndFreeList(FOverlayList);

  DrawFlagPoint.Free;
  FCanvas.Free;
  FConverter.Free;
  FBmpSym.Free;
  FDrawBase.Free
end;

procedure TfrmPlatformDeploytment.FormResize(Sender: TObject);
begin
  pnlAlignToolBar.Width := round((pnlToolBar.Width - 433) / 2);
end;

procedure TfrmPlatformDeploytment.FormShow(Sender: TObject);
begin
  tsPlatforms.Show;

  {$Region ' Load Map Area '}
  with FSelectedEnviArea.FGameArea do
  begin
    LoadMap(vAppDBSetting.MapGSTGame + '\' + Game_Area_Identifier + '\' + Game_Area_Identifier + '.gst');

    Map1.CenterX := Game_Centre_Long;
    Map1.CenterY := Game_Centre_Lat;
  end;

  FConverter.FMap := Map1;

  cbbScale.ItemIndex := cbbScale.Items.Count - 1;
  cbbScaleChange(cbbScale);

  {$ENDREGION}

  {$Region ' Load Platform '}
  LoadAllPlatformInstance;
  {$ENDREGION}

  {$Region ' Load Base '}
  LoadAllBase;
  {$ENDREGION}

  {$Region ' Load Overlay '}
  LoadAllOverlay;
  {$ENDREGION}

  {$Region ' Load Waypoint '}
//  LoadAllPlatformInstance;
  {$ENDREGION}

  {$Region ' Set Cursor '}
  isPlatformPinPoint := False;
  isBasePinPoint := False;
  Map1.MousePointer := miDefaultCursor;

  FHookedPlatform := nil;
  FSelectedPlatform := nil;
  FOriginalPlatform := nil;

  FHookedBase := nil;
  FSelectedBase := nil;
  {$ENDREGION}

  btnSelect.OnClick(nil);

  UpdateSelectedPlatformData;
  UpdatePlatformActivationList;

  Map1.Repaint;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure InitOleVariant(var TheVar: OleVariant);
begin
  TVarData(TheVar).vType := varError;
  TVarData(TheVar).vError := DISP_E_PARAMNOTFOUND;
end;

procedure TfrmPlatformDeploytment.btnApplyClick(Sender: TObject);
begin
  FOriginalPlatform := nil;

  with FSelectedPlatform do
  begin
    if FActivation.Platform_Event_Index = 0 then
      dmTTT.InsertPlatformActivation(FActivation)
    else
      dmTTT.UpdatePlatformActivation(FActivation);
  end;

  UpdatePlatformActivationList;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.btnBaseUpdateClick(Sender: TObject);
begin
  with FSelectedBase.FData do
  begin
    Latitude := dmsToLatt(edtBaseLat.Text);
    Longitude := dmsToLong(edtBaseLong.Text);
  end;

  DeployBase;
end;

procedure TfrmPlatformDeploytment.btnCancelClick(Sender: TObject);
begin
  if Assigned(FOriginalPlatform) then
  begin
    FSelectedPlatform.FActivation := FOriginalPlatform.FActivation;
    FOriginalPlatform := nil;
  end;

  Close;
end;

procedure TfrmPlatformDeploytment.ImgFinishClick(Sender: TObject);
begin
//  SaveData;
  Close;
end;

procedure TfrmPlatformDeploytment.btnRemoveClick(Sender: TObject);
begin
  with FSelectedPlatform.FActivation do
    dmTTT.DeletePlatformActivation(2, Platform_Event_Index);

  UpdatePlatformActivationList;
  FSelectedPlatform := nil;
  UpdateSelectedPlatformData;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.btnScreenCaptureClick(Sender: TObject);
var
  b : TBitmap;
begin
//  b := TBitmap.Create;
//  ScreenShot(b);
//  fScrCapture.Image1.Picture.Assign(b);
end;

procedure TfrmPlatformDeploytment.btnSelectClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnSelect.Down := True;

  Map1.CurrentTool := miSelectTool;
  Map1.MousePointer := miDefaultCursor;
end;

procedure TfrmPlatformDeploytment.btnTacticalSymbolClick(Sender: TObject);
begin
  UpAllToolbarButton;

  FModeTag := 1;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.ScreenShot(const DestBitmap : TBitmap);
var
  DC : HDC;
begin
  DC := GetDC(GetDesktopWindow);
  try
    DestBitmap.Width := GetDeviceCaps(DC, HORZRES);
    DestBitmap.Height := GetDeviceCaps(DC, VERTRES);
    BitBlt(DestBitmap.Canvas.Handle, 0, 0, DestBitmap.Width, DestBitmap.Height,
      DC, 0, 0, SRCCOPY);
  finally
    ReleaseDC(GetDesktopWindow, DC);
  end;
end;

procedure TfrmPlatformDeploytment.lvBaseClick(Sender: TObject);
var
  selectedbase : TResource_Base_Mapping;
begin
  if lvBase.Selected = nil then
  begin
    Exit;
  end;

  lbDeskripsi.Caption := 'Base Data : ';
  gbBases.BringToFront;

  {$REGION ' Show Base Data '}
  FSelectedBase := TResource_Base_Mapping(lvBase.Selected.Data);
  UpdateSelectedBaseData;
  {$ENDREGION}

  {$REGION ' Set Cursor to Pin Point '}
  isBasePinPoint := True;
  isPlatformPinPoint:= False;

  FMapCursor := mceApproximatePosition;

  Map1.CurrentTool := miArrowTool;
  Map1.MousePointer := miCrossCursor;
  {$ENDREGION}

end;

procedure TfrmPlatformDeploytment.lvPlatformClick(Sender: TObject);
begin
  if lvPlatform.Selected = nil then
  begin
    Exit;
  end;

  lbDeskripsi.Caption := 'Platform Data : ';
  gbPlatform.BringToFront;

  FSelectedPlatform := TPlatform_Instance(lvPlatform.Selected.Data);
  UpdateSelectedPlatformData;

  {$REGION ' Set Cursor to Pin Point '}
  isPlatformPinPoint:= True;
  isBasePinPoint := False;
  UpAllToolbarButton;

  FMapCursor := mceApproximatePosition;

  Map1.MousePointer := miCrossCursor;
  Map1.CurrentTool := miArrowTool;

  {$ENDREGION}

end;

procedure TfrmPlatformDeploytment.UpdateHookedPlatformData;
begin
  if not Assigned(FHookedPlatform) then
  begin
//    lbHookedName.Caption := '-';
//    lbHookedPosLat.Caption := '-';
//    lbHookedPosLong.Caption := '-';
//    lbHookedGridLat.Caption := '-';
//    lbHookedGridLong.Caption := '-';

    Exit;
  end;

  with FHookedPlatform.FActivation do
  begin
//    lbHookedName.Caption := FHookedPlatform.FData.Instance_Name;
//
//    lbHookedPosLat.Caption := formatDMS_latt(Init_Position_Latitude);
//    lbHookedPosLong.Caption := formatDMS_long(Init_Position_Longitude);
//
//    if Init_Position_Latitude < FSelectedEnviArea.FGameArea.Game_Centre_Lat then
//      lbHookedGridLat.Caption := FormatFloat('0.00', Init_Position_Cartesian_Y) + ' nm S'
//    else
//      lbHookedGridLat.Caption := FormatFloat('0.00', Init_Position_Cartesian_Y) + ' nm N';
//
//    if Init_Position_Longitude < FSelectedEnviArea.FGameArea.Game_Centre_Long then
//      lbHookedGridLong.Caption := FormatFloat('0.00', Init_Position_Cartesian_X) + ' nm W'
//    else
//      lbHookedGridLong.Caption := FormatFloat('0.00', Init_Position_Cartesian_X) + ' nm E';

    FSelectedPlatform := FHookedPlatform;
    UpdateSelectedPlatformData;
  end;
end;

procedure TfrmPlatformDeploytment.UpdatePlatformActivationList;
var
  i : Integer;
  platInst : TPlatform_Instance;
begin
  dmTTT.GetPlatformActivation(FSelectedAssetDeployment.FData.Deployment_Index, FPlatformActivationList);

  for i := 0 to FPlatformActivationList.Count - 1 do
  begin
    platInst := FPlatformActivationList.Items[i];

    if platInst.FData.Platform_Type = 1 then
    begin
      if dmTTT.GetVehicleDef(platInst.FData.Vehicle_Index, platInst.Vehicle) then
      begin
        case platInst.Vehicle.FData.Platform_Domain of
          vhdAir :
          begin
            case platInst.Vehicle.FData.Platform_Type of
              vhtRotaryRec, vhtRotaryASW, vhtRotarySurv, vhtRotaryAttack : platInst.VectorSymbol := THelicopterVectorSymbol.Create;
              vhtFixed, vhtFixedEW, vhtFixedRec, vhtFixedSurv : platInst.VectorSymbol := TAirPlaneVectorSymbol.Create;
            else
              platInst.VectorSymbol := TAirPlaneVectorSymbol.Create;
            end;
          end;
          vhdLand,
          vhdAmphibious :
          begin
            platInst.VectorSymbol := TTankVectorSymbol.Create;
          end;
          vhdSurface,
          vhdSubsurface :
          begin
            platInst.VectorSymbol := TShipVectorSymbol.Create;
          end;
        else
          platInst.VectorSymbol := TVectorSymbol.Create;
        end;
      end;
    end;
  end;
end;

procedure TfrmPlatformDeploytment.UpdateSelectedPlatformLateralData;
var
  pattern : TPredefined_Pattern;
  platInst : TPlatform_Instance;
begin
  with FSelectedPlatform.FActivation do
  begin
//    case cbLateralGuid.ItemIndex of
//      -1: grbDefaultKosong.BringToFront;
//      0:
//      begin
//        grbStraightGuidance.BringToFront;
//
//        edtCourse_StraightGuidance.Text := FormatFloat('000.0',
//          Init_Command_Course);
//        cmbGroundSpeed_StraightGuidance.ItemIndex := Init_Command_Ground;
//      end;
//      1:
//      begin
//        grbPatternOnSelfGuidance.BringToFront;
//
////        if (Pattern_Instance_Index = 0) or
////          not dmTTT.GetPredefinedPattern(Pattern_Instance_Index,
////          FSelectedResourceAlloc.FData.Resource_Alloc_Index, pattern) then
////          edtPredefinedPattern_PatternOnSelfGuidance.Text := '(None)'
////        else
////          edtPredefinedPattern_PatternOnSelfGuidance.Text :=
////            pattern.FData.Pattern_Identifier;
//
//        edtAngularOffset_PatternOnSelfGuidance.Text := FormatFloat('000.0',
//          Angular_Offset);
//      end;
//      2:
//      begin
//        grbPatternOnTargetGuidance.BringToFront;
//
////        if (Pattern_Instance_Index = 0) or
////          not dmTTT.GetPredefinedPattern(Pattern_Instance_Index,
////          FSelectedResourceAlloc.FData.Resource_Alloc_Index, pattern) then
////          edtPredefinedPattern_PatternOnTargetGuidance.Text := '(None)'
////        else
////          edtPredefinedPattern_PatternOnTargetGuidance.Text :=
////            pattern.FData.Pattern_Identifier;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_PatternOnTargetGuidance.Text := '(None)'
//        else
//          edtTarget_PatternOnTargetGuidance.Text :=
//            platInst.FData.Instance_Name;
//
//        edtAngularOffset_PatternOnTargetGuidance.Text := FormatFloat('000.0',
//          Angular_Offset);
//      end;
//      3:
//      begin
//        grbPatternOnPointGuidance.BringToFront;
//
////        if (Pattern_Instance_Index = 0) or
////          not dmTTT.GetPredefinedPattern(Pattern_Instance_Index,
////          FSelectedResourceAlloc.FData.Resource_Alloc_Index, pattern) then
////          edtPredefinedPattern_PatternOnPointGuidance.Text := '(None)'
////        else
////          edtPredefinedPattern_PatternOnPointGuidance.Text :=
////            pattern.FData.Pattern_Identifier;
//
//        edtAngularOffset_PatternOnPointGuidance.Text := FormatFloat('000.0',
//          Angular_Offset);
//
//        edtLatAnchor_PatternOnPointGuidance.Text :=
//          formatDM_latitude(Anchor_Latitude);
//        edtLongAnchor_PatternOnPointGuidance.Text :=
//          formatDM_longitude(Anchor_Longitude);
//
//        if Anchor_Latitude < FSelectedEnviArea.FGameArea.Game_Centre_Lat then
//          edtYanchor_PatternOnPointGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_Y) + ' nm S'
//        else
//          edtYanchor_PatternOnPointGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_Y) + ' nm N';
//
//        if Anchor_Longitude < FSelectedEnviArea.FGameArea.Game_Centre_Long then
//          edtXanchor_PatternOnPointGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_X) + ' nm W'
//        else
//          edtXanchor_PatternOnPointGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_X) + ' nm E';
//      end;
//      4:
//      begin
//        grbHelmGuidance.BringToFront;
//
//        edtHelmAngle_HelmGuidance.Text := FormatFloat('000.0',
//          Init_Command_Helm_Angle);
//        cmbGroundSpeed_HelmGuidance.ItemIndex := Init_Command_Ground;
//      end;
//      5:
//      begin
//        grbReturnToBaseGuidance.BringToFront;
//
//        cmbGroundSpeed_ReturnToBaseGuidance.ItemIndex := Init_Command_Ground;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtBase_ReturnToBaseGuidance.Text := '(None)'
//        else
//          edtBase_ReturnToBaseGuidance.Text := platInst.FData.Instance_Name;
//      end;
//      6:
//      begin
//        grbStationKeepOnTrackGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_StationKeepOnTrackGuidance.Text := '(None)'
//        else
//          edtTarget_StationKeepOnTrackGuidance.Text :=
//            platInst.FData.Instance_Name;
//
//        edtTargetRange_StationKeepOnTrackGuidance.Text := FormatFloat('0.0',
//          Target_Range);
//        edtAngleOffset_StationKeepOnTrackGuidance.Text := FormatFloat('000.0',
//          Target_Angle_Offset);
//        cbxAbsoluteOffsiteAngle_StationKeepOnTrackGuidance.Checked :=
//          Boolean(Target_Angle_Type);
//      end;
//      7:
//      begin
//        grbStationKeepOnPositionGuidance.BringToFront;
//
//        edtAnchorLat_StationKeepOnPositionGuidance.Text :=
//          formatDM_latitude(Anchor_Latitude);
//        edtAnchorLong_StationKeepOnPositionGuidance.Text :=
//          formatDM_longitude(Anchor_Longitude);
//
//        if Anchor_Latitude < FSelectedEnviArea.FGameArea.Game_Centre_Lat then
//          edtAnchorY_StationKeepOnPositionGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_Y) + ' nm S'
//        else
//          edtAnchorY_StationKeepOnPositionGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_Y) + ' nm N';
//
//        if Anchor_Longitude < FSelectedEnviArea.FGameArea.Game_Centre_Long then
//          edtAnchorX_StationKeepOnPositionGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_X) + ' nm W'
//        else
//          edtAnchorX_StationKeepOnPositionGuidance.Text := FormatFloat('0.00',
//            Anchor_Cartesian_X) + ' nm E';
//
//        cbxDriftsOnCurrent_StationKeepOnPositionGuidance.Checked :=
//          Boolean(Current_Drift);
//      end;
//      8:
//      begin
//        grbCircleOnTrackGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_CircleOnTrackGuidance.Text := '(None)'
//        else
//          edtTarget_CircleOnTrackGuidance.Text :=
//            platInst.FData.Instance_Name;
//
//        edtRadius_CircleOnTrackGuidance.Text := FormatFloat('0.0',
//          Target_Range);
//        cmbDirection_CircleOnTrackGuidance.ItemIndex := Direction_of_Travel;
//        cmbGroundSpeed_CircleOnTrackGuidance.ItemIndex := Init_Command_Ground;
//        edtRangeOffset_CircleOnTrackGuidance.Text := FormatFloat('0.0',
//          Dynamic_Circle_Range_Offset);
//        edtAngleOffset_CircleOnTrackGuidance.Text :=
//          IntToStr(Dynamic_Circle_Angle_Offset);
//        cbxAbsoluteOffsetAngle_CircleOnTrackGuidance.Checked :=
//          Boolean(Dynamic_Circle_Offset_Mode);
//      end;
//      9:
//      begin
//        grbCircleOnPointGuidance.BringToFront;
//
//        edtCentreLat_CircleOnPointGuidance.Text :=
//          formatDM_latitude(Circle_Latitude);
//        edtCentreLong_CircleOnPointGuidance.Text :=
//          formatDM_longitude(Circle_Longitude);
//
//        if Circle_Latitude < FSelectedEnviArea.FGameArea.Game_Centre_Lat then
//          edtCentreY_CircleOnPointGuidance.Text := FormatFloat('0.00', Circle_Y)
//            + ' nm S'
//        else
//          edtCentreY_CircleOnPointGuidance.Text := FormatFloat('0.00', Circle_Y)
//            + ' nm N';
//
//        if Circle_Longitude < FSelectedEnviArea.FGameArea.Game_Centre_Long then
//          edtCentreX_CircleOnPointGuidance.Text := FormatFloat('0.00', Circle_X)
//            + ' nm W'
//        else
//          edtCentreX_CircleOnPointGuidance.Text := FormatFloat('0.00', Circle_X)
//            + ' nm E';
//
//        edtRadius_CircleOnPointGuidance.Text := FormatFloat('0.0', Target_Range);
//        cmbDirection_CircleOnPointGuidance.ItemIndex := Direction_of_Travel;
//        cmbGroundSpeed_CircleOnPointGuidance.ItemIndex := Init_Command_Ground;
//      end;
//      10:
//      begin
//        grbZigZagGuidance.BringToFront;
//
//        cmbLegLength_ZigZagGuidance.ItemIndex := Zig_Zag_Leg_Type;
//        edtBaseCourse_ZigZagGuidance.Text := FormatFloat('000.0',
//          Init_Command_Course);
//        edtPeriod_ZigZagGuidance.Text := FormatFloat('0.0', Period_Distance);
//        edtAmplitude_ZigZagGuidance.Text := FormatFloat('0.0', Amplitude_Distance);
//        cmbGroundSpeed_ZigZagGuidance.ItemIndex := Init_Command_Ground;
//      end;
//      11:
//      begin
//        grbSinuateGuidance.BringToFront;
//
//        edtBaseCourse_SinuateGuidance.Text := FormatFloat('000.0',
//          Init_Command_Course);
//        edtPeriod_SinuateGuidance.Text := FormatFloat('0.0', Period_Distance);
//        edtAmplitude_SinuateGuidance.Text := FormatFloat('0.0',
//          Amplitude_Distance);
//        cmbGroundSpeed_SinuateGuidance.ItemIndex := Init_Command_Ground;
//      end;
//      12:
//      begin
//        grbShadowGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_ShadowGuidance.Text := '(None)'
//        else
//          edtTarget_ShadowGuidance.Text := platInst.FData.Instance_Name;
//
//        edtTargetRange_ShadowGuidance.Text := FormatFloat('0.0', Target_Range);
//      end;
//      13:
//      begin
//        grbEngagementGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_EngagementGuidance.Text := '(None)'
//        else
//          edtTarget_EngagementGuidance.Text := platInst.FData.Instance_Name;
//
//        edtTargetRange_EngagementGuidance.Text := FormatFloat('0.0', Target_Range);
//      end;
//      14:
//      begin
//        grbEvasionGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_EvasionGuidance.Text := '(None)'
//        else
//          edtTarget_EvasionGuidance.Text := platInst.FData.Instance_Name;
//      end;
//      15:
//      begin
//        grbOutRunGuidance.BringToFront;
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_OutRunGuidance.Text := '(None)'
//        else
//          edtTarget_OutRunGuidance.Text := platInst.FData.Instance_Name;
//      end;
//      16:
//      begin
//        grbWayPointGuidance.BringToFront;
//
//        cmbType_WayPointGuidance.ItemIndex := Waypoint_Termination;
//        edtRadius_WayPointGuidance.Text := FormatFloat('000.0',
//          Termination_Heading);
//
//        if (Guidance_Target = 0) or
//          not dmTTT.getPlatformInstanceByIndex(Guidance_Target, platInst) then
//          edtTarget_WayPointGuidance.Text := '(None)'
//        else
//          edtTarget_WayPointGuidance.Text := platInst.FData.Instance_Name;
//      end;
//    end;
  end;
end;

procedure TfrmPlatformDeploytment.UpdateSelectedBaseData;
begin
  if not Assigned(FSelectedBase) then
  begin
    lblBaseNameDetail.Caption := 'No Base Selected';

    edtBaseLat.Text := '';
    edtBaseLong.Text := '';
    Exit;
  end;

  with FSelectedBase do
  begin
    lblBaseNameDetail.Caption := FData.Base_Identifier;

    edtBaseLat.Text := formatDMS_latt(FData.Latitude);
    edtBaseLong.Text := formatDMS_long(FData.Longitude);
  end;
end;

procedure TfrmPlatformDeploytment.UpdateSelectedPlatformData;
var
  i, j : Integer;
  tempList : TList;
  tempPI : TPlatform_Instance;

begin
  if not Assigned(FSelectedPlatform) then
  begin
    lblPlatformNameDetail.Caption := 'No Ship Selected';

    edtAltitude.Enabled := False;
    lbHorizontal.Caption := 'Altitude';
    lbSatuan.Caption := 'feet';

    edtLat.Text := '';
    edtLong.Text := '';
    edtCourse.Text := FormatFloat('0.00', 0);
    cbbGroundSpeed.ItemIndex := -1;
    edtAltitude.Text := FormatFloat('0.00', 0);

    edtFuelRemaining.Text := FormatFloat('0.00', 0);
    edtFuelRemaining.Enabled := True;

    edtLubricantsRemaining.Text := FormatFloat('0.00', 0);
    edtFreshwaterRemaining.Text := FormatFloat('0.00', 0);
    edtWaterRemaining.Text := FormatFloat('0.00', 0);
    edtFoodRemaining.Text := FormatFloat('0.00', 0);

    lvTransport.Clear;

    Exit;
  end;

  with FSelectedPlatform do
  begin
    lblPlatformNameDetail.Caption := FData.Instance_Name;

    PageControl2.TabIndex := 0;

    {$REGION ' Initialize Sector '}
    if Vehicle.FData.Platform_Domain = Ord(vhdAir) then
    begin
      edtAltitude.Enabled := True;
      lbHorizontal.Caption := 'Altitude';
      lbSatuan.Caption := 'feet';

      edtAltitude.Text := FormatFloat('0.00', FActivation.Init_Altitude * C_Meter_To_Feet);
    end
    else
    begin
      if Vehicle.FData.Platform_Domain = Ord(vhdSubsurface) then
        edtAltitude.Enabled := True
      else
        edtAltitude.Enabled := False;

      lbHorizontal.Caption := 'Depth';
      lbSatuan.Caption := 'm';

      edtAltitude.Text := FormatFloat('0.00', FActivation.Init_Altitude);
    end;

    edtLat.Text := formatDMS_latt(FActivation.Init_Position_Latitude);
    edtLong.Text := formatDMS_long(FActivation.Init_Position_Longitude);

    edtCourse.Text := FormatFloat('0.00', FActivation.Init_Course);
    cbbGroundSpeed.ItemIndex := FActivation.Init_Ground_Speed;

    {$ENDREGION}

    {$REGION ' Logistic Sector '}
    if Motion.FData.Endurance_Type <> 0 then
    begin
      edtFuelRemaining.Text := 'Unlimited';
      edtFuelRemaining.Enabled := False;
    end
    else
    begin
      edtFuelRemaining.Text := FormatFloat('0.00', FActivation.Init_Fuel);
      edtFuelRemaining.Enabled := True;
    end;

    edtLubricantsRemaining.Text := FormatFloat('0.00', FActivation.Init_Lubricants);
    edtFreshwaterRemaining.Text := FormatFloat('0.00', FActivation.Init_Freshwater);
    edtWaterRemaining.Text := FormatFloat('0.00', FActivation.Init_Water);
    edtFoodRemaining.Text := FormatFloat('0.00', FActivation.Init_Food);
    {$ENDREGION}

    {$REGION ' Transport Sector '}
    lvTransport.Clear;

    j := 1;
    tempList := TList.Create;
    dmTTT.GetPlatformActivation(FSelectedAssetDeployment.FData.Deployment_Index, tempList);

    for i := 0 to tempList.Count - 1 do
    begin
      tempPI := TPlatform_Instance(tempList[i]);

      if tempPI.FActivation.Host_ID <> FSelectedPlatform.FData.Platform_Instance_Index then
        Continue;

      with lvTransport.Items.Add do
      begin
        Data := tempPI;
        Caption := IntToStr(j);
        SubItems.Add(TPlatform_Instance(tempPI).FData.Instance_Name);
        SubItems.Add(TPlatform_Instance(tempPI).FData.Track_ID);
        j := j+1;
      end;
    end;
    FreeItemsAndFreeList(tempList);

    {$ENDREGION}

  end;
end;

{$ENDREGION}

{$REGION ' ToolBar Handle '}

procedure TfrmPlatformDeploytment.btnDecreaseScaleClick(Sender: TObject);
begin
  if cbbScale.ItemIndex = 0 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex - 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmPlatformDeploytment.btnDimensionSymbolClick(Sender: TObject);
begin
  UpAllToolbarButton;

  FModeTag := 2;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.btnEmbarkPlatformClick(Sender: TObject);
begin
  if FSelectedPlatform = nil then
    Exit;

  frmEmbarkedFromScenario := TfrmEmbarkedFromScenario.Create(Self);
  try
    with frmEmbarkedFromScenario do
    begin
      AssetDeployment := FSelectedAssetDeployment;
      ResourceAlloc := FSelectedResourceAlloc;
      PlatformInstance := FSelectedPlatform;
      ShowModal;
    end;
  finally
    frmEmbarkedFromScenario.Free;
  end;

  FSelectedPlatform := nil;

  LoadAllPlatformInstance;
  UpdatePlatformActivationList;
  UpdateSelectedPlatformData;

  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.btnIncreaseScaleClick(Sender: TObject);
begin
  if cbbScale.ItemIndex = 16 then
    Exit;

  cbbScale.ItemIndex := cbbScale.ItemIndex + 1;
  cbbScaleChange(cbbScale);
end;

procedure TfrmPlatformDeploytment.btnLayerToolClick(Sender: TObject);
var
  vHelpFile, vHelpID : OleVariant;
begin
  UpAllToolbarButton;

  Map1.Layers.LayersDlg(vHelpFile, vHelpID);
end;

procedure TfrmPlatformDeploytment.btnCenterHookClick(Sender: TObject);
var
  zoom : Double;
begin
  zoom := StrToFloat(cbbScale.Items[cbbScale.ItemIndex]);

  with FSelectedEnviArea.FGameArea do
    Map1.ZoomTo(zoom, Game_Centre_Long, Game_Centre_Lat);
end;

procedure TfrmPlatformDeploytment.btnCenterOnGameClick(Sender: TObject);
begin
  UpAllToolbarButton;

  Map1.CenterX := FSelectedEnviArea.FGameArea.Game_Centre_Long;
  Map1.CenterY := FSelectedEnviArea.FGameArea.Game_Centre_Lat;
end;

procedure TfrmPlatformDeploytment.btnZoomClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnZoom.Down := True;

  Map1.CurrentTool := miZoomInTool;
  Map1.MousePointer := miZoomInCursor;

  FMapRulerCursor := mcSelect;
end;

procedure TfrmPlatformDeploytment.btnRulerClick(Sender: TObject);
begin
  btnruler.Down := not btnruler.Down;

  if btnruler.Down then
  begin
    with frmRuler do
    begin
      IDForm := 2;
      Show;
    end;
  end
  else
  begin
    frmRuler.Hide;
  end;
end;

procedure TfrmPlatformDeploytment.btnUpdateClick(Sender: TObject);
begin
  if FSelectedPlatform = nil then
    Exit;

  with FSelectedPlatform do
  begin
    FActivation.Init_Position_Latitude := dmsToLatt(edtLat.Text);
    FActivation.Init_Position_Longitude := dmsToLong(edtLong.Text);;
    FActivation.Init_Position_Cartesian_X := Abs(FActivation.Init_Position_Longitude - FSelectedEnviArea.FGameArea.Game_Centre_Long) * 60;
    FActivation.Init_Position_Cartesian_Y := Abs(FActivation.Init_Position_Latitude - FSelectedEnviArea.FGameArea.Game_Centre_Lat) * 60;
  end;

  DeployPlatformInstance;
end;

procedure TfrmPlatformDeploytment.btnViewClick(Sender: TObject);
begin
//  if btnView.Hint = 'View Platform Mode' then
//  begin
//    btnView.Hint := 'View Tactical Mode';
//    FModeTag := 2;//platom view
//  end
//  else if btnView.Hint = 'View Tactical Mode' then
//  begin
//    btnView.Hint := 'View Platform Mode';
//    FModeTag := 0;//tactical view
//  end;
//  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.btnPanClick(Sender: TObject);
begin
  UpAllToolbarButton;
  btnPan.Down := True;

  Map1.CurrentTool := miPanTool;
  Map1.MousePointer := miPanCursor;

  FMapRulerCursor := mcSelect;
end;

procedure TfrmPlatformDeploytment.btnPreviousClick(Sender: TObject);
var
  i : Integer;
  platInst : TPlatform_Instance;
  found : Boolean;
begin
  found := False;

  if Assigned(FHookedPlatform) then
  begin
    for i := 0 to FPlatformActivationList.Count - 1 do
    begin
      platInst := FPlatformActivationList.Items[i];

      if platInst.FData.Platform_Instance_Index = FHookedPlatform.FData.
        Platform_Instance_Index then
      begin
        found := True;
        Break;
      end;
    end;
  end;

  if found then
  begin
    if i - 1 >= 0 then
      FHookedPlatform := FPlatformActivationList.Items[i - 1]
    else
      FHookedPlatform :=
        FPlatformActivationList.Items[FPlatformActivationList.Count - 1];

    UpdateHookedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.btnNextClick(Sender: TObject);
var
  i : Integer;
  platInst : TPlatform_Instance;
  found : Boolean;
begin
  found := False;

  if Assigned(FHookedPlatform) then
  begin
    for i := 0 to FPlatformActivationList.Count - 1 do
    begin
      platInst := FPlatformActivationList.Items[i];

      if platInst.FData.Platform_Instance_Index = FHookedPlatform.FData.
        Platform_Instance_Index then
      begin
        found := True;
        Break;
      end;
    end;
  end;

  if found then
  begin
    if i + 1 <= FPlatformActivationList.Count - 1 then
      FHookedPlatform := FPlatformActivationList.Items[i + 1]
    else
      FHookedPlatform := FPlatformActivationList.Items[0];

    UpdateHookedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.btnHookClick(Sender: TObject);
begin
  FMapCursor := mceHook;

  Map1.MousePointer := miDefaultCursor;
  Map1.CurrentTool := miArrowTool;

end;

{$ENDREGION}

{$REGION ' Map Handle '}

procedure TfrmPlatformDeploytment.Map1DrawUserLayer(ASender: TObject; const Layer: IDispatch; hOutputDC, hAttributeDC: Integer; const RectFull, RectInvalid: IDispatch);
var
  i, j, ix, iy : integer;
  platInst : TPlatform_Instance;
  baseInst : TResource_Base_Mapping;
  color : TColor;
  fontTaktis : TFontTaktis;

  qx, qy : Integer;
  lf : TLogFont;
  tf : TFont;
  sz: TSize;
  q : TPoint;

  sinX, cosX : extended;
  FRotation : integer;
  FHeading   : double;

  sx, sy, ex, ey: Integer;
  itemStart, itemEnd  : TFlagPoint;
begin
  if not Assigned(FCanvas) then
    Exit;

  with FCanvas do
  begin
    Handle := hOutputDC;
    Pen.Color := RGB(200, 240, 100);
    Pen.Width := 3;

    for i := 0 to FPlatformActivationList.Count - 1 do
    begin
      platInst := FPlatformActivationList.Items[i];

      if platInst.FActivation.State_Transport then
        Continue;

      fontTaktis := TFontTaktis.Create;

      with platInst do
      begin
        FConverter.ConvertToScreen(FActivation.Init_Position_Longitude,FActivation.Init_Position_Latitude, ix, iy);

        case FModeTag of
          0: //tactical static view
          begin
            {$region ' Tactical Static View '}

            if Assigned(FHookedPlatform) and (platInst.FData.Platform_Instance_Index = FHookedPlatform.FData.Platform_Instance_Index) then
              Font.Color := RGB(255, 191, 128)
            else
              Font.Color := GetColor(FData.Force_Designation);

            dmTTT.getFontById(platInst.Vehicle.FData.font_id, fontTaktis);
            Font.Name := fontTaktis.FData.FONT_NAME;
            Font.Size := 24;
            Font.Style := [fsBold];
            SetBkMode(FCanvas.Handle, TRANSPARENT);
            FCanvas.TextOut(ix - 13, iy - 20, char(fontTaktis.FData.FONT_INDEX));

            {$endregion}
          end;
          1: //tactical dynamic view
          begin
            {$region ' Tactical Dynamic View '}

            dmTTT.getFontById(platInst.Vehicle.FData.font_id, fontTaktis);
            Font.Name  :=  fontTaktis.FData.FONT_NAME;
            Font.Size  :=  24;
            Font.Color :=  GetColor(FData.Force_Designation);
            Font.Style := [fsBold];

            FRotation := Round( 10.0 * (90.0 - FActivation.Init_Course ));
            FHeading := DegToRad(90.0 - FActivation.Init_Course);

            tf := TFont.Create;
            tf.Assign(Font);
            GetObject(tf.Handle, sizeof(lf), @lf);

            lf.lfEscapement  :=  FRotation;
            lf.lfOrientation :=  FRotation;

            tf.Handle := CreateFontIndirect(lf);
            Font.Assign(tf);
            tf.Free;

            SetTextAlign(handle, TA_CENTER or VTA_CENTER);
            sz := TextExtent(char(fontTaktis.FData.FONT_INDEX));

            SetBkMode(Handle, TRANSPARENT);
            SinCos(FHeading , sinX, cosX );

            qx := ix - Floor( 0.5 * sz.cy * sinX);
            qy := iy - Floor( 0.5 * sz.cy * cosX);


            TextOut(qx, qy, char(fontTaktis.FData.FONT_INDEX));
            Font.Style := [fsBold];

            Brush.Style := bsClear;

            {$endregion}
          end;
          2: //platform view
          begin
            {$region ' Dimension View '}

            FConverter.FMap := Map1;

            if Assigned(FHookedPlatform) and (platInst.FData.Platform_Instance_Index = FHookedPlatform.FData.Platform_Instance_Index) then
              platInst.VectorSymbol.Color := RGB(255, 191, 128)
            else
              platInst.VectorSymbol.Color := GetColor(FData.Force_Designation);

            platInst.VectorSymbol.Course := FActivation.Init_Course;
            platInst.VectorSymbol.DimWidth := Vehicle.FData.Width;
            platInst.VectorSymbol.DimLength := Vehicle.FData.Length;

            platInst.VectorSymbol.Center.X := ix;
            platInst.VectorSymbol.Center.Y := iy;

            platInst.VectorSymbol.ConvertCoord(FConverter);
            platInst.VectorSymbol.Draw(FCanvas);

            {$endregion}
          end;
        end;

      end;

      Font.Name := 'Courier';
      Font.Size := 8;
      Pen.Style := psDot;
      Pen.Width := 1;

      FRotation := Round( 10.0 * (90.0 - 90 ));
      FHeading := DegToRad(90.0 - 90);

      tf := TFont.Create;
      tf.Assign(Font);
      GetObject(tf.Handle, sizeof(lf), @lf);

      lf.lfEscapement  :=  FRotation;
      lf.lfOrientation :=  FRotation;

      tf.Handle := CreateFontIndirect(lf);
      Font.Assign(tf);
      tf.Free;

      SetTextAlign(handle, TA_CENTER or VTA_CENTER);
      sz := TextExtent(char(fontTaktis.FData.FONT_INDEX));

      SinCos(FHeading , sinX, cosX );

      qx := ix - Floor( 0.5 * sz.cy * sinX);
      qy := iy - Floor( 0.5 * sz.cy * cosX);


      SetBkMode(FCanvas.Handle, TRANSPARENT);
      FCanvas.TextOut(ix + 10, iy + 10, platInst.FData.Track_ID);

      fontTaktis.Free;
    end;


    FDrawBase.ListBase.Clear;
    for j := 0 to FBaseList.Count - 1 do
    begin
      baseInst := FBaseList.Items[j];
      FDrawBase.ListBase.Add(baseInst);
    end;

    FCanvas.Brush.Style := bsClear;
    FDrawBase.Draw(FCanvas);

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
          Pen.Color := clYellow ;
                  Pen.Width:= 2;
          MoveTo(sx, sy);
          LineTo(ex, ey);
        end;
      end;
    end;
    {$ENDREGION}
  end;
end;

procedure TfrmPlatformDeploytment.Map1MapViewChanged(Sender: TObject);
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

procedure TfrmPlatformDeploytment.Map1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  dx, dy, zoom : Double;
  platInst : TPlatform_Instance;

begin
  FMouseDown := Button = mbLeft;
  FConverter.ConvertToMap(X, Y, dx, dy);

  {$REGION ' Ruler Section '}
  if  FMapRulerCursor = mcRullerStart then
  begin
    OnAddRuller(dx,dy);
    frmRuler.Show;
    map1.Repaint;
  end
  else if  FMapRulerCursor = mcRullerEnd then
  begin
    OnAddRuller(dx,dy);
    frmRuler.Show;
    map1.Repaint;
  end;
  {$ENDREGION}

  {$REGION ' Klik Kanan '}
  if Button = mbRight then
  begin
    FMapCursor := mceHook;

    Map1.MousePointer := miDefaultCursor;
    Map1.CurrentTool := miArrowTool;
    Exit;
  end;
  {$ENDREGION}

  {$REGION ' Klik Kiri '}
  case FMapCursor of
    mceHook:
    begin
      FHookedPlatform := FindNearestPlatform(X, Y);
      if Assigned(FHookedPlatform) then
        UpdateHookedPlatformData;

      FHookedBase := FindNearestBase(X, Y);
      if Assigned(FHookedBase) then
    end;
    mceMove:
    begin
//      zoom := StrToFloat(cbbScale.Items[cbbScale.ItemIndex]);
//      Map1.ZoomTo(zoom, dx, dy);
    end;
    mceApproximatePosition:
    begin
      if isBasePinPoint then
      begin

        with FSelectedBase.FData do
        begin
          Latitude := dy;
          Longitude := dx;
        end;

        DeployBase;
      end;

      if isPlatformPinPoint then
      begin
        if Assigned(FSelectedPlatform) then
        begin
          FOriginalPlatform := FSelectedPlatform;

          with FSelectedPlatform.FActivation do
          begin
            Init_Position_Latitude := dy;
            Init_Position_Longitude := dx;
            Init_Position_Cartesian_X := Abs(Init_Position_Longitude - FSelectedEnviArea.FGameArea.Game_Centre_Long) * 60;
            Init_Position_Cartesian_Y := Abs(Init_Position_Latitude - FSelectedEnviArea.FGameArea.Game_Centre_Lat) * 60
          end;

          DeployPlatformInstance;

        end;

        if Assigned(FHookedPlatform) and (FSelectedPlatform.FData.Platform_Instance_Index = FHookedPlatform.FData.Platform_Instance_Index) then
          UpdateHookedPlatformData;
      end;

    end;
    mceTargetingPlatform:
    begin
      FOriginalPlatform := FSelectedPlatform;
      platInst := FindNearestPlatform(X, Y);

      if Assigned(platInst) then
        FSelectedPlatform.FActivation.Guidance_Target := platInst.FData.
          Platform_Instance_Index;
    end;
    mceTargetingPosition:
    begin
      with FSelectedPlatform.FActivation do
      begin
        case Init_Guidance_Type of
          3, 7:
          begin
            Anchor_Latitude := dy;
            Anchor_Longitude := dx;
            Anchor_Cartesian_X := (dx -
              FSelectedEnviArea.FGameArea.Game_Centre_Long) * 60;
            Anchor_Cartesian_Y := (dy -
              FSelectedEnviArea.FGameArea.Game_Centre_Lat) * 60;
          end;
          9:
          begin
            Circle_Latitude := dy;
            Circle_Longitude := dx;
            Circle_X := (dx -
              FSelectedEnviArea.FGameArea.Game_Centre_Long) * 60;
            Circle_Y := (dy -
              FSelectedEnviArea.FGameArea.Game_Centre_Lat) * 60;
          end;
        end;
      end;
    end;
    mceScreenCapture:;
  end;
  {$ENDREGION}

  UpdateSelectedBaseData;
  UpdateSelectedPlatformData;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.Map1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  UpdateCursorPositionData(X, Y);
end;

procedure TfrmPlatformDeploytment.Map1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  dx,dy : Double;
begin
  //xxx := X;
  //yyy := Y;
  //Map1.ConvertCoord(xxx, yyy, xx, yy, miScreenToMap);
  //stateDrawing := false;

//  if statePan then
//  begin
//    statePan := false;
//    stateSelect := true;
//    stateMove := true;
//    Map1.CurrentTool := miPanTool;
//    Map1.MousePointer := miCrossCursor;
//  end;

 {if isCapturingScreen then
 begin

  with fscrCapture do
  begin

   PActually.X := x;
   PActually.Y := Y;
   MouseIsDown := TRUE;

   TmpBmp := TBitmap.Create;

   with TmpBmp do
   begin
     Width := Round(abs(PActually.x - PDown.x));
     Height := Round(abs(PActually.y - PDown.y));
     BitBlt(TmpBmp.Canvas.Handle, 0, 0, Width, Height, fScrCapture.Image1.Canvas.Handle, map1.Left+ PDown.x,
     PDown.y, SRCCOPY);
     fCaptureRes.imgCaptureResult.AutoSize := false;
     fCaptureRes.imgCaptureResult.Picture.Bitmap.Assign(TmpBmp);
     fCaptureRes.Width := Width+10;
     fCaptureRes.Height := Height+fCaptureRes.panel3.height+10;
     fCaptureRes.ShowModal;

     if  fCaptureRes.recapture then  fCaptureRes.recapture:= false
     else isCapturingScreen := false;
     MouseIsDown :=false;
   end;

  end;

 end;
 gPoint.X := X;
 gPoint.Y := Y;
 map1.Repaint;   }

end;

procedure TfrmPlatformDeploytment.OnAddRuller(Long, Lat: double);
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

procedure TfrmPlatformDeploytment.Map1DblClick(Sender: TObject);
begin
  if Assigned(FHookedPlatform) then
  begin
    FSelectedPlatform := FHookedPlatform;
    UpdateSelectedPlatformData;
  end;
end;

procedure TfrmPlatformDeploytment.UpAllToolbarButton;
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

procedure TfrmPlatformDeploytment.UpdateCursorPositionData(const X, Y: Integer);
var
  dx, dy, diffX, diffY : Double;
begin
  FConverter.ConvertToMap(X, Y, dx, dy);

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

procedure TfrmPlatformDeploytment.LoadMap(aGeoset: String);
var
  z : OleVariant;
  i : Integer;
  mInfo : CMapXLayerInfo;
begin
  if Map1 = nil then
    Exit;

  InitOleVariant(z);
  Map1.Layers.RemoveAll;
  Map1.Geoset := aGeoset;

  if aGeoset <> '' then
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

  Map1.BackColor := clSkyBlue;
end;

{$ENDREGION}

{$REGION ' Additional Procedure '}

procedure TfrmPlatformDeploytment.DeployBase;
begin
  with FSelectedBase do
  begin
    dmTTT.UpdateResourceBaseMapping(FData);
  end;

  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.DeployPlatformInstance;
begin
  FOriginalPlatform := nil;

  with FSelectedPlatform do
  begin
    FActivation.Deployment_Index := FSelectedAssetDeployment.FData.Deployment_Index;
    FActivation.Platform_Instance_Index := FSelectedPlatform.FData.Platform_Instance_Index;

    if Vehicle.FData.Platform_Domain = Ord(vhdAir) then
    begin
      {disimpan di database dalam satuan meter}
      FActivation.Init_Altitude := (StrToFloat(edtAltitude.Text)) * C_Feet_To_Meter;
    end
    else
    begin
      {disimpan di database dalam satuan meter}
      FActivation.Init_Altitude := StrToFloat(edtAltitude.Text);
    end;


    FActivation.Init_Ground_Speed := cbbGroundSpeed.ItemIndex;
    FActivation.Init_Course := StrToFloat(edtCourse.Text);

    if edtFuelRemaining.Text <> 'Unlimited' then
      FActivation.Init_Fuel := StrToFloat(edtFuelRemaining.Text);

    FActivation.Init_Lubricants := StrToFloat(edtLubricantsRemaining.Text);
    FActivation.Init_Freshwater := StrToFloat(edtFreshwaterRemaining.Text);
    FActivation.Init_Water := StrToFloat(edtWaterRemaining.Text);
    FActivation.Init_Food := StrToFloat(edtFoodRemaining.Text);

    if FActivation.Platform_Event_Index = 0 then
      dmTTT.InsertPlatformActivation(FActivation)
    else
      dmTTT.UpdatePlatformActivation(FActivation);
  end;

  UpdatePlatformActivationList;
  Map1.Repaint;
end;

procedure TfrmPlatformDeploytment.LoadAllPlatformInstance;
var
  i : Integer;
  platInst : TPlatform_Instance;
  aForce : string;
begin
  lvPlatform.Clear;

  dmTTT.GetPlatformInstance(FSelectedResourceAlloc.FData.Resource_Alloc_Index,-1, -1, FPlatformInstanceOnScenarioList);

  for i := 0 to FPlatformInstanceOnScenarioList.Count - 1 do
  begin
    platInst := FPlatformInstanceOnScenarioList.Items[i];

    if platInst.FData.Platform_Type = 1 then
    begin
      dmTTT.GetVehicleDef(platInst.FData.Vehicle_Index, platInst.Vehicle);
      dmTTT.GetMotion_Characteristics(platInst.Vehicle.FData.Motion_Characteristics, platInst.Motion);
      dmTTT.GetLogisticDef(platInst.Vehicle.FData.Logistics_Index, platInst.Logistic);
      dmTTT.GetTransportDef(platInst.Vehicle.FData.Platform_Capability_Index, platInst.Transport);
      dmTTT.GetPlatformActivation(FSelectedAssetDeployment.FData.Deployment_Index, platInst.FData.Platform_Instance_Index, platInst.FActivation);
    end;

    if platInst.FActivation.State_Transport then
      Continue;

    with lvPlatform.Items.Add do
    begin
      Data := platInst;
      Caption := IntToStr(i + 1);
      SubItems.Add(TPlatform_Instance(platInst).FData.Instance_Name);
      SubItems.Add(TPlatform_Instance(platInst).FData.Track_ID);

      case TPlatform_Instance(platInst).FData.Force_Designation of
        1 : aForce := 'Red';
        2 : aForce := 'Yellow';
        3 : aForce := 'Blue';
        4 : aForce := 'Green';
        5 : aForce := 'White';
        6 : aForce := 'No Force';
      end;

      SubItems.Add(aForce);
    end;
  end;
end;

procedure TfrmPlatformDeploytment.lbSetDefaultClick(Sender: TObject);
begin
  with FSelectedPlatform do
  begin
    if Motion.FData.Endurance_Type <> 0 then
    begin
      edtFuelRemaining.Text := 'Unlimited';
      edtFuelRemaining.Enabled := False;
    end
    else
    begin
      edtFuelRemaining.Text := FormatFloat('0.00', Motion.FData.Max_Fuel_Capacity);
      edtFuelRemaining.Enabled := True;
    end;

    edtLubricantsRemaining.Text := FormatFloat('0.00', Logistic.FData.Max_Lubricants_Capacity);
    edtFreshwaterRemaining.Text := FormatFloat('0.00', Logistic.FData.Max_Water_Capacity);
    edtWaterRemaining.Text := FormatFloat('0.00', Logistic.FData.Max_Freshwater_Capacity);
    edtFoodRemaining.Text := FormatFloat('0.00', Logistic.FData.Max_Ration_Capacity);
  end;
end;

procedure TfrmPlatformDeploytment.LoadAllBase;
var
  i : Integer;
  base : TResource_Base_Mapping;
  aForce : string;
begin
  lvBase.Clear;

  dmTTT.GetResourceBaseMapping(FSelectedResourceAlloc.FData.Resource_Alloc_Index, 0, FBaseList);

  for i := 0 to FBaseList.Count - 1 do
  begin
    base := TResource_Base_Mapping(FBaseList.Items[i]);

    with lvBase.Items.Add do
    begin
      Data := base;
      Caption := IntToStr(i + 1);
      SubItems.Add(base.FData.Base_Identifier);

      case base.FData.Force of
        1 : aForce := 'Red';
        3 : aForce := 'Blue';
      end;

      SubItems.Add(aForce);
    end;
  end;
end;

procedure TfrmPlatformDeploytment.LoadAllOverlay;
var
  i : Integer;
  overlay : TResource_Overlay_Mapping;
  aForce : string;
begin
  lvOverlay.Clear;

  dmTTT.GetResourceOverlayMapping(FSelectedResourceAlloc.FData.Resource_Alloc_Index, 0, FOverlayList);

  for i := 0 to FOverlayList.Count - 1 do
  begin
    overlay := TResource_Overlay_Mapping(FOverlayList.Items[i]);

    with lvOverlay.Items.Add do
    begin
      Data := overlay;
      Caption := IntToStr(i + 1);
      SubItems.Add(overlay.FData.Overlay_Identifier);

      case overlay.FData.Force_Designation of
        1 : aForce := 'Red';
        3 : aForce := 'Blue';
      end;

      SubItems.Add(aForce);
      SubItems.Add('No');
    end;
  end;
end;

procedure TfrmPlatformDeploytment.LoadAllWaypoint;
begin
//
end;

function TfrmPlatformDeploytment.FindNearestBase(const X, Y: Integer): TResource_Base_Mapping;
var
  i, ix, iy : Integer;
  base : TResource_Base_Mapping;
begin
  Result := nil;

  for i := 0 to FBaseList.Count - 1 do
  begin
    base := FBaseList.Items[i];

    with base do
    begin
      FConverter.ConvertToScreen(FData.Longitude,FData.Latitude, ix, iy);

      if (X >= ix - 8) and (X <= ix + 8) and
        (Y >= iy - 8) and (Y <= iy + 8) then
      begin
        Result := base;
        Break;
      end;
    end;
  end;
end;

function TfrmPlatformDeploytment.FindNearestPlatform(const X, Y: Integer): TPlatform_Instance;
var
  i, ix, iy : Integer;
  platInst : TPlatform_Instance;
begin
  Result := nil;

  for i := 0 to FPlatformInstanceOnScenarioList.Count - 1 do
  begin
    platInst := FPlatformInstanceOnScenarioList.Items[i];

    with platInst do
    begin
      FConverter.ConvertToScreen(FActivation.Init_Position_Longitude,FActivation.Init_Position_Latitude, ix, iy);

      if (X >= ix - 8) and (X <= ix + 8) and (Y >= iy - 8) and (Y <= iy + 8) then
      begin
        Result := platInst;
        Break;
      end;
    end;
  end;
end;

function TfrmPlatformDeploytment.GetSymbol(const aType, aDomain: Integer): string;
begin
  case aType of
    1:
    begin
      case aDomain of
        0: Result := 'AirFriend.bmp';
        1: Result := 'SurfaceFriend.bmp';
        2: Result := 'SubsurfaceFriend.bmp';
        3: Result := 'LandFriend.bmp';
        4: Result := 'LandFriend.bmp';
      end;
    end;
    2: Result := 'MissileNeutral.bmp';
    3: Result := 'TorpedoNeutral.bmp';
    4: Result := 'SonobuoyNeutral.bmp';
    5: Result := 'MineNeutral.bmp';
    6: Result := 'AirFriend.bmp';
  end;
end;

procedure TfrmPlatformDeploytment.GbrFlagPoint(mx, my: Double);
var
  ObjectFlagPoint: TFlagPoint;
begin
  ObjectFlagPoint := TFlagPoint.Create(FConverter);
  ObjectFlagPoint.Post.X := mx;
  ObjectFlagPoint.Post.Y := my;
  DrawFlagPoint.FList.Add(ObjectFlagPoint);
end;

function TfrmPlatformDeploytment.GetColor(const aForce: Integer): TColor;
begin
  case aForce of
    1: Result := clRed;
    2: Result := clYellow;
    3: Result := clBlue;
    4: Result := clGreen;
    5: Result := clWhite;
    6: Result := clBlack;
  else
    Result := clWhite;
  end;
end;

{$ENDREGION}

{$REGION ' Filter Input '}

procedure TfrmPlatformDeploytment.dtpActivationTimeKeyPress(Sender: TObject; var Key: Char);
begin
//  if not btnApply.Enabled then
    FOriginalPlatform := FSelectedPlatform;

//  FSelectedPlatform.FActivation.Platform_Activation_Time :=
//    DateTimeToInt(dtpActivationTime.DateTime);

  UpdateSelectedPlatformData;
//  btnApply.Enabled := True;
end;

procedure TfrmPlatformDeploytment.edHorzKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
//    if not btnApply.Enabled then
      FOriginalPlatform := FSelectedPlatform;

//    btnApply.Enabled := True;

    with FSelectedPlatform.FActivation do
    begin
//      Init_Position_Cartesian_X := Abs(LongGridToDiffX(edHorz.Text));
//      Init_Position_Longitude := (LongGridToDiffX(edHorz.Text) / 60) +
//        FSelectedEnviArea.FGameArea.Game_Centre_Long;
    end;

    UpdateSelectedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.EditFlagPoint(id: Integer; mx, my: Double);
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

procedure TfrmPlatformDeploytment.edLatPositionKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
//    if not btnApply.Enabled then
      FOriginalPlatform := FSelectedPlatform;

//    btnApply.Enabled := True;

    with FSelectedPlatform.FActivation do
    begin
//      Init_Position_Latitude := dmsToLatt(edLatPosition.Text); //tidak memiliki pengecekan kesalahan format
//      Init_Position_Cartesian_Y := Abs(Init_Position_Latitude -
//        FSelectedEnviArea.FGameArea.Game_Centre_Lat) * 60
    end;

    UpdateSelectedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.edLongPositionKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
//    if not btnApply.Enabled then
      FOriginalPlatform := FSelectedPlatform;

//    btnApply.Enabled := True;

    with FSelectedPlatform.FActivation do
    begin
//      Init_Position_Longitude := dmsToLong(edLongPosition.Text); //tidak memiliki pengecekan kesalahan format
//      Init_Position_Cartesian_X := Abs(Init_Position_Longitude -
//        FSelectedEnviArea.FGameArea.Game_Centre_Long) * 60
    end;

    UpdateSelectedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.edVertKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
//    if not btnApply.Enabled then
      FOriginalPlatform := FSelectedPlatform;

//    btnApply.Enabled := True;

    with FSelectedPlatform.FActivation do
    begin
//      Init_Position_Cartesian_Y := Abs(LatGridToDiffY(edVert.Text));
//      Init_Position_Latitude := (LatGridToDiffY(edVert.Text) / 60) +
//        FSelectedEnviArea.FGameArea.Game_Centre_Lat;
    end;

    UpdateSelectedPlatformData;
    Map1.Repaint;
  end;
end;

procedure TfrmPlatformDeploytment.cbbScaleChange(Sender: TObject);
var
  z : Double;
  s : string;
begin
  Map1.OnMapViewChanged := nil;

  if cbbScale.ItemIndex < 0  then
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
    cbbScale.ItemIndex := cbbScale.ItemIndex -1 ;

  Map1.OnMapViewChanged := Map1MapViewChanged;
end;

procedure TfrmPlatformDeploytment.spbtnAngularOffset_PatternOnSelfGuidanceClick(Sender: TObject);
begin
//  fOtherSingle.ShowModal;
end;

procedure TfrmPlatformDeploytment.spbtnPredefinedPattern_PatternOnPointGuidanceClick(Sender: TObject);
begin
//  fOtherSingle.ShowModal;
end;

procedure TfrmPlatformDeploytment.spbtnPredefinedPattern_PatternOnTargetGuidanceClick(Sender: TObject);
begin
//  fOtherSingle.ShowModal;
end;

procedure TfrmPlatformDeploytment.PlatformDataChange(Sender: TObject);
begin
//  if not btnApply.Enabled then
    FOriginalPlatform := FSelectedPlatform;

//  btnApply.Enabled := True;

  with FSelectedPlatform.FActivation do
  begin
//    case TComboBox(Sender).Tag of
//      0: Init_Ground_Speed := cbGroundSpeed.ItemIndex;
//      1: Init_Vertical_Speed := cbVerticalSpeed.ItemIndex;
//      2:
//      begin
//        Init_Guidance_Type := cbLateralGuid.ItemIndex;
//        UpdateSelectedPlatformLateralData;
//      end;
//      3: Init_Command_Ground := TComboBox(Sender).ItemIndex; //SLG, HG,
//      4: Direction_of_Travel := TComboBox(Sender).ItemIndex;
//      5: Zig_Zag_Leg_Type := cmbLegLength_ZigZagGuidance.ItemIndex;
//      6: Waypoint_Termination := cmbType_WayPointGuidance.ItemIndex;
//    end;
  end;
end;

procedure TfrmPlatformDeploytment.PlatformDataClick(Sender: TObject);
begin
  if not Assigned(FSelectedPlatform) then
    Exit;

  if Sender is TSpeedButton then
  begin
    case TSpeedButton(Sender).Tag of
      0:
      begin

      end;
      1:
      begin
        FMapCursor := mceTargetingPlatform;

        Map1.MousePointer := miCrossCursor;
        Map1.CurrentTool := miArrowTool;
      end;
      2:
      begin
        FMapCursor := mceTargetingPosition;

        Map1.MousePointer := miCrossCursor;
        Map1.CurrentTool := miArrowTool;
      end;
    end;
  end
  else if Sender is TCheckBox then
  begin
    with FSelectedPlatform.FActivation do
    begin
      case TCheckBox(Sender).Tag of
        0: Target_Angle_Type := Ord(TCheckBox(Sender).Checked);
        1: Current_Drift := Ord(TCheckBox(Sender).Checked);
        2: Dynamic_Circle_Offset_Mode := Ord(TCheckBox(Sender).Checked);
      end;
    end;
  end;
end;

procedure TfrmPlatformDeploytment.PlatformDataKeyPress(Sender: TObject;var Key: Char);
var
  value : Double;
begin
  if not (Key in[#48 .. #57, #8, #13, #46]) then
    Key := #0;

//  btnApply.Enabled := True;

  if Key = #13 then
  begin
//    if not btnApply.Enabled then
      FOriginalPlatform := FSelectedPlatform;

    value := StrToFloat(TEdit(Sender).Text);

    with FSelectedPlatform.FActivation do
    begin
      case TEdit(Sender).Tag of
        0:
        begin
          if value >= 360 then
            value := 0;

          Init_Course := value;
        end;
        1:
        begin
          if value >= 360 then
            value := 0;

          Init_Helm_Angle := value;
        end;
        2: Init_Altitude := value;
        3:
        begin
          if value >= 360 then
            value := 0;

          Init_Command_Course := value;
        end;
        4:
        begin
          if value >= 360 then
            value := 0;

          Angular_Offset := value;
        end;
        5:
        begin
          if value >= 360 then
            value := 0;

          Init_Command_Helm_Angle := value;
        end;
        6: Target_Range := value;
        7:
        begin
          if value >= 360 then
            value := 0;

          Target_Angle_Offset := value;
        end;
        8: Radius_of_Travel := value;
        9: Dynamic_Circle_Range_Offset := value;
        10:
        begin
          if value >= 360 then
            value := 0;

          Dynamic_Circle_Angle_Offset := Round(value);
        end;
        11: Period_Distance := value;
        12: Amplitude_Distance := value;
        13:
        begin
          if value >= 360 then
            value := 0;

          Termination_Heading := value;
        end;
        14: Init_Command_Altitude := value;
      end;
    end;

    UpdateSelectedPlatformData;
  end;
end;

procedure TfrmPlatformDeploytment.pnlMainBackgroundClick(Sender: TObject);
begin

end;

{$ENDREGION}
{$REGION 'TSymbolsProp tidak jadi dipakai'}
{ TSymbolsProp }

constructor TSymbolsProp.firstBmp(file_bitmap: string);
begin
  bmp := TBitmapSymbol.Create;
  Self.bmp.LoadBitmap(file_bitmap, clRed);
  bmp.ConvertCoord(VConvertor);
  Fplatform := TPlatform_Instance.Create;
end;

procedure TSymbolsProp.LoadBitmapSymbols(nameBitmap: string;
  colorBitmap: Integer);
begin
  Self.bmp.LoadBitmap(nameBitmap, colorBitmap);
end;

procedure TSymbolsProp.SetisSelected(const Value: Boolean);
begin
  FisSelected := Value;
end;
{$endregion}
end.
