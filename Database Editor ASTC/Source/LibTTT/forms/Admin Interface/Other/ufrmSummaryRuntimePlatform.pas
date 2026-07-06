unit ufrmSummaryRuntimePlatform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uDBAsset_Runtime_Platform_Library,
  Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TfrmSummaryRuntimePlatform = class(TForm)
    pnl1Title: TPanel;
    Label1: TLabel;
    edtName: TEdit;
    pnl2ControlPage: TPanel;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    grbPlatforms: TGroupBox;
    btnVehicle: TButton;
    btnTorpedo: TButton;
    btnMine: TButton;
    btnMissile: TButton;
    btnSonobuoy: TButton;
    pnl3Button: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    imgBackground: TImage;
    pnlMainBackground: TPanel;

    procedure FormShow(Sender: TObject);
    procedure btnVehicleClick(Sender: TObject);
    procedure btnMissileClick(Sender: TObject);
    procedure btnTorpedoClick(Sender: TObject);
    procedure btnSonobuoyClick(Sender: TObject);
    procedure btnMineClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    FSelectedRPL : TRuntime_Platform_Library;

    function CekInput: Boolean;
    procedure UpdateButtonState;

  public
    isOK  : Boolean; {Penanda jika gagal cek input, btn OK tidak langsung close}
    AfterClose : Boolean; {Penanda ketika yg dipilih btn cancel, list tdk perlu di update }
    LastName : string;

    property SelectedRPL : TRuntime_Platform_Library read FSelectedRPL write FSelectedRPL;
  end;

var
  frmSummaryRuntimePlatform: TfrmSummaryRuntimePlatform;

implementation

uses
  uDataModuleTTT, ufrmVehicleRuntimePlatformLibraryPickList;

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

procedure TfrmSummaryRuntimePlatform.FormCreate(Sender: TObject);
begin
  EnableComposited(pnlMainBackground);
end;

procedure TfrmSummaryRuntimePlatform.FormShow(Sender: TObject);
begin
  tsGeneral.Show;
  UpdateButtonState;

  with FSelectedRPL.FData do
    btnApply.Enabled := Platform_Library_Index = 0;

  isOK := True;
  AfterClose := True;
  btnCancel.Enabled := True;
end;

{$ENDREGION}

{$REGION ' Button Handle '}

procedure TfrmSummaryRuntimePlatform.btnOkClick(Sender: TObject);
begin
  if btnApply.Enabled then
    btnApply.Click;

  if isOk then
    Close;
end;

procedure TfrmSummaryRuntimePlatform.btnApplyClick(Sender: TObject);
begin

  with FSelectedRPL do
  begin
    if not CekInput then
    begin
      isOK := False;
      Exit;
    end;

    LastName := edtName.Text;
    FData.Library_Name := edtName.Text;

    if FData.Platform_Library_Index = 0 then
    begin
      if dmTTT.InsertRuntimePlatformLibraryDef(FData) then
      begin
        ShowMessage('Data berhasil disimpan');
      end;
    end
    else
    begin
        if dmTTT.UpdateRuntimePlatformLibraryDef(FData) then
        begin
          ShowMessage('Data berhasil diperbarui');
        end;
    end;

  end;

  UpdateButtonState;

  isOK := True;
  AfterClose := True;
  btnApply.Enabled := False;
  btnCancel.Enabled := False;
end;

procedure TfrmSummaryRuntimePlatform.btnCancelClick(Sender: TObject);
begin
  AfterClose := False;
  Close;
end;

procedure TfrmSummaryRuntimePlatform.btnVehicleClick(Sender: TObject);
begin
  frmVehicleRuntimePlatformLibraryPickList := TfrmVehicleRuntimePlatformLibraryPickList.Create(Self);
  try
    with frmVehicleRuntimePlatformLibraryPickList do
    begin
      RuntimePlatformLibrary := FSelectedRPL;
      ShowModal;

      btnCancel.Enabled := not isNoCancel;
    end;
  finally
    frmVehicleRuntimePlatformLibraryPickList.Free;
  end;

  btnApply.Enabled := True;
end;

procedure TfrmSummaryRuntimePlatform.btnMissileClick(Sender: TObject);
begin
//  frmMissileRuntimePlatformLibraryPickList := TfrmMissileRuntimePlatformLibraryPickList.Create(Self);
//  try
//    with frmMissileRuntimePlatformLibraryPickList do
//    begin
//      RuntimePlatformLibrary := FSelectedRPL;
//      ShowModal;
//
//      btnCancel.Enabled := not isNoCancel;
//    end;
//  finally
//    frmMissileRuntimePlatformLibraryPickList.Free;
//  end;
//
//  btnApply.Enabled := True;
end;

procedure TfrmSummaryRuntimePlatform.btnTorpedoClick(Sender: TObject);
begin
//  frmTorpedoRuntimePlatformLibraryPickList := TfrmTorpedoRuntimePlatformLibraryPickList.Create(Self);
//  try
//    with frmTorpedoRuntimePlatformLibraryPickList do
//    begin
//      RuntimePlatformLibrary := FSelectedRPL;
//      ShowModal;
//
//      btnCancel.Enabled := not isNoCancel;
//    end;
//  finally
//    frmTorpedoRuntimePlatformLibraryPickList.Free;
//  end;
//
//  btnApply.Enabled := True;
end;

procedure TfrmSummaryRuntimePlatform.btnMineClick(Sender: TObject);
begin
//  frmMineRuntimePlatformLibraryPickList := TfrmMineRuntimePlatformLibraryPickList.Create(Self);
//  try
//    with frmMineRuntimePlatformLibraryPickList do
//    begin
//      RuntimePlatformLibrary := FSelectedRPL;
//      ShowModal;
//
//      btnCancel.Enabled := not isNoCancel;
//    end;
//  finally
//    frmMineRuntimePlatformLibraryPickList.Free;
//  end;
//
//  btnApply.Enabled := True;
end;

procedure TfrmSummaryRuntimePlatform.btnSonobuoyClick(Sender: TObject);
begin
//  frmSonobuoyRuntimePlatformLibraryPickList := TfrmSonobuoyRuntimePlatformLibraryPickList.Create(Self);
//  try
//    with frmSonobuoyRuntimePlatformLibraryPickList do
//    begin
//      RuntimePlatformLibrary := FSelectedRPL;
//      ShowModal;
//
//      btnCancel.Enabled := not isNoCancel;
//    end;
//  finally
//    frmSonobuoyRuntimePlatformLibraryPickList.Free;
//  end;
//
//  btnApply.Enabled := True;
end;

function TfrmSummaryRuntimePlatform.CekInput: Boolean;
var
  i, chkSpace, numSpace: Integer;
begin
  Result := False;

  {Jika inputan class name kosong}
  if (edtName.Text = '')then
  begin
    ShowMessage('Silahkan masukkan nama class');
    Exit;
  end;

  {Jika berisi spasi semua}
  if Copy(edtName.Text, 1, 1) = ' ' then
  begin
    chkSpace := Length(edtName.Text);
    numSpace := 0;

    for i := 1 to chkSpace do
    begin
      if edtName.Text[i] = #32 then
      numSpace := numSpace + 1;
    end;

    if chkSpace = numSpace then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end;
  end;

  {Jika Class Name sudah ada}
  if (dmTTT.GetRuntimePlatformLibraryDef(edtName.Text)>0) then
  begin
    {Jika inputan baru}
    if FSelectedRPL.FData.Platform_Library_Index = 0 then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end
    else if LastName <> edtName.Text then
    begin
      ShowMessage('Silahkan gunakan nama class lain');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmSummaryRuntimePlatform.edtNameChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfrmSummaryRuntimePlatform.UpdateButtonState;
begin
  with FSelectedRPL.FData do
  begin
    if Platform_Library_Index = 0 then
      edtName.Text := '(Unnamed)'
    else
      edtName.Text := Library_Name ;

    LastName := edtName.Text;

    btnVehicle.Enabled := Platform_Library_Index <> 0;
    btnMissile.Enabled := Platform_Library_Index <> 0;
    btnTorpedo.Enabled := Platform_Library_Index <> 0;
    btnSonobuoy.Enabled := Platform_Library_Index <> 0;
    btnMine.Enabled := Platform_Library_Index <> 0;
  end;
end;

{$ENDREGION}

end.
