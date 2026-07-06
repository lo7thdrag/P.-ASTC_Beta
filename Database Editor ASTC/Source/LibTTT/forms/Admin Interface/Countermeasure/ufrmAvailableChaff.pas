unit ufrmAvailableChaff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableChaff = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstChaff: TListBox;
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
    FChaffList : TList;
    FSelectedChaff : TChaff_On_Board;

    procedure UpdateChaffList;

  end;

var
  frmAvailableChaff: TfrmAvailableChaff;

implementation

uses
  uDataModuleTTT, ufrmSummaryChaff, ufrmUsage, ufProgress;

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

procedure TfrmAvailableChaff.FormCreate(Sender: TObject);
begin
  FChaffList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableChaff.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FChaffList);
end;

procedure TfrmAvailableChaff.FormShow(Sender: TObject);
begin
  UpdateChaffList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableChaff.btnNewClick(Sender: TObject);
begin
  frmSummaryChaff := TfrmSummaryChaff.Create(Self);
  try
    with frmSummaryChaff do
    begin
      SelectedChaff := TChaff_On_Board.Create;
      ShowModal;
      SelectedChaff.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryChaff.Free;
  end;

  if FUpdateList then
    UpdateChaffList;
end;

procedure TfrmAvailableChaff.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;

begin
  if lstChaff.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Chaff ... !');
    Exit;
  end;

  with FSelectedChaff do
  begin
    newClassName := FChaff_Def.Chaff_Identifier + ' - Copy';

    count := dmTTT.GetChaffDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FChaff_Def.Chaff_Identifier := newClassName;

    dmTTT.InsertChaffDef(FChaff_Def);
    dmTTT.InsertNoteStorage(19, FChaff_Def.Chaff_Index, FNote);
  end;

  UpdateChaffList;
end;

procedure TfrmAvailableChaff.btnEditClick(Sender: TObject);
begin
  if lstChaff.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Chaff ... !');
    Exit;
  end;

  frmSummaryChaff := TfrmSummaryChaff.Create(Self);
  try
    with frmSummaryChaff do
    begin
      SelectedChaff := FSelectedChaff;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryChaff.Free;
  end;

  if FUpdateList then
    UpdateChaffList;
end;

procedure TfrmAvailableChaff.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstChaff.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Chaff ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedChaff.FChaff_Def do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(3, Chaff_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(19, Chaff_Index);

      if dmTTT.DeleteChaffDef(Chaff_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateChaffList;
  end;
end;

procedure TfrmAvailableChaff.btnUsageClick(Sender: TObject);
begin
  if lstChaff.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Chaff ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedChaff.FChaff_Def.Chaff_Index;
      name_usage := FSelectedChaff.FChaff_Def.Chaff_Identifier;
      usage_title := 'On Board Vehicle:';
      UIndex := 14;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;

end;

procedure TfrmAvailableChaff.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateChaffList
  end;
end;

procedure TfrmAvailableChaff.lbSingleClick(Sender: TObject);
begin
  if lstChaff.ItemIndex = -1 then
    Exit;

  FSelectedChaff := TChaff_On_Board(lstChaff.Items.Objects[lstChaff.ItemIndex]);
end;

procedure TfrmAvailableChaff.UpdateChaffList;
var
  i : Integer;
  chaff : TChaff_On_Board;
begin
  lstChaff.Items.Clear;

//  dmTTT.GetAllChaffDef(FChaffList);
  dmTTT.GetFilterChaffDef(FChaffList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FChaffList.Count;

  for i := 0 to FChaffList.Count - 1 do
  begin
    chaff := FChaffList.Items[i];
    lstChaff.Items.AddObject(chaff.FChaff_Def.Chaff_Identifier, chaff);
    frmProgress.increase(chaff.FChaff_Def.Chaff_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
