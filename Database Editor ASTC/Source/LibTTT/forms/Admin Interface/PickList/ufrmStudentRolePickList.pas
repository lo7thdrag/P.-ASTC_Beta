unit ufrmStudentRolePickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAssetObject, Vcl.Imaging.pngimage;

type
  TfrmStudentRolePickList = class(TForm)
    pnl2ControlPage: TPanel;
    lbAllStudent: TListBox;
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

    procedure lbAllStudentClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FPickedStudenRoleId : Integer;

    FStudentRoleList : TList;
    FSelectedStudenRole : TStudent_Role_List;

    procedure UpdateStudenRoleList;
  public
    property PickedStudenRoleId : Integer read FPickedStudenRoleId
      write FPickedStudenRoleId;
  end;

var
  frmStudentRolePickList  : TfrmStudentRolePickList;


implementation

uses
  uDataModuleTTT, ufrmStudentRoleSummary, ufrmSummaryResourceAllocation, ufrmAvailableResourceAllocation,
  ufrmUsage, uSimContainers;

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

procedure TfrmStudentRolePickList.FormCreate(Sender: TObject);
begin
  FStudentRoleList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmStudentRolePickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FStudentRoleList);
end;

procedure TfrmStudentRolePickList.FormShow(Sender: TObject);
begin
  UpdateStudenRoleList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmStudentRolePickList.btnAddClick(Sender: TObject);
begin
  if lbAllStudent.ItemIndex = -1 then
    Exit;

  FPickedStudenRoleId := FSelectedStudenRole.FData.Role_List_Index;
  Close;
end;

procedure TfrmStudentRolePickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStudentRolePickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateStudenRoleList
  end;
end;

procedure TfrmStudentRolePickList.lbAllStudentClick(Sender: TObject);
begin
  if lbAllStudent.ItemIndex = -1 then
    Exit;

  FSelectedStudenRole := TStudent_Role_List(lbAllStudent.Items.Objects[lbAllStudent.ItemIndex]);
end;

procedure TfrmStudentRolePickList.UpdateStudenRoleList;
var
  roleList : TStudent_Role_List;
var
  i : Integer;
  studenRole : TStudent_Role_List;
begin
  lbAllStudent.Items.Clear;

  dmTTT.GetFilterStudentRoleDef(FStudentRoleList, edtSearch.Text);
//  dmTTT.GetStudent_Role_List(0, FStudentRoleList, roleList);

  for i := 0 to FStudentRoleList.Count - 1 do
  begin
    studenRole := FStudentRoleList.Items[i];


      lbAllStudent.Items.AddObject(
        studenRole.FData.Role_List_Identifier, studenRole);
  end;
end;

{$ENDREGION}

end.
