unit ufrmResorceAllocationPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAssetObject, Vcl.Imaging.pngimage, uSimContainers;

type
  TfrmResorceAllocationPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lbAvailableResAlloc: TListBox;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAvailableResAllocClick(Sender: TObject);
    procedure lbAvailableResAllocDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FSelectedResourceAllocId : Integer;

    FResourceAllocList : TList;
    FSelectedResourceAlloc : TResource_Allocation;

    procedure UpdateResourceAllocList;

  public
    property SelectedResourceAllocId : Integer read FSelectedResourceAllocId
      write FSelectedResourceAllocId;
  end;

var
  frmResorceAllocationPickList: TfrmResorceAllocationPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryResourceAllocation;

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

procedure TfrmResorceAllocationPickList.FormCreate(Sender: TObject);
begin
  FResourceAllocList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmResorceAllocationPickList.FormDestroy(Sender: TObject);
begin
//  if Assigned(FSelectedResourceAlloc) then
//    FreeAndNil(FSelectedResourceAlloc);

  FreeItemsAndFreeList(FResourceAllocList);
end;

procedure TfrmResorceAllocationPickList.FormShow(Sender: TObject);
begin
  UpdateResourceAllocList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmResorceAllocationPickList.btnAddClick(Sender: TObject);
begin
  if lbAvailableResAlloc.ItemIndex = -1 then
    Exit;

  FSelectedResourceAllocId := FSelectedResourceAlloc.FData.Resource_Alloc_Index;
  Close;

end;

procedure TfrmResorceAllocationPickList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmResorceAllocationPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateResourceAllocList;
  end;

end;

procedure TfrmResorceAllocationPickList.lbAvailableResAllocClick(Sender: TObject);
begin
  if lbAvailableResAlloc.ItemIndex = -1 then
    Exit;

  FSelectedResourceAlloc := TResource_Allocation(lbAvailableResAlloc.Items.Objects[lbAvailableResAlloc.ItemIndex]);
end;

procedure TfrmResorceAllocationPickList.lbAvailableResAllocDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmResorceAllocationPickList.UpdateResourceAllocList;
var
  i : Integer;
  resAlloc : TResource_Allocation;
begin
  lbAvailableResAlloc.Items.Clear;

  dmTTT.GetAllResourceAllocationDef(FResourceAllocList);
//  dmTTT.GetFilterResurceAllocationDef(FResourceAllocList, edtSearch.Text);

  for i := 0 to FResourceAllocList.Count - 1 do
  begin
    resAlloc := FResourceAllocList.Items[i];

    lbAvailableResAlloc.Items.AddObject(resAlloc.FData.Allocation_Identifier, resAlloc);
  end;
end;

{$ENDREGION}

end.
