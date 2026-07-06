unit ufrmMotionPickList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.pngimage,

  uDBAsset_MotionCharacteristics, uSimContainers;

type
  TfrmMotionPickList = class(TForm)
    pnl2ControlPage: TPanel;
    lstAvailableMotion: TListBox;
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

    procedure lstAvailableMotionClick(Sender: TObject);
    procedure lstAvailableMotionDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

  private
    FSelectedMotionId : Integer;

    FMotionList : TList;
    FSelectedMotion : TMotion_Characteristics;

    procedure UpdateMotionList;

  public
    property SelectedMotionId : Integer read FSelectedMotionId write FSelectedMotionId;
  end;

var
  frmMotionPickList: TfrmMotionPickList;

implementation

uses
  uDataModuleTTT, ufrmSummaryMotion, ufProgress;

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

procedure TfrmMotionPickList.FormCreate(Sender: TObject);
begin
  FMotionList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmMotionPickList.FormDestroy(Sender: TObject);
begin
  FreeItemsAndFreeList(FMotionList);
end;

procedure TfrmMotionPickList.FormShow(Sender: TObject);
begin
  UpdateMotionList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmMotionPickList.btnAddClick(Sender: TObject);
begin
  if lstAvailableMotion.ItemIndex = -1 then
    Exit;

  FSelectedMotionId := FSelectedMotion.FData.Motion_Index;
  Close;

end;

procedure TfrmMotionPickList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMotionPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateMotionList ;
  end;
end;

procedure TfrmMotionPickList.lstAvailableMotionClick(Sender: TObject);
begin
  if lstAvailableMotion.ItemIndex = -1 then
    Exit;

  FSelectedMotion := TMotion_Characteristics(lstAvailableMotion.Items.Objects[lstAvailableMotion.ItemIndex]);
end;

procedure TfrmMotionPickList.lstAvailableMotionDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TfrmMotionPickList.UpdateMotionList;
var
  i : Integer;
  motion : TMotion_Characteristics;
begin
  lstAvailableMotion.Items.Clear;
  dmTTT.GetFilterMotionCharacteristicDef(FMotionList, edtSearch.Text);

//  dmTTT.GetAllMotionCharacteristicDef(FMotionList);
  dmTTT.GetFilterMotionCharacteristicDef(FMotionList, edtSearch.Text);

  for i := 0 to FMotionList.Count - 1 do
  begin
    motion := FMotionList.Items[i];
    lstAvailableMotion.Items.AddObject(motion.FData.Motion_Identifier, motion);
  end;
end;

{$ENDREGION}

end.
