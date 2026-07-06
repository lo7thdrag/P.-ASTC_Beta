unit ufStartExerciseWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, uT3GroupList, uSRRFunction,
  uSnapshotUtils, uSnapshotGCRec, uSnapshotGCData , uDMGC, Vcl.Imaging.pngimage;

type

  TCubInfo = class
    Assigned   : boolean;
    mnItem : TMenuItem;
  end;

  TfrmStartExerciseWizard = class(TForm)
    Bevel1: TBevel;
    pnlExerciseName: TPanel;
    pnlRecordOption: TPanel;
    pnlCubicleMapping: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edExerciseName: TEdit;
    rbtnRecordYes: TRadioButton;
    rbtnRecordNo: TRadioButton;
    Label3: TLabel;
    gbAudioOption: TGroupBox;
    Panel2: TPanel;
    Bevel2: TBevel;
    btnAddAudio: TButton;
    btnRemoveAudio: TButton;
    btnClearAudio: TButton;
    tvAudioOption: TTreeView;
    Panel3: TPanel;
    Bevel3: TBevel;
    btnAudio_Next: TButton;
    btnAudio_Cancel: TButton;
    btnExcName_Cancel: TButton;
    btnExcName_Next: TButton;
    Panel4: TPanel;
    Bevel4: TBevel;
    btnMapping_Finish: TButton;
    btnMapping_Cancel: TButton;
    btnMapping_Back: TButton;
    tvMapping: TTreeView;
    btnMapToControllers: TButton;
    btnClearAllConfig: TButton;
    btnAudio_Back: TButton;
    pmAssignt: TPopupMenu;
    mnAssign1: TMenuItem;
    Clear1: TMenuItem;
    pnlDevPreplay: TPanel;
    Panel6: TPanel;
    Bevel5: TBevel;
    Button1: TButton;
    btnDevPreplay: TButton;
    pnlButtomDev: TPanel;
    lvConsole: TListView;
    btnExcName_Back: TButton;
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    lblHeader: TLabel;
    procedure btnExcName_CancelClick(Sender: TObject);
    procedure btnExcName_NextClick(Sender: TObject);
    procedure btnAudio_BackClick(Sender: TObject);
    procedure btnAudio_NextClick(Sender: TObject);
    procedure btnMapping_BackClick(Sender: TObject);
    procedure btnMapping_FinishClick(Sender: TObject);
    procedure btnAddAudioClick(Sender: TObject);
    procedure btnRemoveAudioClick(Sender: TObject);
    procedure rbtnRecordYesClick(Sender: TObject);
    procedure rbtnRecordNoClick(Sender: TObject);
    procedure btnClearAudioClick(Sender: TObject);
    procedure tvMappingChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvMappingContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure btnMapToControllersClick(Sender: TObject);
    procedure btnClearAllConfigClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlDevPreplayClick(Sender: TObject);
    procedure btnDevPreplayClick(Sender: TObject);
    procedure btnExcName_BackClick(Sender: TObject);

  private
    DefExcName: string;
    FPairCounter: integer;
    FScenarioID: integer;

    FGroupList    : T3GroupList;
    FCubicleList  : TStringList;

    FNodeAssign: TTreeNode;
    FControllerName : string;
    FGList: TList;

    function getExerciseName: string;
    procedure setExerciseName(const s: string);
    { Private declarations }

    procedure PrepareRecordOption;
    procedure PrepareAssignment;

//    function FindMenu(const sHint: string): TMenuItem;
    procedure menuAssignClick(Sender: TObject);

    function IsAllGroupAssigned: Boolean;
    procedure GetLargestGroupID(var grp: TGroupInfo);

//    function MenuVisibleCount: Integer;

    function GetNodeByName(const s: string): TTreeNode;
  public
    prevForm : TForm;
    stateCanceled : boolean;
    stateFinished : boolean;

    isReplay : boolean;
    isSnapshot : boolean;

    recording: boolean;
    selectedPlatform: Integer;
    { Public declarations }

    procedure EventOnReceiveOnlineList(Sender: TObject);
    function StartNewExercise(const scID: integer): boolean;

    procedure SendAllAssignment;
    procedure SnapshotSetDefaultAsssign;

    property ExerciseName: string read getExerciseName write setExerciseName;

  end;

var
  frmStartExerciseWizard: TfrmStartExerciseWizard;
  lRec      : TRecGCSnapshot ;

implementation

uses
  uStringFunc,
  uNetSessionClient, uNetSessionData,
  ufStartSession, uLibSettingTTT, uTCPDatatype;

{$R *.dfm}

procedure GetSnapshotAssignInfoFromFile (const id : integer  ; const s : string ) ;
var

  lFile     : TFileStream;
  SFullName : String ;
begin
  SFullName := GetSnapshotFullNameNameFromDisplayName(id,s);
  lFile     := TFileStream.Create(SFullName, fmOpenRead or fmShareDenyWrite);
  try
    if not lRec.LoadFrom(lFile) then
    begin
      lFile.Free;
      Exit ;
    end;
  finally
    lFile.Free;
  end;
end;

procedure TfrmStartExerciseWizard.PrepareRecordOption;
begin
  rbtnRecordNo.Checked := true;
  rbtnRecordNoClick(rbtnRecordNo);
end;

procedure TfrmStartExerciseWizard.rbtnRecordNoClick(Sender: TObject);
begin

  btnAddAudio.Enabled     := false;
  btnRemoveAudio.Enabled  := false;
  btnClearAudio.Enabled   := false;

  FPairCounter := 1;
  tvAudioOption.Items.Clear;
  recording := false ;
end;

procedure TfrmStartExerciseWizard.rbtnRecordYesClick(Sender: TObject);
begin
  btnAddAudio.Enabled := true;
  btnRemoveAudio.Enabled  := false;
  btnClearAudio.Enabled   := false;
  recording := true ;
end;


procedure TfrmStartExerciseWizard.btnExcName_BackClick(Sender: TObject);
begin
  pnlDevPreplay.BringToFront;
end;

procedure TfrmStartExerciseWizard.btnExcName_CancelClick(Sender: TObject);
begin
  stateCanceled := true;
  Close;
  if prevForm <> nil then
    prevForm.Show;

end;

procedure TfrmStartExerciseWizard.btnExcName_NextClick(Sender: TObject);
var i, j: integer;
    s: string;
begin
  s := edExerciseName.Text;
  j := 0;
  for i := 1 to Length(s) do
    if s[i]  in  ['\', '/', '.', '"', ':','*','?','<','>','|'] then
       inc(j);
  if j = 0 then
  begin
    if isReplay then
    begin
       //pnlCubicleMapping.BringToFront ;
       stateFinished := True;
       btnMapToControllersClick(Sender);
       SendAllAssignment;
       Close;
    end
    else if isSnapshot then
       pnlRecordOption.BringToFront ;
    begin
       pnlRecordOption.BringToFront ;
    end;
  end
  else begin
    edExerciseName.Text := DefExcName;
    edExerciseName.SelectAll;
    edExerciseName.SetFocus;
  end;
end;

procedure TfrmStartExerciseWizard.btnAddAudioClick(Sender: TObject);
//var nFirst,
//    nPair, nMember : TTreeNode;
begin

  if tvAudioOption.Items.Count < 12 then begin
//    nFirst := tvAudioOption.Items.GetFirstNode;
//    nPair := tvAudioOption.Items.Add(nFirst, 'Audio Track - Pair '
//      + IntToStr(FPairCounter) );

//    nMember := tvAudioOption.Items.AddChild(nPair, 'Audio Track 1' );
//    nMember := tvAudioOption.Items.AddChild(nPair, 'Audio Track 2' );   nMember never used

    inc(FPairCounter);

    if tvAudioOption.Items.Count >= 12 then
      btnAddAudio.Enabled := false;

    btnRemoveAudio.Enabled  := true;
    btnClearAudio.Enabled   := true;
  end;

end;

procedure TfrmStartExerciseWizard.btnRemoveAudioClick(Sender: TObject);
var nSel : TTreeNode;
    maxC : integer;
begin
  maxC := tvAudioOption.Items.Count-1;
  if maxC < 0 then begin
    exit;
    btnRemoveAudio.Enabled  := false;
    btnClearAudio.Enabled   := false;
  end;

  nSel := tvAudioOption.Items.Item[maxC];
  if (nSel <> nil) and (nSel.Parent <> nil) then begin
    tvAudioOption.Items.Delete(nSel.Parent);

    if tvAudioOption.Items.Count = 0 then
       btnRemoveAudio.Enabled := false;
    Dec(FPairCounter);

    btnAddAudio.Enabled := true;
  end;
end;


procedure TfrmStartExerciseWizard.btnAudio_BackClick(Sender: TObject);
begin
  pnlExerciseName.BringToFront;
end;

procedure TfrmStartExerciseWizard.PrepareAssignment;
var
  i, j : Integer;
  lPi : TList;
  gInfo, newGInfo : TGroupInfo;
  pInfo : TDeployedPlatformInfo;
  fNode, node : TTreeNode;
begin
  if isSnapshot then
     SnapshotSetDefaultAsssign
  else
  begin
    tvMapping.Items.Clear;
    fNode := tvMapping.Items.GetFirstNode;
    fNode := tvMapping.Items.AddChild(fNode, edExerciseName.Text);

    FGList.Clear;
    lPi := TList.Create;

    dmGC.GetGroupList(FScenarioID, FGList);
    for i := 0 to FGList.Count - 1 do
    begin
      gInfo := FGList.Items[i];

      node := tvMapping.Items.AddChildObject(fNode, gInfo.Group_Identifier, gInfo);

      dmGC.GetGroupMember(gInfo.Group_Index, lPi);
      for j := 0 to lPi.Count - 1 do
      begin
        pInfo := lPI.Items[j];
        tvMapping.Items.AddChildObject(node, pInfo.Instance_Name, pInfo);
      end;
    end;

    //choco : add new group
//    newGInfo := TGroupInfo.Create;
//    newGInfo.Group_Identifier := 'Unassigned Group';
//    tvMapping.Items.AddChildObject(fNode, newGInfo.Group_Identifier, newGInfo);

    fNode.Expand(false);
    lPi.Free;

    btnMapping_Finish.Enabled := False;
  end;
end;

procedure TfrmStartExerciseWizard.btnAudio_NextClick(Sender: TObject);
begin
  PrepareAssignment;
  pnlCubicleMapping.BringToFront;
end;

procedure TfrmStartExerciseWizard.btnClearAllConfigClick(Sender: TObject);
var i: integer;
    cInfo: TCubInfo;
begin
  PrepareAssignment;

  for i := 0 to FCubicleList.Count - 1 do begin
    cInfo := FCubicleList.Objects[i] as TCubInfo;

    cInfo.Assigned := false;
    cInfo.mnItem.Visible := true;
  end;

end;

procedure TfrmStartExerciseWizard.btnClearAudioClick(Sender: TObject);
begin
  tvAudioOption.Items.Clear;
  btnAddAudio.Enabled     := true;
  btnRemoveAudio.Enabled  := false;
  btnClearAudio.Enabled   := false;
end;

procedure TfrmStartExerciseWizard.btnDevPreplayClick(Sender: TObject);
begin
  pnlExerciseName.BringToFront;
end;

procedure TfrmStartExerciseWizard.btnMapping_BackClick(Sender: TObject);
begin
  if isReplay then
     pnlExerciseName.BringToFront
  else
     pnlRecordOption.BringToFront;
end;

procedure TfrmStartExerciseWizard.btnMapping_FinishClick(Sender: TObject);
begin
  stateFinished := true;
  SendAllAssignment;

  Close;
end;

procedure TfrmStartExerciseWizard.EventOnReceiveOnlineList(Sender: TObject);
var i, j: integer;
    ss, sNew : TStringList;
    ss0, ss1, ss2: TStrings;

    s, cub: string;
    mn : TMenuItem;
    cInfo: TCubInfo;
    li: TListItem;
    consoleInfo : string;
begin
  ss := sender as TStringList;

  sNew:= TStringList.Create; // new Cubicle list;
  sNew.sorted := true;

  ss0 := TStringList.Create;  // equal
  ss1 := TStringList.Create;  // only in oubicle list
  ss2 := TStringList.Create;  // only in new list

  FControllerName := '';
  for I := 0 to ss.Count - 1 do  begin
    s := ss[i];
    cub := FGroupList.GetCubicleName(s);
    if FGroupList.IsController(s) then
       FControllerName := cub;

    //add cubicle info to list view console
    consoleInfo := FGroupList.GetConsoleName(s);
    li := lvConsole.Items.Add;
    li.Caption := s;
    li.SubItems.Add(consoleInfo);
    li.SubItems.Add('Online');
//    li.Data := cbInfo;

    if (cub <> '') and (sNew.IndexOf(cub) < 0) then
      sNew.Add(cub);
  end;

  StringListCompare(FCubicleList, sNew,
   ss0, ss1, ss2, true);

  // same item, reset.
  for i := 0 to ss0.Count - 1 do begin
    j := FCubicleList.IndexOf(ss0[i]);
    if j >= 0 then begin
      cInfo :=  FCubicleList.Objects[j] as TCubInfo;
      cInfo.Assigned := false;
      cInfo.mnItem.Visible := true;
    end;
  end;

  // deleted item, .
  for i := 0 to ss1.Count - 1 do begin
    j := FCubicleList.IndexOf(ss1[i]);
    if j >= 0 then begin
      cInfo :=  FCubicleList.Objects[j] as TCubInfo;
      pmAssignt.Items[0].Remove(cInfo.mnItem);
      cInfo.Free;
      FCubicleList.Delete(j);
    end;
  end;

//new item
  for i := 0 to ss2.Count - 1 do begin
    cInfo := TCubInfo.Create;
    cInfo.Assigned := false;
    mn := TMenuItem.Create(self);

    mn.Caption  := ss2[i];
    mn.Hint     := ss2[i];
    pmAssignt.Items[0].Add(mn);
    mn.OnClick := menuAssignClick;

    cInfo.mnItem   := mn;

    FCubicleList.AddObject(ss2[i], cInfo);
  end;

  ss0.Free;
  ss1.Free;
  ss2.Free;
end;

{procedure TfrmStartExerciseWizard.EventOnReceiveOnlineList(Sender: TObject);
var i, j: integer;
    ss: TStrings;
    s, cub: string;
    mn : TMenuItem;
begin
  ss := sender as TStringList;
  pmAssignt.Items[0].Clear;

  FCubicleList.Clear;

  for I := 0 to FCubicleList.Count - 1 do  begin
    mn := TMenuItem.Create(self);

    mn.Caption  := FCubicleList[i];
    mn.Hint     := FCubicleList[i];

    pmAssignt.Items[0].Add(mn);
    mn.OnClick := menuAssignClick;
  end;

end;
}

procedure TfrmStartExerciseWizard.FormCreate(Sender: TObject);
begin
  FGroupList := T3GroupList.Create;
  FCubicleList := TStringList.Create;
  FCubicleList.Sorted := true;

  FGList := TList.Create;
end;

procedure TfrmStartExerciseWizard.FormDestroy(Sender: TObject);
begin
  FGroupList.Free;
  FGList.Free;

  FCubicleList.Free;
end;

procedure TfrmStartExerciseWizard.FormShow(Sender: TObject);
begin
  recording := false ;
  lvConsole.Clear;
end;

function TfrmStartExerciseWizard.getExerciseName: string;
begin
  result := edExerciseName.Text;
end;

function TfrmStartExerciseWizard.GetNodeByName(const s: string): TTreeNode;
var
  i : Integer;
  node : TTreeNode;
begin
  Result := nil;

  for i := 0 to tvMapping.Items.Count - 1 do
  begin
    node := tvMapping.Items[i];

    if node.Level = 1 then
    begin
      if TGroupInfo(node.Data).Group_Identifier = s then
      begin
        Result := node;
      end;
    end;
  end;
end;

procedure TfrmStartExerciseWizard.GetLargestGroupID(var grp: TGroupInfo);
var
  i, gId : Integer;
  gInfo : TGroupInfo;
begin
  gId := -999999;
  for i := 0 to FGList.Count - 1 do
  begin
    gInfo := FGList.Items[i];

    if gInfo.Group_Index > gId then
    begin
      gId := gInfo.Group_Index;
      grp := gInfo;
    end;
  end;
end;

procedure TfrmStartExerciseWizard.setExerciseName(const s: string);
begin
  DefExcName := s;
  edExerciseName.Text := s;
end;

function TfrmStartExerciseWizard.StartNewExercise(const scID: integer): boolean;
begin
  stateCanceled := false;
  stateFinished := false;

  FScenarioID := scID;

  PrepareRecordOption;
  if isSnapshot then begin
    GetSnapshotAssignInfoFromFile(scID,frmStartSession.SelectedSnapshotDisplayName);
    FGroupList.LoadFromFile(vGameDataSetting.GroupSetting);
    PrepareAssignment;
  end else
  begin
    PrepareAssignment;
    FGroupList.LoadFromFile(vGameDataSetting.GroupSetting);
    //FCubicleList.Clear;
  end;

//  pnlExerciseName.BringToFront;
  pnlDevPreplay.BringToFront;
  btnExcName_Next.Caption := 'Next';

  ShowModal;
  result := stateFinished;

end;

procedure TfrmStartExerciseWizard.tvMappingChange(Sender: TObject;
  Node: TTreeNode);
var  pInfo : TDeployedPlatformInfo;
begin
  if node = nil then exit;

  if node.Level = 2  then begin
     pInfo := node.Data;
     if pInfo <> nil then begin

       selectedPlatform :=  pInfo.Platform_Instance_Index;
     end;
  end;

end;

procedure TfrmStartExerciseWizard.tvMappingContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  FNodeAssign := tvMapping.Selected;
  if FNodeAssign = nil then Exit;
  if (FNodeAssign.Level < 1) or (FNodeAssign.Level>2)  then begin
    mnAssign1.Enabled := False;
    FNodeAssign := nil;
    exit;
  end;

  mnAssign1.Enabled := true;
  if tvMapping.Selected.Level = 1  then
    FNodeAssign := tvMapping.Selected
  else if tvMapping.Selected.Level = 2  then
    FNodeAssign := tvMapping.Selected.Parent;

  if pmAssignt.Items[0].Count > 0 then begin  /// add by sam
    if FNodeAssign.Text = 'Unassigned Group' then
      mnAssign1.Items[0].Visible := False
    else
      mnAssign1.Items[0].Visible := True;
  end;
end;

procedure TfrmStartExerciseWizard.menuAssignClick(Sender: TObject);
var
  i : Integer;
  gInfo, newGInfo : TGroupInfo;
  mn : TMenuItem;
  cub: TCubInfo;
  fNode : TTreeNode;
begin
  if FNodeAssign = nil then
    Exit;

  mn := sender as TMenuItem;
  gInfo := FNodeAssign.Data;

  if Assigned(gInfo) then
  begin
    if gInfo.CubicleName <> '' then
    begin
      i := FCubicleList.IndexOf(gInfo.CubicleName);
      if i >= 0 then
      begin
        cub := FCubicleList.Objects[i] as TCubInfo;
        cub.Assigned := false;
        cub.mnItem.Visible := true;
      end;
    end;

    gInfo.CubicleName := mn.Hint;

    if gInfo.Group_Identifier = 'Unassigned Group' then
    begin
      newGInfo := TGroupInfo.Create;
      newGInfo.Group_Identifier := gInfo.Group_Identifier;
      newGInfo.CubicleName := gInfo.CubicleName;
      GetLargestGroupID(gInfo);
      newGInfo.Group_Index := gInfo.Group_Index + 1;
      newGInfo.Deployment_Index := gInfo.Deployment_Index;

      FGList.Add(newGInfo);

      fNode := GetNodeByName(newGInfo.Group_Identifier);
      tvMapping.Items.AddChildObject(fNode, newGInfo.CubicleName, newGInfo);
    end
    else
      FNodeAssign.Text := gInfo.Group_Identifier + ' ( ' + gInfo.CubicleName + ' )';

    i := FCubicleList.IndexOf(mn.Hint);
    if i >= 0 then
    begin
      cub := FCubicleList.Objects[i] as TCubInfo;
      cub.Assigned := True;
      if mn.Hint <> FControllerName then
        mn.Visible := False;
    end;

    if IsAllGroupAssigned then
      btnMapping_Finish.Enabled := True;
  end;
end;

procedure TfrmStartExerciseWizard.pnlDevPreplayClick(Sender: TObject);
begin

end;

//function TfrmStartExerciseWizard.MenuVisibleCount: Integer;
//var
//  i : Integer;
//  mi: TMenuItem;
//begin
//  Result := 0;
//  for i := 0 to pmAssignt.Items[0].Count - 1 do
//  begin
//    mi := pmAssignt.Items[0].Items[i];
//    if mi.Visible then
//      Inc(Result);
//  end;
//end;

procedure TfrmStartExerciseWizard.Clear1Click(Sender: TObject);
var gInfo : TGroupInfo;
    i     : integer;
    cub   : TCubInfo;
begin
  if FNodeAssign = nil then Exit;
  gInfo := FNodeAssign.Data;
  if gInfo <> nil then begin
    i := FCubicleList.IndexOf(gInfo.CubicleName);
    if i >= 0 then begin
      cub := FCubicleList.Objects[i] as TCubInfo;
      cub.Assigned := false;
      cub.mnItem.Visible := true;
    end;

    gInfo.CubicleName := '';

    FNodeAssign.Text := gInfo.Group_Identifier;
    btnMapping_Finish.Enabled := false;
  end;
end;

function TfrmStartExerciseWizard.IsAllGroupAssigned: Boolean;
var
  i : Integer;
  g : TGroupInfo;
  c : Integer;
begin
  // return true jika semua group sudah habis di assign ke cubicle
  c := 0;
  for i := 0 to FGList.Count - 1 do
  begin
    g := FGList[i];
    if g.CubicleName <> '' then
      Inc(c);
  end;
  Result := (c <> 0) and (c = FGList.Count);
end;

procedure TfrmStartExerciseWizard.btnMapToControllersClick(Sender: TObject);
var
  i: Integer;
  g : TGroupInfo;
  t : TTreeNode;
begin
  for i := 0 to tvMapping.Items.Count - 1 do
  begin
    t := tvMapping.Items.Item[i];
    if t.Level = 1 then
    begin
      g := t.Data;
      if g.CubicleName = '' then
      begin
        g.CubicleName := FControllerName;
        t.Text := g.Group_Identifier + ' ( ' + FControllerName + ' )';
      end;
    end;
  end;

  if IsAllGroupAssigned then
    btnMapping_Finish.Enabled := True;
end;

procedure TfrmStartExerciseWizard.SendAllAssignment;
var
  i, j, idx : Integer;
  g, ug : TGroupInfo;
  cub, subCub : TCubicleInfo;
  assG, unassG : TAssignGroup;
  ipAdd : string;
  ssIP, ussIP : TStringList;
begin
  theClient.SendCubicleAssign('0.0.0.0', CMD_ASSIGN_CLEAR, 0);

  ssIP := TStringList.Create;
  ssIP.Sorted := True;
  ussIP := TStringList.Create;
  ussIP.Sorted := True;

  // building index  of shipment.
  for i := 0 to FGList.Count - 1 do
  begin
    g := FGList[i];

    if g.CubicleName = '' then
      Continue;

    cub := FGroupList.GetCubicle(g.CubicleName);
    if Assigned(cub) then
    begin
      for j := 0 to cub.ConsoleIPs.Count - 1 do
      begin
        ipAdd := cub.ConsoleIPs[j];
        if ssIP.Find(ipAdd, idx) then
        begin
          assG := ssIP.Objects[idx] as TAssignGroup;
          assG.Add(g.Group_Index);
        end
        else
        begin
          assG := TAssignGroup.Create;
          assG.Add(g.Group_Index);
          ssIP.AddObject(ipAdd, assG);
        end;
      end;
    end;
  end;

  for i := 0 to ssIP.Count - 1 do
  begin
    ipAdd := ssIP[i];
    assG := ssIP.Objects[i] as TAssignGroup;

    for j := 0 to assG.Count - 1 do
    begin
      theClient.SendCubicleAssign(ipAdd, CMD_ASSIGN_ADD, assG.AssList[j] );
    end;
  end;

  theClient.SendCubicleAssign('0.0.0.0', CMD_ASSIGN_END, 0);
end;

procedure TfrmStartExerciseWizard.SnapshotSetDefaultAsssign;
var
  i, j, k     : integer;
  lPi         : TList;
  gInfo, grp , newGInfo       : TGroupInfo;  { }
  pInfo       : TDeployedPlatformInfo;
  fNode,
  node, t     : TTreeNode;
  ipAdd       : string;
  recCublist  : _SSA_CubGroup ;
  recCub      : _SS_CubGroup ;
  recCubMember: _SS_CubGroupMember;
begin
  recCublist  := lRec.FRCubicleGroupList ;

  tvMapping.Items.Clear;
  fNode := tvMapping.Items.GetFirstNode;
  fNode := tvMapping.Items.AddChild(fNode, edExerciseName.Text);

  FGList.Clear;
  lPi := TList.Create;

  // dmGC.GetGroupList(FScenarioID, FGList);
  for i := Low(recCublist) to High(recCublist) do begin
    recCub := recCublist[i];
    if recCub.FData.Group_Index > 0 then begin
      gInfo := TGroupInfo.Create;
      with gInfo do begin
        Group_Index       := recCub.FData.Group_Index;
        Group_Identifier  := recCub.FData.Group_Identifier;
        Deployment_Index  := recCub.FData.Deployment_Index;
        CubicleName       := recCub.CubicleName ;
      end;

      node := tvMapping.Items.AddChildObject(fNode, gInfo.Group_Identifier, gInfo);
      FGList.Add(gInfo);

      //dmGC.GetGroupMember(gInfo.Group_Index, lPi);
      lPi.Clear;
      for j := Low(recCublist[i].FSList) to High(recCublist[i].FSList) do begin
          recCubMember := recCublist[i].FSList[j];
          gInfo := TGroupInfo.Create;
          with gInfo do begin
              Group_Index       := recCubMember.FData.Group_Index;
              Group_Identifier  := recCubMember.Instance_Name; //  cub.FData.Group_Identifier;
              Deployment_Index  := recCubMember.FData.Deployment_Index;
          end;
          lPi.add(gInfo);
      end;

      for j := 0 to lPi.Count - 1 do begin
        pInfo :=  lPI.Items[j];
        tvMapping.Items.AddChildObject(node, pInfo.Instance_Name, pInfo);
      end;

    end;
  end;

  { assign from snapshot}
  for i := 0 to (tvMapping.Items.Count-1)-1 do  begin
    t := tvMapping.Items.Item[i];
    if t.Level = 1  then begin
      gInfo := t.Data ;
      if gInfo <> nil then begin
          if length(lRec.FRAssignCGList)>0 then begin
            for j := low(lRec.FRAssignCGList) to high(lRec.FRAssignCGList) do begin
                for k := low(lRec.FRAssignCGList[j].AssList) to high(lRec.FRAssignCGList[j].AssList) do begin
                  if gInfo.Group_Index = lRec.FRAssignCGList[j].AssList[k] then begin
                    ipAdd := LongIp_To_StrIp(lRec.FRAssignCGList[j].LongIP);
                    gInfo.CubicleName := FGroupList.GetCubicleName(ipAdd);
                    t.Text := gInfo.Group_Identifier + ' ( '+ gInfo.CubicleName + ' )';
                  end;
                end;
            end;
          end;
      end;
    end;
  end;

  //choco : add new group
  GetLargestGroupID(grp);
  newGInfo := TGroupInfo.Create;
  newGInfo.Group_Index := grp.Group_Index + 1;
  newGInfo.Deployment_Index := grp.Deployment_Index;
  newGInfo.Group_Identifier := 'Unassigned Group';
  FGList.Add(newGInfo);
  tvMapping.Items.AddChildObject(fNode, newGInfo.Group_Identifier, newGInfo);

  fNode.Expand(false);
  lPi.Free;

end;



end.
