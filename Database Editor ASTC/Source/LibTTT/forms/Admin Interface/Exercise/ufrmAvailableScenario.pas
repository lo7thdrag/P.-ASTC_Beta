unit ufrmAvailableScenario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uDBAssetObject, uDBAsset_Deploy, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,

  uDBAsset_GameEnvironment, tttData, uSimContainers;

type
  TUpdatePlatformID = class

  public
    OldId :  Integer;
    NewId : Integer;

  end;

  TfrmAvailableScenario = class(TForm)
    Image1: TImage;
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableButton: TPanel;
    btnDelete: TImage;
    btnEdit: TImage;
    btnCopy: TImage;
    btnNew: TImage;
    pnlTableList: TPanel;
    lstScenarioList: TListBox;
    Label1: TLabel;
    edtSearch: TEdit;

    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lstScenarioListClick(Sender: TObject);

    procedure btnNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);

    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure edtSearchChange(Sender: TObject);

  private
    FUpdateList : Boolean;
    FScenarioList : TList;
    FIdTranslateList : TList;

    FOldEnvironmentIndex : Integer;
    FOldAssetDeploymentndex : Integer;
    FOldResourceAllocationIndex : Integer;

    FSelectedScenario : TScenario_Definition;
    FSelectedAssetDeployment : TAsset_Deployment;
    FSelectedResourceAllocation : TResource_Allocation;
    FSelectedEnvironment : TGame_Environment_Definition;
    FSelectedGameArea : TGame_Area_Definition;

    function TranslatePlatformID(aOldPlatformIndex: Integer): Integer;

    procedure UpdateScenarioList;

    procedure CopyScenario;
    procedure CopyPlatform(const aNewResourceAllocationIndex, aNewDeploymentIndex: Integer);
    procedure CopyOverlay(const aNewResourceAllocationIndex: Integer);
    procedure CopyRPL(const aNewResourceAllocationIndex: Integer);
    procedure CopyWaypoint(const aNewResourceAllocationIndex: Integer);
    procedure CopyPlatformActivation(const aNewDeploymentIndex: Integer);
    procedure CopyCubicleGroup(const aNewDeploymentIndex: Integer);
    procedure CopyCubicleGroupPlatformAndCommunication(const aCubGroupIndex, aNewCubGroupIndex, aNewDeploymentIndex: Integer);

  end;

var
  frmAvailableScenario: TfrmAvailableScenario;

implementation

uses
  uDataModuleTTT, ufrmSummaryScenario, ufrmUsage, newClassASTT;

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

{$REGION ' Form Handle '}

procedure TfrmAvailableScenario.FormCreate(Sender: TObject);
begin
  FScenarioList := TList.Create;
  FIdTranslateList := TList.Create;

  FSelectedAssetDeployment := TAsset_Deployment.Create;
  FSelectedResourceAllocation := TResource_Allocation.Create;
  FSelectedEnvironment := TGame_Environment_Definition.Create;
  FSelectedGameArea := TGame_Area_Definition.Create;
end;

procedure TfrmAvailableScenario.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FScenarioList);
  FreeItemsAndFreeList(FIdTranslateList);

  FreeAndNil(FSelectedAssetDeployment);
  FreeAndNil(FSelectedResourceAllocation);
  FreeAndNil(FSelectedEnvironment);
  FreeAndNil(FSelectedGameArea);

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableScenario.FormShow(Sender: TObject);
begin
  UpdateScenarioList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableScenario.btnNewClick(Sender: TObject);
begin
  frmSummaryScenario := TfrmSummaryScenario.Create(Self);
  try
    with frmSummaryScenario do
    begin
      SelectedScenario            := TScenario_Definition.Create;
      SelectedResourceAllocation  := TResource_Allocation.Create;
      SelectedEnvironment         := TGame_Environment_Definition.Create;
      SelectedGameArea            := TGame_Area_Definition.Create;
      SelectedAssetDeployment     := TAsset_Deployment.Create;

      ShowModal;

      SelectedScenario.Free;
      SelectedResourceAllocation.Free;
      SelectedEnvironment.Free;
      SelectedGameArea.Free;
      SelectedAssetDeployment.Free;
    end;
  finally
    frmSummaryScenario.Free;
  end;

  UpdateScenarioList;
end;

procedure TfrmAvailableScenario.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count, parentIndex : Integer;

begin
  if lstScenarioList.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Scenario ... !');
    Exit;
  end;

  CopyScenario;
  UpdateScenarioList;
end;

procedure TfrmAvailableScenario.btnEditClick(Sender: TObject);
begin
  if lstScenarioList.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Scenario ... !');
    Exit;
  end;

  frmSummaryScenario := TfrmSummaryScenario.Create(Self);
  try
    with frmSummaryScenario do
    begin
      SelectedScenario            := FSelectedScenario;
      SelectedResourceAllocation  := FSelectedResourceAllocation;
      SelectedEnvironment         := FSelectedEnvironment;
      SelectedGameArea            := FSelectedGameArea;
      SelectedAssetDeployment     := FSelectedAssetDeployment;
      ShowModal;
    end;
  finally
    frmSummaryScenario.Free;
  end;

  UpdateScenarioList;
end;

procedure TfrmAvailableScenario.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstScenarioList.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Scenario ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation, mbOKCancel, 0);

  if warning = mrOK then
  begin
    {$REGION ' Delete Aset Deployment '}
    with FSelectedAssetDeployment.FData do
    begin
      dmTTT.DeletePlatformActivation(1, Deployment_Index);

      dmTTT.DeleteCubicleGroupAssignment(1, Deployment_Index);
      dmTTT.DeleteCubicleGroupChannelAssignment(1, Deployment_Index);
      dmTTT.DeleteCubicleGroup(1, Deployment_Index);
    end;
    {$ENDREGION}

    {$REGION ' Delete Scenario Definition '}
    with FSelectedScenario.FData do
      dmTTT.DeleteScenarioDef(Scenario_Index);
    {$ENDREGION}

    {$REGION ' Delete Resource Allocation '}
    with FSelectedResourceAllocation.FData do
    begin
      dmTTT.DeletePlatformInstance(1, Resource_Alloc_Index);
      dmTTT.DeleteResourceBaseMapping(1, Resource_Alloc_Index, 0, 0);
      dmTTT.DeleteResourceOverlayMapping(1, Resource_Alloc_Index);

      dmTTT.DeleteResourceRPLMapping(1, Resource_Alloc_Index, 0);
      dmTTT.DeleteResourceWaypointMapping(1, Resource_Alloc_Index, 0);

      dmTTT.DeleteResourceAllocationDef(Resource_Alloc_Index);
    end;
    {$ENDREGION}

    {$REGION ' Delete Environment '}
    with FSelectedEnvironment.FData do
    begin
      dmTTT.DeleteGlobalConvergenceZone(Game_Enviro_Index);

      dmTTT.DeleteEnvironmentDef(Game_Enviro_Index)
    end;
    {$ENDREGION}

    UpdateScenarioList;
  end;
end;

procedure TfrmAvailableScenario.lstScenarioListClick(Sender: TObject);
begin
  if lstScenarioList.ItemIndex = -1 then
    Exit;

  FSelectedScenario := TScenario_Definition(lstScenarioList.Items.Objects[lstScenarioList.ItemIndex]);

  with FSelectedScenario.FData do
  begin
    dmTTT.GetAssetDeployment(Scenario_Index, FSelectedAssetDeployment);
    dmTTT.GetResourceAllocationDef(Resource_Alloc_Index, FSelectedResourceAllocation);
  end;

  with FSelectedResourceAllocation.FData do
    dmTTT.GetEnvironmentDef(Game_Enviro_Index, FSelectedEnvironment);

  with FSelectedEnvironment.FData do
    dmTTT.GetGameAreaDef(Game_Area_Index, FSelectedGameArea);
end;

function TfrmAvailableScenario.TranslatePlatformID(aOldPlatformIndex: Integer): Integer;
var
  i : Integer;
  idTemp : TUpdatePlatformID;

begin
  Result := 0;

  for i := 0 to FIdTranslateList.Count - 1 do
  begin
    idTemp := FIdTranslateList.Items[i];

    if idTemp.OldId = aOldPlatformIndex then
    begin
      Result := idTemp.NewId;
    end;
  end;
end;

procedure TfrmAvailableScenario.CopyCubicleGroup(const aNewDeploymentIndex: Integer);
var
  i, j, parentIndex : Integer;
  tempList : TList;
  cubicleTemp : TCubicle_Group_Assignment;

begin

  {$REGION ' Force Red '}
  tempList := TList.Create;
  dmTTT.GetCubicleGroup(FOldAssetDeploymentndex, ord(fgRed), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    cubicleTemp := tempList.Items[i];

    with cubicleTemp do
    begin
      parentIndex := FData.Group_Index;
      FData.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroup(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Yellow '}
  tempList := TList.Create;
  dmTTT.GetCubicleGroup(FOldAssetDeploymentndex, ord(fgYellow), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    cubicleTemp := tempList.Items[i];

    with cubicleTemp do
    begin
      parentIndex := FData.Group_Index;
      FData.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroup(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Blue '}
  tempList := TList.Create;
  dmTTT.GetCubicleGroup(FOldAssetDeploymentndex, ord(fgBlue), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    cubicleTemp := tempList.Items[i];

    with cubicleTemp do
    begin
      parentIndex := FData.Group_Index;
      FData.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroup(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Green '}
  tempList := TList.Create;
  dmTTT.GetCubicleGroup(FOldAssetDeploymentndex, ord(fgGreen), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    cubicleTemp := tempList.Items[i];

    with cubicleTemp do
    begin
      parentIndex := FData.Group_Index;
      FData.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroup(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' No Force '}
  tempList := TList.Create;
  dmTTT.GetCubicleGroup(FOldAssetDeploymentndex, ord(fgNoForce), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    cubicleTemp := tempList.Items[i];

    with cubicleTemp do
    begin
      parentIndex := FData.Group_Index;
      FData.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroup(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

end;

procedure TfrmAvailableScenario.CopyCubicleGroupPlatformAndCommunication(const aCubGroupIndex, aNewCubGroupIndex, aNewDeploymentIndex: Integer);
var
  cubGroupList : TList;
  i : Integer;
  cubGroup : TCubicle_Group_Assignment;
begin
  cubGroupList := TList.Create;

  dmTTT.GetCubicleGroupAssignment(aCubGroupIndex, cubGroupList);

  for i := 0 to cubGroupList.Count - 1 do
  begin
    cubGroup := cubGroupList.Items[i];

    with cubGroup do
    begin
      FCubicle.Group_Index := aNewCubGroupIndex;
      FCubicle.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroupAssignment(FCubicle);
    end;
  end;

  for i := 0 to cubGroupList.Count - 1 do
  begin
    cubGroup := cubGroupList.Items[i];
    cubGroup.Free;
  end;

  cubGroupList.Clear;

  dmTTT.GetCubicleGroupChannelAssignment(aCubGroupIndex, cubGroupList);

  for i := 0 to cubGroupList.Count - 1 do
  begin
    cubGroup := cubGroupList.Items[i];

    with cubGroup do
    begin
      FChannel.Group_Index := aNewCubGroupIndex;
//      FChannel.Deployment_Index := aNewDeploymentIndex;

      dmTTT.InsertCubicleGroupChannelAssignment(FChannel);
    end;
  end;

  for i := 0 to cubGroupList.Count - 1 do
  begin
    cubGroup := cubGroupList.Items[i];
    cubGroup.Free;
  end;

  cubGroupList.Free;
end;

procedure TfrmAvailableScenario.CopyOverlay(const aNewResourceAllocationIndex: Integer);
var
  i, j : Integer;
  tempList : TList;
  overlayTemp : TResource_Overlay_Mapping;

begin
  {$REGION ' Force Red '}
  tempList := TList.Create;
  dmTTT.GetResourceOverlayMapping(FOldResourceAllocationIndex, ord(fgRed), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    overlayTemp := tempList.Items[i];

    with overlayTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceOverlayMapping(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Yellow '}
  tempList := TList.Create;
  dmTTT.GetResourceOverlayMapping(FOldResourceAllocationIndex, ord(fgYellow), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    overlayTemp := tempList.Items[j];

    with overlayTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceOverlayMapping(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Blue '}
  tempList := TList.Create;
  dmTTT.GetResourceOverlayMapping(FOldResourceAllocationIndex, ord(fgBlue), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    overlayTemp := tempList.Items[i];

    with overlayTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceOverlayMapping(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Green '}
  tempList := TList.Create;
  dmTTT.GetResourceOverlayMapping(FOldResourceAllocationIndex, ord(fgGreen), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    overlayTemp := tempList.Items[j];

    with overlayTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceOverlayMapping(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' No Force '}
  tempList := TList.Create;
  dmTTT.GetResourceOverlayMapping(FOldResourceAllocationIndex, ord(fgNoForce), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    overlayTemp := tempList.Items[i];

    with overlayTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceOverlayMapping(FData);
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}
end;

procedure TfrmAvailableScenario.CopyPlatform(const aNewResourceAllocationIndex, aNewDeploymentIndex: Integer);
var
  i, j : Integer;
  tempList : TList;
  platformTemp : TPlatform_Instance;
  idTranslateTemp : TUpdatePlatformID;
  oldPlatformID : Integer;

begin
  FIdTranslateList.Clear;

  {$REGION ' Force Red '}
  tempList := TList.Create;
  dmTTT.GetPlatformInstance(FOldResourceAllocationIndex, 1, ord(fgRed), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[j];

    with platformTemp do
    begin
      oldPlatformID := FData.Platform_Instance_Index;
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertPlatformInstance(FData);

      {Copy Platform Activation}
      if dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, oldPlatformID, FActivation) > 0 then
      begin
        FActivation.Deployment_Index := aNewDeploymentIndex;
        FActivation.Platform_Instance_Index := FData.Platform_Instance_Index;

        dmTTT.InsertPlatformActivation(FActivation);
      end;

      idTranslateTemp := TUpdatePlatformID.Create;
      with idTranslateTemp do
      begin
        OldId := oldPlatformID;
        NewId := FData.Platform_Instance_Index;

        FIdTranslateList.Add(idTranslateTemp);
      end;
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Yellow '}
  tempList := TList.Create;
  dmTTT.GetPlatformInstance(FOldResourceAllocationIndex, 1, ord(fgYellow), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[j];

    with platformTemp do
    begin
      oldPlatformID := FData.Platform_Instance_Index;
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertPlatformInstance(FData);

      {Copy Platform Activation}
      if dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, oldPlatformID, FActivation) > 0 then
      begin
        FActivation.Deployment_Index := aNewDeploymentIndex;
        FActivation.Platform_Instance_Index := FData.Platform_Instance_Index;

        dmTTT.InsertPlatformActivation(FActivation);
      end;

      idTranslateTemp := TUpdatePlatformID.Create;
      with idTranslateTemp do
      begin
        OldId := oldPlatformID;
        NewId := FData.Platform_Instance_Index;

        FIdTranslateList.Add(idTranslateTemp);
      end;
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Blue '}
  tempList := TList.Create;
  dmTTT.GetPlatformInstance(FOldResourceAllocationIndex, 1, ord(fgBlue), tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[i];

    with platformTemp do
    begin
      oldPlatformID := FData.Platform_Instance_Index;
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertPlatformInstance(FData);

      {Copy Platform Activation}
      if dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, oldPlatformID, FActivation) > 0 then
      begin
        FActivation.Deployment_Index := aNewDeploymentIndex;
        FActivation.Platform_Instance_Index := FData.Platform_Instance_Index;

        dmTTT.InsertPlatformActivation(FActivation);
      end;

      idTranslateTemp := TUpdatePlatformID.Create;
      with idTranslateTemp do
      begin
        OldId := oldPlatformID;
        NewId := FData.Platform_Instance_Index;

        FIdTranslateList.Add(idTranslateTemp);
      end;
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' Force Green '}
  tempList := TList.Create;
  dmTTT.GetPlatformInstance(FOldResourceAllocationIndex, 1, ord(fgGreen), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[j];

    with platformTemp do
    begin
      oldPlatformID := FData.Platform_Instance_Index;
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertPlatformInstance(FData);

      {Copy Platform Activation}
      if dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, oldPlatformID, FActivation) > 0 then
      begin
        FActivation.Deployment_Index := aNewDeploymentIndex;
        FActivation.Platform_Instance_Index := FData.Platform_Instance_Index;

        dmTTT.InsertPlatformActivation(FActivation);
      end;

      idTranslateTemp := TUpdatePlatformID.Create;
      with idTranslateTemp do
      begin
        OldId := oldPlatformID;
        NewId := FData.Platform_Instance_Index;

        FIdTranslateList.Add(idTranslateTemp);
      end;
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}

  {$REGION ' No Force '}
  tempList := TList.Create;
  dmTTT.GetPlatformInstance(FOldResourceAllocationIndex, 1, ord(fgNoForce), tempList);
  for j := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[j];

    with platformTemp do
    begin
      oldPlatformID := FData.Platform_Instance_Index;
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertPlatformInstance(FData);

      {Copy Platform Activation}
      if dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, oldPlatformID, FActivation) > 0 then
      begin
        FActivation.Deployment_Index := aNewDeploymentIndex;
        FActivation.Platform_Instance_Index := FData.Platform_Instance_Index;

        dmTTT.InsertPlatformActivation(FActivation);
      end;

      idTranslateTemp := TUpdatePlatformID.Create;
      with idTranslateTemp do
      begin
        OldId := oldPlatformID;
        NewId := FData.Platform_Instance_Index;

        FIdTranslateList.Add(idTranslateTemp);
      end;
    end;
  end;
  FreeItemsAndFreeList(tempList);
  {$ENDREGION}
end;

procedure TfrmAvailableScenario.CopyPlatformActivation(const aNewDeploymentIndex: Integer);
var
  i : Integer;
  tempList : TList;
  platformTemp : TPlatform_Instance;

begin
  tempList := TList.Create;

  dmTTT.GetPlatformActivation(FOldAssetDeploymentndex, tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    platformTemp := tempList.Items[i];

    with platformTemp do
    begin
      FActivation.Deployment_Index := aNewDeploymentIndex;
      dmTTT.InsertPlatformActivation(FActivation);
    end;
  end;
  tempList.Free;
end;

procedure TfrmAvailableScenario.CopyRPL(const aNewResourceAllocationIndex: Integer);
var
  i : Integer;
  tempList : TList;
  rplTemp : TResource_Library_Mapping;

begin
  tempList := TList.Create;

  dmTTT.GetResourceRPLMapping(FOldResourceAllocationIndex, tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    rplTemp := tempList.Items[i];

    with rplTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceRPLMapping(FData);
    end;
  end;
  tempList.Free;
end;

procedure TfrmAvailableScenario.CopyScenario;
var
  newScenarioName : string;
  count, parentIndex : Integer;

begin

  {$REGION ' Pengecekan nama scenario baru '}
  with FSelectedScenario do
  begin
    newScenarioName := FData.Scenario_Identifier + ' - Copy';

    count := dmTTT.GetScenarioDef(newScenarioName);

    if count > 0 then
      newScenarioName := newScenarioName + ' (' + IntToStr(count + 1) + ')';
  end;
  {$ENDREGION}

  {$REGION ' Insert Environtment '}
  with FSelectedEnvironment do
  begin
    FOldEnvironmentIndex := FData.Game_Enviro_Index;

    FData.Game_Enviro_Identifier := 'Scenario - ' + newScenarioName;
    dmTTT.InsertEnvironmentDef(FData);

    FGlobal_Conv.Game_Enviro_Index := FData.Game_Enviro_Index;
    dmTTT.InsertGlobalConvergenceZone(FGlobal_Conv);
  end;
  {$ENDREGION}

  {$REGION ' Insert Resource Allocation '}
  with FSelectedResourceAllocation do
  begin
    FOldResourceAllocationIndex := FData.Resource_Alloc_Index;

    FData.Allocation_Identifier := 'Scenario - ' + newScenarioName;
    FData.Game_Enviro_Index := FSelectedEnvironment.FData.Game_Enviro_Index;
    dmTTT.InsertResourceAllocationDef(FData);
  end;
  {$ENDREGION}

  {$REGION ' Insert Scenario '}
  with FSelectedScenario do
  begin
    FData.Resource_Alloc_Index := FSelectedResourceAllocation.FData.Resource_Alloc_Index;

    FData.Scenario_Identifier := newScenarioName;
    FData.Scenario_Code := 0;

    if dmTTT.InsertScenarioDef(FSelectedScenario.FData) then
    begin
      with FSelectedAssetDeployment do
      begin
        FOldAssetDeploymentndex :=  FData.Deployment_Index;
        FData.Deployment_Identifier := '(Scenario ' + newScenarioName + ')';
        FData.Scenario_Index := FSelectedScenario.FData.Scenario_Index;

        dmTTT.InsertAssetDeployment(FSelectedAssetDeployment.FData);
      end;
    end;
  end;
  {$ENDREGION}

  {$REGION ' Copy Semua Resource '}

  {Copy Platform}
  CopyPlatform(FSelectedResourceAllocation.FData.Resource_Alloc_Index, FSelectedAssetDeployment.FData.Deployment_Index);

  {Copy Overlay}
  CopyOverlay(FSelectedResourceAllocation.FData.Resource_Alloc_Index);

  {Copy RPL}
  CopyRPL(FSelectedResourceAllocation.FData.Resource_Alloc_Index);

  {Copy Waypoint}
  CopyWaypoint(FSelectedResourceAllocation.FData.Resource_Alloc_Index);

  {Copy Cubicle Group}
  CopyCubicleGroup(FSelectedAssetDeployment.FData.Deployment_Index);

  {$ENDREGION}

end;

procedure TfrmAvailableScenario.CopyWaypoint(const aNewResourceAllocationIndex: Integer);
var
  i : Integer;
  tempList : TList;
  waypointTemp : TResource_Waypoint_Mapping;

begin
  tempList := TList.Create;

  dmTTT.GetResourceWaypointMapping(FOldResourceAllocationIndex, tempList);
  for i := 0 to tempList.Count - 1 do
  begin
    waypointTemp := tempList.Items[i];

    with waypointTemp do
    begin
      FData.Resource_Alloc_Index := aNewResourceAllocationIndex;
      dmTTT.InsertResourceWaypointMapping(waypointTemp);
    end;
  end;
  tempList.Free;
end;

procedure TfrmAvailableScenario.edtSearchChange(Sender: TObject);
var
  i : Integer;
  FTempScenario : TScenario_Definition;

begin
  lstScenarioList.Items.Clear;

//  dmTTT.GetAllScenarioDef(FScenarioList);
  dmTTT.GetFilterScenarioDef(FScenarioList, edtSearch.Text);

  for i := 0 to FScenarioList.Count - 1 do
  begin
    FTempScenario := FScenarioList.Items[i];
    lstScenarioList.Items.AddObject(FTempScenario.FData.Scenario_Identifier,FTempScenario);
  end;
end;

procedure TfrmAvailableScenario.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
if Key = #13 then
  begin
    UpdateScenarioList
  end;
end;

procedure TfrmAvailableScenario.UpdateScenarioList;
var
  i : Integer;
  FTempScenario : TScenario_Definition;

begin
  lstScenarioList.Items.Clear;

//  dmTTT.GetAllScenarioDef(FScenarioList);
  dmTTT.GetFilterScenarioDef(FScenarioList, edtSearch.Text);

  for i := 0 to FScenarioList.Count - 1 do
  begin
    FTempScenario := FScenarioList.Items[i];
    lstScenarioList.Items.AddObject(FTempScenario.FData.Scenario_Identifier,FTempScenario);
  end;
end;

{$ENDREGION}

end.
