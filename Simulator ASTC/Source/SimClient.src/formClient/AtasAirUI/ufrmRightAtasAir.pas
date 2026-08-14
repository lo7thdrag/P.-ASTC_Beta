unit ufrmRightAtasAir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufmControlled,
  ufmPlatformGuidance, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons,
  VrControls, VrBlinkLed, ufmSensor, Vcl.Menus, Vcl.ComCtrls,

    ufmWeapon,uT3Unit,uT3DetectedTrack,uBaseCoordSystem,uT3Common,uT3Vehicle,
   uDBAsset_Vehicle,uTMapTouch2;

type
  TfrmRightAtasAir = class(TForm)
    pnlContainer: TPanel;
    pnlWeaponController: TPanel;
    Label10: TLabel;
    pmModeSonobuoy: TPopupMenu;
    pnlContact: TPanel;
    lbl1: TLabel;
    pnlTrackSheet: TPanel;
    pnlTabTrackControl: TPanel;
    pnlTabTrackTable: TPanel;
    imgMainBackgorundContact: TImage;
    imgMainBackgorundController: TImage;
    pnlGameStatus: TPanel;
    Image4: TImage;
    Label1: TLabel;
    pnlGameState: TPanel;
    fmWeapon1: TfmWeapon;
    pnlTrackInformationBody: TPanel;
    pnlTrackControl: TPanel;
    lvTrackControl: TListView;
    pnlTrackTable: TPanel;
    lvTrackTable: TListView;
    procedure TTButtonClick(Sender: TObject);
    procedure fmWeapon1btnWeaponClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvTrackTableSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    function FindTrackListByMember(const arg: string): TListItem;
    procedure UpdateTrackListData;
    { Private declarations }
  public
    Map1 : TMapXTouch;
    procedure AddTrackPlatform(Sender: TObject);
    procedure RemoveFromTrackList(Sender: TObject);
    procedure UpdateFormData;

    { Public declarations }
  end;

var
  frmRightAtasAir: TfrmRightAtasAir;

implementation

{$R *.dfm}

procedure TfrmRightAtasAir.AddTrackPlatform(Sender: TObject);
var
  sTrackNum, sDomain, sIdent: string;
  li: TListItem;
  pi: TT3PlatformInstance;
  det: TT3DetectedTrack;
begin
  pi := nil;

  if Sender is TT3DetectedTrack then
  begin
    det := Sender as TT3DetectedTrack;

    if Assigned(det.TrackObject) then
    begin
      if det.TrackObject is TT3DeviceUnit then
        pi := det.TrackObject.Parent as TT3PlatformInstance
      else
        pi := det.TrackObject as TT3PlatformInstance;
    end;

    sTrackNum := FormatTrackNumber(det.trackNumber);
    sDomain := getDomain(det.TrackDomain);
    sIdent  := getIdentStr(det.TrackIdent);
  end
  else if (Sender is TT3PlatformInstance) then
  begin
    pi := Sender as TT3PlatformInstance;

    if pi is TT3NonRealVehicle then
    begin
      sTrackNum := IntToStr(TT3PlatformInstance(pi).TrackNumber);
      sDomain   := getDomain(TT3PlatformInstance(pi).TrackDomain);
      sIdent := getIdentStr(TT3PlatformInstance(pi).TrackIdent);
    end
    else
    begin
      sTrackNum := pi.TrackLabel;
      sDomain   := getDomain(TVehicle_Definition(TT3Vehicle(pi).UnitDefinition).FData.Platform_Domain);
      sIdent := getIdentStr(pi.Force_Designation);
    end;
  end;

  if pi <> nil then
  begin
    li := FindTrackListByMember(sTrackNum);
    if li = nil then
    begin
      li := lvTrackTable.Items.Add;

      li.Caption := sDomain;
      li.SubItems.Add(sTrackNum);
      li.SubItems.Add(sIdent);
      li.SubItems.Add(FormatCourse(pi.Course));
      li.SubItems.Add(FormatSpeed(pi.Speed));

      if sDomain = 'Air' then
      begin
        li.SubItems.Add(FormatAltitude(pi.Altitude * C_Meter_To_Feet));
        li.SubItems.Add(' ');
      end
      else
      begin
        li.SubItems.Add(' ');
        li.SubItems.Add(FormatAltitude(pi.Altitude));
      end;
//      else
//      begin
//
//      end;
//
//      if pi.Altitude >= 0 then
//      begin
//        li.SubItems.Add(FormatAltitude(pi.Altitude));
//        li.SubItems.Add(' ');
//      end
//      else
//      begin
//        li.SubItems.Add(' ');
//        li.SubItems.Add(FormatAltitude(pi.Altitude));
//      end;

      li.Data := Sender;
    end
    else
    begin
      // sudah ada.
      li.Caption := sDomain;
      li.SubItems[0] := sTrackNum;
      li.SubItems[1] := sIdent;
      li.SubItems[2] := FormatCourse(pi.Course);
      li.SubItems[3] := FormatSpeed(pi.Speed);

      if sDomain = 'Air' then
      begin
        li.SubItems[4] := FormatAltitude(pi.Altitude * C_Meter_To_Feet);
        li.SubItems[5] := ' ';
      end
      else
      begin
        li.SubItems[4] := ' ';
        li.SubItems[5] := FormatAltitude(pi.Altitude);
      end;
    end;
  end;
end;

function TfrmRightAtasAir.FindTrackListByMember(const arg: string): TListItem;
var
  i: Integer;
  f: Boolean;
  li: TListItem;
begin
  result := nil;
  li := nil;
  f := false;
  i := 0;

  while not f and (i < lvTrackTable.Items.Count) do
  begin
    li := lvTrackTable.Items.Item[i];

    f := SameText(li.SubItems[0], arg);

    Inc(i);
  end;

  if f then
    result := li;
end;

procedure TfrmRightAtasAir.fmWeapon1btnWeaponClick(Sender: TObject);
begin
  if Assigned(Sender)then
  begin
    fmWeapon1.btnWeaponClick(Sender);
  end;
end;

procedure TfrmRightAtasAir.FormCreate(Sender: TObject);
begin
   fmWeapon1.InitCreate(self);
   lvTrackTable.DoubleBuffered := true;
   lvTrackTable.SortType := stText;
   lvTrackTable.Font.Color := clBlack;
end;

procedure TfrmRightAtasAir.lvTrackTableSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  obj: TObject;
begin
  if Item = nil then
    exit;

  obj := Item.Data;
  if obj is TT3DetectedTrack then (obj as TT3DetectedTrack)
    .Selected := true
  else if obj is TT3PlatformInstance then (obj as TT3PlatformInstance)
    .Selected := true;

  Map1.Repaint;
end;

procedure TfrmRightAtasAir.RemoveFromTrackList(Sender: TObject);
var
  s: string;
  li: TListItem;
  det: TT3DetectedTrack;
  pi: TT3PlatformInstance;
begin
  if Sender is TT3DetectedTrack then
  begin
    det := Sender as TT3DetectedTrack;
    s := FormatTrackNumber(det.TrackNumber);
  end
  else if Sender is TT3PlatformInstance then
  begin
    pi := Sender as TT3PlatformInstance;

    if pi is TT3NonRealVehicle then
      s := IntToStr(pi.TrackNumber)
    else
      s := pi.TrackLabel;
  end
  else
    Exit;

  li := FindTrackListByMember(s);

  if li <> nil then
    li.Delete;
end;

procedure TfrmRightAtasAir.TTButtonClick(Sender: TObject);
var
  PanelTag: integer;
  Panel: Tpanel;
begin
  panel := Sender as Tpanel;
  PanelTag := panel.Tag;

  if panel = pnlTabTrackTable then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackTable.Color := RGB(29, 81, 103);
      pnlTrackTable.BringToFront;
      pnlTabTrackTable.Tag := 1;
      pnlTabTrackControl.Tag := 0;
      pnlTabTrackControl.Color := RGB(16, 46, 58);
    end;
  end;

  if panel = pnlTabTrackControl then
  begin
    if PanelTag = 0 then
    begin
      pnlTabTrackControl.Color := RGB(29, 81, 103);
      pnlTrackControl.BringToFront;
      pnlTabTrackControl.Tag := 1;
      pnlTabTrackTable.Tag := 0;
      pnlTabTrackTable.Color := RGB(16, 46, 58);
    end;
  end;
end;

procedure TfrmRightAtasAir.UpdateFormData;
begin
//    fmWeapon1.SetControlledObject(pit);
//    fmWeapon1.Refresh_VisibleTab;
end;

procedure TfrmRightAtasAir.UpdateTrackListData;
var
  i: Integer;
  li: TListItem;
  sTrackNum, sDomain, sIdent: string;
  pi: TT3PlatformInstance;
  det: TT3DetectedTrack;
  obj: TObject;
begin
  for i := lvTrackTable.Items.Count - 1 downto 0 do
  begin
    pi := nil;
    li := lvTrackTable.Items[i];
    obj := li.Data;

    if obj = nil then
    begin
      lvTrackTable.items.Delete(i);
      Continue;
    end;

    if obj is TT3DetectedTrack then
    begin
      det := obj as TT3DetectedTrack;
      sTrackNum := FormatTrackNumber(det.trackNumber);
      sDomain := getDomain(det.TrackDomain);
      sIdent := getIdentStr(det.TrackIdent);

      if Assigned(det.TrackObject) then
      begin
        if det.TrackObject is TT3DeviceUnit then
          pi := det.TrackObject.Parent as TT3PlatformInstance
        else
          pi := det.TrackObject as TT3PlatformInstance;
      end;
    end
    else if obj is TT3PlatformInstance then
    begin
      pi := obj as TT3PlatformInstance;

      if pi is TT3NonRealVehicle then
      begin
        sTrackNum := IntToStr(TT3PlatformInstance(pi).TrackNumber);
        sDomain   := getDomain(TT3PlatformInstance(pi).TrackDomain);
        sIdent := getIdentStr(TT3PlatformInstance(pi).TrackIdent);
      end
      else
      begin
        sTrackNum := pi.TrackLabel;
        sDomain   := getDomain(TVehicle_Definition(TT3Vehicle(pi).UnitDefinition).FData.Platform_Domain);
        sIdent := getIdentStr(pi.Force_Designation);
      end;
    end;

    if Assigned(pi) then
    begin
      li.Caption := sDomain;

      li.SubItems[0] := sTrackNum;
      li.SubItems[1] := sIdent;
      li.SubItems[2] := FormatCourse(pi.Course);
      li.SubItems[3] := FormatSpeed(pi.Speed);

      if sDomain = 'Air' then
      begin
        li.SubItems[4] := FormatAltitude(pi.Altitude * C_Meter_To_Feet);
        li.SubItems[5] := ' ';
      end
      else
      begin
        li.SubItems[4] := ' ';
        li.SubItems[5] := FormatAltitude(pi.Altitude);
      end;
    end;
  end;
end;

end.
