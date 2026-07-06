unit ufrmGameAreaPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage,
  uDBAsset_GameEnvironment, uSimContainers;

type
  TfrmGameAreaPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lbAvailableGameArea: TListBox;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnl1Header: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAvailableGameAreaClick(Sender: TObject);
    procedure lbAvailableGameAreaDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FSelectedGameAreaId : Integer;
    FSelectedGameAreaName : String; {u/ kebutuhan overlay editor}

    FGameAreaList : TList;
    FSelectedGameArea : TGame_Environment_Definition;

    procedure UpdateGameAreaList;

  public
    property SelectedGameAreaId : Integer read FSelectedGameAreaId write FSelectedGameAreaId;
    property SelectedGameAreaName : String read FSelectedGameAreaName write FSelectedGameAreaName;
  end;

var
  frmGameAreaPickList: TfrmGameAreaPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryEnvironment;

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

procedure TfrmGameAreaPickList.FormCreate(Sender: TObject);
begin
  FGameAreaList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmGameAreaPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FGameAreaList);
end;

procedure TfrmGameAreaPickList.FormShow(Sender: TObject);
begin
  UpdateGameAreaList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmGameAreaPickList.btnAddClick(Sender: TObject);
begin
  if lbAvailableGameArea.ItemIndex = -1 then
    Exit;

  if Assigned(FSelectedGameArea) then
  begin
    FSelectedGameAreaId := FSelectedGameArea.FGameArea.Game_Area_Index;
    FSelectedGameAreaName := FSelectedGameArea.FGameArea.Game_Area_Identifier;
  end;

  Close;
//  FSelectedGameAreaId := FSelectedGameArea.FGameArea.Game_Area_Index;
//  Close;

end;

procedure TfrmGameAreaPickList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGameAreaPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateGameAreaList
  end;
end;

procedure TfrmGameAreaPickList.lbAvailableGameAreaClick(Sender: TObject);
begin
  if lbAvailableGameArea.ItemIndex = -1 then
    Exit;

  FSelectedGameArea := TGame_Environment_Definition(lbAvailableGameArea.Items.Objects[lbAvailableGameArea.ItemIndex]);
end;

procedure TfrmGameAreaPickList.lbAvailableGameAreaDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmGameAreaPickList.UpdateGameAreaList;
var
  i : Integer;
  gameArea : TGame_Environment_Definition;
begin
  lbAvailableGameArea.Items.Clear;

//  dmTTT.GetAllGameAreaDef(FGameAreaList);
  dmTTT.GetFilterGameAreaDef(FGameAreaList, edtSearch.Text);

  for i := 0 to FGameAreaList.Count - 1 do
  begin
    gameArea := FGameAreaList.Items[i];

    lbAvailableGameArea.Items.AddObject(gameArea.FGameArea.Game_Area_Identifier, gameArea);

  end;
end;

{$ENDREGION}

end.
