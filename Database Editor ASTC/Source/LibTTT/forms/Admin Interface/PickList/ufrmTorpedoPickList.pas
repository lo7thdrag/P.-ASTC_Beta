unit ufrmTorpedoPickList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,Vcl.ExtCtrls,

  uDBAsset_Weapon, uSimContainers;

type
  TfrmTorpedoPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lstAvailableTorpedo: TListBox;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstAvailableTorpedoClick(Sender: TObject);
    procedure lstAvailableTorpedoDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FTorpedoList : TList;
    FTorpedoId : Integer;

    FSelectedTorpedo : TTorpedo_On_Board;
    FSelectedHybrid : THybrid_On_Board;

    procedure UpdateTorpedoList;
  public
    property SelectedHybrid : THybrid_On_Board read FSelectedHybrid write FSelectedHybrid;
  end;

var
  frmTorpedoPickList: TfrmTorpedoPickList;

implementation

uses
  uDataModuleTTT;
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

procedure TfrmTorpedoPickList.FormCreate(Sender: TObject);
begin
  FTorpedoList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmTorpedoPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FTorpedoList);
end;

procedure TfrmTorpedoPickList.FormShow(Sender: TObject);
begin
  UpdateTorpedoList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmTorpedoPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableTorpedo.ItemIndex = -1 then
    Exit;

  with FSelectedHybrid.FTorpedo_Def do
  begin
    Torpedo_Index := FSelectedTorpedo.FDef.Torpedo_Index;
    Class_Identifier := FSelectedTorpedo.FDef.Class_Identifier;
  end;

  close;
end;

procedure TfrmTorpedoPickList.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmTorpedoPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateTorpedoList
  end;
end;

procedure TfrmTorpedoPickList.lstAvailableTorpedoClick(Sender: TObject);
begin
  if lstAvailableTorpedo.ItemIndex = -1 then
    Exit;

  FSelectedTorpedo := TTorpedo_On_Board(lstAvailableTorpedo.Items.Objects[lstAvailableTorpedo.ItemIndex]);
end;

procedure TfrmTorpedoPickList.lstAvailableTorpedoDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmTorpedoPickList.UpdateTorpedoList;
var
  i : Integer;
  torpedo : TTorpedo_On_Board;
begin
  lstAvailableTorpedo.Items.Clear;

//  dmTTT.GetAllTorpedoDef(FTorpedoList);
  dmTTT.GetFilterTorpedoDef(FTorpedoList, edtSearch.Text);

  for i := 0 to FTorpedoList.Count - 1 do
  begin
    torpedo := FTorpedoList.Items[i];
    lstAvailableTorpedo.Items.AddObject(torpedo.FDef.Class_Identifier, torpedo);
  end;

end;

{$ENDREGION}

end.
