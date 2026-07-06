unit ufrmGameDefaultsPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBGame_Defaults, uDBAssetObject,
  Vcl.Imaging.pngimage;

type
  TfrmGameDefaultsPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lbGameDefaultAvailable: TListBox;
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

    procedure lbGameDefaultAvailableDblClick(Sender: TObject);
    procedure lbGameDefaultAvailableClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);




  private
    FPickedGameDefaultId : Integer;

    FGameDefaultList : TList;
    FSelectedGameDefault : TGame_Defaults;

    procedure UpdateGameDefaultList;
  public
    property PickedGameDefaultId : Integer read FPickedGameDefaultId
      write FPickedGameDefaultId;
  end;

var
  frmGameDefaultsPickList: TfrmGameDefaultsPickList;

implementation

uses
  uSimDBEditor,ufrmSummaryResourceAllocation, uDataModuleTTT,
  ufrmEnvironmentCharacteristic, ufrmGameDefaultSummary, ufDBEditor, uSimContainers{,
  {uOtherSingleList};

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

procedure TfrmGameDefaultsPickList.FormCreate(Sender: TObject);
begin
  FGameDefaultList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmGameDefaultsPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FGameDefaultList);
end;

procedure TfrmGameDefaultsPickList.FormShow(Sender: TObject);
begin
  UpdateGameDefaultList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmGameDefaultsPickList.btnAddClick(Sender: TObject);
begin
  if lbGameDefaultAvailable.ItemIndex = -1 then
    Exit;

  FPickedGameDefaultId := FSelectedGameDefault.FData.Defaults_Index;
  Close;
end;

procedure TfrmGameDefaultsPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGameDefaultsPickList.edtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateGameDefaultList;
  end;
end;

procedure TfrmGameDefaultsPickList.lbGameDefaultAvailableClick(Sender: TObject);
begin
  if lbGameDefaultAvailable.ItemIndex = -1 then
    Exit;

  FSelectedGameDefault := TGame_Defaults(lbGameDefaultAvailable.Items.Objects[lbGameDefaultAvailable.ItemIndex]);
end;

procedure TfrmGameDefaultsPickList.lbGameDefaultAvailableDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmGameDefaultsPickList.UpdateGameDefaultList;
var
  i : Integer;
  gameDefault : TGame_Defaults;
begin
  lbGameDefaultAvailable.Items.Clear;

//  dmTTT.GetAllGameDefault(FGameDefaultList);
  dmTTT.GetFilterGameDefaultDef(FGameDefaultList, edtSearch.Text);

  for i := 0 to FGameDefaultList.Count - 1 do
  begin
    gameDefault := FGameDefaultList.Items[i];

    lbGameDefaultAvailable.Items.AddObject(gameDefault.FData.Defaults_Identifier, gameDefault);
  end;
end;

{$ENDREGION}

end.
