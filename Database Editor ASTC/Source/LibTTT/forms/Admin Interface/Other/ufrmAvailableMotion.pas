unit ufrmAvailableMotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_MotionCharacteristics;

type
  TfrmAvailableMotion = class(TForm)
    pnlMainTable: TPanel;
    pnlTableList: TPanel;
    lstMotions: TListBox;
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
    FMotionList : TList;
    FSelectedMotion : TMotion_Characteristics;

    procedure UpdateMotionList;

  end;

var
  frmAvailableMotion: TfrmAvailableMotion;

implementation

uses
  uDataModuleTTT, ufrmSummaryMotion, ufrmUsage, ufProgress, uSimContainers;

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

procedure TfrmAvailableMotion.FormCreate(Sender: TObject);
begin
  FMotionList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableMotion.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FMotionList);
end;

procedure TfrmAvailableMotion.FormShow(Sender: TObject);
begin
  UpdateMotionList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableMotion.btnNewClick(Sender: TObject);
begin
  frmSummaryMotion := TfrmSummaryMotion.Create(Self);
  try
    with frmSummaryMotion do
    begin
      SelectedMotion := TMotion_Characteristics.Create;
      ShowModal;
      SelectedMotion.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryMotion.Free;
  end;

  if FUpdateList then
    UpdateMotionList;
end;

procedure TfrmAvailableMotion.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lstMotions.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Motion ... !');
    Exit;
  end;

  with FSelectedMotion do
  begin
    newClassName := FData.Motion_Identifier + ' - Copy';

    count := dmTTT.GetMotionCharacteristicDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Motion_Identifier := newClassName;

    dmTTT.InsertMotionCharacteristicDef(FData);
  end;

  UpdateMotionList;
end;

procedure TfrmAvailableMotion.btnEditClick(Sender: TObject);
begin
  if lstMotions.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Motion ... !');
    Exit;
  end;

  frmSummaryMotion := TfrmSummaryMotion.Create(Self);
  try
    with frmSummaryMotion do
    begin
      SelectedMotion := FSelectedMotion;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryMotion.Free;
  end;
  
  if FUpdateList then
    UpdateMotionList;
end;

procedure TfrmAvailableMotion.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList : TList;

begin
  if lstMotions.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Motion ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    tempList := TList.Create;
    with FSelectedMotion.FData do
    begin
      {Pengecekan Relasi Dengan Tabel Vehicle Definition}
      if dmTTT.GetMotionCharacteristicAtVehicleDef(Motion_Index,tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Vehicle Definition');
        tempList.Destroy;
        Exit;
      end;

      {Catatan : Seharusnya ada Pengecekan Relasi Dengan Tabel Missile Definition}
      if dmTTT.GetMotionCharacteristicAtMissileDef(Motion_Index,tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Missile Definition');
        tempList.Destroy;
        Exit;
      end;

      {Catatan : Seharusnya ada Pengecekan Relasi Dengan Tabel Torpedo Definition}
      if dmTTT.GetMotionCharacteristicAtTorpedoDef(Motion_Index,tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Torpedo Definition');
        tempList.Destroy;
        Exit;
      end;
      tempList.Destroy;

      if dmTTT.DeleteMotionCharacteristicDef(Motion_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;
  end;

  UpdateMotionList;
end;

procedure TfrmAvailableMotion.btnUsageClick(Sender: TObject);
begin
  if lstMotions.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Motion ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedMotion.FData.Motion_Index;
      name_usage  := FSelectedMotion.FData.Motion_Identifier;
      UIndex  := 32;
      usage_title := 'Vehicle Class:';
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableMotion.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateMotionList
  end;
end;

procedure TfrmAvailableMotion.lbSingleClick(Sender: TObject);
begin
  if lstMotions.ItemIndex = -1 then
    Exit;

  FSelectedMotion := TMotion_Characteristics(lstMotions.Items.Objects[lstMotions.ItemIndex]);
end;

procedure TfrmAvailableMotion.UpdateMotionList;
var
  i : Integer;
  motion : TMotion_Characteristics;
begin
  lstMotions.Items.Clear;

//  dmTTT.GetAllMotionCharacteristicDef(FMotionList);
  dmTTT.GetFilterMotionCharacteristicDef(FMotionList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FMotionList.Count;

  for i := 0 to FMotionList.Count - 1 do
  begin
    motion := FMotionList.Items[i];
    lstMotions.Items.AddObject(motion.FData.Motion_Identifier, motion);
    frmProgress.increase(motion.FData.Motion_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
