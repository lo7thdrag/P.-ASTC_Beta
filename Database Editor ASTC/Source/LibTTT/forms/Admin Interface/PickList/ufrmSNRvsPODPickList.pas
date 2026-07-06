unit ufrmSNRvsPODPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage,
  newClassASTT, uSimContainers;

type
  TfrmSNRvsPODPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lstAvailableSNRvsPOD: TListBox;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lstAvailableSNRvsPODClick(Sender: TObject);
    procedure lstAvailableSNRvsPODDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FSelectedPODvsSNRId : Integer;

    FSNRvsPODList : TList;
    FSelectedPODvsSNR : TPOD_vs_SNR_Curve_Definition;

    procedure UpdateSNRvsPODList;
  public
    property SelectedPODvsSNRId : Integer read FSelectedPODvsSNRId
      write FSelectedPODvsSNRId;
  end;

var
  frmSNRvsPODPickList: TfrmSNRvsPODPickList;

implementation

uses
  uDataModuleTTT ;

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

procedure TfrmSNRvsPODPickList.FormCreate(Sender: TObject);
begin
  FSNRvsPODList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSNRvsPODPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSNRvsPODList);
end;

procedure TfrmSNRvsPODPickList.FormShow(Sender: TObject);
begin
  UpdateSNRvsPODList;
end;


{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSNRvsPODPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableSNRvsPOD.ItemIndex = -1 then
    Exit;

  FSelectedPODvsSNRId := FSelectedPODvsSNR.FData.Curve_Definition_Index;
  Close;
end;

procedure TfrmSNRvsPODPickList.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmSNRvsPODPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSNRvsPODList
  end;
end;

procedure TfrmSNRvsPODPickList.lstAvailableSNRvsPODClick(Sender: TObject);
begin
  if lstAvailableSNRvsPOD.ItemIndex = -1 then
    Exit;

  FSelectedPODvsSNR := TPOD_vs_SNR_Curve_Definition(
    lstAvailableSNRvsPOD.Items.Objects[lstAvailableSNRvsPOD.ItemIndex]);
end;

procedure TfrmSNRvsPODPickList.lstAvailableSNRvsPODDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmSNRvsPODPickList.UpdateSNRvsPODList;
var
  i : Integer;
  snrVSpod : TPOD_vs_SNR_Curve_Definition;
begin
  lstAvailableSNRvsPOD.Items.Clear;

//  dmTTT.GetAllPODvsSNRCurveDef(FSNRvsPODList);
  dmTTT.GetFilterPODvsSNRCurveDef(FSNRvsPODList, edtSearch.Text);

  for i := 0 to FSNRvsPODList.Count - 1 do
  begin
    snrVSpod := FSNRvsPODList.Items[i];

    if snrVSpod.FData.Curve_Definition_Index <> FSelectedPODvsSNRId then
      lstAvailableSNRvsPOD.Items.AddObject(snrVSpod.FData.Curve_Definition_Identifier, snrVSpod);

  end;
end;

{$ENDREGION}

end.
