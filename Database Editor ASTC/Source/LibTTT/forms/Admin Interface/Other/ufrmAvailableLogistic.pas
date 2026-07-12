unit ufrmAvailableLogistic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, uDBAsset_Logistics, uDBAssetObject,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uSimContainers;

type
  TfrmAvailableLogistic = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableButton: TPanel;
    btnDelete: TImage;
    btnEdit: TImage;
    btnCopy: TImage;
    btnNew: TImage;
    btnUsage: TImage;
    Label1: TLabel;
    edtSearch: TEdit;
    pnlTableList: TPanel;
    lbLogistic: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure btnNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUsageClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtloglistKeyPress(Sender: TObject; var Key: Char);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);

  private
    FUpdateList : Boolean;
    FLogisticList : TList;
    FSelectedLogistic : TLogistics;

    procedure UpdateLogisticList;
  end;

var
  frmAvailableLogistic: TfrmAvailableLogistic;

implementation

{$R *.dfm}

uses
  uDataModuleTTT, ufrmSummaryLogistic, ufrmUsage, ufProgress;

{$REGION ' Form Handle '}

procedure TfrmAvailableLogistic.FormCreate(Sender: TObject);
begin
  FLogisticList := TList.Create;
end;

procedure TfrmAvailableLogistic.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FLogisticList);
end;

procedure TfrmAvailableLogistic.FormShow(Sender: TObject);
begin
  UpdateLogisticList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableLogistic.btnNewClick(Sender: TObject);
begin
  frmSummaryLogistic := TfrmSummaryLogistic.Create(Self);
  try
    with frmSummaryLogistic do
    begin
      SelectedLogistic := TLogistics.Create;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryLogistic.Free;
  end;

  if FUpdateList then
    UpdateLogisticList;
end;

procedure TfrmAvailableLogistic.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAvailableLogistic.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbLogistic.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Logistic ... !');
    Exit;
  end;

  with FSelectedLogistic do
  begin
    newClassName := FData.Logistic_Identifier + ' - Copy';

    count := dmTTT.GetLogisticDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Logistic_Identifier := newClassName;

    dmTTT.InsertLogisticDef(FData);
  end;

  UpdateLogisticList;
end;

procedure TfrmAvailableLogistic.btnEditClick(Sender: TObject);
begin
  if lbLogistic.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Logistic ... !');
    Exit;
  end;

  frmSummaryLogistic := TfrmSummaryLogistic.Create(Self);
  try
    with frmSummaryLogistic do
    begin
      SelectedLogistic := FSelectedLogistic;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryLogistic.Free;
  end;

  if FUpdateList then
    UpdateLogisticList;
end;

procedure TfrmAvailableLogistic.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList : TList;

begin
  if lbLogistic.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Logistic ... !');
    Exit;
  end;

  warning := MessageDlg('Are you sure to delete this Logistic data ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    tempList := TList.Create;
    with FSelectedLogistic.FData do
    begin
      {Pengecekan Relasi Dengan Tabel Vehicle Definition}
      if dmTTT.GetLogisticAtVehicle(Logistic_Index,tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang digunakan di Vehicle Definition');
        tempList.Destroy;
        Exit;
      end;
      tempList.Destroy;

      if dmTTT.DeleteLogisticDef(Logistic_Index) then
      begin
        ShowMessage('Data berhasil dihapus');
      end;

    end;
  end;

  UpdateLogisticList;
end;

procedure TfrmAvailableLogistic.btnUsageClick(Sender: TObject);
begin
  if lbLogistic.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedLogistic.FData.Logistic_Index;
      name_usage  := FSelectedLogistic.FData.Logistic_Identifier;
      UIndex  := 39;
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableLogistic.edtloglistKeyPress(Sender: TObject; var Key: Char);
begin
//  if Key = #13 then
//  begin
//    UpdateLogisticList
//  end;
end;

procedure TfrmAvailableLogistic.edtSearchChange(Sender: TObject);
var
  i : Integer;
  logistic : TLogistics;
begin
  lbLogistic.Items.Clear;

  dmTTT.GetfilterLogisticDef(FLogisticList,edtSearch.Text);

  for i := 0 to FLogisticList.Count - 1 do
  begin
    logistic := TLogistics(FLogisticList.Items[i]);
    lbLogistic.Items.AddObject(logistic.FData.Logistic_Identifier, logistic);
  end;
end;

procedure TfrmAvailableLogistic.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateLogisticList
  end;
end;

procedure TfrmAvailableLogistic.lbSingleClick(Sender: TObject);
begin
  if lbLogistic.ItemIndex = -1 then
    Exit;

  FSelectedLogistic := TLogistics(lbLogistic.Items.Objects[lbLogistic.ItemIndex]);
end;

procedure TfrmAvailableLogistic.UpdateLogisticList;
var
  i : Integer;
  logistic : TLogistics;
begin
  lbLogistic.Items.Clear;

//  dmTTT.GetAllLogisticDef(FLogisticList);
  dmTTT.GetFilterLogisticDef(FLogisticList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Mengisi data dari database';
  frmProgress.MaxJob := FLogisticList.Count;

  for i := 0 to FLogisticList.Count - 1 do
  begin
    logistic := TLogistics(FLogisticList.Items[i]);
    lbLogistic.Items.AddObject(logistic.FData.Logistic_Identifier, logistic);
    frmProgress.increase(logistic.FData.Logistic_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
