unit ufrmEnvironmentPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uDBAsset_GameEnvironment, uDBAssetObject,
  Vcl.Imaging.pngimage;

type
  TfrmEnvironmentPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lbEnvironmentAvailable: TListBox;
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

    procedure lbEnvironmentAvailableClick(Sender: TObject);
    procedure lbEnvironmentAvailableDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FPickedEnvironmentId : Integer;

    FEnvironmentList : TList;
    FSelectedEnvironment : TGame_Environment_Definition;

    procedure UpdateEnvironmentList;
  public
    property PickedEnvironmentId : Integer read FPickedEnvironmentId
      write FPickedEnvironmentId;
  end;

var
  frmEnvironmentPickList: TfrmEnvironmentPickList;

implementation

uses
  uSimDBEditor, ufrmSummaryResourceAllocation, ufrmSummaryEnvironment,
  ufrmSubEnviCharacteristic, newClassASTT,
  uDBAssets_SubAreaEnviroDefinition, uDataModuleTTT, uSimContainers;

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

procedure TfrmEnvironmentPickList.FormCreate(Sender: TObject);
begin
  FEnvironmentList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmEnvironmentPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FEnvironmentList);
end;

procedure TfrmEnvironmentPickList.FormShow(Sender: TObject);
begin
  UpdateEnvironmentList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmEnvironmentPickList.btnAddClick(Sender: TObject);
begin
  if lbEnvironmentAvailable.ItemIndex = -1 then
    Exit;

  FPickedEnvironmentId := FSelectedEnvironment.FData.Game_Enviro_Index;
  close;
end;

procedure TfrmEnvironmentPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEnvironmentPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateEnvironmentList
  end;
end;

procedure TfrmEnvironmentPickList.lbEnvironmentAvailableClick(Sender: TObject);
begin
  if lbEnvironmentAvailable.ItemIndex = -1 then
    Exit;

  FSelectedEnvironment := TGame_Environment_Definition(lbEnvironmentAvailable.Items.Objects[lbEnvironmentAvailable.ItemIndex]);
end;

procedure TfrmEnvironmentPickList.lbEnvironmentAvailableDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmEnvironmentPickList.UpdateEnvironmentList;
var
  i : Integer;
  gameEnvi : TGame_Environment_Definition;
begin
  lbEnvironmentAvailable.Items.Clear;

  dmTTT.GetFilterEnvironmentDef(FEnvironmentList, edtSearch.Text);

  getEnvironments(FEnvironmentList);

  for i := 0 to FEnvironmentList.Count - 1 do
  begin
    gameEnvi := FEnvironmentList.Items[i];

    lbEnvironmentAvailable.Items.AddObject(
        gameEnvi.FData.Game_Enviro_Identifier, gameEnvi);
  end;
end;

{$ENDREGION}

end.
