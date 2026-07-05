unit ufrmAvailableBomb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Weapon, uSimContainers;

type
  TfrmAvailableBomb = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstBomb: TListBox;
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
    FBombList : TList;
    FSelectedBomb : TBomb_Definition;

    procedure CopyProbabilityOfHit(idBomb, targetType : integer);
    procedure UpdateBombList;

  end;

var
  frmAvailableBomb: TfrmAvailableBomb;

implementation

uses
  uDataModuleTTT, ufrmSummaryBomb, ufrmUsage, ufProgress;

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

procedure TfrmAvailableBomb.FormCreate(Sender: TObject);
begin
  FBombList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableBomb.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FBombList);
end;

procedure TfrmAvailableBomb.FormShow(Sender: TObject);
begin
  UpdateBombList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableBomb.btnNewClick(Sender: TObject);
begin
  frmSummaryBomb := TfrmSummaryBomb.Create(Self);
  try
    with frmSummaryBomb do
    begin
      SelectedBomb := TBomb_Definition.Create;
      ShowModal;
      SelectedBomb.Free;

      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryBomb.Free;
  end;

  if FUpdateList then
    UpdateBombList;
end;

procedure TfrmAvailableBomb.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
  idTemp : Integer;

begin
  if lstBomb.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Bomb ... !');
    Exit;
  end;

  with FSelectedBomb do
  begin
    newClassName := FData.Bomb_Identifier + ' - Copy';

    count := dmTTT.GetBombDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Bomb_Identifier := newClassName;
    idTemp :=FData.Bomb_Index;

    dmTTT.InsertBombDef(FData);
    dmTTT.InsertNoteStorage(14, FData.Bomb_Index, FNote);

    {Copy Probability Of Hit}
    CopyProbabilityOfHit(idTemp, 1);
  end;

  UpdateBombList;
end;

procedure TfrmAvailableBomb.btnEditClick(Sender: TObject);
begin
  if lstBomb.ItemIndex = -1 then
    Exit;

  frmSummaryBomb := TfrmSummaryBomb.Create(Self);
  try
    with frmSummaryBomb do
    begin
      SelectedBomb := FSelectedBomb;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryBomb.Free;
  end;

  if FUpdateList then
    UpdateBombList;
end;

procedure TfrmAvailableBomb.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lstBomb.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Bomb ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedBomb.FData do
    begin
      tempList := TList.Create;

      if dmTTT.GetPointEffectAtVehicleOnBoard(11, Bomb_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      {Catatan : Seharusnya ada tambahan menghapus data di Tabel Gun_POH_vs_Range}
      dmTTT.DeleteBombPOHvsRange(1, Bomb_Index);

      dmTTT.DeleteNoteStorage(14, Bomb_Index);

      if dmTTT.DeleteBOmbDef(Bomb_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateBombList;
  end;
end;

procedure TfrmAvailableBomb.btnUsageClick(Sender: TObject);
begin
  if lstBomb.ItemIndex = -1 then
    Exit;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedBomb.FData.Bomb_Index;
      name_usage := FSelectedBomb.FData.Bomb_Identifier;
      usage_title := 'On Board Vehicle:';
      UIndex := 11;

      ShowModal;
    end;

  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableBomb.CopyProbabilityOfHit(idBomb, targetType: integer);
var
  i : Integer;
  PointList : TList;
  data : TBomb_Definition;

begin
  with FSelectedBomb do
  begin
    PointList := TList.Create;

    if dmTTT.GetBombPOHvsRange(idBomb, targetType, PointList) > 0 then
    begin
      for i := 0 to PointList.Count - 1 do
      begin
        data := PointList.Items[i];
        data.FBomb_POH.Bomb_Index := FData.Bomb_Index;
        dmTTT.InsertBombPOHvsRange(data.FBomb_POH)
      end;
    end;

    PointList.Destroy;
  end;
end;

procedure TfrmAvailableBomb.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateBombList
  end;
end;

procedure TfrmAvailableBomb.lbSingleClick(Sender: TObject);
begin
  if lstBomb.ItemIndex = -1 then
    Exit;

  FSelectedBomb := TBomb_Definition(lstBomb.Items.Objects[lstBomb.ItemIndex]);
end;

procedure TfrmAvailableBomb.UpdateBombList;
var
  i : Integer;
  bomb : TBomb_Definition;

begin
  lstBomb.Items.Clear;

//  dmTTT.GetAllBombDef(FBombList);
  dmTTT.GetFilterBombDef(FBombList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FBombList.Count;

  for i := 0 to FBombList.Count - 1 do
  begin
    bomb := FBombList.Items[i];
    lstBomb.Items.AddObject(bomb.FData.Bomb_Identifier, bomb);
    frmProgress.increase(bomb.FData.Bomb_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
