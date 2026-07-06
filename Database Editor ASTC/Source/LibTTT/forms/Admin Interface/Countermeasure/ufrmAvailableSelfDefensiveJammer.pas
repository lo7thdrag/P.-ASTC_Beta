unit ufrmAvailableSelfDefensiveJammer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableSelfDefensiveJammer = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstSelfDefensiveJammer: TListBox;
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
    FSelfDefensiveJammerList : TList;
    FSelectedSelfDefensiveJammer : TDefensive_Jammer_On_Board;

    procedure UpdateSelfDefensiveJammerList;

   end;

var
  frmAvailableSelfDefensiveJammer: TfrmAvailableSelfDefensiveJammer;

implementation

uses
  uDataModuleTTT, ufrmSummarySelfDefensiveJammer, ufrmUsage, ufProgress;

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

procedure TfrmAvailableSelfDefensiveJammer.FormCreate(Sender: TObject);
begin
  FSelfDefensiveJammerList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableSelfDefensiveJammer.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSelfDefensiveJammerList);
end;

procedure TfrmAvailableSelfDefensiveJammer.FormShow(Sender: TObject);
begin
  UpdateSelfDefensiveJammerList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableSelfDefensiveJammer.btnNewClick(Sender: TObject);
begin
 frmSummarySelfDefensiveJammer := TfrmSummarySelfDefensiveJammer.Create(Self);
  try
    with frmSummarySelfDefensiveJammer do
    begin
      SelectedDefensiveJammer := TDefensive_Jammer_On_Board.Create;
      ShowModal;
      SelectedDefensiveJammer.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummarySelfDefensiveJammer.Free;
  end;

  if FUpdateList then
    UpdateSelfDefensiveJammerList;
end;

procedure TfrmAvailableSelfDefensiveJammer.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;

begin
  if lstSelfDefensiveJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Self Defensive Jammer ... !');
    Exit;
  end;

  with FSelectedSelfDefensiveJammer do
  begin
    newClassName := FDefensiveJammer_Def.Defensive_Jammer_Identifier + ' - Copy';

    count := dmTTT.GetSelfDefensiveJammerDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDefensiveJammer_Def.Defensive_Jammer_Identifier := newClassName;

    dmTTT.InsertSelfDefensiveJammerDef(FDefensiveJammer_Def);
    dmTTT.InsertNoteStorage(16, FDefensiveJammer_Def.Defensive_Jammer_Index, FNote);
  end;

  UpdateSelfDefensiveJammerList;
end;

procedure TfrmAvailableSelfDefensiveJammer.btnEditClick(Sender: TObject);
begin
  if lstSelfDefensiveJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Self Defensive Jammer ... !');
    Exit;
  end;

  frmSummarySelfDefensiveJammer := TfrmSummarySelfDefensiveJammer.Create(Self);
  try
    with frmSummarySelfDefensiveJammer do
    begin
      SelectedDefensiveJammer := FSelectedSelfDefensiveJammer;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummarySelfDefensiveJammer.Free;
  end;

  if FUpdateList then
    UpdateSelfDefensiveJammerList;
end;

procedure TfrmAvailableSelfDefensiveJammer.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstSelfDefensiveJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Self Defensive Jammer ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedSelfDefensiveJammer.FDefensiveJammer_Def do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(6, Defensive_Jammer_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(16, Defensive_Jammer_Index);

      if dmTTT.DeleteSelfDefensiveJammerDef(Defensive_Jammer_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateSelfDefensiveJammerList;
  end;
end;

procedure TfrmAvailableSelfDefensiveJammer.btnUsageClick(Sender: TObject);
begin
  if lstSelfDefensiveJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Self Defensive Jammer ... !');
    Exit;
  end;

  with frmUsage do
  begin
    UId := FSelectedSelfDefensiveJammer.FDefensiveJammer_Def.Defensive_Jammer_Index;
    name_usage := FSelectedSelfDefensiveJammer.FDefensiveJammer_Def.Defensive_Jammer_Identifier;
    usage_title := 'On Board Vehicle:';
    UIndex := 16;

    ShowModal;
  end;
end;

procedure TfrmAvailableSelfDefensiveJammer.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then
  begin
    UpdateSelfDefensiveJammerList
  end;
end;

procedure TfrmAvailableSelfDefensiveJammer.lbSingleClick(Sender: TObject);
begin
  if lstSelfDefensiveJammer.ItemIndex = -1 then
    Exit;

  FSelectedSelfDefensiveJammer := TDefensive_Jammer_On_Board(lstSelfDefensiveJammer.Items.Objects[lstSelfDefensiveJammer.ItemIndex]);
end;

procedure TfrmAvailableSelfDefensiveJammer.UpdateSelfDefensiveJammerList;
var
  i : Integer;
  selfdefensivejammer : TDefensive_Jammer_On_Board;
begin
  lstSelfDefensiveJammer.Items.Clear;

//  dmTTT.GetAllSelfDefensiveJammerDef(FSelfDefensiveJammerList);
  dmTTT.GetFilterSelfDefensiveJammerDef(FSelfDefensiveJammerList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FSelfDefensiveJammerList.Count;

  for i := 0 to FSelfDefensiveJammerList.Count - 1 do
  begin
    selfdefensivejammer := FSelfDefensiveJammerList.Items[i];
    lstSelfDefensiveJammer.Items.AddObject(selfdefensivejammer.FDefensiveJammer_Def.Defensive_Jammer_Identifier, selfdefensivejammer);
    frmProgress.increase(selfdefensivejammer.FDefensiveJammer_Def.Defensive_Jammer_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
