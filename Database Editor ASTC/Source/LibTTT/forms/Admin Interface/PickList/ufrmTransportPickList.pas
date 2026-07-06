unit ufrmTransportPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  uDBAsset_Transport ,uDBAssetObject, uSimContainers ;

type
  TfrmTransportPickList = class(TForm)
    lstAvailableTransport: TListBox;
    pnlMainBackground: TPanel;
    pnl2ControlPage: TPanel;
    imgBackground: TImage;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnl1Header: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lstAvailableTransportClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);

  private
    FSelectedTransportId : Integer;

    FTransportList : TList;
    FSelectedTransport : TTransport;

    procedure UpdateTransportList;

  public
    property SelectedTransportId : Integer read FSelectedTransportId write FSelectedTransportId;
  end;

var
  frmTransportPickList: TfrmTransportPickList;

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

procedure TfrmTransportPickList.FormCreate(Sender: TObject);
begin
  FTransportList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmTransportPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FTransportList);
end;

procedure TfrmTransportPickList.FormShow(Sender: TObject);
begin
  UpdateTransportList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmTransportPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableTransport.ItemIndex = -1 then
    Exit;

  FSelectedTransportId := FSelectedTransport.FData.Transport_Index;
  Close;

end;

procedure TfrmTransportPickList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTransportPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTransportList
  end;
end;

procedure TfrmTransportPickList.lstAvailableTransportClick(Sender: TObject);
begin
  if lstAvailableTransport.ItemIndex = -1 then
    Exit;

  FSelectedTransport := TTransport(lstAvailableTransport.Items.Objects[lstAvailableTransport.ItemIndex]);
end;

procedure TfrmTransportPickList.UpdateTransportList;
var
  i : Integer;
  transport : TTransport;
begin
  lstAvailableTransport.Items.Clear;

//  dmTTT.GetAllTransportDef(FTransportList);
  dmTTT.GetFilterTransportDef(FTransportList, edtSearch.Text);

  for i := 0 to FTransportList.Count - 1 do
  begin
    transport := FTransportList.Items[i];

    lstAvailableTransport.Items.AddObject(transport.FData.Transport_Identifier, transport);

  end;
end;

{$ENDREGION}

end.
