unit ufrmRadarJammerOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Vehicle, uDBAsset_Countermeasure, uSimContainers,
  Vcl.Imaging.pngimage;

type
  TfrmRadarJammerOnBoardPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    lbAllRadarJammerDef: TListBox;
    lbRadarJammerOnBoard: TListBox;
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

    procedure lbAllRadarJammerDefClick(Sender: TObject);
    procedure lbRadarJammerOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);


  private
    FAllRadarJammerDefList : TList;
    FAllRadarJammerOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedRadarJammer : TJammer_On_Board;

    procedure UpdateRadarJammerList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;
  end;

var
  frmRadarJammerOnBoardPickList: TfrmRadarJammerOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryRadarNoiseJammer, ufrmRadarJammerMount;

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

procedure TfrmRadarJammerOnBoardPickList.FormClose(Sender: TObject;var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TfrmRadarJammerOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllRadarJammerDefList      := TList.Create;
  FAllRadarJammerOnBoardList  := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmRadarJammerOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllRadarJammerDefList);
  FreeItemsAndFreeList(FAllRadarJammerOnBoardList);
end;

procedure TfrmRadarJammerOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateRadarJammerList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmRadarJammerOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllRadarJammerDef.ItemIndex = -1 then
    Exit;

  frmRadarJammerMount := TfrmRadarJammerMount.Create(Self);
  try
    with frmRadarJammerMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedRadarJammer := FSelectedRadarJammer;
      ShowModal;
    end;
  finally
    frmRadarJammerMount.Free;
  end;

  UpdateRadarJammerList;
end;

procedure TfrmRadarJammerOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbRadarJammerOnBoard.ItemIndex = -1 then
    Exit;

  frmRadarJammerMount := TfrmRadarJammerMount.Create(Self);
  try
    with frmRadarJammerMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedRadarJammer := FSelectedRadarJammer;
      ShowModal;
    end;
  finally
    frmRadarJammerMount.Free;
  end;

  UpdateRadarJammerList;
end;

procedure TfrmRadarJammerOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbRadarJammerOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedRadarJammer.FData do
  begin
    dmTTT.DeleteRadarNoiseJammerOnBoard(2, Jammer_Instance_Index);
  end;

  AfterClose := True;
  UpdateRadarJammerList;
end;

procedure TfrmRadarJammerOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateRadarJammerList;
  end;
end;

procedure TfrmRadarJammerOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRadarJammerOnBoardPickList.lbAllRadarJammerDefClick(Sender: TObject);
begin
  if lbAllRadarJammerDef.ItemIndex = -1 then
    Exit;
  FSelectedRadarJammer := TJammer_On_Board(lbAllRadarJammerDef.Items.Objects[lbAllRadarJammerDef.ItemIndex]);
end;

procedure TfrmRadarJammerOnBoardPickList.lbRadarJammerOnBoardClick(Sender: TObject);
begin
  if lbRadarJammerOnBoard.ItemIndex = -1 then
    Exit;
  FSelectedRadarJammer := TJammer_On_Board( lbRadarJammerOnBoard.Items.Objects[lbRadarJammerOnBoard.ItemIndex]);
end;

procedure TfrmRadarJammerOnBoardPickList.UpdateRadarJammerList;
var
  i, j : Integer;
  avaRadarJammer, selRadarJammer : TJammer_On_Board;
  found : Boolean;
begin
  lbAllRadarJammerDef.Items.Clear;
  lbRadarJammerOnBoard.Items.Clear;

  dmTTT.GetFilterRadarNoiseJammerDef(FAllRadarJammerDefList, edtSearch.Text);
  dmTTT.GetRadarNoiseJammerOnBoard(FSelectedVehicle.FData.Vehicle_Index,FAllRadarJammerOnBoardList);

  for i := 0 to FAllRadarJammerDefList.Count - 1 do
  begin
    avaRadarJammer := FAllRadarJammerDefList.Items[i];

    found := False;
    for j := 0 to FAllRadarJammerOnBoardList.Count - 1 do
    begin
      selRadarJammer := FAllRadarJammerOnBoardList.Items[j];

      if selRadarJammer.FDef.Jammer_Index = avaRadarJammer.FDef.Jammer_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbRadarJammerOnBoard.Items.AddObject(
        selRadarJammer.FData.Instance_Identifier, selRadarJammer)
    else
      lbAllRadarJammerDef.Items.AddObject(avaRadarJammer.FDef.Jammer_Identifier,
        avaRadarJammer);
  end;
end;

{$ENDREGION}

end.
