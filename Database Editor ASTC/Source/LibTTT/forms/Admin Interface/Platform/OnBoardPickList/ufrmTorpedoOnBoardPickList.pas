unit ufrmTorpedoOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.pngimage,
  uDBAsset_Weapon, uDBAsset_Vehicle, uSimContainers;

type
  E_TorpedoSelectionCaller = (tscResourceAllocation, tscVehicleAssets,
    tscMissile, tscRuntimePlatformLibrary);

  TfrmTorpedoOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAllTorpedoDef: TListBox;
    lbAllTorpedoOnBoard: TListBox;
    btnClose: TButton;
    edtSearch: TEdit;
    lbl1: TLabel;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAllTorpedoDefClick(Sender: TObject);
    procedure lbAllTorpedoOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllTorpedoDefList : TList;
    FAllTorpedoOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedTorpedo : TTorpedo_On_Board;

    procedure UpdateTorpedoList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmTorpedoOnBoardPickList: TfrmTorpedoOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmTorpedoMounts;

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

procedure TfrmTorpedoOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Act?ion := cafree;
end;

procedure TfrmTorpedoOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllTorpedoDefList      := TList.Create;
  FAllTorpedoOnBoardList  := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmTorpedoOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllTorpedoDefList);
  FreeItemsAndFreeList(FAllTorpedoOnBoardList);
end;

procedure TfrmTorpedoOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateTorpedoList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmTorpedoOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllTorpedoDef.ItemIndex = -1 then
    Exit;

  frmTorpedoMounts := TfrmTorpedoMounts.Create(Self);
  try
    with frmTorpedoMounts do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedTorpedo := FSelectedTorpedo;
      ShowModal;
    end;
  finally
    frmTorpedoMounts.Free;
  end;

  UpdateTorpedoList;
end;

procedure TfrmTorpedoOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllTorpedoOnBoard.ItemIndex = -1 then
    Exit;

  frmTorpedoMounts := TfrmTorpedoMounts.Create(Self);
  try
    with frmTorpedoMounts do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedTorpedo := FSelectedTorpedo;
      ShowModal;
    end;
  finally
    frmTorpedoMounts.Free;
  end;

  UpdateTorpedoList;
end;

procedure TfrmTorpedoOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllTorpedoOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedTorpedo.FData do
  begin
    dmTTT.DeleteBlindZone(6, Fitted_Weap_Index);
    dmTTT.DeleteFittedWeaponLauncherOnBoard(2, Fitted_Weap_Index);
    dmTTT.DeleteFittedWeaponOnBoard(2, Fitted_Weap_Index);
  end;

  UpdateTorpedoList;
end;

procedure TfrmTorpedoOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTorpedoList;
  end;
end;

procedure TfrmTorpedoOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTorpedoOnBoardPickList.lbAllTorpedoDefClick(Sender: TObject);
begin
  if lbAllTorpedoDef.ItemIndex = -1 then
    Exit;

  FSelectedTorpedo := TTorpedo_On_Board(lbAllTorpedoDef.Items.Objects[lbAllTorpedoDef.ItemIndex]);
end;

procedure TfrmTorpedoOnBoardPickList.lbAllTorpedoOnBoardClick(Sender: TObject);
begin
  if lbAllTorpedoOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedTorpedo := TTorpedo_On_Board(lbAllTorpedoOnBoard.Items.Objects[lbAllTorpedoOnBoard.ItemIndex]);
end;

procedure TfrmTorpedoOnBoardPickList.UpdateTorpedoList;
var
  i : Integer;
  torpedo : TTorpedo_On_Board;
begin
  lbAllTorpedoDef.Items.Clear;
  lbAllTorpedoOnBoard.Items.Clear;

  dmTTT.GetFilterTorpedoDef(FAllTorpedoDefList, edtSearch.Text);
  dmTTT.GetTorpedoOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllTorpedoOnBoardList);

  for i := 0 to FAllTorpedoDefList.Count - 1 do
  begin
    torpedo := FAllTorpedoDefList.Items[i];
    lbAllTorpedoDef.Items.AddObject(torpedo.FDef.Class_Identifier, torpedo);
  end;

  for i := 0 to FAllTorpedoOnBoardList.Count - 1 do
  begin
    torpedo := FAllTorpedoOnBoardList.Items[i];
    lbAllTorpedoOnBoard.Items.AddObject(torpedo.FData.Instance_Identifier, torpedo);
  end;
end;

 {$ENDREGION}

end.
