unit ufrmAvailableSNRvsPOD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uSimContainers, newClassASTT;

type
  TfrmAvailableSNRvsPOD = class(TForm)
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
    lstSNRvsPOD: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbSingleClick(Sender: TObject);

    procedure imgNewClick(Sender: TObject);
    procedure imgCopyClick(Sender: TObject);
    procedure imgEditClick(Sender: TObject);
    procedure imgDeleteClick(Sender: TObject);
    procedure imgUsageClick(Sender: TObject);

    procedure btnCloseClick(Sender: TObject);
    procedure edtsnrpodlistKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);

  private
    FUpdateList : Boolean;
    FSNRvsPODList : TList;
    FSelectedSNRvsPOD : TPOD_vs_SNR_Curve_Definition;

    procedure UpdateSNRvsPODList;
    procedure CopyPODvsSNRPoint(const aDefaultIndex, aNewDefaultIndex: Integer);
  end;

var
  frmAvailableSNRvsPOD: TfrmAvailableSNRvsPOD;

implementation

uses
  uDataModuleTTT, ufrmSummarySnrVsPod, ufrmUsage, ufProgress;
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

procedure TfrmAvailableSNRvsPOD.FormCreate(Sender: TObject);
begin
  FSNRvsPODList := TList.Create;
  EnableComposited(pnlMainTable);
end;

procedure TfrmAvailableSNRvsPOD.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSNRvsPODList);
end;

procedure TfrmAvailableSNRvsPOD.FormShow(Sender: TObject);
begin
  UpdateSNRvsPODList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmAvailableSNRvsPOD.imgNewClick(Sender: TObject);
begin
  frmSummarySnrVsPod := TfrmSummarySnrVsPod.Create(Self);
  try
    with frmSummarySnrVsPod do
    begin
      SelectedSNRvsPOD := TPOD_vs_SNR_Curve_Definition.Create;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummarySnrVsPod.Free;
  end;

  if FUpdateList then
    UpdateSNRvsPODList;
end;

procedure TfrmAvailableSNRvsPOD.imgCopyClick(Sender: TObject);
var
  newClassName : string;
  count, parentIndex : Integer;
begin
  if lstSNRvsPOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data SNR vs POD Curve ... ');
    Exit;
  end;

  with FSelectedSNRvsPOD do
  begin
    parentIndex := FData.Curve_Definition_Index;
    newClassName := FData.Curve_Definition_Identifier + ' - Copy';

    count := dmTTT.GetPODvsSNRCurveDef(newClassName);

    if count > 0 then
      newClassName := newClassName + ' (' + IntToStr(count + 1) + ')';

    FData.Curve_Definition_Identifier := newClassName;

    dmTTT.InsertPODvsSNRCurveDef(FData);
    CopyPODvsSNRPoint(parentIndex, FData.Curve_Definition_Index);
  end;

  UpdateSNRvsPODList;
end;

procedure TfrmAvailableSNRvsPOD.imgEditClick(Sender: TObject);
begin
  if lstSNRvsPOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data SNR vs POD Curve ... !');
    Exit;
  end;

  frmSummarySnrVsPod := TfrmSummarySnrVsPod.Create(Self);
  try
    with frmSummarySnrVsPod do
    begin
      SelectedSNRvsPOD := FSelectedSNRvsPOD;
      ShowModal;
      FUpdateList := AfterClose;
    end;

  finally
    frmSummarySnrVsPod.Free;
  end;

  if FUpdateList then
    UpdateSNRvsPODList;
end;

procedure TfrmAvailableSNRvsPOD.imgDeleteClick(Sender: TObject);
var
  warning : Integer;
  tempList: TList;

begin
  if lstSNRvsPOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data SNR vs POD Curve ... !');
    Exit;
  end;

  warning := MessageDlg('Apakah anda akan menghapus data ini ?', mtConfirmation,
    mbOKCancel, 0);

  if warning = mrOK then
  begin
    with FSelectedSNRvsPOD.FData do
    begin
      tempList := TList.Create;

      if dmTTT.GetRadarByPOD_vs_SNR(Curve_Definition_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Radar Definition');
        tempList.Free;
        Exit;
      end;

      if dmTTT.GetSonarByPOD_vs_SNR(Curve_Definition_Index, tempList) then
      begin
        ShowMessage('Data tidak bisa dihapus, karena sedang terhubung dengan data Sonar Definition');
        tempList.Free;
        Exit;
      end;
      tempList.Free;

      dmTTT.DeletePODvsSNRCurvePoint(1, Curve_Definition_Index);

      if dmTTT.DeletePODvsSNRCurveDef(Curve_Definition_Index) then
        ShowMessage('Data telah berhasil dihapus');

    end;

    UpdateSNRvsPODList;
  end;
end;

procedure TfrmAvailableSNRvsPOD.imgUsageClick(Sender: TObject);
begin
  if lstSNRvsPOD.ItemIndex = -1 then
  begin
    ShowMessage('Silahkan pilih salah satu data SNR vs POD Curve ... !');
    Exit;
  end;

  frmUsage := TfrmUsage.Create(Self);
  try
    with frmUsage do
    begin
      UId := FSelectedSNRvsPOD.FData.Curve_Definition_Index;
      name_usage := FSelectedSNRvsPOD.FData.Curve_Definition_Identifier;
      UIndex := 38;

      ShowModal;
    end;
  finally
    frmUsage.Free;
  end;
  
end;

procedure TfrmAvailableSNRvsPOD.CopyPODvsSNRPoint(const aDefaultIndex, aNewDefaultIndex: Integer);
var
  PODvsSNRPointList : TList;
  i : Integer;
  PODvsSNRPoint : TPOD_vs_SNR_Point;
begin
  PODvsSNRPointList := TList.Create;

  dmTTT.GetPODvsSNRCurvePoint(aDefaultIndex, PODvsSNRPointList);

  for i := 0 to PODvsSNRPointList.Count - 1 do
  begin
    PODvsSNRPoint := PODvsSNRPointList.Items[i];

    with PODvsSNRPoint do
    begin
      FData.Curve_Definition_Index := aNewDefaultIndex;

      dmTTT.InsertPODvsSNRCurvePoint(FData);
    end;
  end;

  for i := 0 to PODvsSNRPointList.Count - 1 do
  begin
    PODvsSNRPoint := PODvsSNRPointList.Items[i];
    PODvsSNRPoint.Free;
  end;

  PODvsSNRPointList.Free;
end;

procedure TfrmAvailableSNRvsPOD.edtsnrpodlistKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSNRvsPODList
  end;
end;

procedure TfrmAvailableSNRvsPOD.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmAvailableSNRvsPOD.lbSingleClick(Sender: TObject);
begin
  if lstSNRvsPOD.ItemIndex = -1 then
    Exit;

  FSelectedSNRvsPOD := TPOD_vs_SNR_Curve_Definition(lstSNRvsPOD.Items.Objects[lstSNRvsPOD.ItemIndex]);
end;

procedure TfrmAvailableSNRvsPOD.UpdateSNRvsPODList;
var
  i : Integer;
  snrvspod : TPOD_vs_SNR_Curve_Definition;

begin
  lstSNRvsPOD.Items.Clear;

  dmTTT.GetfilterPODvsSNRCurveDef(FSNRvsPODList,edtSearch.text);

  frmProgress := TfrmProgress.Create(nil);
  frmProgress.Caption := 'Loading data from database';
  frmProgress.MaxJob := FSNRvsPODList.Count;

  for i := 0 to FSNRvsPODList.Count - 1 do
  begin
    snrvspod := FSNRvsPODList.Items[i];
    lstSNRvsPOD.Items.AddObject(snrvspod.FData.Curve_Definition_Identifier, snrvspod);
  end;
  frmProgress.Free;

end;

{$ENDREGION}

end.
