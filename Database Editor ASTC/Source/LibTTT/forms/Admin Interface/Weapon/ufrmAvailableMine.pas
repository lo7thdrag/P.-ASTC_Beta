unit ufrmAvailableMine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAsset_Weapon, uSimContainers;

type
  TfrmAvailableMine = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstMine: TListBox;
    pnlTableButton: TPanel;
    btnDelete: TImage;
    btnEdit: TImage;
    btnCopy: TImage;
    btnNew: TImage;
    btnUsage: TImage;
    Label1: TLabel;
    edtSearch: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure btnNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUsageClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);

  private
    FUpdateList : Boolean;
    FMineList : TList;
    FSelectedMine : TMine_On_Board;

    procedure CopyPODvsRange(idMine, targetType: integer);
    procedure UpdateMineList;

  end;

var
  frmAvailableMine: TfrmAvailableMine;

implementation

uses
  uDataModuleTTT, ufrmSummaryMine, ufrmUsage, ufProgress;
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

procedure TfrmAvailableMine.FormCreate(Sender: TObject);
begin
  FMineList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableMine.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FMineList);
end;

procedure TfrmAvailableMine.FormShow(Sender: TObject);
begin
  UpdateMineList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableMine.btnNewClick(Sender: TObject);
begin
  frmSummaryMine := TfrmSummaryMine.Create(Self);
  try
    with frmSummaryMine do
    begin
      SelectedMine := TMine_On_Board.Create;
      ShowModal;
      SelectedMine.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryMine.Free;
  end;

  if FUpdateList then
    UpdateMineList;
end;

procedure TfrmAvailableMine.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
  idTemp : Integer;
begin
  if lstMine.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Mine ... !');
    Exit;
  end;

  with FSelectedMine do
  begin
    newClassName := FMine_Def.Mine_Identifier + ' - Copy';

    count := dmTTT.GetMineDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FMine_Def.Mine_Identifier := newClassName;
    idTemp :=FMine_Def.Mine_Index;

    dmTTT.InsertMineDef(FMine_Def);
    dmTTT.InsertNoteStorage(3, FMine_Def.Mine_Index, FNote);

    {Copy Probability of Detonation Curve}
    CopyPODvsRange(idTemp, 1);

  end;

  UpdateMineList;
end;

procedure TfrmAvailableMine.btnEditClick(Sender: TObject);
begin
  if lstMine.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Mine ... !');
    Exit;
  end;

  frmSummaryMine := TfrmSummaryMine.Create(Self);
  try
    with frmSummaryMine do
    begin
      SelectedMine := FSelectedMine;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryMine.Free;
  end;

  if FUpdateList then
    UpdateMineList;
end;

procedure TfrmAvailableMine.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lstMine.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Mine ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedMine.FMine_Def do
    begin
      tempList := TList.Create;

      {Pengecekan Relasi Dengan Resource Allocation}
      if dmTTT.GetPlatformInstanceAtResourceAllocation(5, Mine_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data resource allocation');
        tempList.Free;
        Exit;
      end;

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetFittedWeaponAtVehicleOnBoard(9, Mine_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      {Catatan : Seharusnya ada tambahan menghapus data di Tabel Mine_POD_vs_Range}
      dmTTT.DeleteMinePODvsRange(1, Mine_Index);

      dmTTT.DeleteNoteStorage(3, Mine_Index);

      if dmTTT.DeleteMineDef(Mine_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateMineList;
  end;
end;

procedure TfrmAvailableMine.btnUsageClick(Sender: TObject);
begin
  if lstMine.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Mine ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedMine.FMine_Def.Mine_Index;
      name_usage := FSelectedMine.FMine_Def.Mine_Identifier;
      usage_title := 'On Board Vehicle:';
      UIndex := 9;

      ShowModal;
    end;

  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableMine.lbSingleClick(Sender: TObject);
begin
  if lstMine.ItemIndex = -1 then
    Exit;

  FSelectedMine := TMine_On_Board(lstMine.Items.Objects[lstMine.ItemIndex]);
end;

procedure TfrmAvailableMine.CopyPODvsRange(idMine, targetType: integer);
var
  newClassName : string;
  count, i : Integer;
  PointList : TList;
  data : TMine_On_Board;

begin
  with FSelectedMine do
  begin
    PointList := TList.Create;

    if dmTTT.GetMinePODvsRange(idMine, targetType, PointList) > 0 then
    begin
      for i := 0 to PointList.Count - 1 do
      begin
        data := PointList.Items[i];
        data.FMine_POD.Mine_Index := FMine_Def.Mine_Index;
        dmTTT.InsertMinePODvsRange(data.FMine_POD)
      end;
    end;
    PointList.Destroy;
  end;
end;

procedure TfrmAvailableMine.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateMineList
  end;
end;

procedure TfrmAvailableMine.UpdateMineList;
var
  i : Integer;
  mine : TMine_On_Board;

begin
  lstMine.Items.Clear;

//  dmTTT.GetAllMineDef(FMineList);
  dmTTT.GetFilterMineDef(FMineList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FMineList.Count;

  for i := 0 to FMineList.Count - 1 do
  begin
    mine := FMineList.Items[i];
    lstMine.Items.AddObject(mine.FMine_Def.Mine_Identifier, mine);
    frmProgress.increase(mine.FMine_Def.Mine_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
