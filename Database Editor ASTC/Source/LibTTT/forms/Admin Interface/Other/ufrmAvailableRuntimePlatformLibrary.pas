unit ufrmAvailableRuntimePlatformLibrary;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, uDBAsset_Runtime_Platform_Library;

type
  TfrmAvailableRuntimePlatformLibrary = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    pnlTableList: TPanel;
    lstRuntimePlatformLibrary: TListBox;
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
    FRuntimePlatformLibraryList : TList;
    FSelectedRuntimePlatformLibrary : TRuntime_Platform_Library;

     procedure UpdateRPLList;
     procedure CopyPlatfromLibraryEntry(const aLibraryIndex,aNewLibraryIndex: Integer);
  end;

var
  frmAvailableRuntimePlatformLibrary: TfrmAvailableRuntimePlatformLibrary;

implementation

uses
  uDataModuleTTT, ufrmSummaryRuntimePlatform, ufrmUsage, ufProgress, uSimContainers;

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

procedure TfrmAvailableRuntimePlatformLibrary.FormCreate(Sender: TObject);
begin
  FRuntimePlatformLibraryList := TList.Create;

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableRuntimePlatformLibrary.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FRuntimePlatformLibraryList);
end;

procedure TfrmAvailableRuntimePlatformLibrary.FormShow(Sender: TObject);
begin
  UpdateRPLList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableRuntimePlatformLibrary.btnNewClick(Sender: TObject);
begin
    frmSummaryRuntimePlatform := TfrmSummaryRuntimePlatform.Create(Self);
  try
    with frmSummaryRuntimePlatform do
    begin
      SelectedRPL := TRuntime_Platform_Library.Create;
      ShowModal;
      SelectedRPL.Free;

      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryRuntimePlatform.Free;
  end;

  if FUpdateList then
    UpdateRPLList;
end;

procedure TfrmAvailableRuntimePlatformLibrary.btnCopyClick(Sender: TObject);
var
  newClassName : string;
  count, parentIndex : Integer;
begin
  with FSelectedRuntimePlatformLibrary do
  begin
    parentIndex := FData.Platform_Library_Index;
    newClassName := FData.Library_Name + ' - Copy';

    count := dmTTT.GetRuntimePlatformLibraryDef(newClassName);

    if count > 0 then
    newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Library_Name := newClassName;

    dmTTT.InsertRuntimePlatformLibraryDef(FData);
    CopyPlatfromLibraryEntry(parentIndex, FData.Platform_Library_Index);
  end;

  UpdateRPLList;
end;

procedure TfrmAvailableRuntimePlatformLibrary.btnEditClick(Sender: TObject);
begin
  if lstRuntimePlatformLibrary.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Runtime Platfor Library ... !');
    Exit;
  end;

  frmSummaryRuntimePlatform := TfrmSummaryRuntimePlatform.Create(Self);
  try
    with frmSummaryRuntimePlatform do
    begin
      SelectedRPL := FSelectedRuntimePlatformLibrary;
      ShowModal;
      FUpdateList := AfterClose;
    end;
  finally
    frmSummaryRuntimePlatform.Free;
  end;

  if FUpdateList then
    UpdateRPLList;
end;

procedure TfrmAvailableRuntimePlatformLibrary.btnDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;
begin
  if lstRuntimePlatformLibrary.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Runtime Platfor Library ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,mbOKCancel, 0);

  if warning = mrOK then
  begin
    tempList := TList.Create;

    with FSelectedRuntimePlatformLibrary.FData do
    begin
      if dmTTT.GetRPLAtResourceAllocation(Platform_Library_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data vehicle');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      dmTTT.DeletePlatformLibraryEntry(1, Platform_Library_Index);

      if dmTTT.DeleteRuntimePlatformLibraryDef(Platform_Library_Index) then
        ShowMessage('Data telah berhasil dihapus');
    end;

    UpdateRPLList;
  end;
end;

procedure TfrmAvailableRuntimePlatformLibrary.btnUsageClick(Sender: TObject);
begin
  if lstRuntimePlatformLibrary.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Runtime Platfor Library ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedRuntimePlatformLibrary.FData.Platform_Library_Index;
      name_usage := FSelectedRuntimePlatformLibrary.FData.Library_Name;
      usage_title := 'On Scenario : ';
      UIndex := 26;
      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
end;

procedure TfrmAvailableRuntimePlatformLibrary.lbSingleClick(Sender: TObject);
begin
  if lstRuntimePlatformLibrary.ItemIndex = -1 then
    Exit;

  FSelectedRuntimePlatformLibrary := TRuntime_Platform_Library(lstRuntimePlatformLibrary.Items.Objects[lstRuntimePlatformLibrary.ItemIndex]);
end;

procedure TfrmAvailableRuntimePlatformLibrary.UpdateRPLList;
var
  i : Integer;
  runtimeplatformlibrary : TRuntime_Platform_Library;
begin
  lstRuntimePlatformLibrary.Items.Clear;

//  dmTTT.GetAllRuntimePlatformLibraryDef(FRuntimePlatformLibraryList);
  dmTTT.GetFilterRuntimePlatformLibraryDef(FRuntimePlatformLibraryList, edtSearch.Text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FRuntimePlatformLibraryList.Count;

  for i := 0 to FRuntimePlatformLibraryList.Count - 1 do
  begin
    runtimeplatformlibrary := FRuntimePlatformLibraryList.Items[i];
    lstRuntimePlatformLibrary.Items.AddObject(runtimeplatformlibrary.FData.Library_Name, runtimeplatformlibrary);
    frmProgress.increase(runtimeplatformlibrary.FData.Library_Name);
  end;
  frmProgress.Free;
end;

procedure TfrmAvailableRuntimePlatformLibrary.CopyPlatfromLibraryEntry(const aLibraryIndex, aNewLibraryIndex: Integer);
var
  libraryPlatformList : TList;
  i, j : Integer;
  platLibEntry : TPlatform_Library_Entry;
begin
  libraryPlatformList := TList.Create;

  for i := 0 to 4 do
  begin
    case i of
      0: dmTTT.GetAllVehiclePlatformLibraryEntry(aLibraryIndex, libraryPlatformList);
      1: dmTTT.GetAllMissilePlatformLibraryEntry(aLibraryIndex, libraryPlatformList);
      2: dmTTT.GetAllTorpedoPlatformLibraryEntry(aLibraryIndex, libraryPlatformList);
      3: dmTTT.GetAllSonobuoyPlatformLibraryEntry(aLibraryIndex, libraryPlatformList);
      4: dmTTT.GetAllMinePlatformLibraryEntry(aLibraryIndex, libraryPlatformList);
    end;

    for j := 0 to libraryPlatformList.Count - 1 do
    begin
      platLibEntry := libraryPlatformList.Items[j];

      with platLibEntry do
      begin
        FData.Library_Index := aNewLibraryIndex;

        dmTTT.InsertPlatformLibraryEntry(FData);
      end;
    end;

    for j := 0 to libraryPlatformList.Count - 1 do
    begin
      platLibEntry := libraryPlatformList.Items[j];
      platLibEntry.Free;
    end;

    libraryPlatformList.Clear;
  end;

  libraryPlatformList.Free;
end;

procedure TfrmAvailableRuntimePlatformLibrary.edtSearchChange(Sender: TObject);
var
  i : Integer;
  runtimeplatformlibrary : TRuntime_Platform_Library;
begin
  lstRuntimePlatformLibrary.Items.Clear;

//  dmTTT.GetAllRuntimePlatformLibraryDef(FRuntimePlatformLibraryList);
  dmTTT.GetFilterRuntimePlatformLibraryDef(FRuntimePlatformLibraryList, edtSearch.Text);

  for i := 0 to FRuntimePlatformLibraryList.Count - 1 do
  begin
    runtimeplatformlibrary := FRuntimePlatformLibraryList.Items[i];
    lstRuntimePlatformLibrary.Items.AddObject(runtimeplatformlibrary.FData.Library_Name, runtimeplatformlibrary);
  end;
end;

procedure TfrmAvailableRuntimePlatformLibrary.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateRPLList
  end;
end;

{$ENDREGION}

end.
