unit ufrmLeftNav;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzBmpBtn,
  Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, VrControls, VrWheel, Vcl.StdCtrls, Vcl.ComCtrls,
  VrMeter, AdvSmoothLabel, Vcl.Buttons,

  uT3Unit;

type
  TfrmLeftNav = class(TForm)
    pnlContent: TPanel;
    pnlEnvironment: TPanel;
    Label5: TLabel;
    pnlAboveWater: TPanel;
    Image1: TImage;
    lblTittle1: TLabel;
    lbl: TLabel;
    lblSpeedWIndTrue: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    lblDirectionWindTrue: TLabel;
    Panel4: TPanel;
    Panel1: TPanel;
    Label3: TLabel;
    lblOceanCurrentSpeed: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblOceanCurrentDirection: TLabel;
    Label19: TLabel;
    Panel8: TPanel;
    pnlShipInformation: TPanel;
    lblShipName: TLabel;
    pnlHeading: TPanel;
    Image3: TImage;
    Label4: TLabel;
    lblActualHeading: TLabel;
    Image14: TImage;
    imgBackJarumHeading: TImage;
    pnlSTWnSOG: TPanel;
    Image7: TImage;
    Label10: TLabel;
    lblSOG: TLabel;
    Label9: TLabel;
    lblSWT: TLabel;
    Label11: TLabel;
    Label20: TLabel;
    Panel10: TPanel;
    timerHeading: TTimer;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    lblDraft: TLabel;
    Bevel7: TBevel;
    Label22: TLabel;
    Image6: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    pnlSparator2: TPanel;
    Image5: TImage;
    Image12: TImage;
    Image2: TImage;
    img1: TImage;
    img2: TImage;
    lblOceanDepth: TLabel;
    lbl7: TLabel;
    lblDepthCaption: TLabel;
    img4: TImage;
    bvl1: TBevel;
    pnlCOG: TPanel;
    img6: TImage;
    imgBackJarumCOG: TImage;
    lbl9: TLabel;
    lbl11: TLabel;
    img10: TImage;
    bvl3: TBevel;
    lblCOG: TLabel;
    img3: TImage;
    img5: TImage;
    pnl1: TPanel;
    pnlState: TPanel;
    lblStatus: TLabel;
    img8: TImage;
    lbl1: TLabel;
    img7: TImage;
    lblDepth: TLabel;
    lbl6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  protected
    FControlled: TObject;
  private

    procedure Refresh_OwnShipTab;
    procedure Refresh_EnvirontmentTab;
    procedure Refresh_Draft;

    procedure RotateAndDisplayFixedSize(TargetImage: TImage; SourcePng: TPngImage; Angle: Extended);

  public
    imgJarumHeading : TPngImage;
    imgJarumCOG : TPngImage;
    FVTgtHeading: Double;
    FVCurHeading: Double;

    procedure UpdateFormData;
  end;

var
  frmLeftNav: TfrmLeftNav;

implementation

uses
  uDBAsset_GameEnvironment, uT3SimManager, uSimMgr_Client, uBaseCoordSystem, uMapLayerDB,
  uSimObjects, ufmOwnShip, tttData, ufmControlled, uT3Vehicle, ufTacticalDisplay, System.Math;

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

procedure TfrmLeftNav.FormCreate(Sender: TObject);
begin

  EnableComposited(pnlContent);
  EnableComposited(pnlHeading);
  EnableComposited(pnlCOG);

  imgJarumHeading := TPngImage.Create;
  imgJarumHeading.LoadFromFile('data\Image Simulator\Navigasi\compass.png');
//  imgJarumHeading.Transparent := True;

  imgJarumCOG := TPngImage.Create;
  imgJarumCOG.LoadFromFile('data\Image Simulator\Navigasi\compass.png');
//  imgJarumCOG.Transparent := True;

end;

procedure TfrmLeftNav.FormDestroy(Sender: TObject);
begin
  imgJarumHeading.Free;
  imgJarumCOG.Free;
end;

procedure TfrmLeftNav.Refresh_Draft;
var
  vVehicle: TT3Vehicle;
begin
  if (simMgrClient <> nil) and (simMgrClient.ControlledPlatform <> nil) and
     (simMgrClient.ControlledPlatform is TT3Vehicle) then
  begin
    vVehicle := TT3Vehicle(simMgrClient.ControlledPlatform);

    lblDraft.Caption := Format('%.1f', [vVehicle.GetDraftInMeter]);

    {$REGION ' Ground Status '}
    if vVehicle.OnGrounded then
    begin
      lblStatus.Caption := 'On Grounded';
      pnlState.Color := clRed;
    end
    else if vVehicle.OnLand then
    begin
      lblStatus.Caption := 'On Land';
      pnlState.Color := clRed;
    end
    else
    begin
      lblStatus.Caption := 'On Sea';
      pnlState.Color := clAqua;
    end;
    {$ENDREGION}
  end
  else
  begin
    lblDraft.Caption := '-';
    lblStatus.Caption := '-';
  end;
end;

procedure TfrmLeftNav.Refresh_EnvirontmentTab;
var
  ge: TGame_Environment_Definition;
  isOnlandTemp, isdeptAvailTemp : Boolean;
  d1, d2: Double;

begin
  {$REGION ' Evironment Bar '}
  if not Assigned(simMgrClient) then
    Exit;

  ge := simMgrClient.GameEnvironment;

  with ge.FData do
  begin
    lblSpeedWIndTrue.Caption              := FormatSpeed(Wind_Speed);
    lblDirectionWindTrue.Caption          := FormatCourse(Wind_Direction);
//    lblWaterTemp.Caption                  := FormatFloat('00.0', Air_Temperature);
    lblOceanCurrentSpeed.Caption          := FormatFloat('00.0', Ocean_Current_Speed);
    lblOceanCurrentDirection.Caption      := FormatFloat('000.0', Ocean_Current_Direction);
  end;

  if simMgrClient.ControlledPlatform <> nil then
  begin

    with TT3PlatformInstance(simMgrClient.ControlledPlatform) do
    begin
      isOnlandTemp := DepthLayerDB.GetMapLand(getPositionX, getPositionY, d1, d2);

      if isOnlandTemp then
      begin
        lblOceanDepth.Caption := FormatSpeed(d2);
      end
      else
      begin
        try
          isdeptAvailTemp := DepthLayerDB.GetMapDepth(getPositionX, getPositionY, d1, d2);
        except
          isdeptAvailTemp := False;
        end;

        if isdeptAvailTemp then
        begin
          lblOceanDepth.Caption := FormatSpeed(d2);
        end
        else
        begin
          lblOceanDepth.Caption := '0';
        end;
      end;
    end;
  end;
  {$ENDREGION}
end;

procedure TfrmLeftNav.Refresh_OwnShipTab;
begin
  if (simMgrClient <> nil) and (simMgrClient.ControlledPlatform <> nil) and
     (simMgrClient.ControlledPlatform is TT3Vehicle) then
  begin

    with TT3PlatformInstance(simMgrClient.ControlledPlatform) do
    begin
      lblActualHeading.Caption := FormatCourse(TT3Vehicle(simMgrClient.ControlledPlatform).Heading);
      lblCOG.Caption := FormatCourse(TT3Vehicle(simMgrClient.ControlledPlatform).Course);
      lblSOG.Caption := FormatSpeed(TT3Vehicle(simMgrClient.ControlledPlatform).Speed);
      lblSWT.Caption := FormatSpeed(TT3Vehicle(simMgrClient.ControlledPlatform).OrderedSpeed);

      {$REGION ' Ordered & Actual Depth/Altitude Status '}
      if (TT3Vehicle(simMgrClient.ControlledPlatform).PlatformDomain = vhdSubsurface) then
      begin
        lblDepthCaption.Caption := 'Depth';
        lbl6.Caption := 'Meters';
        lblDepth.Caption := FormatSpeed (TT3Vehicle(simMgrClient.ControlledPlatform).Altitude);
      end
      else
      begin
        lblDepthCaption.Caption := 'Altitude';
        lbl6.Caption := 'Feets';
        lblDepth.Caption := FormatAltitude (TT3Vehicle(simMgrClient.ControlledPlatform).Altitude * C_Meter_To_Feet);
      end;
      {$ENDREGION}

      RotateAndDisplayFixedSize(imgBackJarumHeading, imgJarumHeading, TT3Vehicle(simMgrClient.ControlledPlatform).Heading);
      RotateAndDisplayFixedSize(imgBackJarumCOG, imgJarumCOG, TT3Vehicle(simMgrClient.ControlledPlatform).Course);
    end;
  end;
end;

procedure TfrmLeftNav.UpdateFormData;
begin
  Refresh_EnvirontmentTab;
  Refresh_OwnShipTab;
  Refresh_Draft;
end;

procedure TfrmLeftNav.RotateAndDisplayFixedSize(TargetImage: TImage; SourcePng: TPngImage; Angle: Extended);
var
  Dst: TPngImage;
  x, y: Integer;
  fx, fy: Double;
  CenterSrcX, CenterSrcY: Double;
  CenterDstX, CenterDstY: Double;
  cosA, sinA: Double;
  SrcX, SrcY: Integer;
  PSrc, PAlphaSrc, PDst, PAlphaDst: PByteArray;
  BufferBmp: TBitmap;
  BufferCanvas: TCanvas;
begin
  Dst := TPngImage.Create;
  BufferBmp := TBitmap.Create;
  try
    Dst.CreateBlank(COLOR_RGBALPHA, 8, TargetImage.Width, TargetImage.Height);//SourcePng.Width, SourcePng.Height);  // set size

    CenterSrcX := SourcePng.Width / 2;
    CenterSrcY := SourcePng.Height / 2;
    CenterDstX := Dst.Width / 2;
    CenterDstY := Dst.Height / 2;

    cosA := Cos(DegToRad(Angle));
    SinA := Sin(DegToRad(Angle));

    for y := 0 to Dst.Height - 1 do
    begin
      PDst := Dst.Scanline[y];
      PAlphaDst := Dst.AlphaScanline[y];
      for x := 0 to Dst.Width - 1 do
      begin
        fx := (x - CenterDstX) * cosA + (y - CenterDstY) * sinA + CenterSrcX;
        fy := (y - CenterDstY) * cosA - (x - CenterDstX) * sinA + CenterSrcY;

        SrcX := Floor(fx);
        SrcY := Floor(fy);

        if (SrcX >= 0) and (SrcX < SourcePng.Width) and (SrcY >= 0) and (SrcY < SourcePng.Height) then
        begin
          PSrc := SourcePng.Scanline[SrcY];
          PAlphaSrc := SourcePng.AlphaScanline[SrcY];

          PDst[x * 3 + 0] := PSrc[SrcX * 3 + 0];  // Blue
          PDst[x * 3 + 1] := PSrc[SrcX * 3 + 1];  // Green
          PDst[x * 3 + 2] := PSrc[SrcX * 3 + 2];  // Red
          PAlphaDst[x] := PAlphaSrc[SrcX]        // Alpha

        end
        else
        begin
          PDst[x * 3 + 0] := 0;
          PDst[x * 3 + 1] := 0;
          PDst[x * 3 + 2] := 0;
          PAlphaDst[x] := 0;
        end;
      end;
    end;
    // Double Buffer ke target image
    BufferBmp.PixelFormat := pf32bit;
    BufferBmp.Width := TargetImage.Width;
    BufferBmp.Height := TargetImage.Height;

    BufferCanvas := BufferBmp.Canvas;
//    BufferCanvas.Brush.Color := clBtnFace;
    BufferCanvas.FillRect(Rect(0, 0, BufferBmp.Width, BufferBmp.Height));

    BufferCanvas.Draw(0, 0, Dst);      //BufferCanvas.StretchDraw(Rect(0, 0, BufferBmp.Width, BufferBmp.Height), Dst);

    TargetImage.Picture.Bitmap.Assign(BufferBmp);
  finally
    BufferBmp.Free;
    Dst.Free;
  end;
end;

end.
