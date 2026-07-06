unit ufrmSonarPickList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,Vcl.ExtCtrls,
  uDBAsset_Sonar, uSimContainers;

type
  TfrmSonarPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lstAvailableSonar: TListBox;
    pnl3Button: TPanel;
    btnCancel: TButton;
    btnAdd: TButton;
    pnlTableHeader: TPanel;
    Label2: TLabel;
    edtSearch: TEdit;
    pnlMainBackground: TPanel;
    imgBackground: TImage;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lstAvailableSonarClick(Sender: TObject);
    procedure lstAvailableSonarDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FSelectedSonarId : Integer;

    FSonarList : TList;
    FSelectedSonar : TSonar_On_Board;

    procedure UpdateSonarList;

  public
    property SelectedSonarId : Integer read FSelectedSonarId
      write FSelectedSonarId;

  end;

var
  frmSonarPickList: TfrmSonarPickList;

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

procedure TfrmSonarPickList.FormCreate(Sender: TObject);
begin
  FSonarList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmSonarPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FSonarList);
end;

procedure TfrmSonarPickList.FormShow(Sender: TObject);
begin
  UpdateSonarList
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSonarPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableSonar.ItemIndex = -1 then
    Exit;

  FSelectedSonarId := FSelectedSonar.FDef.Sonar_Index;
  close;

end;

procedure TfrmSonarPickList.btnCancelClick(Sender: TObject);
begin
  Close
end;

procedure TfrmSonarPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateSonarList
  end;
end;

procedure TfrmSonarPickList.lstAvailableSonarClick(Sender: TObject);
begin
  if lstAvailableSonar.ItemIndex = -1 then
    Exit;

  FSelectedSonar := TSonar_On_Board(lstAvailableSonar.Items.Objects[lstAvailableSonar.ItemIndex]);
end;

procedure TfrmSonarPickList.lstAvailableSonarDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmSonarPickList.UpdateSonarList;
var
  i : Integer;
  sonar : TSonar_On_Board;
begin
  lstAvailableSonar.Items.Clear;

  dmTTT.GetFilterSonarDef(FSonarList, edtSearch.Text);
//  dmTTT.GetAllSonarDef(FSonarList);

  for i := 0 to FSonarList.Count - 1 do
  begin
    sonar := FSonarList.Items[i];
    lstAvailableSonar.Items.AddObject(sonar.FDef.Sonar_Identifier, sonar);
  end;
end;

{$ENDREGION}

end.
