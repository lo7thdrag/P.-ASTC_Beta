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
    imgMainBackgorund: TImage;
    Label5: TLabel;
    pnlAboveWater: TPanel;
    Image1: TImage;
    lblTittle1: TLabel;
    lbl: TLabel;
    lblSpeedWIndTrue: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    lblDirectionWindTrue: TLabel;
    btnPlatformOp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel4: TPanel;
    Panel1: TPanel;
    Image5: TImage;
    Label3: TLabel;
    lblOceanCurrentSpeed: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblOceanCurrentDirection: TLabel;
    Label19: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel8: TPanel;
    Panel9: TPanel;
    Image4: TImage;
    Label29: TLabel;
    Bevel8: TBevel;
    lblWaterTemp: TLabel;
    lblRange: TLabel;
    Bevel5: TBevel;
    lblDepthNav: TLabel;
    Panel2: TPanel;
    lblShipName: TLabel;
    Panel5: TPanel;
    Image3: TImage;
    Label4: TLabel;
    lblActualHeading: TLabel;
    Image14: TImage;
    Image17: TImage;
    Panel6: TPanel;
    Image7: TImage;
    Label8: TLabel;
    Bevel3: TBevel;
    lblCOG: TLabel;
    Label10: TLabel;
    lblSOG: TLabel;
    Bevel4: TBevel;
    Label9: TLabel;
    Bevel1: TBevel;
    lblSWT: TLabel;
    Label11: TLabel;
    Label20: TLabel;
    Panel10: TPanel;
    Image2: TImage;
    timerHeading: TTimer;
    procedure Refresh_OwnShipTab(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timerHeadingTimer(Sender: TObject);
    procedure lblActualHeadingClick(Sender: TObject);
  protected
    FControlled: TObject;
  private


    procedure RotateAndDisplayFixedSize(TargetImage: TImage; SourcePng: TPngImage; Angle: Extended);
    { Private declarations }
  public
    FOriginalPngTrainning : TPngImage;
    FVTgtHeading: Double;
    FVCurHeading: Double;
    { Public declarations }
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
  FOriginalPngTrainning := TPngImage.Create;
  FOriginalPngTrainning.LoadFromFile('D:\Pekerjaan\Image\Button Left Navigasi\compass.png');

  EnableComposited(Self);
end;

procedure TfrmLeftNav.FormDestroy(Sender: TObject);
begin
  FOriginalPngTrainning.Free;
end;

procedure TfrmLeftNav.lblActualHeadingClick(Sender: TObject);
begin
  FVTgtHeading := StrToFloat(lblActualHeading.Caption);
end;

procedure TfrmLeftNav.Refresh_OwnShipTab(Sender: TObject);
var
  ge: TGame_Environment_Definition;
  isOnlandTemp, isdeptAvailTemp : Boolean;
  d1, d2: Double;

begin
  {$REGION ' Evironment Bar '}
  if not Assigned(simMgrClient) then Exit;
  ge := (simMgrClient).GameEnvironment;

  with ge.FData do
  begin
    lblSpeedWIndTrue.Caption              := FormatSpeed(Wind_Speed);
    lblDirectionWindTrue.Caption          := FormatCourse(Wind_Direction);
    lblWaterTemp.Caption                  := FormatFloat('00.0', Air_Temperature);
    lblOceanCurrentSpeed.Caption          := FormatFloat('00.0', Ocean_Current_Speed);
    lblOceanCurrentDirection.Caption      := FormatFloat('000.0', Ocean_Current_Direction);
  end;

  if Assigned(FControlled) and TT3PlatformInstance(FControlled).Initialized then
  begin
    with TT3PlatformInstance(FControlled) do
    begin
      isOnlandTemp := DepthLayerDB.GetMapLand(getPositionX, getPositionY, d1, d2);

      if isOnlandTemp then
      begin
        lblDepthNav.Caption := FormatSpeed(d2) + ' Meter';
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
          lblDepthNav.Caption := FormatSpeed(d2) + ' Meter';
        end
        else
        begin
          lblDepthNav.Caption := '0 Meter';
        end;
      end;
    end;

    if Assigned(FControlled) then
    begin
      if TT3Vehicle(FControlled).Course = 0 then
      begin
        lblActualHeading.Caption := '0.00';
      end
      else
      begin
        lblActualHeading.Caption := FormatCourse(TT3Vehicle(FControlled).Heading);
      end;
    end
    else
    begin
      lblActualHeading.Caption := '---';
    end;
  end;
  {$ENDREGION}

  {$REGION ' Ship Information '}
  //Kalau form right bisa ganti copy dari form right ini sementara pakai tactical display dulu
  lblActualHeading.Caption :=  frmTacticalDisplay.fmPlatformGuidance1.lblStraightLineActualHeading.Caption;
  lblCOG.Caption := frmTacticalDisplay.fmPlatformGuidance1.lblStraightLineActualHeading.Caption;
  {$ENDREGION}
end;

procedure TfrmLeftNav.RotateAndDisplayFixedSize(TargetImage: TImage;
  SourcePng: TPngImage; Angle: Extended);
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

procedure TfrmLeftNav.timerHeadingTimer(Sender: TObject);
begin
 if Round(FVTgtHeading) <> Round(FVCurHeading) then
  begin
    if ((FVTgtHeading - FVCurHeading) <= 180) and ((FVTgtHeading - FVCurHeading) > 0) then
    begin
      //rotate cw (r)
      FVCurHeading := FVCurHeading + 1;
    end
    else
    begin
      //rotate ccw (l)
      FVCurHeading := FVCurHeading - 1;
    end;

    RotateAndDisplayFixedSize(image17, FOriginalPngTrainning, FVCurHeading);
  end
end;

end.
