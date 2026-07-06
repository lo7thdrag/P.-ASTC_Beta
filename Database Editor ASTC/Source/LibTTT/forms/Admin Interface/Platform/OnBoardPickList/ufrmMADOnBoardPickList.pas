unit ufrmMADOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uDBAsset_Vehicle, uDBAsset_Sensor,
  Vcl.Imaging.pngimage, uSimContainers;

type
  TfrmMADOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAllMADDef: TListBox;
    lbAllMADOnBoard: TListBox;
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

    procedure lbAllMADDefClick(Sender: TObject);
    procedure lbAllMADOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);


  private
    FAllMADDefList : TList;
    FAllMADOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedMAD : TMAD_On_Board;

    procedure UpdateMADList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmMADOnBoardPickList: TfrmMADOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmMADMount;

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

procedure TfrmMADOnBoardPickList.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmMADOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllMADDefList := TList.Create;
  FAllMADOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmMADOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllMADDefList);
  FreeItemsAndFreeList(FAllMADOnBoardList);
end;

procedure TfrmMADOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateMADList;
end;


{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmMADOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllMADDef.ItemIndex = -1 then
    Exit;

  frmMADMount := TfrmMADMount.Create(Self);
  try
    with frmMADMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedMAD := FSelectedMAD;
      ShowModal;
    end;
  finally
    frmMADMount.Free;
  end;

  UpdateMADList;
end;

 procedure TfrmMADOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllMADOnBoard.ItemIndex = -1 then
    Exit;

  frmMADMount := TfrmMADMount.Create(Self);
  try
    with frmMADMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedMAD := FSelectedMAD;
      ShowModal;
    end;
  finally
    frmMADMount.Free;
  end;

  UpdateMADList;
end;

 procedure TfrmMADOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllMADOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedMAD.FData do
  begin
    dmTTT.DeleteMADOnBoard(2, MAD_Instance_Index);
  end;

  UpdateMADList;
end;

procedure TfrmMADOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateMADList;
  end;
end;

procedure TfrmMADOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMADOnBoardPickList.lbAllMADDefClick(Sender: TObject);
begin
  if lbAllMADDef.ItemIndex = -1 then
    Exit;

  FSelectedMAD := TMAD_On_Board( lbAllMADDef.Items.Objects[lbAllMADDef.ItemIndex]);
end;

procedure TfrmMADOnBoardPickList.lbAllMADOnBoardClick(Sender: TObject);
begin
  if lbAllMADOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedMAD := TMAD_On_Board( lbAllMADOnBoard.Items.Objects[lbAllMADOnBoard.ItemIndex]);
end;

procedure TfrmMADOnBoardPickList.UpdateMADList;
var
  i : Integer;
  MAD, madSel : TMAD_On_Board;
begin
  lbAllMADDef.Items.Clear;
  lbAllMADOnBoard.Items.Clear;

  dmTTT.GetFilterMADDef(FAllMADDefList, edtSearch.Text);
  dmTTT.GetMADOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllMADOnBoardList);

  for i := 0 to FAllMADDefList.Count - 1 do
  begin
    MAD := FAllMADDefList.Items[i];
    lbAllMADDef.Items.AddObject(MAD.FMAD_Def.Class_Identifier, MAD);
  end;

  for i := 0 to FAllMADOnBoardList.Count - 1 do
  begin
    MAD := FAllMADOnBoardList.Items[i];
    lbAllMADOnBoard.Items.AddObject(MAD.FMAD_Def.Class_Identifier, MAD);
  end;

end;

{$ENDREGION}

end.

