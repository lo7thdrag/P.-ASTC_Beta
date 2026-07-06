unit ufrmRadarOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage,
  uDBAsset_Vehicle, uDBAsset_Radar, uSimContainers;

type
  TfrmRadarOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditMount: TButton;
    btnRemove: TButton;
    lbAllRadarDef: TListBox;
    lbAllRadarOnBoard: TListBox;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    lbl1: TLabel;
    edtSearch: TEdit;
    btnClose: TButton;
    pnl5: TPanel;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAllRadarDefClick(Sender: TObject);
    procedure lbAllRadarOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllRadarDefList : TList;
    FAllRadarOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedRadar : TRadar_On_Board;

    procedure UpdateRadarList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmRadarOnBoardPickList: TfrmRadarOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmRadarMount, tttData;

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

procedure TfrmRadarOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllRadarDefList      := TList.Create;
  FAllRadarOnBoardList  := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmRadarOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllRadarDefList);
  FreeItemsAndFreeList(FAllRadarOnBoardList);
end;

procedure TfrmRadarOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateRadarList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmRadarOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllRadarDef.ItemIndex = -1 then
    Exit;

  frmRadarMount := TfrmRadarMount.Create(Self);
  try
    with frmRadarMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedRadar := FSelectedRadar;
      ShowModal;
    end;
  finally
    frmRadarMount.Free;
  end;
  UpdateRadarList;
end;

procedure TfrmRadarOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllRadarOnBoard.ItemIndex = -1 then
    Exit;

  frmRadarMount := TfrmRadarMount.Create(Self);
  try
    with frmRadarMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedRadar := FSelectedRadar;
      ShowModal;
    end;
    AfterClose := frmRadarMount.AfterClose;
  finally
    frmRadarMount.Free;
  end;

  UpdateRadarList;
end;

procedure TfrmRadarOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllRadarOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedRadar.FData do
  begin
    dmTTT.DeleteBlindZone(Ord(bzcRadar), Radar_Instance_Index);
    dmTTT.DeleteRadarOnBoard(2, Radar_Instance_Index);
  end;

  UpdateRadarList;
end;

procedure TfrmRadarOnBoardPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateRadarList;
  end;
end;

procedure TfrmRadarOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRadarOnBoardPickList.lbAllRadarDefClick(Sender: TObject);
begin
  if lbAllRadarDef.ItemIndex = -1 then
    Exit;

  FSelectedRadar := TRadar_On_Board(lbAllRadarDef.Items.Objects[lbAllRadarDef.ItemIndex]);
end;

procedure TfrmRadarOnBoardPickList.lbAllRadarOnBoardClick(Sender: TObject);
begin
  if lbAllRadarOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedRadar := TRadar_On_Board(lbAllRadarOnBoard.Items.Objects[lbAllRadarOnBoard.ItemIndex]);
end;

procedure TfrmRadarOnBoardPickList.UpdateRadarList;
var
  i : Integer;
  radar : TRadar_On_Board;
begin
  lbAllRadarDef.Items.Clear;
  lbAllRadarOnBoard.Items.Clear;

  dmTTT.GetFilterRadarDef(FAllRadarDefList, edtSearch.Text);
  dmTTT.GetRadarOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllRadarOnBoardList);

  for i := 0 to FAllRadarDefList.Count - 1 do
  begin
    radar := FAllRadarDefList.Items[i];
    lbAllRadarDef.Items.AddObject(radar.FDef.Radar_Identifier, radar);
  end;

  for i := 0 to FAllRadarOnBoardList.Count - 1 do
  begin
    radar := FAllRadarOnBoardList.Items[i];
    lbAllRadarOnBoard.Items.AddObject(radar.FData.Instance_Identifier, radar);
  end;
end;

{$ENDREGION}

end.
