unit uDBAsset_Vehicle;

interface

uses

  Windows, Classes, SysUtils, Graphics, tttData, uDBNote_Storage, uWaypoint, uSimContainers;


type


  TVehicle_Definition = class
  private
    FGuidanceType   : TVehicleGuidanceType;
    FActiveWaypoint : TObject;
    procedure SetGuidanceType(const Value: TVehicleGuidanceType);
    procedure SetActiveWaypoint(const Value: TObject);
 // published

  public
    FData                 : TRecVehicle_Definition;
    FPlatform_Ident       : TRecPlatform_Instance_Identifier;
    FNote                   : TNote_Storage ;
    FPlatform_Library_Entry : TRecPlatform_Library_Entry;
    FHosted_Platform      : TRecHosted_Platform;
    Waypoints     : TWaypoint;

    {$REGION ' Sensor '}

    Radars         : TList;      //     : TRadar_On_Board;
    Sonars         : TList;      //      : TSonar_On_Board;
    EOSensors      : TList;      //      : TEO_On_Board;
    ESMSensors     : TList;      //      : TESM_On_Board;
    IFFSensors     : TList;      //      : TIFF_Sensor_On_Board;
    MADSensors     : TList;      //      : TMAD_Sensor_On_Board;
    Visualsensors  : TList;      //      : Visual_Sensor_On_Board;
    FCRSensors     : TList;      //      : TFCR_On_Board;
    Sonobuoy       : TList;

    {$ENDREGION}

    {$REGION ' Weapon '}

    Missiles      : TList;
    Torpedos      : TList;
    Guns          : TList;
    Mines         : TList;
    Bombs         : TList;
    Hybrids       : TList;
    Point_Effects : TList;

    {$ENDREGION}

    {$REGION ' Countermeasure '}

    Acoustic_Decoys         : TList;
    Air_Bubble_Mount        : TList;
    Chaffs                  : TList;
    Chaff_Launchers         : TList;
    Defensive_Jammers       : TList;
    Floating_Decoys         : TList;
    Infrared_Decoys         : TList;
    Jammers                 : TList;
    Towed_Jammer_Decoys     : TList;

    {$ENDREGION}

    {$REGION ' Embark Platform '}

    Hosted_Platform         : TList;

    {$ENDREGION}

    {$REGION ' Predefined '}

    Predefined              : TList;

    {$ENDREGION}

    FPfCapability           : TRecTransport; //dng

    constructor Create;
    destructor Destroy; override;
    procedure InitWaypoint;

    function FindRadarByID(const id: integer): TObject;
    function FindSonarByID(const id: integer): TObject;
    function FindESMByID(const id: integer): TObject;

    function FindWeaponGunByID(const id: integer): TObject;

    property GuidanceType   : TVehicleGuidanceType read FGuidanceType write SetGuidanceType;
    property ActiveWaypoint : TObject read FActiveWaypoint write SetActiveWaypoint;
  end;


implementation

uses
  uDBAsset_Sensor,uDBAsset_Radar, uDBAsset_Sonar, uDBAsset_Scripted,
    uDBAsset_Weapon;

{ TVehicle_Definition }

constructor TVehicle_Definition.Create;
begin
  {$REGION ' Sensor '}

  Radars         := TList.Create;
  Sonars         := TList.Create;
  EOSensors      := TList.Create;
  ESMSensors     := TList.Create;
  IFFSensors     := TList.Create;
  MADSensors     := TList.Create;
  Visualsensors  := TList.Create;
  FCRSensors     := TList.Create;
  Sonobuoy       := TList.Create;

  {$ENDREGION}

  {$REGION ' Weapon '}

  Missiles      := TList.Create;
  Torpedos      := TList.Create;
  Guns          := TList.Create;
  Mines         := TList.Create;
  Bombs         := TList.Create;
  Hybrids       := TList.Create;
  Point_Effects := TList.Create;

  {$ENDREGION}

  {$REGION ' Countermeasure '}

  Acoustic_Decoys         := TList.Create;
  Air_Bubble_Mount        := TList.Create;
  Chaffs                  := TList.Create;
  Chaff_Launchers         := TList.Create;
  Defensive_Jammers       := TList.Create;
  Floating_Decoys         := TList.Create;
  Infrared_Decoys         := TList.Create;
  Jammers                 := TList.Create;
  Towed_Jammer_Decoys     := TList.Create;

  {$ENDREGION}

  {$REGION ' Embark Platform '}

  Hosted_Platform         := TList.Create;

  {$ENDREGION}

  {$REGION ' Predefined '}

  Predefined              := TList.Create;

  {$ENDREGION}

  Waypoints               := TWaypoint.Create;
  GuidanceType            := vgtStraightLine;
end;

destructor TVehicle_Definition.Destroy;
begin
  {$REGION ' Sensor '}
  FreeItemsAndFreeList(Radars);
  FreeItemsAndFreeList(Sonars);
  FreeItemsAndFreeList(EOSensors);
  FreeItemsAndFreeList(ESMSensors);
  FreeItemsAndFreeList(IFFSensors);
  FreeItemsAndFreeList(MADSensors);
  FreeItemsAndFreeList(Visualsensors);
  FreeItemsAndFreeList(FCRSensors);
  FreeItemsAndFreeList(Sonobuoy);
  {$ENDREGION}

  {$REGION ' Weapon '}
  FreeItemsAndFreeList(Missiles);
  FreeItemsAndFreeList(Torpedos);
  FreeItemsAndFreeList(Mines);
  FreeItemsAndFreeList(Hybrids);
  FreeItemsAndFreeList(Bombs);
  FreeItemsAndFreeList(Guns);
  FreeItemsAndFreeList(Point_Effects);
  {$ENDREGION}

  {$REGION ' Countermeasure '}
  FreeItemsAndFreeList(Acoustic_Decoys);
  FreeItemsAndFreeList(Air_Bubble_Mount);
  FreeItemsAndFreeList(Chaffs);
  FreeItemsAndFreeList(Chaff_Launchers);
  FreeItemsAndFreeList(Defensive_Jammers);
  FreeItemsAndFreeList(Floating_Decoys);
  FreeItemsAndFreeList(Infrared_Decoys);
  FreeItemsAndFreeList(Jammers);
  FreeItemsAndFreeList(Towed_Jammer_Decoys);
  {$ENDREGION}

  {$REGION ' Embark Platform '}
  FreeItemsAndFreeList(Hosted_Platform);
  {$ENDREGION}

  {$REGION ' Predefined '}
  FreeItemsAndFreeList(Predefined);
  {$ENDREGION}

  Waypoints.Free;

  inherited;
end;

procedure TVehicle_Definition.InitWaypoint;
var
  wpEvent : TWaypointEventClass;
  i, j : integer;
begin
  // event n behav radar
  for i:= 0 to Radars.Count - 1 do
    for j := 0 to TRadar_On_Board(Radars[i]).FScripted_Radar.Count - 1 do
      with TScripted_Radar(TRadar_On_Board(Radars[i]).FScripted_Radar) do begin
        wpEvent := TWaypointEventClass.Create;
        wpEvent.FType := wetRadar;
        wpEvent.FData := event;
        wpEvent.FEnable := false;
        Waypoints.Add(behav,wpEvent);
      end;

  // event n behav sonar
  for i:= 0 to Sonars.Count - 1 do
    for j := 0 to TSonar_On_Board(Sonars[i]).FScripted_sonar.Count - 1 do
      with TScripted_Sonar(TSonar_On_Board(Sonars[i]).FScripted_sonar) do begin
        wpEvent := TWaypointEventClass.Create;
        wpEvent.FType := wetSonar;
        wpEvent.FData := event;
        wpEvent.FEnable := false;
        Waypoints.Add(behav,wpEvent);
      end;

  // event n behav chaff
  {for i:= 0 to Chaffs.Count - 1 do
    for j := 0 to TChaff_On_Board(Chaffs[i]).FScripted_Chaffs.Count - 1 do
      with TScripted_Chaff(TChaff_On_Board(Chaffs[i]).FScripted_Chaffs)do
        Waypoints.Add(behav,event);

  // event n behav infrared
  for i:= 0 to Infrared_Decoys.Count - 1 do
    for j := 0 to TInfrared_Decoy_On_Board(Infrared_Decoys[i]).FScripted_Infra.Count - 1 do
      with TScripted_Infrared(TInfrared_Decoy_On_Board(Infrared_Decoys[i]).FScripted_Infra)do
        Waypoints.Add(behav,event); }

end;

procedure TVehicle_Definition.SetActiveWaypoint(const Value: TObject);
begin
  FActiveWaypoint := Value;
end;

procedure TVehicle_Definition.SetGuidanceType(
  const Value: TVehicleGuidanceType);
begin
  FGuidanceType := Value;

  case FGuidanceType of
    vgtWaypoint :
      begin
        if Waypoints.Count > 0 then
          FActiveWaypoint := Waypoints.First;
      end;
  end;

end;

function TVehicle_Definition.FindRadarByID(const id: integer): TObject;
var f: boolean;
    i: integer;
    r: TRadar_On_Board;
begin
  result := nil;
  r := nil;
  f := false;
  i := 0;
  while not f and (i< Radars.Count)  do begin
    r := Radars[i];
    f := r.FData.Radar_Instance_Index = id;

    inc(i)
  end;
  if f then
    result := r;
end;

function TVehicle_Definition.FindSonarByID(const id: integer): TObject;
var f: boolean;
    i: integer;
    r: TSonar_On_Board;
begin
  result := nil;
  r := nil;
  f := false;
  i := 0;
  while not f and (i< Sonars.Count)  do begin
    r := Sonars[i];
    f := r.FData.Sonar_Instance_Index = id;

    inc(i)
  end;
  if f then
    result := r;
end;

function TVehicle_Definition.FindESMByID(const id: integer): TObject;
var f: boolean;
    i: integer;
    r: TESM_On_Board;
begin
  result := nil;
  r := nil;
  f := false;
  i := 0;
  while not f and (i< ESMSensors.Count)  do begin
    r := ESMSensors[i];
    f := r.FData.ESM_Instance_Index = id;

    inc(i)
  end;
  if f then
    result := r;
end;

function TVehicle_Definition.FindWeaponGunByID(const id: integer): TObject;
var f: boolean;
    i: integer;
    wpn: TGun_Definition;
begin
  result := nil;
  wpn := nil;
  f := false;
  i := 0;
  while not f and (i< Guns.Count)  do begin
    wpn := Guns[i];
    f := wpn.FData.Gun_Index = id;
    inc(i)
  end;
  if f then
    result := wpn;

end;


end.
