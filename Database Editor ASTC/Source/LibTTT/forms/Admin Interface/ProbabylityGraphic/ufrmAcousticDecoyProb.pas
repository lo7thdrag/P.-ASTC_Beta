unit ufrmAcousticDecoyProb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uDBAsset_Countermeasure, DB,
  uBlindZoneView, uDBBlind_Zone, uSimContainers, Vcl.Imaging.pngimage;

type
  TfrmAcousticDecoyProb = class(TForm)
    grdpnlAcousticDecoyPOH: TGridPanel;
    pnl1: TPanel;
    pnlAspect: TPanel;
    pnlGuidanceType: TPanel;
    pnl_BZone1: TPanel;
    pnl_BZone2: TPanel;
    pnl_BZone3: TPanel;
    pnl_BZone4: TPanel;
    pnlActive: TPanel;
    edtActive1: TEdit;
    edtActive2: TEdit;
    edtActive3: TEdit;
    edtActive4: TEdit;
    pnlPassive: TPanel;
    edtPassive1: TEdit;
    edtPassive2: TEdit;
    edtPassive3: TEdit;
    edtPassive4: TEdit;
    pnlActivePassive: TPanel;
    edtActivePassive1: TEdit;
    edtActivePassive2: TEdit;
    edtActivePassive3: TEdit;
    edtActivePassive4: TEdit;
    pnlWireGuided: TPanel;
    edtWireGuided1: TEdit;
    edtWireGuided2: TEdit;
    edtWireGuided3: TEdit;
    edtWireGuided4: TEdit;
    pnlWakeHoming: TPanel;
    edtWakeHoming1: TEdit;
    edtWakeHoming2: TEdit;
    edtWakeHoming3: TEdit;
    edtWakeHoming4: TEdit;
    pnl1Title: TPanel;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    pnlSparatorHor2: TPanel;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure edtGeneralChange(Sender: TObject);
    procedure edtAspectPersentageKeyPress(Sender: TObject; var Key: Char);
    procedure ValidationFormatInput();

    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

  private
    FSelectedAcousticDecoy : TAcoustic_Decoy_On_Board;

    FAcousticDecoyPOHList : TList;
    FAspect1 : TBlindZoneView;
    FAspect2 : TBlindZoneView;
    FAspect3 : TBlindZoneView;
    FAspect4 : TBlindZoneView;

    function GetNumberOfKoma(s : string): Boolean;
    procedure UpdateAcousticDecoyPOHData;

  public
    procedure addRecord(const g_type,aspect: Integer; poh : Single);

    property SelectedAcousticDecoy : TAcoustic_Decoy_On_Board read FSelectedAcousticDecoy write FSelectedAcousticDecoy;
  end;

var
  frmAcousticDecoyProb: TfrmAcousticDecoyProb;

implementation

uses
  uDataModuleTTT;

{$R *.dfm}

{$REGION ' Form Handle '}

procedure TfrmAcousticDecoyProb.FormCreate(Sender: TObject);
var
  zs : TZoneSector;
begin
  FAcousticDecoyPOHList := TList.Create;

  {$REGION ' Aspect 1 '}
  FAspect1 := TBlindZoneView.Create(Self);
  with FAspect1 do
  begin
    Parent := pnl_BZone1;
    Left := 0;
    Top := 0;
    Height := pnl_BZone1.Height;
    Width := pnl_BZone1.Width;
    EnableDrag := True;

    zs := AddZone;
    zs.Degree := 0;
    zs.AngleWidth := 60;
  end;
  {$ENDREGION}

  {$REGION ' Aspect 2 '}
  FAspect2 := TBlindZoneView.Create(Self);
  with FAspect2 do
  begin
    Parent := pnl_BZone2;
    Left := 0;
    Top := 0;
    Height := pnl_BZone2.Height;
    Width := pnl_BZone2.Width;
    EnableDrag := True;

    zs := AddZone;
    zs.Degree := 60;
    zs.AngleWidth := 60;

    zs := AddZone;
    zs.Degree := 300;
    zs.AngleWidth := 60;
  end;
  {$ENDREGION}

  {$REGION ' Aspect 3 '}
  FAspect3 := TBlindZoneView.Create(Self);
  with FAspect3 do
  begin
    Parent := pnl_BZone3;
    Left := 0;
    Top := 0;
    Height := pnl_BZone3.Height;
    Width := pnl_BZone3.Width;
    EnableDrag := True;

    zs := AddZone;
    zs.Degree := 120;
    zs.AngleWidth := 60;

    zs := AddZone;
    zs.Degree := 240;
    zs.AngleWidth := 60;
  end;
  {$ENDREGION}

  {$REGION ' Aspect 4 '}
  FAspect4 := TBlindZoneView.Create(Self);
  with FAspect4 do
  begin
    Parent := pnl_BZone4;
    Left := 0;
    Top := 0;
    Height := pnl_BZone4.Height;
    Width := pnl_BZone4.Width;
    EnableDrag := True;

    zs := AddZone;
    zs.Degree := 180;
    zs.AngleWidth := 60;
  end;
  {$ENDREGION}

end;

procedure TfrmAcousticDecoyProb.FormDestroy(Sender: TObject);
begin
  FAspect1.Free;
  FAspect2.Free;
  FAspect3.Free;
  FAspect4.Free;

  FreeItemsAndFreeList(FAcousticDecoyPOHList);
end;

procedure TfrmAcousticDecoyProb.FormShow(Sender: TObject);
begin
  FAspect1.Repaint;
  FAspect2.Repaint;
  FAspect3.Repaint;
  FAspect4.Repaint;

  UpdateAcousticDecoyPOHData;
end;

function TfrmAcousticDecoyProb.GetNumberOfKoma(s: string): Boolean;
var
  a, i : Integer;
begin
  Result := False;
  a := 0;

  for i := 1 to length(s) do
  begin
    if s[i] = '.' then
      a := a + 1;
  end;

  if a > 0 then
    Result := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAcousticDecoyProb.addRecord(const g_type, aspect: Integer; poh : Single);
var
  acousticDecoyPOH : TAcoustic_Decoy_POH_Modifier;

begin
  acousticDecoyPOH := TAcoustic_Decoy_POH_Modifier.Create;

  acousticDecoyPOH.FAccousticDecoy_POH.Decoy_Index            := FSelectedAcousticDecoy.FAccousticDecoy_Def.Decoy_Index;
  acousticDecoyPOH.FAccousticDecoy_POH.POH_Modifier           := poh;
  acousticDecoyPOH.FAccousticDecoy_POH.Torpedo_Guidance_Type  := g_type;
  acousticDecoyPOH.FAccousticDecoy_POH.Aspect_Angle           := aspect;

  dmTTT.InsertAcoustic_Decoy_POH_Modifier(acousticDecoyPOH);

  acousticDecoyPOH.Free;
end;

procedure TfrmAcousticDecoyProb.btnApplyClick(Sender: TObject);
var
  val: Double;
  isvalid: Boolean;

begin
  ValidationFormatInput;

  dmTTT.DeleteAcoustic_Decoy_POH_Modifier(FSelectedAcousticDecoy.FAccousticDecoy_Def.Decoy_Index);

  {$REGION ' Active Accoustic '}
  isvalid := TryStrToFloat(edtActive1.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(10,0, val);
  end;

  isvalid := TryStrToFloat(edtActive2.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(10,1, val);
  end;

  isvalid := TryStrToFloat(edtActive3.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(10,2, val);
  end;

  isvalid := TryStrToFloat(edtActive4.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(10,3, val);
  end;
  {$ENDREGION}

  {$REGION ' Passive Accoustic '}
  isvalid := TryStrToFloat(edtPassive1.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(11,0, val);
  end;

  isvalid := TryStrToFloat(edtPassive2.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(11,1, val);
  end;

  isvalid := TryStrToFloat(edtPassive3.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(11,2, val);
  end;

  isvalid := TryStrToFloat(edtPassive4.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(11,3, val);
  end;
  {$ENDREGION}

  {$REGION ' Active/Passive Accoustic '}
  isvalid := TryStrToFloat(edtActivePassive1.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(12,0, val);
  end;

  isvalid := TryStrToFloat(edtActivePassive2.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(12,1, val);
  end;

  isvalid := TryStrToFloat(edtActivePassive3.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(12,2, val);
  end;

  isvalid := TryStrToFloat(edtActivePassive4.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(12,3, val);
  end;
  {$ENDREGION}

  {$REGION ' Wire Guided '}
  isvalid := TryStrToFloat(edtWireGuided1.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(13,0, val);
  end;

  isvalid := TryStrToFloat(edtWireGuided2.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(13,1, val);
  end;

  isvalid := TryStrToFloat(edtWireGuided3.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(13,2, val);
  end;

  isvalid := TryStrToFloat(edtWireGuided4.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(13,3, val);
  end;
  {$ENDREGION}

  {$REGION ' Wake Homing '}
  isvalid := TryStrToFloat(edtWakeHoming1.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(18,0, val);
  end;

  isvalid := TryStrToFloat(edtWakeHoming2.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(18,1, val);
  end;

  isvalid := TryStrToFloat(edtWakeHoming3.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(18,2, val);
  end;

  isvalid := TryStrToFloat(edtWakeHoming4.Text,val);
  if (isvalid) and (val >= 0) and (val <= 0.5) then
  begin
    addRecord(18,3, val);
  end;
  {$ENDREGION}

  btnApply.Enabled := False;
end;

procedure TfrmAcousticDecoyProb.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcousticDecoyProb.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  Close;
end;

procedure TfrmAcousticDecoyProb.edtAspectPersentageKeyPress(Sender: TObject;var Key: Char);
var
  value : Double;
begin
  if not (Key in[#48 .. #57, #8, #13, #46]) then
  begin
    Key := #0;
    Exit;
  end;

  if GetNumberOfKoma(TEdit(sender).Text) then
  begin
    if Key = #46 then
      Key := #0;
  end;

  if Key = #13 then
  begin
    value := StrToFloat(TEdit(Sender).Text);

    if value > 0.5 then
      value := 0.49;

    if value <= 0 then
      value := 0.1;

    TEdit(Sender).Text := FloatToStr(value);
  end;
end;

procedure TfrmAcousticDecoyProb.edtGeneralChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmAcousticDecoyProb.UpdateAcousticDecoyPOHData;
var
  i : Integer;
  acousticDecoyPOH : TAcoustic_Decoy_POH_Modifier;
begin

  with FSelectedAcousticDecoy.FAccousticDecoy_Def do
    dmTTT.GetAcousticDecoyPOHModifier(Decoy_Index, FAcousticDecoyPOHList);

  if FAcousticDecoyPOHList.Count = 0 then
  begin
    for i := 0 to 4 do
    begin
      acousticDecoyPOH := TAcoustic_Decoy_POH_Modifier.Create;
      FAcousticDecoyPOHList.Add(acousticDecoyPOH);
    end;
  end;

  for i := 0 to FAcousticDecoyPOHList.Count - 1 do
  begin
    acousticDecoyPOH := FAcousticDecoyPOHList.Items[i];

    with acousticDecoyPOH.FAccousticDecoy_POH do
    begin
      case Torpedo_Guidance_Type of
        10:
        begin
          case Aspect_Angle of
            0: edtActive1.Text := FloatToStr(POH_Modifier);
            1: edtActive2.Text := FloatToStr(POH_Modifier);
            2: edtActive3.Text := FloatToStr(POH_Modifier);
            3: edtActive4.Text := FloatToStr(POH_Modifier);
          end;
        end;
        11:
        begin
          case Aspect_Angle of
            0: edtPassive1.Text := FloatToStr(POH_Modifier);
            1: edtPassive2.Text := FloatToStr(POH_Modifier);
            2: edtPassive3.Text := FloatToStr(POH_Modifier);
            3: edtPassive4.Text := FloatToStr(POH_Modifier);
          end;
        end;
        12:
        begin
          case Aspect_Angle of
            0: edtActivePassive1.Text := FloatToStr(POH_Modifier);
            1: edtActivePassive2.Text := FloatToStr(POH_Modifier);
            2: edtActivePassive3.Text := FloatToStr(POH_Modifier);
            3: edtActivePassive4.Text := FloatToStr(POH_Modifier);
          end;
        end;
        13:
        begin
          case Aspect_Angle of
            0: edtWireGuided1.Text := FloatToStr(POH_Modifier);
            1: edtWireGuided2.Text := FloatToStr(POH_Modifier);
            2: edtWireGuided3.Text := FloatToStr(POH_Modifier);
            3: edtWireGuided4.Text := FloatToStr(POH_Modifier);
          end;
        end;
        18:
        begin
          case Aspect_Angle of
            0: edtWakeHoming1.Text := FloatToStr(POH_Modifier);
            1: edtWakeHoming2.Text := FloatToStr(POH_Modifier);
            2: edtWakeHoming3.Text := FloatToStr(POH_Modifier);
            3: edtWakeHoming4.Text := FloatToStr(POH_Modifier);
          end;
        end;
      end;
      ValidationFormatInput;
    end;
  end;
end;

{$REGION ' Filter Input '}

procedure TfrmAcousticDecoyProb.ValidationFormatInput;
var
  i: Integer;
  value : Double;

begin
  for i:=0 to ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      if TEdit(Components[i]).Tag = 4 then
        continue;

      if TEdit(Components[i]).Text = '' then
        TEdit(Components[i]).Text := '0';

      value := StrToFloat(TEdit(Components[i]).Text);

      if (value > 0.5) then
        value := 0.5;

      if (value <= 0) then
        value := 0.1;

      case TEdit(Components[i]).Tag of
        0: TEdit(Components[i]).Text := FormatFloat('0', value);
        1: TEdit(Components[i]).Text := FormatFloat('0.0', value);
        2: TEdit(Components[i]).Text := FormatFloat('0.00', value);
        3: TEdit(Components[i]).Text := FormatFloat('0.000', value);
      end;
    end;
  end;
end;

{$ENDREGION}

{$ENDREGION}
end.
