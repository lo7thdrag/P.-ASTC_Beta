unit ufrmAvailableTowedJammerDecoy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableTowedJammerDecoy = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstTowedJammerDecoy: TListBox;
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
    FTowedJammerDecoyList : TList;
    FSelectedTowedJammerDecoy : TTowed_Jammer_Decoy_On_Board;

    procedure UpdateTowedJammerDecoyList;

  end;

var
  frmAvailableTowedJammerDecoy: TfrmAvailableTowedJammerDecoy;

implementation

uses
  uDataModuleTTT, ufrmSummaryTowedJammerDecoy, ufrmUsage, ufProgress;

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

procedure TfrmAvailableTowedJammerDecoy.FormCreate(Sender: TObject);
begin
  FTowedJammerDecoyList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableTowedJammerDecoy.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FTowedJammerDecoyList);
end;

procedure TfrmAvailableTowedJammerDecoy.FormShow(Sender: TObject);
begin
  UpdateTowedJammerDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableTowedJammerDecoy.btnNewClick(Sender: TObject);
begin

  frmSummaryTowedJammerDecoy := TfrmSummaryTowedJammerDecoy.Create(Self);
  try
    with frmSummaryTowedJammerDecoy do
    begin
      SelectedTowedJammerDecoy := TTowed_Jammer_Decoy_On_Board.Create;
      ShowModal;
      SelectedTowedJammerDecoy.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryTowedJammerDecoy.Free;
  end;

  if FUpdateList then
    UpdateTowedJammerDecoyList;
end;

procedure TfrmAvailableTowedJammerDecoy.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lstTowedJammerDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Towed Jammer Decoy ... !');
    Exit;
  end;

  with FSelectedTowedJammerDecoy do
  begin
    newClassName := FDef.Towed_Decoy_Identifier + ' - Copy';

    count := dmTTT.GetTowedJammerDecoyDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Towed_Decoy_Identifier := newClassName;

    dmTTT.InsertTowedJammerDef(FDef);
    dmTTT.InsertNoteStorage(17, FDef.Towed_Decoy_Index, FNote);
  end;

  UpdateTowedJammerDecoyList;
end;

procedure TfrmAvailableTowedJammerDecoy.btnEditClick(Sender: TObject);
begin
  if lstTowedJammerDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Towed Jammer Decoy ... !');
    Exit;
  end;

  frmSummaryTowedJammerDecoy := TfrmSummaryTowedJammerDecoy.Create(Self);
  try
    with frmSummaryTowedJammerDecoy do
    begin
      SelectedTowedJammerDecoy := FSelectedTowedJammerDecoy;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryTowedJammerDecoy.Free;
  end;

  if FUpdateList then
    UpdateTowedJammerDecoyList;
end;

procedure TfrmAvailableTowedJammerDecoy.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstTowedJammerDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Towed Jammer Decoy ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedTowedJammerDecoy.FDef do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(7, Towed_Decoy_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(17, Towed_Decoy_Index);

      if dmTTT.DeleteTowedJammerDef(Towed_Decoy_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateTowedJammerDecoyList;
  end;
end;

procedure TfrmAvailableTowedJammerDecoy.btnUsageClick(Sender: TObject);
begin
  if lstTowedJammerDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Towed Jammer Decoy ... !');
    Exit;
  end;

  with frmUsage do
  begin
    UId := FSelectedTowedJammerDecoy.FDef.Towed_Decoy_Index;
    name_usage := FSelectedTowedJammerDecoy.FDef.Towed_Decoy_Identifier;
    usage_title := 'On Board Vehicle:';
    UIndex := 17;

    ShowModal;
  end;
end;

procedure TfrmAvailableTowedJammerDecoy.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTowedJammerDecoyList
  end;
end;

procedure TfrmAvailableTowedJammerDecoy.lbSingleClick(Sender: TObject);
begin
  if lstTowedJammerDecoy.ItemIndex = -1 then
    Exit;

  FSelectedTowedJammerDecoy := TTowed_Jammer_Decoy_On_Board(lstTowedJammerDecoy.Items.Objects[lstTowedJammerDecoy.ItemIndex]);
end;

procedure TfrmAvailableTowedJammerDecoy.UpdateTowedJammerDecoyList;
var
  i : Integer;
  towedjammerdecoy : TTowed_Jammer_Decoy_On_Board;
begin
  lstTowedJammerDecoy.Items.Clear;

//  dmTTT.GetAllTowedJammerDecoyDef(FTowedJammerDecoyList);
  dmTTT.GetFilterTowedJammerDecoyDef(FTowedJammerDecoyList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FTowedJammerDecoyList.Count;

  for i := 0 to FTowedJammerDecoyList.Count - 1 do
  begin
    towedjammerdecoy := FTowedJammerDecoyList.Items[i];
    lstTowedJammerDecoy.Items.AddObject(towedjammerdecoy.FDef.Towed_Decoy_Identifier, towedjammerdecoy);
    frmProgress.increase(towedjammerdecoy.FDef.Towed_Decoy_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
