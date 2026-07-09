unit ufrmAvailableRadarNoiseJammer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,Vcl.ExtCtrls,

  uDBAsset_Countermeasure, uSimContainers;

type
  TfrmAvailableRadarNoiseJammer = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstRadarNoiseJammer: TListBox;
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
   FRadarNoiseJammerList : TList;
   FSelectedRadarNoiseJammer : TRadar_Noise_Jammer_On_Board;

    procedure UpdateRadarNoiseJammerList;

   end;

var
  frmAvailableRadarNoiseJammer: TfrmAvailableRadarNoiseJammer;

implementation

uses
  uDataModuleTTT, ufrmSummaryRadarNoiseJammer, ufrmUsage, ufProgress;

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

procedure TfrmAvailableRadarNoiseJammer.FormCreate(Sender: TObject);
begin
  FRadarNoiseJammerList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableRadarNoiseJammer.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FRadarNoiseJammerList);
end;

procedure TfrmAvailableRadarNoiseJammer.FormShow(Sender: TObject);
begin
  UpdateRadarNoiseJammerList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableRadarNoiseJammer.btnNewClick(Sender: TObject);
begin
  frmSummaryRadarNoiseJammer := TfrmSummaryRadarNoiseJammer.Create(Self);
  try
    with frmSummaryRadarNoiseJammer do
    begin
      SelectedRadarJammer := TRadar_Noise_Jammer_On_Board.Create;
      ShowModal;
      SelectedRadarJammer.Free;

      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryRadarNoiseJammer.Free;
  end;

  if FUpdateList then
    UpdateRadarNoiseJammerList;
end;

procedure TfrmAvailableRadarNoiseJammer.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;

begin
  if lstRadarNoiseJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar Noise Jammer... !');
    Exit;
  end;

  with FSelectedRadarNoiseJammer do
  begin
    newClassName := FDef.Jammer_Identifier + ' - Copy';

    count := dmTTT.GetRadarNoiseJammerDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FDef.Jammer_Identifier := newClassName;

    dmTTT.InsertRadarNoiseJammerDef(FDef);
    dmTTT.InsertNoteStorage(15, FDef.Jammer_Index, FNote);
  end;

  UpdateRadarNoiseJammerList;
end;

procedure TfrmAvailableRadarNoiseJammer.btnEditClick(Sender: TObject);
begin
  if lstRadarNoiseJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar Noise Jammer... !');
    Exit;
  end;

  frmSummaryRadarNoiseJammer := TfrmSummaryRadarNoiseJammer.Create(Self);
  try
    with frmSummaryRadarNoiseJammer do
    begin
      SelectedRadarJammer := FSelectedRadarNoiseJammer;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryRadarNoiseJammer.Free;
  end;

  if FUpdateList then
    UpdateRadarNoiseJammerList;
end;

procedure TfrmAvailableRadarNoiseJammer.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
begin
  if lstRadarNoiseJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar Noise Jammer... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedRadarNoiseJammer.FDef do
    begin
      if dmTTT.GetCountermeasure_On_Board_By_Index(8, Jammer_Index) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        Exit;
      end;

      dmTTT.DeleteNoteStorage(15, Jammer_Index);

      if dmTTT.DeleteRadarNoiseJammerDef(Jammer_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateRadarNoiseJammerList;
  end;
end;

procedure TfrmAvailableRadarNoiseJammer.btnUsageClick(Sender: TObject);
begin
  if lstRadarNoiseJammer.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Radar Noise Jammer... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedRadarNoiseJammer.FDef.Jammer_Index;
      name_usage := FSelectedRadarNoiseJammer.FDef.Jammer_Identifier;
      usage_title := 'On Board Vehicle:';
      UIndex := 18;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end
end;

procedure TfrmAvailableRadarNoiseJammer.edtSearchChange(Sender: TObject);
var
  i : Integer;
  radarnoisejammer : TRadar_Noise_Jammer_On_Board;
begin
  lstRadarNoiseJammer.Items.Clear;

//  dmTTT.GetAllRadarNoiseJammerDef(FRadarNoiseJammerList);
  dmTTT.GetFilterRadarNoiseJammerDef(FRadarNoiseJammerList, edtSearch.Text);

  for i := 0 to FRadarNoiseJammerList.Count - 1 do
  begin
    radarnoisejammer := FRadarNoiseJammerList.Items[i];
    lstRadarNoiseJammer.Items.AddObject(radarnoisejammer.FDef.Jammer_Identifier, radarnoisejammer);
  end;
end;

procedure TfrmAvailableRadarNoiseJammer.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateRadarNoiseJammerList
  end;
end;

procedure TfrmAvailableRadarNoiseJammer.lbSingleClick(Sender: TObject);
begin
  if lstRadarNoiseJammer.ItemIndex = -1 then
    Exit;

  FSelectedRadarNoiseJammer := TRadar_Noise_Jammer_On_Board(lstRadarNoiseJammer.Items.Objects[lstRadarNoiseJammer.ItemIndex]);
end;

procedure TfrmAvailableRadarNoiseJammer.UpdateRadarNoiseJammerList;
var
  i : Integer;
  radarnoisejammer : TRadar_Noise_Jammer_On_Board;
begin
  lstRadarNoiseJammer.Items.Clear;

//  dmTTT.GetAllRadarNoiseJammerDef(FRadarNoiseJammerList);
  dmTTT.GetFilterRadarNoiseJammerDef(FRadarNoiseJammerList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FRadarNoiseJammerList.Count;

  for i := 0 to FRadarNoiseJammerList.Count - 1 do
  begin
    radarnoisejammer := FRadarNoiseJammerList.Items[i];
    lstRadarNoiseJammer.Items.AddObject(radarnoisejammer.FDef.Jammer_Identifier, radarnoisejammer);
    frmProgress.increase(radarnoisejammer.FDef.Jammer_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
