unit ufConnectTerminate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TfrmConnectTerminate = class(TForm)
    tvMapping: TTreeView;
    btnOK: TButton;
    btnCancel: TButton;
    pnlMainBackground: TPanel;
    imgBackground: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure btnOKConnectClick(Sender: TObject);
    procedure btnOKTerminateClick(Sender: TObject);
    procedure DisplayGroups(const scID: integer);

  public
    { Public declarations }
    ExerciseName: string;
    OKTerminate,
    OKConnect : Boolean;


    procedure SetAsTerminate;
    procedure SetAsConnect;
    procedure UpdateSession;
  end;

var
  frmConnectTerminate: TfrmConnectTerminate;

implementation

uses
  uDMGC, uNetSessionClient;

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


procedure TfrmConnectTerminate.FormCreate(Sender: TObject);
begin
//  show;
  EnableComposited(pnlMainBackground);
end;

procedure TfrmConnectTerminate.SetAsConnect;
begin
  OKConnect := False;
  Caption := 'Connect';
  btnOK.Caption := '&Connect';
  btnOK.OnClick := btnOKConnectClick;

end;

procedure TfrmConnectTerminate.SetAsTerminate;
begin
  OKTerminate := False;
  Caption := 'Terminate';
  btnOK.Caption := '&Terminate';
  btnOK.OnClick := btnOKTerminateClick;

end;

procedure TfrmConnectTerminate.UpdateSession;
begin
  if theClient.GameSessionExist then
    DisplayGroups(theClient.GameSessionSCID)
  else begin
    tvMapping.Items.Clear;
    Caption  := 'No Available Session';
  end;
end;

procedure TfrmConnectTerminate.btnCancelClick(Sender: TObject);
begin
  OKTerminate  := False;
  OKConnect    := False;
  Close;
end;

procedure TfrmConnectTerminate.btnOKConnectClick(Sender: TObject);
begin
  OKConnect := True;
  Close;
end;

procedure TfrmConnectTerminate.btnOKTerminateClick(Sender: TObject);
begin
  OKTerminate := True;
  Close;
end;

procedure TfrmConnectTerminate.DisplayGroups(const scID: integer);
var i, j: integer;
    lGrp, lPi : TList;
    gInfo: TGroupInfo;
    pInfo : TDeployedPlatformInfo;
    fNode, node: TTreeNode;
    scInfo: TScenarioInfo;
begin
  dmGC.GetScenarioInfo(scID, scInfo);
  if scInfo <> nil then begin
    ExerciseName := scInfo.Scenario_Identifier;
  end;

  tvMapping.Items.Clear;
  fNode := tvMapping.Items.GetFirstNode;
  fNode := tvMapping.Items.AddChild(fNode, ExerciseName);

  lGrp := TList.Create;
  lPi  := TList.Create;

  dmGC.GetGroupList(scID, lGrp);
  for i := 0 to lGrp.Count - 1 do begin
    gInfo := lGrp.Items[i];
    node := tvMapping.Items.AddChild(fNode, gInfo.Group_Identifier);

    dmGC.GetGroupMember(gInfo.Group_Index, lPi);
    for j := 0 to lPi.Count - 1 do begin
      pInfo :=  lPI.Items[j];
      tvMapping.Items.AddChild(node, pInfo.Instance_Name);
    end;
  end;

  fNode.Expand(false);
  lPi.Free;
  lGrp.Free;
  scInfo.Free;

end;


end.
