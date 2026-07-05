unit ufrmAvailableSonobuoy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Sonobuoy, uSimContainers;

type
  TfrmAvailableSonobuoy = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lbSonobuoy: TListBox;
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
    FSonobuoyList : TList;
    FSelectedSonobuoy : TSonobuoy_On_Board;

    procedure UpdateSonobuoyList;
  end;

var
  frmAvailableSonobuoy: TfrmAvailableSonobuoy;

implementation

uses
  uDataModuleTTT, ufrmSummarySonobuoy, ufrmUsage, ufProgress;

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

procedure TfrmAvailableSonobuoy.FormCreate(Sender: TObject);
begin
  FSonobuoyList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableSonobuoy.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSonobuoyList);
end;

procedure TfrmAvailableSonobuoy.FormShow(Sender: TObject);
begin
  UpdateSonobuoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableSonobuoy.btnNewClick(Sender: TObject);
begin
  frmSummarySonobuoy := TfrmSummarySonobuoy.Create(Self);
  try
    with frmSummarySonobuoy do
    begin
      SelectedSonobuoy := TSonobuoy_On_Board.Create;
      ShowModal;
      SelectedSonobuoy.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummarySonobuoy.Free;
  end;

  if FUpdateList then
    UpdateSonobuoyList;
end;

procedure TfrmAvailableSonobuoy.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbSonobuoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonobuoy ... !');
    Exit;
  end;

  with FSelectedSonobuoy do
  begin
    newClassName := FDef.Class_Identifier + ' - Copy';

    count := dmTTT.GetSonobuoyDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Class_Identifier := newClassName;

    dmTTT.InsertSonobuoyDef(FDef);
    dmTTT.InsertNoteStorage(6, FDef.Sonobuoy_Index, FNote);
  end;

  UpdateSonobuoyList;
end;

procedure TfrmAvailableSonobuoy.btnEditClick(Sender: TObject);
begin
  if lbSonobuoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonobuoy ... !');
    Exit;
  end;

  frmSummarySonobuoy := TfrmSummarySonobuoy.Create(Self);
  try
    with frmSummarySonobuoy do
    begin
      SelectedSonobuoy := FSelectedSonobuoy;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummarySonobuoy.Free;
  end;

  if FUpdateList then
    UpdateSonobuoyList;
end;

procedure TfrmAvailableSonobuoy.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lbSonobuoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonobuoy ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedSonobuoy.FDef do
    begin
      tempList := TList.Create;

      {Pengecekan Relasi Dengan Resource Allocation}
      if dmTTT.GetPlatformInstanceAtResourceAllocation(4, Sonobuoy_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data resource allocation');
        FreeItemsAndFreeList(tempList);
        Exit;
      end;

      {Pengecekan Relasi Dengan Runtime Platform Library}
      if dmTTT.GetPlatformAtPlatformLibraryEntry(7, Sonobuoy_Index, tempList) > 0then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Runtime Platform Library');
        FreeItemsAndFreeList(tempList);
        Exit;
      end;
      FreeItemsAndFreeList(tempList);

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(8, Sonobuoy_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(6, Sonobuoy_Index);

      if dmTTT.DeleteSonobuoyDef(Sonobuoy_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateSonobuoyList;
  end;
end;

procedure TfrmAvailableSonobuoy.btnUsageClick(Sender: TObject);
begin
  if lbSonobuoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Sonobuoy ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedSonobuoy.FDef.Sonobuoy_Index;
      name_usage := FSelectedSonobuoy.FDef.Class_Identifier;
      usage_title := 'On Board Vehicle:';
      UIndex := 6;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableSonobuoy.edtSearchKeyPress(Sender: TObject;var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSonobuoyList
  end;
end;

procedure TfrmAvailableSonobuoy.lbSingleClick(Sender: TObject);
begin
  if lbSonobuoy.ItemIndex = -1 then
    Exit;

  FSelectedSonobuoy := TSonobuoy_On_Board(lbSonobuoy.Items.Objects[lbSonobuoy.ItemIndex]);
end;

procedure TfrmAvailableSonobuoy.UpdateSonobuoyList;
var
  i : Integer;
  sonobuoy : TSonobuoy_On_Board;
begin
  lbSonobuoy.Items.Clear;

  dmTTT.GetFilterSonobuoyDef(FSonobuoyList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FSonobuoyList.Count;

  for i := 0 to FSonobuoyList.Count - 1 do
  begin
    sonobuoy := FSonobuoyList.Items[i];
    lbSonobuoy.Items.AddObject(sonobuoy.FDef.Class_Identifier, sonobuoy);
    frmProgress.increase(sonobuoy.FDef.Class_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
