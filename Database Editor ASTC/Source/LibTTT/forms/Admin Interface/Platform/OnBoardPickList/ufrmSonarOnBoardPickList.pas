unit ufrmSonarOnBoardPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage,
  uDBAsset_Vehicle, uDBAsset_Sonar, uSimContainers;

type
//  E_SonarSelectCaller = (sscVehicleAssets, sscSonobuoy);

  TfrmSonarOnBoardPickList = class(TForm)
    shp1: TShape;
    pnlMain: TPanel;
    lbAllSonarDef: TListBox;
    lbAllSonarOnBoard: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    btnEditMount: TButton;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    btnClose: TButton;
    lbl1: TLabel;
    edtSearch: TEdit;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAllSonarDefClick(Sender: TObject);
    procedure lbAllSonarOnBoardClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FAllSonarDefList : TList;
    FAllSonarOnBoardList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedSonar : TSonar_On_Board;

    procedure UpdateSonarList;

  public
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, btn Cancel di summary menyala}
    property SelectedVehicle : TVehicle_Definition read FSelectedVehicle write FSelectedVehicle;

  end;

var
  frmSonarOnBoardPickList: TfrmSonarOnBoardPickList;

implementation

uses
  uDataModuleTTT, ufrmSonarMount, tttData;

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

procedure TfrmSonarOnBoardPickList.FormCreate(Sender: TObject);
begin
  FAllSonarDefList     := TList.Create;
  FAllSonarOnBoardList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSonarOnBoardPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FAllSonarDefList);
  FreeItemsAndFreeList(FAllSonarOnBoardList);
end;

procedure TfrmSonarOnBoardPickList.FormShow(Sender: TObject);
begin
  UpdateSonarList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSonarOnBoardPickList.btnAddClick(Sender: TObject);
begin
  if lbAllSonarDef.ItemIndex = -1 then
    Exit;

  frmSonarMount := TfrmSonarMount.Create(Self);
  try
    with frmSonarMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedSonar := FSelectedSonar;
      ShowModal;
    end;
    AfterClose := frmSonarMount.AfterClose;
  finally
    frmSonarMount.Free;
  end;

  UpdateSonarList;
end;

procedure TfrmSonarOnBoardPickList.btnEditClick(Sender: TObject);
begin
  if lbAllSonarOnBoard.ItemIndex = -1 then
    Exit;

  frmSonarMount := TfrmSonarMount.Create(Self);
  try
    with frmSonarMount do
    begin
      SelectedVehicle := FSelectedVehicle;
      SelectedSonar := FSelectedSonar;
      ShowModal;
    end;
    AfterClose := frmSonarMount.AfterClose;
  finally
    frmSonarMount.Free;
  end;

  UpdateSonarList;
end;

procedure TfrmSonarOnBoardPickList.btnRemoveClick(Sender: TObject);
begin
  if lbAllSonarOnBoard.ItemIndex = -1 then
    Exit;

  with FSelectedSonar.FData do
  begin
    dmTTT.DeleteBlindZone(Ord(bzcSonar), Sonar_Instance_Index);
    dmTTT.DeleteSonarOnBoard(2, Sonar_Instance_Index);
  end;

  UpdateSonarList;
end;

procedure TfrmSonarOnBoardPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSonarList;
  end;
end;

procedure TfrmSonarOnBoardPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSonarOnBoardPickList.lbAllSonarDefClick(Sender: TObject);
begin
  if lbAllSonarDef.ItemIndex = -1 then
    Exit;

  FSelectedSonar := TSonar_On_Board(lbAllSonarDef.Items.Objects[lbAllSonarDef.ItemIndex]);
end;

procedure TfrmSonarOnBoardPickList.lbAllSonarOnBoardClick(Sender: TObject);
begin
  if lbAllSonarOnBoard.ItemIndex = -1 then
    Exit;

  FSelectedSonar := TSonar_On_Board(lbAllSonarOnBoard.Items.Objects[lbAllSonarOnBoard.ItemIndex]);
end;

procedure TfrmSonarOnBoardPickList.UpdateSonarList;
var
  i : Integer;
  sonar : TSonar_On_Board;
begin
  lbAllSonarDef.Items.Clear;
  lbAllSonarOnBoard.Items.Clear;

  dmTTT.GetFilterSonarDef(FAllSonarDefList, edtSearch.Text);
  dmTTT.GetSonarOnBoard(FSelectedVehicle.FData.Vehicle_Index, FAllSonarOnBoardList);

  for i := 0 to FAllSonarDefList.Count - 1 do
  begin
    sonar := FAllSonarDefList.Items[i];
    lbAllSonarDef.Items.AddObject(sonar.FDef.Sonar_Identifier, sonar);
  end;

  for i := 0 to FAllSonarOnBoardList.Count - 1 do
  begin
    sonar := FAllSonarOnBoardList.Items[i];
    lbAllSonarOnBoard.Items.AddObject(sonar.FData.Instance_Identifier, sonar);
  end;
end;

{$ENDREGION}

end.
