unit ufrmAvailableInfraredDecoy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableInfraredDecoy = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstInfraredDecoy: TListBox;
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
    FInfraredDecoyList : TList;
    FSelectedInfraredDecoy : TInfrared_Decoy_On_Board;

    procedure UpdateInfraredDecoyList;

   end;

var
  frmAvailableInfraredDecoy: TfrmAvailableInfraredDecoy;

implementation

uses
  uDataModuleTTT, ufrmSummaryInfraredDecoy, ufrmUsage, ufProgress;
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

procedure TfrmAvailableInfraredDecoy.FormCreate(Sender: TObject);
begin
  FInfraredDecoyList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableInfraredDecoy.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FInfraredDecoyList);
end;

procedure TfrmAvailableInfraredDecoy.FormShow(Sender: TObject);
begin
  UpdateInfraredDecoyList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableInfraredDecoy.btnNewClick(Sender: TObject);
begin

  frmSummaryInfraredDecoy := TfrmSummaryInfraredDecoy.Create(Self);
  try
    with frmSummaryInfraredDecoy do
    begin
      SelectedInfraredDecoy := TInfrared_Decoy_On_Board.Create;
      ShowModal;
      SelectedInfraredDecoy.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryInfraredDecoy.Free;
  end;

  if FUpdateList then
    UpdateInfraredDecoyList;
end;

procedure TfrmAvailableInfraredDecoy.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;

begin
  if lstInfraredDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Infrared Decoy ... !');
    Exit;
  end;

  with FSelectedInfraredDecoy do
  begin
    newClassName := FInfraredDecoy_Def.Infrared_Decoy_Identifier + ' - Copy';

    count := dmTTT.GetInfraredDecoyDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FInfraredDecoy_Def.Infrared_Decoy_Identifier := newClassName;

    dmTTT.InsertInfraredDecoyDef(FInfraredDecoy_Def);
    dmTTT.InsertNoteStorage(23, FInfraredDecoy_Def.Infrared_Decoy_Index, FNote);
  end;

  UpdateInfraredDecoyList;
end;

procedure TfrmAvailableInfraredDecoy.btnEditClick(Sender: TObject);
begin
  if lstInfraredDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Infrared Decoy ... !');
    Exit;
  end;

  frmSummaryInfraredDecoy := TfrmSummaryInfraredDecoy.Create(Self);
  try
    with frmSummaryInfraredDecoy do
    begin
      SelectedInfraredDecoy := FSelectedInfraredDecoy;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryInfraredDecoy.Free;
  end;

  if FUpdateList then
    UpdateInfraredDecoyList;
end;

procedure TfrmAvailableInfraredDecoy.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstInfraredDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Infrared Decoy ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedInfraredDecoy.FInfraredDecoy_Def do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(4, Infrared_Decoy_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(23, Infrared_Decoy_Index);

      if dmTTT.DeleteInfraredDecoyDef(Infrared_Decoy_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateInfraredDecoyList;
  end;
end;

procedure TfrmAvailableInfraredDecoy.btnUsageClick(Sender: TObject);
begin
  if lstInfraredDecoy.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Infrared Decoy ... !');
    Exit;
  end;

  with frmUsage do
  begin
    UId := FSelectedInfraredDecoy.FInfraredDecoy_Def.Infrared_Decoy_Index;
    name_usage := FSelectedInfraredDecoy.FInfraredDecoy_Def.Infrared_Decoy_Identifier;
    usage_title := 'On Board Vehicle:';
    UIndex := 19;

    ShowModal;
  end;
end;

procedure TfrmAvailableInfraredDecoy.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateInfraredDecoyList
  end;
end;

procedure TfrmAvailableInfraredDecoy.lbSingleClick(Sender: TObject);
begin
  if lstInfraredDecoy.ItemIndex = -1 then
    Exit;

  FSelectedInfraredDecoy := TInfrared_Decoy_On_Board(lstInfraredDecoy.Items.Objects[lstInfraredDecoy.ItemIndex]);
end;

procedure TfrmAvailableInfraredDecoy.UpdateInfraredDecoyList;
var
  i : Integer;
  infrareddecoy : TInfrared_Decoy_On_Board;
begin
  lstInfraredDecoy.Items.Clear;

//  dmTTT.GetAllInfraredDecoyDef(FInfraredDecoyList);
  dmTTT.GetFilterInfraredDecoyDef(FInfraredDecoyList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FInfraredDecoyList.Count;

  for i := 0 to FInfraredDecoyList.Count - 1 do
  begin
    infrareddecoy := FInfraredDecoyList.Items[i];
    lstInfraredDecoy.Items.AddObject(infrareddecoy.FInfraredDecoy_Def.Infrared_Decoy_Identifier, infrareddecoy);
    frmProgress.increase(infrareddecoy.FInfraredDecoy_Def.Infrared_Decoy_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
