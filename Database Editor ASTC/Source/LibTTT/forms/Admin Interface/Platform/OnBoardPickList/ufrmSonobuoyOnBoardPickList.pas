unit ufrmSonobuoyOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uDBAsset_Vehicle, uDBAsset_Sonobuoy,
  Vcl.Imaging.pngimage, uSimContainers;

type
  TfrmSonobuoyOnBoardPickList = class(TForm)
    shp1: TShape;
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditMount: TButton;
    btnRemove: TButton;
    lbAllSonobuoyDef: TListBox;
    lbAllSonobuoyOnBoard: TListBox;
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

    procedure lbAllSonobuoyDefClick(Sender: TObject);
    procedure lbAllSonobuoyOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditMountClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);


  private
    FAllSonobuoyDefList : TList;
    FAllSonobuoyOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedSonobuoy : TSonobuoy_On_Board;

    procedure UpdateSonobuoyList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmSonobuoyOnBoardPickList: TfrmSonobuoyOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSonobuoyMount;

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

procedure TfrmSonobuoyOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmSonobuoyOnBoardPickList.FormCreate(Sender: TObject);

begin
  FAllSonobuoyDefList     := TList.Create;
  FAllSonobuoyOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSonobuoyOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllSonobuoyDefList);
  FreeItemsAndFreeList(FAllSonobuoyOnBoardList);
end;

procedure TfrmSonobuoyOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateSonobuoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSonobuoyOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllSonobuoyDef.ItemIndex = -1 then
    Exit;

  frmSonobuoyMount := TfrmSonobuoyMount.Create(Self);
  try
    with frmSonobuoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedSonobuoy := FSelectedSonobuoy;
      ShowModal;
    end;
  finally
    frmSonobuoyMount.Free;
  end;

  UpdateSonobuoyList;
end;

procedure TfrmSonobuoyOnBoardPickList.btnEditMountClick(Sender: TObject);
begin
  if lbAllSonobuoyOnBoard.ItemIndex = -1 then
    Exit;

  frmSonobuoyMount := TfrmSonobuoyMount.Create(Self);
  try
    with frmSonobuoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedSonobuoy := FSelectedSonobuoy;
      ShowModal;
    end;
  finally
    frmSonobuoyMount.Free;
  end;

  UpdateSonobuoyList;
end;

procedure TfrmSonobuoyOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllSonobuoyOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedSonobuoy.FData do
  begin
    dmTTT.DeleteSonobuoyOnBoard(2, Sonobuoy_Instance_Index);
  end;

  UpdateSonobuoyList;
end;

procedure TfrmSonobuoyOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSonobuoyList;
  end;
end;

procedure TfrmSonobuoyOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSonobuoyOnBoardPickList.lbAllSonobuoyDefClick(Sender: TObject);
begin
 if lbAllSonobuoyDef.ItemIndex = -1 then
    Exit;
  FSelectedSonobuoy := TSonobuoy_On_Board( lbAllSonobuoyDef.Items.Objects[lbAllSonobuoyDef.ItemIndex]);
end;

procedure TfrmSonobuoyOnBoardPickList.lbAllSonobuoyOnBoardClick(Sender: TObject);
begin
  if lbAllSonobuoyOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedSonobuoy := TSonobuoy_On_Board(lbAllSonobuoyOnBoard.Items.Objects[lbAllSonobuoyOnBoard.ItemIndex]);
end;

procedure TfrmSonobuoyOnBoardPickList.UpdateSonobuoyList;
var
  i : Integer;
  sonobuoy : TSonobuoy_On_Board;
begin
  lbAllSonobuoyDef.Items.Clear;
  lbAllSonobuoyOnBoard.Items.Clear;

  dmTTT.GetFilterSonobuoyDef(FAllSonobuoyDefList, edtSearch.Text);
  dmTTT.GetSonobuoyOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllSonobuoyOnBoardList);

  for i := 0 to FAllSonobuoyDefList.Count - 1 do
  begin
    sonobuoy := FAllSonobuoyDefList.Items[i];
    lbAllSonobuoyDef.Items.AddObject(sonobuoy.FDef.Class_Identifier, sonobuoy);
  end;

  for i := 0 to FAllSonobuoyOnBoardList.Count - 1 do
  begin
    sonobuoy := FAllSonobuoyOnBoardList.Items[i];
    lbAllSonobuoyOnBoard.Items.AddObject(sonobuoy.FData.Instance_Identifier, sonobuoy);
  end;
end;

{$ENDREGION}

 end.
