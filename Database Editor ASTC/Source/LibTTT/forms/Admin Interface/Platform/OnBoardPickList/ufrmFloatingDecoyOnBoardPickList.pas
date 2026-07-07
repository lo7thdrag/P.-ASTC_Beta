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
  uDataModuleTTT, ufrmSummaryFloatingDecoy, ufrmFloatingDecoyMount;

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

  frmFloatingDecoyMount := TfrmFloatingDecoyMount.Create(Self);
  try
    with frmFloatingDecoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedFloatingDecoy := FSelectedFloatingDecoy;
      ShowModal;
    end;
  finally
    frmFloatingDecoyMount.Free;
  end;

  UpdateFloatingDecoyList;
end;

procedure TfrmFloatingDecoyOnBoardPickList.btnEditMountClick(Sender: TObject);
begin
  if lbAllFloatingDecoyOnBoard.ItemIndex = -1 then
    Exit;

  frmFloatingDecoyMount := TfrmFloatingDecoyMount.Create(Self);
  try
    with frmFloatingDecoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedFloatingDecoy := FSelectedFloatingDecoy;
      ShowModal;
    end;
  finally
    frmFloatingDecoyMount.Free;
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

procedure TfrmFloatingDecoyOnBoardPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
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
  i, j : Integer;
  floatingdecoy, floatingdecoyonboard : TFloating_Decoy_On_Board;
  found : Boolean;

begin
  lbAllFloatingDecoyDef.Items.Clear;
  lbAllFloatingDecoyOnBoard.Items.Clear;

  dmTTT.GetFilterFloatingDecoyDef(FAllFloatingDecoyDefList, edtSearch.Text);
  dmTTT.GetFloatingDecoyOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllFloatingDecoyOnBoardList);

  {$REGION ' Print Available '}
  for i := 0 to FAllFloatingDecoyDefList.Count - 1 do
  begin
    floatingdecoy := FAllFloatingDecoyDefList.Items[i];

    found := False;
    for j := 0 to FAllFloatingDecoyOnBoardList.Count - 1 do
    begin
      floatingdecoyonboard := FAllFloatingDecoyDefList.Items[j];

      if floatingdecoyonboard.FFloatingDecoy_Def.Floating_Decoy_Index = floatingdecoy.FFloatingDecoy_Def.Floating_Decoy_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if not found then
      lbAllFloatingDecoyDef.Items.AddObject(floatingdecoy.FFloatingDecoy_Def.Floating_Decoy_Identifier, floatingdecoy);

  end;
  {$ENDREGION}

  {$REGION ' Print Onboard '}
  for j := 0 to FAllFloatingDecoyOnBoardList.Count - 1 do
  begin
    floatingdecoyonboard := FAllFloatingDecoyOnBoardList.Items[j];
    lbAllFloatingDecoyOnBoard.Items.AddObject(floatingdecoyonboard.FFloatingDecoy_Def.Floating_Decoy_Identifier, floatingdecoyonboard)
  end;
  {$ENDREGION}

end;

{$ENDREGION}

end.
