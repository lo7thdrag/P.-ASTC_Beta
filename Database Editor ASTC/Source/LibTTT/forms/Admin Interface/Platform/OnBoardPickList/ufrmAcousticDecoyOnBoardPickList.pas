unit ufrmAcousticDecoyOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmAcousticDecoyOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAllAcousticDecoyOnBoard: TListBox;
    lbAllAcousticDecoyDef: TListBox;
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

    procedure lbAllAcousticDecoyDefClick(Sender: TObject);
    procedure lbAllAcousticDecoyOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);


  private
    FAllAcousticDecoyDefList : TList;
    FAllAcousticDecoyOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedAcousticDecoy : TAcoustic_Decoy_On_Board;

    procedure UpdateAcousticDecoyList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmAcousticDecoyOnBoardPickList: TfrmAcousticDecoyOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryAcousticDecoy, ufrmAcousticDecoyMount;

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


procedure TfrmAcousticDecoyOnBoardPickList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmAcousticDecoyOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllAcousticDecoyDefList     := TList.Create;
  FAllAcousticDecoyOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmAcousticDecoyOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllAcousticDecoyDefList);
  FreeItemsAndFreeList(FAllAcousticDecoyOnBoardList);
end;

procedure TfrmAcousticDecoyOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateAcousticDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAcousticDecoyOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllAcousticDecoyDef.ItemIndex = -1 then
    Exit;

  frmAcousticDecoyMount := TfrmAcousticDecoyMount.Create(Self);
  try
    with frmAcousticDecoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedAcousticDecoy := FSelectedAcousticDecoy;
      ShowModal;
    end;
  finally
    frmAcousticDecoyMount.Free;
  end;

  UpdateAcousticDecoyList;
end;

procedure TfrmAcousticDecoyOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllAcousticDecoyOnBoard.ItemIndex = -1 then
    Exit;

  frmAcousticDecoyMount := TfrmAcousticDecoyMount.Create(Self);
  try
    with frmAcousticDecoyMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedAcousticDecoy := FSelectedAcousticDecoy;
      ShowModal;
    end;
  finally
    frmAcousticDecoyMount.Free;
  end;

  UpdateAcousticDecoyList;
end;

procedure TfrmAcousticDecoyOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllAcousticDecoyOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedAcousticDecoy.FData do
  begin
    dmTTT.DeleteAcousticDecoyOnBoard(2, Acoustic_Instance_Index);
  end;

  AfterClose := True;
  UpdateAcousticDecoyList;
end;

procedure TfrmAcousticDecoyOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateAcousticDecoyList;
  end;
end;

procedure TfrmAcousticDecoyOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAcousticDecoyOnBoardPickList.lbAllAcousticDecoyDefClick(Sender: TObject);
begin
  if lbAllAcousticDecoyDef.ItemIndex = -1 then
    Exit;

  FSelectedAcousticDecoy := TAcoustic_Decoy_On_Board(lbAllAcousticDecoyDef.Items.Objects[lbAllAcousticDecoyDef.ItemIndex]);
end;

procedure TfrmAcousticDecoyOnBoardPickList.lbAllAcousticDecoyOnBoardClick(Sender: TObject);
begin
  if lbAllAcousticDecoyOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedAcousticDecoy := TAcoustic_Decoy_On_Board(lbAllAcousticDecoyOnBoard.Items.Objects[lbAllAcousticDecoyOnBoard.ItemIndex]);
end;

procedure TfrmAcousticDecoyOnBoardPickList.UpdateAcousticDecoyList;
var
  i, j : Integer;
  acousticdecoy, acousticdecoyonboard : TAcoustic_Decoy_On_Board;
  found : Boolean;

begin
  lbAllAcousticDecoyDef.Items.Clear;
  lbAllAcousticDecoyOnBoard.Items.Clear;

  dmTTT.GetFilterAcousticDecoyDef(FAllAcousticDecoyDefList, edtSearch.Text);
  dmTTT.GetAcousticDecoyOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllAcousticDecoyOnBoardList);

  for i := 0 to FAllAcousticDecoyDefList.Count - 1 do
  begin
    acousticdecoy := FAllAcousticDecoyDefList.Items[i];

    found := False;
    for j := 0 to FAllAcousticDecoyOnBoardList.Count - 1 do
    begin
      acousticdecoyonboard := FAllAcousticDecoyOnBoardList.Items[j];

      if acousticdecoyonboard.FAccousticDecoy_Def.Decoy_Index = acousticdecoy.FAccousticDecoy_Def.Decoy_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbAllAcousticDecoyOnBoard.Items.AddObject(acousticdecoyonboard.FAccousticDecoy_Def.Decoy_Identifier, acousticdecoyonboard)
    else
      lbAllAcousticDecoyDef.Items.AddObject(acousticdecoy.FAccousticDecoy_Def.Decoy_Identifier, acousticdecoy);
  end;
end;


{$ENDREGION}

end.
