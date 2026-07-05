unit ufrmAvailableSonar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Sonar, uSimContainers;

type
  TfrmAvailableSonar = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lbSonar: TListBox;
    pnlTableButton: TPanel;
    btnDelete: TImage;
    btnEdit: TImage;
    btnCopy: TImage;
    btnNew: TImage;
    btnUsage: TImage;
    Label1: TLabel;
    edtSearch: TEdit;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure btnNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUsageClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FUpdateList : Boolean;
    FSonarList : TList;
    FSelectedSonar : TSonar_On_Board;

    procedure UpdateSonarList;

  end;

var
  frmAvailableSonar: TfrmAvailableSonar;

implementation

uses
  uDataModuleTTT, ufrmSummarySonar, ufrmUsage, ufProgress;

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

procedure TfrmAvailableSonar.FormCreate(Sender: TObject);
begin
  FSonarList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableSonar.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSonarList);
end;

procedure TfrmAvailableSonar.FormShow(Sender: TObject);
begin
  UpdateSonarList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableSonar.btnNewClick(Sender: TObject);
begin
  frmSummarySonar := TfrmSummarySonar.Create(Self);
  try
    with frmSummarySonar do
    begin
      SelectedSonar := TSonar_On_Board.Create;
      ShowModal;
      SelectedSonar.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummarySonar.Free;
  end;

  if FUpdateList then
    UpdateSonarList;
end;

procedure TfrmAvailableSonar.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbSonar.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonar ... !');
    Exit;
  end;

  with FSelectedSonar do
  begin
    newClassName := FDef.Sonar_Identifier + ' - Copy';

    count := dmTTT.GetSonarDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Sonar_Identifier := newClassName;

    dmTTT.InsertSonarDef(FDef);
    dmTTT.InsertNoteStorage(9, FDef.Sonar_Index, FNote);
  end;

  UpdateSonarList;
end;

procedure TfrmAvailableSonar.btnEditClick(Sender: TObject);
begin
  if lbSonar.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonar ... !');
    Exit;
  end;

  frmSummarySonar := TfrmSummarySonar.Create(Self);
  try
    with frmSummarySonar do
    begin
      SelectedSonar := FSelectedSonar;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummarySonar.Free;
  end;

  if FUpdateList then
    UpdateSonarList;
end;

procedure TfrmAvailableSonar.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lbSonar.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonar ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedSonar.FDef do
    begin

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(4, Sonar_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      {Pengecekan Relasi Dengan Tabel Sonobuoy Definition}
      tempList := TList.Create;
      if dmTTT.GetSonarAtSonobuoyDef(Sonar_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Sonobuoy Definition');
        FreeItemsAndFreeList(tempList);
        Exit;
      end;
      FreeItemsAndFreeList(tempList);

      dmTTT.DeleteNoteStorage(9, Sonar_Index);

      if dmTTT.DeleteSonarDef(Sonar_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateSonarList;
  end;
end;

procedure TfrmAvailableSonar.btnUsageClick(Sender: TObject);
begin
  if lbSonar.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonar ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedSonar.FDef.Sonar_Index;
      name_usage := FSelectedSonar.FDef.Sonar_Identifier;
      UIndex := 2;
      usage_title := 'On Board Vehicle:';
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableSonar.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSonarList
  end;
end;

procedure TfrmAvailableSonar.lbSingleClick(Sender: TObject);
begin
  if lbSonar.ItemIndex = -1 then
    Exit;

  FSelectedSonar := TSonar_On_Board(lbSonar.Items.Objects[lbSonar.ItemIndex]);
end;

procedure TfrmAvailableSonar.UpdateSonarList;
var
  i : Integer;
  sonar : TSonar_On_Board;
begin
  lbSonar.Items.Clear;

  dmTTT.GetFilterSonarDef(FSonarList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FSonarList.Count;

  for i := 0 to FSonarList.Count - 1 do
  begin
    sonar := FSonarList.Items[i];
    lbSonar.Items.AddObject(sonar.FDef.Sonar_Identifier, sonar);
    frmProgress.increase(sonar.FDef.Sonar_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
