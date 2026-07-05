unit ufrmAvailableESM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Sensor, uSimContainers;

type
  TfrmAvailableESM = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lbESM: TListBox;
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
    FESMList : TList;
    FSelectedESM : TESM_On_Board;

    procedure UpdateESMList;
  end;

var
  frmAvailableESM: TfrmAvailableESM;

implementation

uses
  uDataModuleTTT, ufrmSummaryESM, ufrmUsage, ufProgress;

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

procedure TfrmAvailableESM.FormCreate(Sender: TObject);
begin
  FESMList := Tlist.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableESM.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FESMList);
end;

procedure TfrmAvailableESM.FormShow(Sender: TObject);
begin
  UpdateESMList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableESM.btnNewClick(Sender: TObject);
begin
  frmSummaryESM := TfrmSummaryESM.Create(Self);
  try
    with frmSummaryESM do
    begin
      SelectedESM := TESM_On_Board.Create;
      ShowModal;
      SelectedESM.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryESM.Free;
  end;

  if FUpdateList then
    UpdateESMList;
end;

procedure TfrmAvailableESM.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbESM.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data ESM ... !');
    Exit;
  end;

  with FSelectedESM do
  begin
    newClassName := FESM_Def.Class_Identifier + ' - Copy';

    count := dmTTT.GetESMDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FESM_Def.Class_Identifier := newClassName;

    dmTTT.InsertESMDef(FESM_Def);
    dmTTT.InsertNoteStorage(10, FESM_Def.ESM_Index, FNote);
  end;

  UpdateESMList;
end;

procedure TfrmAvailableESM.btnEditClick(Sender: TObject);
begin
  if lbESM.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data ESM ... !');
    Exit;
  end;

  frmSummaryESM := TfrmSummaryESM.Create(Self);
  try
    with frmSummaryESM do
    begin
      SelectedESM := FSelectedESM;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryESM.Free;
  end;

  if FUpdateList then
    UpdateESMList;
end;

procedure TfrmAvailableESM.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lbESM.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data ESM ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedESM.FESM_Def do
    begin

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(3, ESM_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(10, ESM_Index);

      if dmTTT.DeleteESMDef(ESM_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateESMList;
  end;
end;

procedure TfrmAvailableESM.btnUsageClick(Sender: TObject);
begin
  if lbESM.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data ESM ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedESM.FESM_Def.ESM_Index;
      name_usage := FSelectedESM.FESM_Def.Class_Identifier;
      UIndex := 3;
      usage_title := 'On Board Vehicle:';
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableESM.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateESMList
  end;

end;

procedure TfrmAvailableESM.lbSingleClick(Sender: TObject);
begin
  if lbESM.ItemIndex = -1 then
    Exit;

  FSelectedESM := TESM_On_Board(lbESM.Items.Objects[lbESM.ItemIndex]);
end;

procedure TfrmAvailableESM.UpdateESMList;
var
  i : Integer;
  esm : TESM_On_Board;
begin
  lbESM.Items.Clear;

  dmTTT.GetFilterESMDef(FESMList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FESMList.Count;

  for i := 0 to FESMList.Count - 1 do
  begin
    esm := FESMList.Items[i];
    lbESM.Items.AddObject(esm.FESM_Def.Class_Identifier, esm);
    frmProgress.increase(esm.FESM_Def.Class_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
