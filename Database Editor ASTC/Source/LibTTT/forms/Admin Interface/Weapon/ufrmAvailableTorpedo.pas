unit ufrmAvailableTorpedo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Weapon, uSimContainers;

type
  TfrmAvailableTorpedo = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstTorpedo: TListBox;
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
    procedure edtSearchChange(Sender: TObject);

  private
    FUpdateList : Boolean;
    FTorpedoList : TList;
    FSelectedTorpedo : TTorpedo_On_Board;

    procedure UpdateTorpedoList;

  end;

var
  frmAvailableTorpedo: TfrmAvailableTorpedo;

implementation

uses
  uDataModuleTTT, ufrmSummaryTorpedo, ufrmUsage, ufProgress;
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

procedure TfrmAvailableTorpedo.FormCreate(Sender: TObject);
begin
  FTorpedoList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableTorpedo.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FTorpedoList);
end;

procedure TfrmAvailableTorpedo.FormShow(Sender: TObject);
begin
  UpdateTorpedoList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableTorpedo.btnNewClick(Sender: TObject);
begin
  frmSummaryTorpedo := TfrmSummaryTorpedo.Create(Self);
  try
    with frmSummaryTorpedo do
    begin
      SelectedTorpedo := TTorpedo_On_Board.Create;
      ShowModal;
      SelectedTorpedo.Free;

      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryTorpedo.Free;
  end;

  if FUpdateList then
    UpdateTorpedoList;
end;

procedure TfrmAvailableTorpedo.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lstTorpedo.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Torpedo ... !');
    Exit;
  end;

  with FSelectedTorpedo do
  begin
    newClassName := FDef.Class_Identifier + ' - Copy';

    count := dmTTT.GetTorpedoDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Class_Identifier := newClassName;

    dmTTT.InsertTorpedoDef(FDef);
    dmTTT.InsertNoteStorage(4, FDef.Torpedo_Index, FNote);
  end;

  UpdateTorpedoList;
end;

procedure TfrmAvailableTorpedo.btnEditClick(Sender: TObject);
begin
  if lstTorpedo.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Torpedo ... !');
    Exit;
  end;

  frmSummaryTorpedo := TfrmSummaryTorpedo.Create(Self);
  try
    with frmSummaryTorpedo do
    begin
      SelectedTorpedo := FSelectedTorpedo;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryTorpedo.Free;
  end;

  if FUpdateList then
    UpdateTorpedoList;
end;

procedure TfrmAvailableTorpedo.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lstTorpedo.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Torpedo ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedTorpedo.FDef do
    begin
      tempList := TList.Create;

      {Pengecekan Relasi Dengan Resource Allocation}
      if dmTTT.GetPlatformInstanceAtResourceAllocation(3, Torpedo_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data resource allocation');
        tempList.Free;
        Exit;
      end;

      {Pengecekan Relasi Dengan Tabel On Board}
      if dmTTT.GetFittedWeaponAtVehicleOnBoard(8, Torpedo_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        tempList.Free;
        Exit;
      end;

      {Pengecekan Relasi Dengan Tabel Missile Definition}
      if dmTTT.GetTorpedoAtMissileDef(Torpedo_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data missile definition');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      dmTTT.DeleteTorpedoPOHModifier(1, Torpedo_Index);
      dmTTT.DeleteNoteStorage(4, Torpedo_Index);

      if dmTTT.DeleteTorpedoDef(Torpedo_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateTorpedoList;
  end;
end;

procedure TfrmAvailableTorpedo.btnUsageClick(Sender: TObject);
begin
  if lstTorpedo.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Torpedo ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedTorpedo.FDef.Torpedo_Index;
      name_usage := FSelectedTorpedo.FDef.Class_Identifier;
      usage_title := 'On Board Vehicle : ';
      UIndex := 8;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableTorpedo.edtSearchChange(Sender: TObject);
var
  i : Integer;
  torpedo : TTorpedo_On_Board;

begin
  lstTorpedo.Items.Clear;

//  dmTTT.GetAllTorpedoDef(FTorpedoList);
  dmTTT.GetFilterTorpedoDef(FTorpedoList, edtSearch.Text);

  for i := 0 to FTorpedoList.Count - 1 do
  begin
    torpedo := FTorpedoList.Items[i];
    lstTorpedo.Items.AddObject(Torpedo.FDef.Class_Identifier, torpedo);
  end;
end;

procedure TfrmAvailableTorpedo.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTorpedoList
  end;
end;

procedure TfrmAvailableTorpedo.lbSingleClick(Sender: TObject);
begin
  if lstTorpedo.ItemIndex = -1 then
    Exit;
  FSelectedTorpedo := TTorpedo_On_Board(lstTorpedo.Items.Objects[lstTorpedo.ItemIndex]);
end;

procedure TfrmAvailableTorpedo.UpdateTorpedoList;
var
  i : Integer;
  torpedo : TTorpedo_On_Board;

begin
  lstTorpedo.Items.Clear;

//  dmTTT.GetAllTorpedoDef(FTorpedoList);
  dmTTT.GetFilterTorpedoDef(FTorpedoList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FTorpedoList.Count;

  for i := 0 to FTorpedoList.Count - 1 do
  begin
    torpedo := FTorpedoList.Items[i];
    lstTorpedo.Items.AddObject(Torpedo.FDef.Class_Identifier, torpedo);
    frmProgress.increase(Torpedo.FDef.Class_Identifier);
  end;
  frmProgress.Free;

end;

{$ENDREGION}

end.
