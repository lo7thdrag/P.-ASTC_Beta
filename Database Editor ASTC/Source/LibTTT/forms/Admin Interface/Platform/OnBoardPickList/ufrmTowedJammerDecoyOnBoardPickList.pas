unit ufrmTowedJammerDecoyOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmTowedJammerDecoyOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditMount: TButton;
    btnRemove: TButton;
    lbAllTowedJammerDecoyDef: TListBox;
    lbAllTowedJammerDecoyOnBoard: TListBox;
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

    procedure lbAllTowedJammerDecoyDefClick(Sender: TObject);
    procedure lbAllTowedJammerDecoyOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditMountClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllTowedJammerDecoyDefList : TList;
    FAllTowedJammerDecoyOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedTowedJammerDecoy : TTowed_Jammer_Decoy_On_Board;

    procedure UpdateTowedJammerDecoyList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmTowedJammerDecoyOnBoardPickList: TfrmTowedJammerDecoyOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryTowedJammerDecoy, ufrmTowedJammerMount;

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

procedure TfrmTowedJammerDecoyOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllTowedJammerDecoyDefList     := TList.Create;
  FAllTowedJammerDecoyOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllTowedJammerDecoyDefList);
  FreeItemsAndFreeList(FAllTowedJammerDecoyOnBoardList);
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateTowedJammerDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmTowedJammerDecoyOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllTowedJammerDecoyDef.ItemIndex = -1 then
    Exit;

  frmTowedJammerMount := TfrmTowedJammerMount.Create(Self);
  try
    with frmTowedJammerMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedTowedJammerDecoy := FSelectedTowedJammerDecoy;
      ShowModal;
    end;
  finally
    frmTowedJammerMount.Free;
  end;

  UpdateTowedJammerDecoyList;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.btnEditMountClick(Sender: TObject);
begin
  if lbAllTowedJammerDecoyOnBoard.ItemIndex = -1 then
    Exit;

  frmTowedJammerMount := TfrmTowedJammerMount.Create(Self);
  try
    with frmTowedJammerMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedTowedJammerDecoy := FSelectedTowedJammerDecoy;
      ShowModal;
    end;
  finally
    frmTowedJammerMount.Free;
  end;

  UpdateTowedJammerDecoyList;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllTowedJammerDecoyOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedTowedJammerDecoy.FData do
    dmTTT.DeleteTowedJammerDecoyOnBoard(2, Towed_Decoy_Instance_Index);

  AfterClose := True;
  UpdateTowedJammerDecoyList;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTowedJammerDecoyList;
  end;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.lbAllTowedJammerDecoyDefClick(Sender: TObject);
begin
  if lbAllTowedJammerDecoyDef.ItemIndex = -1 then
    Exit;
  FSelectedTowedJammerDecoy := TTowed_Jammer_Decoy_On_Board(lbAllTowedJammerDecoyDef.Items.Objects[lbAllTowedJammerDecoyDef.ItemIndex]);
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.lbAllTowedJammerDecoyOnBoardClick(Sender: TObject);
begin
  if lbAllTowedJammerDecoyOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedTowedJammerDecoy := TTowed_Jammer_Decoy_On_Board(lbAllTowedJammerDecoyOnBoard.Items.Objects[lbAllTowedJammerDecoyOnBoard.ItemIndex]);
end;

procedure TfrmTowedJammerDecoyOnBoardPickList.UpdateTowedJammerDecoyList;
var
  i : Integer;
  towedjammerdecoy : TTowed_Jammer_Decoy_On_Board;
begin
  lbAllTowedJammerDecoyDef.Items.Clear;
  lbAllTowedJammerDecoyOnBoard.Items.Clear;

  dmTTT.GetFilterTowedJammerDecoyDef(FAllTowedJammerDecoyDefList, edtSearch.Text);
  dmTTT.GetTowedJammerDecoyOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllTowedJammerDecoyOnBoardList);

  for i := 0 to FAllTowedJammerDecoyDefList.Count - 1 do
  begin
    towedjammerdecoy := FAllTowedJammerDecoyDefList.Items[i];
    lbAllTowedJammerDecoyDef.Items.AddObject(towedjammerdecoy.FDef.Towed_Decoy_Identifier, towedjammerdecoy);
  end;

  for i := 0 to FAllTowedJammerDecoyOnBoardList.Count - 1 do
  begin
    towedjammerdecoy := FAllTowedJammerDecoyOnBoardList.Items[i];
    lbAllTowedJammerDecoyOnBoard.Items.AddObject(towedjammerdecoy.FData.Instance_Identifier, towedjammerdecoy);
  end;
end;

{$ENDREGION}

end.
