unit ufrmIFFOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uDBAsset_Vehicle, uDBAsset_Sensor,
  Vcl.Imaging.pngimage, uSimContainers;

type
  TfrmIFFOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAllIFFDef: TListBox;
    lbAllIFFOnBoard: TListBox;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAllIFFDefClick(Sender: TObject);
    procedure lbAllIFFOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);


  private
    FAllIFFDefList : TList;
    FAllIFFOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedIFF, FDummyIFF : TIFF_Sensor_On_Board;

    procedure UpdateIFFList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmIFFOnBoardPickList: TfrmIFFOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmIFFMount;

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

procedure TfrmIFFOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllIFFDefList := TList.Create;
  FAllIFFOnBoardList := TList.Create;

  FDummyIFF := TIFF_Sensor_On_Board.Create;
  FDummyIFF.FData.Instance_Identifier := 'IFF';

  EnableComposited(pnlMainBackground);
end;

procedure TfrmIFFOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllIFFDefList);
  FreeItemsAndFreeList(FAllIFFOnBoardList);

  FDummyIFF.Free;
end;

procedure TfrmIFFOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateIFFList;
end;


{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmIFFOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllIFFDef.ItemIndex = -1 then
    Exit;

  frmIFFMount := TfrmIFFMount.Create(Self);
  try
    with frmIFFMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedIFF := FSelectedIFF;
      ShowModal;
    end;
  finally
    frmIFFMount.Free;
  end;

  UpdateIFFList;
end;

procedure TfrmIFFOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllIFFOnBoard.ItemIndex = -1 then
    Exit;

  frmIFFMount := TfrmIFFMount.Create(Self);
  try
    with frmIFFMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedIFF := FSelectedIFF;
      ShowModal;
    end;
    AfterClose := frmIFFMount.AfterClose;
  finally
    frmIFFMount.Free;
  end;

  UpdateIFFList;
end;

procedure TfrmIFFOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllIFFOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedIFF.FData do
  begin
    dmTTT.DeleteIFFOnBoard(2, IFF_Instance_Index);
  end;

  UpdateIFFList;

  AfterClose := True;
end;

procedure TfrmIFFOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateIFFList;
  end;
end;

procedure TfrmIFFOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmIFFOnBoardPickList.lbAllIFFDefClick(Sender: TObject);
begin
  if lbAllIFFDef.ItemIndex = -1 then
    Exit;

  FSelectedIFF := TIFF_Sensor_On_Board(lbAllIFFDef.Items.Objects[lbAllIFFDef.ItemIndex]);
end;

procedure TfrmIFFOnBoardPickList.lbAllIFFOnBoardClick(Sender: TObject);
begin
  if lbAllIFFOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedIFF := TIFF_Sensor_On_Board(lbAllIFFOnBoard.Items.Objects[lbAllIFFOnBoard.ItemIndex]);
end;

procedure TfrmIFFOnBoardPickList.UpdateIFFList;
var
  i : Integer;
  iff : TIFF_Sensor_On_Board;
begin
  lbAllIFFDef.Items.Clear;
  lbAllIFFOnBoard.Items.Clear;

  dmTTT.GetIFFOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllIFFOnBoardList);

  if FAllIFFOnBoardList.Count = 0 then
  begin
    lbAllIFFDef.Items.AddObject(FDummyIFF.FData.Instance_Identifier, FDummyIFF);
  end;

  for i := 0 to FAllIFFOnBoardList.Count - 1 do
  begin
    iff := FAllIFFOnBoardList.Items[i];
    lbAllIFFOnBoard.Items.AddObject(iff.FData.Instance_Identifier, iff);
  end;
end;

{$ENDREGION}

end.
