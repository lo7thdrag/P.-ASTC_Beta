unit ufrmAvailableOverlay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  newClassASTT, uSimContainers;

type
  TfrmAvailableOverlay = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstGrapicalOverlays: TListBox;
    pnlTableButton: TPanel;
    btnDelete: TImage;
    btnEdit: TImage;
    btnCopy: TImage;
    btnNew: TImage;
    btnUsage: TImage;
    Label1: TLabel;
    edtSearch: TEdit;
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
    FOverlayList : TList;
    FSelectedOverlay : TOverlay_Definition;

    procedure UpdateOverlayList;
    procedure CopyOverlayFileStream(fFile: String);
  end;

var
  frmAvailableOverlay: TfrmAvailableOverlay;

implementation

uses
  uDataModuleTTT, ufrmSummaryOverlay, ufrmUsage, uDBEditSetting, ufProgress;

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

procedure TfrmAvailableOverlay.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FOverlayList);

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableOverlay.FormShow(Sender: TObject);
begin
  UpdateOverlayList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableOverlay.btnNewClick(Sender: TObject);
begin

 frmSummaryOverlay := TfrmSummaryOverlay.Create(Self);
  try
    with frmSummaryOverlay do
    begin
      SelectedOverlay := TOverlay_Definition.Create;
      ShowModal;
      FUpdateList := AfterClose;
      SelectedOverlay.Free;
    end;
  finally
    frmSummaryOverlay.Free;
  end;

  if FUpdateList then
    UpdateOverlayList;
end;

procedure TfrmAvailableOverlay.btnCopyClick(Sender: TObject);
var
  SourcePath, TargetPath : string;
  newClassName, oldClassName : string;
  count : Integer;
begin
  if lstGrapicalOverlays.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Overlay ... !');
    Exit;
  end;

  with FSelectedOverlay do
  begin
    oldClassName := FData.Overlay_Identifier;
    newClassName := FData.Overlay_Identifier + ' - Copy';

    count := dmTTT.GetOverlayDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Overlay_Identifier := newClassName;
    FData.Name := newClassName;

    dmTTT.InsertOverlayDef(FData);
//    CopyOverlayFileStream(vAppDBSetting.OverlayPath + '\' + FData.Overlay_Filename + '.dat');

    {$REGION ' Copy file Overlay '}
    SourcePath := vAppDBSetting.OverlayPath + '\'+ oldClassName + '.dat' ;
    TargetPath := vAppDBSetting.OverlayPath + '\'+ newClassName + '.dat' ;

    CopyFile(PChar(SourcePath), PChar(TargetPath), True);
    {$ENDREGION}

  end;

  UpdateOverlayList;
end;

procedure TfrmAvailableOverlay.btnEditClick(Sender: TObject);
begin
  if lstGrapicalOverlays.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Overlay ... !');
    Exit;
  end;

  frmSummaryOverlay := TfrmSummaryOverlay.Create(Self);
  try
    with frmSummaryOverlay do
    begin
      SelectedOverlay := FSelectedOverlay;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryOverlay.Free;
  end;

  if FUpdateList then
    UpdateOverlayList;
end;

procedure TfrmAvailableOverlay.btnDeleteClick(Sender: TObject);
var
  warning, i : Integer;
  tempList : TList;
begin
  if lstGrapicalOverlays.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Overlay ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation, mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedOverlay.FData do
    begin
      {Pengecekan Relasi Dengan Tabel Resource Allocation Definition}
      tempList := TList.Create;
      if dmTTT.GetOverlayAtResourceAllocation(Overlay_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Resource Allocation');
        Exit;
        tempList.Destroy;
      end;
      tempList.Destroy;

      if dmTTT.DeleteOverlayDef(Overlay_Index) then
      begin
        DeleteFile(vAppDBSetting.OverlayPath + '\' + FSelectedOverlay.FData.Name + '.dat');
        ShowMessage('Data telah berhasil dihapus');
      end;
    end;

    UpdateOverlayList;
  end;
end;

procedure TfrmAvailableOverlay.btnUsageClick(Sender: TObject);
begin
  if lstGrapicalOverlays.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Overlay ... !');
    Exit;
  end;

  with frmUsage do
  begin
    UId := FSelectedOverlay.FData.Overlay_Index;
    name_usage := FSelectedOverlay.FData.Overlay_Identifier;
    UIndex := 35;

    ShowModal;
  end;
end;

procedure TfrmAvailableOverlay.CopyOverlayFileStream(fFile: String);
var
     Fs : TFileStream;
begin

  try
    Fs := TFileStream.Create(fFile, fmOPENWRITE or fmCREATE);
  except
     Showmessage('Couldn''t save file overlay!' + #13);
  end;
  Fs.Free;  // << this actually writes the data to disk
end;

procedure TfrmAvailableOverlay.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateOverlayList
  end;
end;

procedure TfrmAvailableOverlay.lbSingleClick(Sender: TObject);
begin
  if lstGrapicalOverlays.ItemIndex = -1 then
    Exit;
  FSelectedOverlay := TOverlay_Definition(lstGrapicalOverlays.Items.Objects[lstGrapicalOverlays.ItemIndex]);
end;

procedure TfrmAvailableOverlay.UpdateOverlayList;
var
  i : Integer;
  overlay : TOverlay_Definition;
begin
  lstGrapicalOverlays.Items.Clear;

//  dmTTT.GetAllOverlayDef(FOverlayList);
  dmTTT.GetFilterOverlayDef(FOverlayList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FOverlayList.Count;

  for i := 0 to FOverlayList.Count - 1 do
  begin
    overlay := FOverlayList.Items[i];
    lstGrapicalOverlays.Items.AddObject(overlay.FData.Overlay_Identifier, overlay);
    frmProgress.increase(overlay.FData.Overlay_Identifier);
  end;
  frmProgress.Free;
end;

{$ENDREGION}

end.
