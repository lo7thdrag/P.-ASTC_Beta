unit ufrmAvailableFloatingDecoy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableFloatingDecoy = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstFloatingDecoy: TListBox;
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
    FFloatingDecoyList : TList;
    FSelectedFloatingDecoy : TFloating_Decoy_On_Board;

    procedure UpdateFloatingDecoyList;

   end;

var
  frmAvailableFloatingDecoy: TfrmAvailableFloatingDecoy;

implementation

uses
  uDataModuleTTT, ufrmSummaryFloatingDecoy, ufrmUsage, ufProgress;

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

procedure TfrmAvailableFloatingDecoy.FormCreate(Sender: TObject);
begin
  FFloatingDecoyList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableFloatingDecoy.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FFloatingDecoyList);
end;

procedure TfrmAvailableFloatingDecoy.FormShow(Sender: TObject);
begin
  UpdateFloatingDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableFloatingDecoy.btnNewClick(Sender: TObject);
begin
  frmSummaryFloatingDecoy := TfrmSummaryFloatingDecoy.Create(Self);
  try
    with frmSummaryFloatingDecoy do
    begin
      SelectedFloatingDecoy := TFloating_Decoy_On_Board.Create;
      ShowModal;
      SelectedFloatingDecoy.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryFloatingDecoy.Free;
  end;

  if FUpdateList then
    UpdateFloatingDecoyList;
end;

procedure TfrmAvailableFloatingDecoy.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lstFloatingDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Floating Decoy ... !');
    Exit;
  end;

  with FSelectedFloatingDecoy do
  begin
    newClassName := FFloatingDecoy_Def.Floating_Decoy_Identifier + ' - Copy';

    count := dmTTT.GetFloatingDecoyDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FFloatingDecoy_Def.Floating_Decoy_Identifier := newClassName;

    dmTTT.InsertFloatingDecoyDef(FFloatingDecoy_Def);
    dmTTT.InsertNoteStorage(18, FFloatingDecoy_Def.Floating_Decoy_Index, FNote);
  end;

  UpdateFloatingDecoyList;
end;

procedure TfrmAvailableFloatingDecoy.btnEditClick(Sender: TObject);
begin
  if lstFloatingDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Floating Decoy ... !');
    Exit;
  end;

  frmSummaryFloatingDecoy := TfrmSummaryFloatingDecoy.Create(Self);
  try
    with frmSummaryFloatingDecoy do
    begin
      SelectedFloatingDecoy := FSelectedFloatingDecoy;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryFloatingDecoy.Free;
  end;

  if FUpdateList then
    UpdateFloatingDecoyList;
end;

procedure TfrmAvailableFloatingDecoy.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstFloatingDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Floating Decoy ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedFloatingDecoy.FFloatingDecoy_Def do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(5, Floating_Decoy_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(18, Floating_Decoy_Index);

      if dmTTT.DeleteFloatingDecoyDef(Floating_Decoy_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateFloatingDecoyList;
  end;
end;

procedure TfrmAvailableFloatingDecoy.btnUsageClick(Sender: TObject);
begin
  if lstFloatingDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Floating Decoy ... !');
    Exit;
  end;

  with frmUsage do
  begin
    UId := FSelectedFloatingDecoy.FFloatingDecoy_Def.Floating_Decoy_Index;
    name_usage := FSelectedFloatingDecoy.FFloatingDecoy_Def.Floating_Decoy_Identifier;
    usage_title := 'On Board Vehicle:';
    UIndex := 15;

    ShowModal;
  end;
end;

procedure TfrmAvailableFloatingDecoy.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateFloatingDecoyList
  end;
end;

procedure TfrmAvailableFloatingDecoy.lbSingleClick(Sender: TObject);
begin
  if lstFloatingDecoy.ItemIndex = -1 then
    Exit;

  FSelectedFloatingDecoy := TFloating_Decoy_On_Board(lstFloatingDecoy.Items.Objects[lstFloatingDecoy.ItemIndex]);
end;

procedure TfrmAvailableFloatingDecoy.UpdateFloatingDecoyList;
var
  i : Integer;
  floatingdecoy : TFloating_Decoy_On_Board;
begin
  lstFloatingDecoy.Items.Clear;

//  dmTTT.GetAllFloatingDecoyDef(FFloatingDecoyList);
  dmTTT.GetFilterFloatingDecoyDef(FFloatingDecoyList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FFloatingDecoyList.Count;

  for i := 0 to FFloatingDecoyList.Count - 1 do
  begin
    floatingdecoy := FFloatingDecoyList.Items[i];
    lstFloatingDecoy.Items.AddObject(floatingdecoy.FFloatingDecoy_Def.Floating_Decoy_Identifier, floatingdecoy);
    frmProgress.increase(floatingdecoy.FFloatingDecoy_Def.Floating_Decoy_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
