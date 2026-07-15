unit ufrmAvailableWaypoint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,

  uDBAssetObject, uSimContainers;

type
  TfrmAvailableWaypoint = class(TForm)
    pnlMainTable: TPanel;
    pnlTableHeader: TPanel;
    lbl1: TLabel;
    pnlTableButton: TPanel;
    imgDelete: TImage;
    imgEdit: TImage;
    imgCopy: TImage;
    imgNew: TImage;
    imgUsage: TImage;
    lbl2: TLabel;
    edtSearch: TEdit;
    pnlTableList: TPanel;
    lstWaypoint: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure imgNewClick(Sender: TObject);
    procedure imgCopyClick(Sender: TObject);
    procedure imgEditClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure imgUsageClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtwaypointlistKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);

  private
    FUpdateList : Boolean;
    FWaypointList : TList;
    FSelectedWaypoint : TWaypoint_Def;

    procedure UpdateWaypointList;
  end;

var
  frmAvailableWaypoint: TfrmAvailableWaypoint;

implementation

uses
  uDataModuleTTT, ufrmSummaryWaypoint, ufrmUsage, ufProgress;

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

procedure TfrmAvailableWaypoint.FormCreate(Sender: TObject);
begin
  FWaypointList := TList.Create;
end;

procedure TfrmAvailableWaypoint.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FWaypointList);

  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableWaypoint.FormShow(Sender: TObject);
begin
  UpdateWaypointList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableWaypoint.imgNewClick(Sender: TObject);
begin
  frmSummaryWaypoint := TfrmSummaryWaypoint.Create(Self);
  try
    with frmSummaryWaypoint do
    begin
      SelectedWaypoint := TWaypoint_Def.Create;
      ShowModal;
      FUpdateList := AfterClose;
      SelectedWaypoint.Free;
    end;
  finally
    frmSummaryWaypoint.Free;
  end;

  if FUpdateList then
    UpdateWaypointList;
end;

procedure TfrmAvailableWaypoint.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmAvailableWaypoint.imgCopyClick(Sender: TObject);
var
  newClassName : string;
  count : Integer;
begin
  if lstWaypoint.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Waypoint ... !');
    Exit;
  end;

  with FSelectedWaypoint do
  begin
    newClassName := FData.Waypoint_Name + ' - Copy';

    count := dmTTT.GetWaypointDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Waypoint_Name := newClassName;

    dmTTT.InsertWaypointDef(FData);
  end;

  UpdateWaypointList;
end;

procedure TfrmAvailableWaypoint.imgEditClick(Sender: TObject);
begin
  if lstWaypoint.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Waypoint ... !');
    Exit;
  end;

  frmSummaryWaypoint := TfrmSummaryWaypoint.Create(Self);
  try
    with frmSummaryWaypoint do
    begin
      SelectedWaypoint := FSelectedWaypoint;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummaryWaypoint.Free;
  end;

  if FUpdateList then
    UpdateWaypointList;
end;

procedure TfrmAvailableWaypoint.imgDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lstWaypoint.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data waypoint !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda yakin ingin menghapus Data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedWaypoint.FData do
    begin
      tempList := TList.Create;

      {Pengecekan Relasi Dengan Resource Allocation}
      if dmTTT.GetWaypointAtResourceAllocation(Waypoint_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang digunakan di Resource Allocation');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      dmTTT.DeleteWaypointData(Waypoint_Index);

      if dmTTT.DeleteWaypointDef(Waypoint_Index) then
      begin
        ShowMessage('Data berhasil dihapus');
      end;
    end;

    UpdateWaypointList;
  end;
end;

procedure TfrmAvailableWaypoint.imgUsageClick(Sender: TObject);
begin
  if lstWaypoint.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data Waypoint ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedWaypoint.FData.Waypoint_Index;
      name_usage := FSelectedWaypoint.FData.Waypoint_Name;
      UIndex := 41;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableWaypoint.edtSearchChange(Sender: TObject);
var
  i : Integer;
  waypoint : TWaypoint_Def;

begin
  lstWaypoint.Items.Clear;

  dmTTT.GetFilterWaypointDef(FWaypointList, edtSearch.text);

  for i := 0 to FWaypointList.Count - 1 do
  begin
    waypoint := FWaypointList.Items[i];
    lstWaypoint.Items.AddObject(waypoint.FData.Waypoint_Name, waypoint);
  end;
end;

procedure TfrmAvailableWaypoint.edtwaypointlistKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateWaypointList
  end;
end;

procedure TfrmAvailableWaypoint.lbSingleClick(Sender: TObject);
begin
  if lstWaypoint.ItemIndex = -1 then
    Exit;

  FSelectedWaypoint := TWaypoint_Def(lstWaypoint.Items.Objects[lstWaypoint.ItemIndex]);
end;

procedure TfrmAvailableWaypoint.UpdateWaypointList;
var
  i : Integer;
  waypoint : TWaypoint_Def;

begin
  lstWaypoint.Items.Clear;

  dmTTT.GetFilterWaypointDef(FWaypointList, edtSearch.text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Mengisi data dari database';
  frmProgress.MaxJob := FWaypointList.Count;

  for i := 0 to FWaypointList.Count - 1 do
  begin
    waypoint := FWaypointList.Items[i];
    lstWaypoint.Items.AddObject(waypoint.FData.Waypoint_Name, waypoint);
    frmProgress.increase(waypoint.FData.Waypoint_Name);
  end;

  frmProgress.Free;
end;

{$ENDREGION}

end.
