unit ufrmFloatingDecoyOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmFloatingDecoyOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEditMount: TButton;
    btnRemove: TButton;
    lbAllFloatingDecoyDef: TListBox;
    lbAllFloatingDecoyOnBoard: TListBox;
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

    procedure lbAllFloatingDecoyDefClick(Sender: TObject);
    procedure lbAllFloatingDecoyOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditMountClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllFloatingDecoyDefList : TList;
    FAllFloatingDecoyOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedFloatingDecoy : TFloating_Decoy_On_Board;

    procedure UpdateFloatingDecoyList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmFloatingDecoyOnBoardPickList: TfrmFloatingDecoyOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryFloatingDecoy, ufrmFloatingMount;

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


procedure TfrmFloatingDecoyOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmFloatingDecoyOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllFloatingDecoyDefList      := TList.Create;
  FAllFloatingDecoyOnBoardList  := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmFloatingDecoyOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllFloatingDecoyDefList);
  FreeItemsAndFreeList(FAllFloatingDecoyOnBoardList);
end;

procedure TfrmFloatingDecoyOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateFloatingDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmFloatingDecoyOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllFloatingDecoyDef.ItemIndex = -1 then
    Exit;

  frmFloatingMount := TfrmFloatingMount.Create(Self);
  try
    with frmFloatingMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedFloatingDecoy := FSelectedFloatingDecoy;
      ShowModal;
    end;
  finally
    frmFloatingMount.Free;
  end;

  UpdateFloatingDecoyList;
end;

procedure TfrmFloatingDecoyOnBoardPickList.btnEditMountClick(Sender: TObject);
begin
  if lbAllFloatingDecoyOnBoard.ItemIndex = -1 then
    Exit;

  frmFloatingMount := TfrmFloatingMount.Create(Self);
  try
    with frmFloatingMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedFloatingDecoy := FSelectedFloatingDecoy;
      ShowModal;
    end;
  finally
    frmFloatingMount.Free;
  end;

  UpdateFloatingDecoyList;
end;

procedure TfrmFloatingDecoyOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllFloatingDecoyOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedFloatingDecoy.FData do
    dmTTT.DeleteFloatingDecoyOnBoard(2, Floating_Decoy_Instance_Index);

  AfterClose := True;
  UpdateFloatingDecoyList;
end;

procedure TfrmFloatingDecoyOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateFloatingDecoyList;
  end;
end;

procedure TfrmFloatingDecoyOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFloatingDecoyOnBoardPickList.lbAllFloatingDecoyDefClick(Sender: TObject);
begin
  if lbAllFloatingDecoyDef.ItemIndex = -1 then
    Exit;
  FSelectedFloatingDecoy := TFloating_Decoy_On_Board( lbAllFloatingDecoyDef.Items.Objects[lbAllFloatingDecoyDef.ItemIndex]);
end;

procedure TfrmFloatingDecoyOnBoardPickList.lbAllFloatingDecoyOnBoardClick(Sender: TObject);
begin
  if lbAllFloatingDecoyOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedFloatingDecoy := TFloating_Decoy_On_Board(lbAllFloatingDecoyOnBoard.Items.Objects[lbAllFloatingDecoyOnBoard.ItemIndex]);
end;

procedure TfrmFloatingDecoyOnBoardPickList.UpdateFloatingDecoyList;
var
  i : Integer;
  floatingdecoy : TFloating_Decoy_On_Board;
begin
  lbAllFloatingDecoyDef.Items.Clear;
  lbAllFloatingDecoyOnBoard.Items.Clear;

  dmTTT.GetFilterFloatingDecoyDef(FAllFloatingDecoyDefList, edtSearch.Text);
  dmTTT.GetFloatingDecoyOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllFloatingDecoyOnBoardList);

  for i := 0 to FAllFloatingDecoyDefList.Count - 1 do
  begin
    floatingdecoy := FAllFloatingDecoyDefList.Items[i];
    lbAllFloatingDecoyDef.Items.AddObject(floatingdecoy.FFloatingDecoy_Def.Floating_Decoy_Identifier, floatingdecoy);
  end;

  for i := 0 to FAllFloatingDecoyOnBoardList.Count - 1 do
  begin
    floatingdecoy := FAllFloatingDecoyOnBoardList.Items[i];
    lbAllFloatingDecoyOnBoard.Items.AddObject(floatingdecoy.FData.Instance_Identifier, floatingdecoy);
  end;
end;

{$ENDREGION}

end.
