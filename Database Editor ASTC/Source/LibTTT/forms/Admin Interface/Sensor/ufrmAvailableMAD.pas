unit ufrmAvailableMAD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Sensor, uSimContainers;

type
  TfrmAvailableMAD = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lbMAD: TListBox;
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
    FMADList : TList;
    FSelectedMAD : TMAD_On_Board;

    procedure UpdateMADList;
  end;

var
  frmAvailableMAD: TfrmAvailableMAD;

implementation

uses
  uDataModuleTTT, ufrmSummaryMAD, ufrmUsage, ufProgress;

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

procedure TfrmAvailableMAD.FormCreate(Sender: TObject);
begin
  FMADList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableMAD.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FMADList);
end;

procedure TfrmAvailableMAD.FormShow(Sender: TObject);
begin
  UpdateMADList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableMAD.btnNewClick(Sender: TObject);
begin
  frmSummaryMAD := TfrmSummaryMAD.Create(Self);
  try
    with frmSummaryMAD do
    begin
      SelectedMAD := TMAD_On_Board.Create;
      ShowModal;
      SelectedMAD.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryMAD.Free;
  end;

  if FUpdateList then
    UpdateMADList;
end;

procedure TfrmAvailableMAD.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lbMAD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data MAD ... !');
    Exit;
  end;

  with FSelectedMAD do
  begin
    newClassName := FMAD_Def.Class_Identifier + ' - Copy';

    count := dmTTT.GetMADDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FMAD_Def.Class_Identifier := newClassName;

    dmTTT.InsertMADDef(FMAD_Def);
    dmTTT.InsertNoteStorage(11, FMAD_Def.MAD_Index, FNote);
  end;

  UpdateMADList;
end;

procedure TfrmAvailableMAD.btnEditClick(Sender: TObject);
begin
  if lbMAD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data MAD ... !');
    Exit;
  end;

  frmSummaryMAD := TfrmSummaryMAD.Create(Self);
  try
    with frmSummaryMAD do
    begin
      SelectedMAD := FSelectedMAD;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryMAD.Free;
  end;

  if FUpdateList then
    UpdateMADList;
end;

procedure TfrmAvailableMAD.btnDeleteClick(Sender: TObject);
var
  warning: Integer;
begin
  if lbMAD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data MAD ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedMAD.FMAD_Def do
    begin
      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetSensor_On_Board_By_Index(2, MAD_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(11, MAD_Index);

      if dmTTT.DeleteMADDef(MAD_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateMADList;
  end;
end;

procedure TfrmAvailableMAD.btnUsageClick(Sender: TObject);
begin
  if lbMAD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data MAD ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedMAD.FMAD_Def.MAD_Index;
      name_usage := FSelectedMAD.FMAD_Def.Class_Identifier;
      UIndex := 5;
      usage_title := 'On Board Vehicle:';

    ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableMAD.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateMADList
  end;
end;

procedure TfrmAvailableMAD.lbSingleClick(Sender: TObject);
begin
  if lbMAD.ItemIndex = -1 then
    Exit;

  FSelectedMAD := TMAD_On_Board(lbMAD.Items.Objects[lbMAD.ItemIndex]);
end;

procedure TfrmAvailableMAD.UpdateMADList;
var
  i : Integer;
  mad : TMAD_On_Board;
begin
  lbMAD.Items.Clear;

  dmTTT.GetFilterMADDef(FMADList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FMADList.Count;

  for i := 0 to FMADList.Count - 1 do
  begin
    mad := FMADList.Items[i];
    lbMAD.Items.AddObject(mad.FMAD_Def.Class_Identifier, mad);
    frmProgress.increase(mad.FMAD_Def.Class_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
