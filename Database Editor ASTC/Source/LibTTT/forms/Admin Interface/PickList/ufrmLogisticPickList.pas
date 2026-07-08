unit ufrmLogisticPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Logistics, uSimContainers;

type
  TfrmLogisticPickList = class(TForm)
    lstAvailableLogistic: TListBox;
    pnlMainBackground: TPanel;
    Image1: TImage;
    pnl1Header: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    pnl2ControlPage: TPanel;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lstAvailableMotionClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);

  private
    FSelectedLogisticId : Integer;

    FLogisticList : TList;
    FSelectedLogistic : TLogistics;

    procedure UpdateLogisticList;

  public
    property SelectedLogisticId : Integer read FSelectedLogisticId write FSelectedLogisticId;
  end;

var
  frmLogisticPickList: TfrmLogisticPickList;

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

procedure TfrmLogisticPickList.FormCreate(Sender: TObject);
begin
  FLogisticList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmLogisticPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FLogisticList);
end;

procedure TfrmLogisticPickList.FormShow(Sender: TObject);
begin
  UpdateLogisticList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmLogisticPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableLogistic.ItemIndex = -1 then
    Exit;

  FSelectedLogisticId := FSelectedLogistic.FData.Logistic_Index;
  Close;
end;

procedure TfrmLogisticPickList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogisticPickList.edtSearchChange(Sender: TObject);
var
  i : Integer;
  logistics : TLogistics;
begin
  lstAvailableLogistic.Items.Clear;

//  dmTTT.GetAllLogisticDef(FLogisticList);
  dmTTT.GetFilterLogisticDef(FLogisticList, edtSearch.Text);

  for i := 0 to FLogisticList.Count - 1 do
  begin
    logistics := FLogisticList.Items[i];

    lstAvailableLogistic.Items.AddObject(logistics.FData.Logistic_Identifier, logistics);

  end;
end;

procedure TfrmLogisticPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateLogisticList
  end;
end;

procedure TfrmLogisticPickList.lstAvailableMotionClick(Sender: TObject);
begin
  if lstAvailableLogistic.ItemIndex = -1 then
    Exit;

  FSelectedLogistic := TLogistics(lstAvailableLogistic.Items.Objects[lstAvailableLogistic.ItemIndex]);
end;

procedure TfrmLogisticPickList.UpdateLogisticList;
var
  i : Integer;
  logistics : TLogistics;
begin
  lstAvailableLogistic.Items.Clear;

//  dmTTT.GetAllLogisticDef(FLogisticList);
  dmTTT.GetFilterLogisticDef(FLogisticList, edtSearch.Text);

  for i := 0 to FLogisticList.Count - 1 do
  begin
    logistics := FLogisticList.Items[i];

    lstAvailableLogistic.Items.AddObject(logistics.FData.Logistic_Identifier, logistics);

  end;
end;

{$ENDREGION}

end.
