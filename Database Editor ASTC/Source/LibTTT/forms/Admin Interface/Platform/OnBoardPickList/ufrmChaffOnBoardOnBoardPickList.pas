unit ufrmChaffOnBoardOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmChaffOnBoardOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditMount: TButton;
    btnRemove: TButton;
    lbAllChaffDef: TListBox;
    lbAllChaffOnBoard: TListBox;
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

    procedure lbAllChaffDefClick(Sender: TObject);
    procedure lbAllChaffOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditMountClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllChaffDefList : TList;
    FAllChaffOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedChaff : TChaff_On_Board;

    procedure UpdateChaffList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmChaffOnBoardOnBoardPickList: TfrmChaffOnBoardOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryChaff, ufrmChaffMount, uChaffAssets;

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


procedure TfrmChaffOnBoardOnBoardPickList.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmChaffOnBoardOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllChaffDefList     := TList.Create;
  FAllChaffOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmChaffOnBoardOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllChaffDefList);
  FreeItemsAndFreeList(FAllChaffOnBoardList);
end;

procedure TfrmChaffOnBoardOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateChaffList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmChaffOnBoardOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllChaffDef.ItemIndex = -1 then
    Exit;

  frmChaffMountForm := TfrmChaffMountForm.Create(Self);
  try
    with frmChaffMountForm do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedChaff := FSelectedChaff;
      ShowModal;
    end;
  finally
    frmChaffMountForm.Free;
  end;

  UpdateChaffList;
end;

procedure TfrmChaffOnBoardOnBoardPickList.btnEditMountClick(Sender: TObject);
begin
  if lbAllChaffOnBoard.ItemIndex = -1 then
    Exit;

  frmChaffMountForm := TfrmChaffMountForm.Create(Self);
  try
    with frmChaffMountForm do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedChaff := FSelectedChaff;
      ShowModal;
    end;
  finally
    frmChaffMountForm.Free;
  end;

  UpdateChaffList;
end;

procedure TfrmChaffOnBoardOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllChaffOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedChaff.FData do
    dmTTT.DeleteChaffOnBoard(2, Chaff_Instance_Index);

  AfterClose := True;
  UpdateChaffList;
end;

procedure TfrmChaffOnBoardOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateChaffList;
  end;
end;

procedure TfrmChaffOnBoardOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChaffOnBoardOnBoardPickList.lbAllChaffDefClick(Sender: TObject);
begin
  if lbAllChaffDef.ItemIndex = -1 then
    Exit;
  FSelectedChaff := TChaff_On_Board( lbAllChaffDef.Items.Objects[lbAllChaffDef.ItemIndex]);
end;

procedure TfrmChaffOnBoardOnBoardPickList.lbAllChaffOnBoardClick(Sender: TObject);
begin
  if lbAllChaffOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedChaff := TChaff_On_Board(lbAllChaffOnBoard.Items.Objects[lbAllChaffOnBoard.ItemIndex]);
end;

procedure TfrmChaffOnBoardOnBoardPickList.UpdateChaffList;
var
  i, j : Integer;
  chaff, chaffOnBoard : TChaff_On_Board;
  found : Boolean;

begin
  lbAllChaffDef.Items.Clear;
  lbAllChaffOnBoard.Items.Clear;

  dmTTT.GetFilterChaffDef(FAllChaffDefList, edtSearch.Text);
  dmTTT.GetChaffOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllChaffOnBoardList);

  for i := 0 to FAllChaffDefList.Count - 1 do
  begin
    chaff := FAllChaffDefList.Items[i];

    found := False;
    for j := 0 to FAllChaffOnBoardList.Count - 1 do
    begin
      chaffOnBoard := FAllChaffOnBoardList.Items[j];

      if chaffOnBoard.FChaff_Def.Chaff_Index = chaff.FChaff_Def.Chaff_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbAllChaffOnBoard.Items.AddObject(chaffOnBoard.FChaff_Def.Chaff_Identifier, chaffOnBoard)
    else
      lbAllChaffDef.Items.AddObject(chaff.FChaff_Def.Chaff_Identifier, chaff);
  end;

end;

{$ENDREGION}

end.
