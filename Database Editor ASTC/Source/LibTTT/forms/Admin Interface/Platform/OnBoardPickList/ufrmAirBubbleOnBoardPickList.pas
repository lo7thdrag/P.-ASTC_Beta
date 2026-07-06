unit ufrmAirBubbleOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmAirBubbleOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAirBubbleOnBoard: TListBox;
    lbAllAirBubbleDef: TListBox;
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

    procedure lbAllAirBubbleDefClick(Sender: TObject);
    procedure lbAirBubbleOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllAirBubbleDefList : TList;
    FAllAirBubbleOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedAirBubble : TAir_Bubble_Mount;

    procedure UpdateAirBubbleList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmAirBubbleOnBoardPickList: TfrmAirBubbleOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryAirBubble, ufrmAirBubblesMounts;

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

procedure TfrmAirBubbleOnBoardPickList.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmAirBubbleOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllAirBubbleDefList      := TList.Create;
  FAllAirBubbleOnBoardList  := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmAirBubbleOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllAirBubbleDefList);
  FreeItemsAndFreeList(FAllAirBubbleOnBoardList);
end;

procedure TfrmAirBubbleOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateAirBubbleList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAirBubbleOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllAirBubbleDef.ItemIndex = -1 then
    Exit;

  frmAirBubblesMounts := TfrmAirBubblesMounts.Create(Self);
  try
    with frmAirBubblesMounts do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedAirBubble := FSelectedAirBubble;
      ShowModal;
    end;
  finally
    frmAirBubblesMounts.Free;
  end;

  UpdateAirBubbleList;
end;

procedure TfrmAirBubbleOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAirBubbleOnBoard.ItemIndex = -1 then
    Exit;

  frmAirBubblesMounts := TfrmAirBubblesMounts.Create(Self);
  try
    with frmAirBubblesMounts do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedAirBubble := FSelectedAirBubble;
      ShowModal;
    end;
  finally
    frmAirBubblesMounts.Free;
  end;

  UpdateAirBubbleList;
end;

procedure TfrmAirBubbleOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAirBubbleOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedAirBubble.FData do
    dmTTT.DeleteAirBubbleOnBoard(2, Air_Bubble_Instance_Index);

  AfterClose := True;
  UpdateAirBubbleList;
end;

procedure TfrmAirBubbleOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateAirBubbleList;
  end;
end;

procedure TfrmAirBubbleOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAirBubbleOnBoardPickList.lbAllAirBubbleDefClick(Sender: TObject);
begin
  if lbAllAirBubbleDef.ItemIndex = -1 then
    Exit;

  FSelectedAirBubble := TAir_Bubble_Mount(lbAllAirBubbleDef.Items.Objects[lbAllAirBubbleDef.ItemIndex]);
end;

procedure TfrmAirBubbleOnBoardPickList.lbAirBubbleOnBoardClick(Sender: TObject);
begin
 if lbAirBubbleOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedAirBubble := TAir_Bubble_Mount( lbAirBubbleOnBoard.Items.Objects[lbAirBubbleOnBoard.ItemIndex]);
end;

procedure TfrmAirBubbleOnBoardPickList.UpdateAirBubbleList;
var
  i, j : Integer;
  avaAirBubble, selAirBubble : TAir_Bubble_Mount;
  found : Boolean;
begin
  lbAllAirBubbleDef.Items.Clear;
  lbAirBubbleOnBoard.Items.Clear;

  dmTTT.GetFilterAirBubbleDef(FAllAirBubbleDefList, edtSearch.Text);
  dmTTT.GetAirBubbleOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllAirBubbleOnBoardList);

  for i := 0 to FAllAirBubbleDefList.Count - 1 do
  begin
    avaAirBubble := FAllAirBubbleDefList.Items[i];

    found := False;
    for j := 0 to FAllAirBubbleOnBoardList.Count - 1 do
    begin
      selAirBubble := FAllAirBubbleOnBoardList.Items[j];

      if selAirBubble.FAirBubble_Def.Air_Bubble_Index = avaAirBubble.
        FAirBubble_Def.Air_Bubble_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbAirBubbleOnBoard.Items.AddObject(selAirBubble.FData.Instance_Identifier,
        selAirBubble)
    else
      lbAllAirBubbleDef.Items.AddObject(
        avaAirBubble.FAirBubble_Def.Air_Bubble_Identifier, avaAirBubble);
  end;
end;

{$ENDREGION}

end.
