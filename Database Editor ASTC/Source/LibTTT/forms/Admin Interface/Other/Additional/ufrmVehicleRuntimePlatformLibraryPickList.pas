unit ufrmVehicleRuntimePlatformLibraryPickList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  uDBAssetObject, uDBAsset_Vehicle, uDBAsset_Runtime_Platform_Library;
type
  TfrmVehicleRuntimePlatformLibraryPickList = class(TForm)
    pnlMain: TPanel;
    btnAdd: TButton;
    btnRemove: TButton;
    lbAllVehicleDef: TListBox;
    lbAllVehicleOnRPL: TListBox;
    btnClose: TButton;
    edtSearch: TEdit;
    lbl1: TLabel;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure lbAllVehicleDefClick(Sender: TObject);
    procedure lbAllVehicleOnRPLClick(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);

 private
    FAllVehicleDefList : TList;
    FAllVehicleOnRPLList : TList;

    FSelectedVehicle : TVehicle_Definition;
    FSelectedPlatformLibrary : TPlatform_Library_Entry;
    FRuntimePlatformLibrary: TRuntime_Platform_Library;

    procedure UpdateVehicleList;

  public
    isNoCancel : Boolean;
    property RuntimePlatformLibrary : TRuntime_Platform_Library read FRuntimePlatformLibrary write FRuntimePlatformLibrary;

  end;

var
  frmVehicleRuntimePlatformLibraryPickList: TfrmVehicleRuntimePlatformLibraryPickList;

implementation

uses
  uDataModuleTTT, uSimContainers;

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

procedure TfrmVehicleRuntimePlatformLibraryPickList.FormCreate(Sender: TObject);
begin
  FAllVehicleDefList   := TList.Create;
  FAllVehicleOnRPLList := TList.Create;

  EnableComposited(pnlMainBackground);
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.FormDestroy(
  Sender: TObject);
begin
  FreeItemsAndFreeList(FAllVehicleDefList);
  FreeItemsAndFreeList(FAllVehicleOnRPLList);
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.FormShow(Sender: TObject);
begin
  isNoCancel := False;
  UpdateVehicleList;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmVehicleRuntimePlatformLibraryPickList.btnAddClick(Sender: TObject);
var
  PlatformLibrary : TPlatform_Library_Entry;

begin
  if lbAllVehicleDef.ItemIndex = -1 then
    Exit;

  PlatformLibrary := TPlatform_Library_Entry.Create;

  with PlatformLibrary.FData do
  begin
    Library_Index := FRuntimePlatformLibrary.FData.Platform_Library_Index;
    Platform_Type := 1;
    Vehicle_Index := FSelectedVehicle.FData.Vehicle_Index;
  end;

  if dmTTT.InsertPlatformLibraryEntry(PlatformLibrary.FData)then
    isNoCancel := True;

  PlatformLibrary.Free;

  UpdateVehicleList;
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.btnRemoveClick(Sender: TObject);
begin
 if lbAllVehicleOnRPL.ItemIndex = -1 then
    Exit;

 if dmTTT.DeletePlatformLibraryEntry(2, FSelectedPlatformLibrary.FData.Library_Entry_Index)then
    isNoCancel := True;;

  UpdateVehicleList;
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    UpdateVehicleList
  end;
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.lbAllVehicleDefClick(Sender: TObject);
begin
 if lbAllVehicleDef.ItemIndex = -1 then
    Exit;

  FSelectedVehicle := TVehicle_Definition(lbAllVehicleDef.Items.Objects[lbAllVehicleDef.ItemIndex]);
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.lbAllVehicleOnRPLClick(Sender: TObject);
begin
 if lbAllVehicleOnRPL.ItemIndex = -1 then
    Exit;

  FSelectedPlatformLibrary := TPlatform_Library_Entry(lbAllVehicleOnRPL.Items.Objects[lbAllVehicleOnRPL.ItemIndex]);
end;

procedure TfrmVehicleRuntimePlatformLibraryPickList.UpdateVehicleList;
var
  i, j : Integer;
  Vehicle : TVehicle_Definition;
  PlatformLibrary : TPlatform_Library_Entry;
  found : Boolean;
begin
  lbAllVehicleDef.Items.Clear;
  lbAllVehicleOnRPL.Items.Clear;

  dmTTT.GetFilterVehicleDef(FAllVehicleDefList, edtSearch.Text);
  dmTTT.GetAllVehiclePlatformLibraryEntry(FRuntimePlatformLibrary.FData.Platform_Library_Index,FAllVehicleOnRPLList);

  for i := 0 to FAllVehicleDefList.Count - 1 do
  begin
    Vehicle := FAllVehicleDefList.Items[i];

    found := False;
    for j := 0 to FAllVehicleOnRPLList.Count - 1 do
    begin
      PlatformLibrary := FAllVehicleOnRPLList.Items[j];

      if PlatformLibrary.FData.Vehicle_Index = Vehicle.FData.Vehicle_Index then
      begin
        found := True;
        Break;
      end;
    end;

    if found then
      lbAllVehicleOnRPL.Items.AddObject(Vehicle.FData.Vehicle_Identifier, PlatformLibrary)
    else
      lbAllVehicleDef.Items.AddObject(Vehicle.FData.Vehicle_Identifier, Vehicle);
  end;
end;

 {$ENDREGION}

end.
