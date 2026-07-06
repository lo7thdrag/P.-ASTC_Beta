unit ufrmInfraredDecoyOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmInfraredDecoyOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditSelected: TButton;
    btnRemove: TButton;
    lbAllInfraredDecoyDef: TListBox;
    lbAllInfraredDecoyOnBoard: TListBox;
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

    procedure lbAllInfraredDecoyDefClick(Sender: TObject);
    procedure lbAllInfraredDecoyOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditSelectedClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllInfraredDecoyDefList : TList;
    FAllInfraredDecoyOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedInfraredDecoy : TInfrared_Decoy_On_Board;

    procedure UpdateInfraredDecoyList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmInfraredDecoyOnBoardPickList: TfrmInfraredDecoyOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryInfraredDecoy, ufrmfIRmount;

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


procedure TfrmInfraredDecoyOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmInfraredDecoyOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllInfraredDecoyDefList     := TList.Create;
  FAllInfraredDecoyOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmInfraredDecoyOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllInfraredDecoyDefList);
  FreeItemsAndFreeList(FAllInfraredDecoyOnBoardList);
end;

procedure TfrmInfraredDecoyOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateInfraredDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmInfraredDecoyOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllInfraredDecoyDef.ItemIndex = -1 then
    Exit;

  frmfIRmount := TfrmfIRmount.Create(Self);
  try
    with frmfIRmount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedInfraredDecoy := FSelectedInfraredDecoy;
      ShowModal;
    end;
  finally
    frmfIRmount.Free;
  end;

  UpdateInfraredDecoyList;
end;

procedure TfrmInfraredDecoyOnBoardPickList.btnEditSelectedClick(Sender: TObject);
begin
  if lbAllInfraredDecoyOnBoard.ItemIndex = -1 then
    Exit;

  frmfIRmount := TfrmfIRmount.Create(Self);
  try
    with frmfIRmount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedInfraredDecoy := FSelectedInfraredDecoy;
      ShowModal;
    end;
  finally
    frmfIRmount.Free;
  end;

  UpdateInfraredDecoyList;
end;

procedure TfrmInfraredDecoyOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllInfraredDecoyOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedInfraredDecoy.FData do
    dmTTT.DeleteInfraredDecoyOnBoard(2, Infrared_Decoy_Instance_Index);

  AfterClose := True;
  UpdateInfraredDecoyList;
end;

procedure TfrmInfraredDecoyOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateInfraredDecoyList;
  end;
end;

procedure TfrmInfraredDecoyOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInfraredDecoyOnBoardPickList.lbAllInfraredDecoyDefClick(Sender: TObject);
begin
  if lbAllInfraredDecoyDef.ItemIndex = -1 then
    Exit;
  FSelectedInfraredDecoy := TInfrared_Decoy_On_Board(lbAllInfraredDecoyDef.Items.Objects[lbAllInfraredDecoyDef.ItemIndex]);
end;

procedure TfrmInfraredDecoyOnBoardPickList.lbAllInfraredDecoyOnBoardClick(Sender: TObject);
begin
  if lbAllInfraredDecoyOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedInfraredDecoy := TInfrared_Decoy_On_Board( lbAllInfraredDecoyOnBoard.Items.Objects[lbAllInfraredDecoyOnBoard.ItemIndex]);
end;

procedure TfrmInfraredDecoyOnBoardPickList.UpdateInfraredDecoyList;
var
  i, j : Integer;
  infrareddecoy, infrareddecoyOnBoard : TInfrared_Decoy_On_Board;
  found : Boolean;
begin
  lbAllInfraredDecoyDef.Items.Clear;
  lbAllInfraredDecoyOnBoard.Items.Clear;

  dmTTT.GetFilterInfraredDecoyDef(FAllInfraredDecoyDefList, edtSearch.Text);
  dmTTT.GetInfraredDecoyOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllInfraredDecoyOnBoardList);

  for i := 0 to FAllInfraredDecoyDefList.Count - 1 do
  begin
    infrareddecoy := FAllInfraredDecoyDefList.Items[i];

    found := False;
    for j := 0 to FAllInfraredDecoyOnBoardList.Count - 1 do
    begin
      infrareddecoyOnBoard := FAllInfraredDecoyOnBoardList.Items[j];

      if infrareddecoyOnBoard.FInfraRedDecoy_Def.Infrared_Decoy_Index = infrareddecoy.FInfraRedDecoy_Def.Infrared_Decoy_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbAllInfraredDecoyOnBoard.Items.AddObject(infrareddecoyOnBoard.FInfraRedDecoy_Def.Infrared_Decoy_Identifier, infrareddecoyOnBoard)
    else
      lbAllInfraredDecoyDef.Items.AddObject(infrareddecoy.FInfraRedDecoy_Def.Infrared_Decoy_Identifier, infrareddecoy);
  end;

end;

{$ENDREGION}

end.
