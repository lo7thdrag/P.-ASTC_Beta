unit uShowWin11Keyboard;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, Winapi.ActiveX, System.Win.ComObj, System.SysUtils;

const
  CLSID_UIHostNoLaunch: TGUID = '{4CE576FA-83DC-4F88-951C-9D0782B4E376}';
  IID_ITipInvocation: TGUID   = '{37C994E7-432B-4834-A2F7-DCE1F13B834B}';

type
  ITipInvocation = interface(IUnknown)
    ['{37C994E7-432B-4834-A2F7-DCE1F13B834B}']
    procedure Toggle(hwnd: HWND); stdcall;
  end;

procedure ShowTouchKeyboard;

implementation

procedure ShowTouchKeyboard;
var
  TipInvocation: ITipInvocation;
  Unk: IUnknown;
begin
  // 1. Ensure TabTip host process is running
  if FindWindow('IPTip_Main_Window', nil) = 0 then
  begin
    ShellExecute(0, 'open',
      'C:\Program Files\Common Files\microsoft shared\ink\TabTip.exe',
      nil, nil, SW_SHOWNORMAL);
    Sleep(150); // Brief pause for process initialization on first launch
  end;

  // 2. Toggle the touch keyboard UI via COM
  if Succeeded(CoCreateInstance(CLSID_UIHostNoLaunch, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IID_ITipInvocation, Unk)) then
  begin
    if Supports(Unk, IID_ITipInvocation, TipInvocation) then
      TipInvocation.Toggle(GetDesktopWindow);
  end;
end;

end.
