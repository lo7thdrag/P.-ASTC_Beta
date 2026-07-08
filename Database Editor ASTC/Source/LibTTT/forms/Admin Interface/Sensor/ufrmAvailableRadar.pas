unit ufrmAvailableRadar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uSimDBEditor, tttData, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  UDBAsset_Radar, uSimContainers;

type
  TfrmAvailableRadar = class(TForm)
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
    lbRadars: TListBox;

    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure btnNewClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUsageClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure edtSearchChange(Sender: TObject);

  private
    FUpdateList : Boolean;
    FRadarList : TList;
    FSelectedRadar : TRadar_On_Board;

    procedure UpdateRadarList;
  end;

var
  frmAvailableRadar: TfrmAvailableRadar;

implementation

uses
  uDataModuleTTT, ufrmSummaryRadar, ufrmUsage, ufProgress;

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

procedure TfrmAvailableRadar.FormCreate(Sender: TObject);
begin
  FRadarList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableRadar.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FRadarList);
end;

procedure TfrmAvailableRadar.FormShow(Sender: TObject);
begin
  UpdateRadarList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableRadar.btnNewClick(Sender: TObject);
begin
  frmSummaryRadar := TfrmSummaryRadar.Create(Self);
  try
    with frmSummaryRadar do
    begin
      SelectedRadar := TRadar_On_Board.Create;
      ShowModal;
      SelectedRadar.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryRadar.Free;
  end;

  if FUpdateList then
    UpdateRadarList;
end;

procedure TfrmAvailableRadar.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
 if lbRadars.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar ... !');
    Exit;
  end;

  with FSelectedRadar do
  begin
    newClassName := FDef.Radar_Identifier + ' - Copy';

    count := dmTTT.GetRadarDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Radar_Identifier := newClassName;

    dmTTT.InsertRadarDef(FDef);
    dmTTT.InsertNoteStorage(7, FDef.Radar_Index, FNote);
  end;

  UpdateRadarList;
end;

procedure TfrmAvailableRadar.btnEditClick(Sender: TObject);
begin
  if lbRadars.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar ... !');
    Exit;
  end;

  frmSummaryRadar := TfrmSummaryRadar.Create(Self);
  try
    with frmSummaryRadar do
    begin
      SelectedRadar := FSelectedRadar;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryRadar.Free;
  end;

  if FUpdateList then
    UpdateRadarList;
end;

procedure TfrmAvailableRadar.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lbRadars.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedRadar.FDef do
    begin

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(1, Radar_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      {Catatan : Seharusnya ada tambahan menghapus data di Tabel Vertical Coverage}
      dmTTT.DeleteRadar_Vertical_Coverage(1, Radar_Index, 0);

      dmTTT.DeleteNoteStorage(7, Radar_Index);

      if dmTTT.DeleteRadarDef(Radar_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateRadarList;
  end;
end;

procedure TfrmAvailableRadar.btnUsageClick(Sender: TObject);
begin
  if lbRadars.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedRadar.FDef.Radar_Index;
      name_usage := FSelectedRadar.FDef.Radar_Identifier;
      usage_title := 'On Board Vehicle : ';
      UIndex := 1;
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableRadar.edtSearchChange(Sender: TObject);
var
  i : Integer;
  radar : TRadar_On_Board;
begin
  lbRadars.Items.Clear;

  dmTTT.GetFilterRadarDef(FRadarList, edtSearch.Text);

  for i := 0 to FRadarList.Count - 1 do
  begin
    radar := FRadarList.Items[i];
    lbRadars.Items.AddObject(radar.FDef.Radar_Identifier, radar);
  end;
end;

procedure TfrmAvailableRadar.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateRadarList
  end;
end;

procedure TfrmAvailableRadar.lbSingleClick(Sender: TObject);
begin
  if lbRadars.ItemIndex = -1 then
    Exit;

  FSelectedRadar := TRadar_On_Board(lbRadars.Items.Objects[lbRadars.ItemIndex]);
end;

procedure TfrmAvailableRadar.UpdateRadarList;
var
  i : Integer;
  radar : TRadar_On_Board;
begin
  lbRadars.Items.Clear;

  dmTTT.GetFilterRadarDef(FRadarList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Mengisi data dari database';
  frmProgress.MaxJob := FRadarList.Count;

  for i := 0 to FRadarList.Count - 1 do
  begin
    radar := FRadarList.Items[i];
    lbRadars.Items.AddObject(radar.FDef.Radar_Identifier, radar);
    frmProgress.increase(radar.FDef.Radar_Identifier);
  end;

  frmProgress.Free;
end;

{$ENDREGION}
end.
