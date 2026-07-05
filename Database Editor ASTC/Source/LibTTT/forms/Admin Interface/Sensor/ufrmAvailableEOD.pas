unit ufrmAvailableEOD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Sensor, uSimContainers;

type
  TfrmAvailableEOD = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lbEOD: TListBox;
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
    FEODList : TList;
    FSelectedEOD : TEOD_On_Board;

    procedure UpdateEODList;
  end;

var
  frmAvailableEOD: TfrmAvailableEOD;

implementation

uses
  uDataModuleTTT, ufrmSummaryEOD, ufrmUsage, ufProgress;

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

procedure TfrmAvailableEOD.FormCreate(Sender: TObject);
begin
  FEODList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableEOD.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FEODList);
end;

procedure TfrmAvailableEOD.FormShow(Sender: TObject);
begin
  UpdateEODList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableEOD.btnNewClick(Sender: TObject);
begin
  frmSummaryEOD := TfrmSummaryEOD.Create(Self);
  try
    with frmSummaryEOD do
    begin
      SelectedEO := TEOD_On_Board.Create;
      ShowModal;
      SelectedEO.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryEOD.Free;
  end;

  if FUpdateList then
    UpdateEODList;
end;

procedure TfrmAvailableEOD.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbEOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data EOD ... !');
    Exit;
  end;

  with FSelectedEOD do
  begin
    newClassName := FEO_Def.Class_Identifier + ' - Copy';

    count := dmTTT.GetEODef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FEO_Def.Class_Identifier := newClassName;

    dmTTT.InsertEODef(FEO_Def);
    dmTTT.InsertNoteStorage(12, FEO_Def.EO_Index, FNote);
  end;

  UpdateEODList;
end;

procedure TfrmAvailableEOD.btnEditClick(Sender: TObject);
begin
  if lbEOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data EOD ... !');
    Exit;
  end;

  frmSummaryEOD := TfrmSummaryEOD.Create(Self);
  try
    with frmSummaryEOD do
    begin
      SelectedEO := FSelectedEOD;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryEOD.Free;
  end;

  if FUpdateList then
    UpdateEODList;
end;

procedure TfrmAvailableEOD.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lbEOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data EOD ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedEOD.FEO_Def do
    begin

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(5, EO_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(12, EO_Index);

      if dmTTT.DeleteEODef(EO_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateEODList;
  end;
end;

procedure TfrmAvailableEOD.btnUsageClick(Sender: TObject);
begin
  if lbEOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data EOD ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedEOD.FEO_Def.EO_Index;
      name_usage := FSelectedEOD.FEO_Def.Class_Identifier;
      UIndex := 4;
      usage_title := 'On Board Vehicle:';
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableEOD.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateEODList
  end;
end;

procedure TfrmAvailableEOD.lbSingleClick(Sender: TObject);
begin
  if lbEOD.ItemIndex = -1 then
    Exit;

  FSelectedEOD := TEOD_On_Board(lbEOD.Items.Objects[lbEOD.ItemIndex]);
end;

procedure TfrmAvailableEOD.UpdateEODList;
var
  i : Integer;
  eod : TEOD_On_Board;
begin
  lbEOD.Items.Clear;

  dmTTT.GetFilterEODDef(FEODList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FEODList.Count;

  for i := 0 to FEODList.Count - 1 do
  begin
    eod := FEODList.Items[i];
    lbEOD.Items.AddObject(eod.FEO_Def.Class_Identifier, eod);
    frmProgress.increase(eod.FEO_Def.Class_Identifier);
  end;
  frmProgress.Free;

end;

{$ENDREGION}

end.
