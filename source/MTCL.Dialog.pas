(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Dialog;

interface

uses
  System.Classes, Winapi.Windows, System.SysUtils, Winapi.Messages,
  System.Generics.Collections, System.TypInfo,
  MTCL.BaseControl, MTCL.Button, MTCL.Memo;

type
  TMtclDialog = class
  private type
    TMtclDialogThread = class(TThread)
    private const
      cDialogStateInitialized = 1;

    var
      FResource: Integer;
      FHandle: HWND;
      FControls: TObjectList<TMtclBaseControl>;
      FControlsByID: TDictionary<Integer, TMtclBaseControl>;
      FControlsByHandle: TDictionary<HWND, TMtclBaseControl>;
      FState: Integer;
      procedure AddControl(const AHandle: HWND);
      procedure MtclDialogProc(var AMessage: TMessage);
    protected
      procedure Execute; override;
    public
      constructor Create(const AResource: Integer);
      destructor Destroy; override;
      procedure Show;
      procedure Hide;
      function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
      property Handle: HWND read FHandle write FHandle;
    end;

  var
    FDialogThread: TMtclDialogThread;
    function GetHandle: HWND;
    procedure SetHandle(const Value: HWND);
  public
    constructor Create(const AResource: Integer);
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    procedure Close;
    property Handle: HWND read GetHandle write SetHandle;
    function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
  end;

implementation

function EnumWindowsProc(AHandle: HWND; ADialog: TMtclDialog.TMtclDialogThread)
  : Bool; stdcall;
begin
  ADialog.AddControl(AHandle);
  Result := True;
end;

{ TMtclDialog.TMtclDialogThread }

procedure TMtclDialog.TMtclDialogThread.AddControl(const AHandle: HWND);
var
  ControlNameChars: array [0 .. 255] of Char;
  ControlName: string;
  AddedControl: TMtclBaseControl;
  ControlID: Integer;
begin
  if GetClassName(AHandle, ControlNameChars, Length(ControlNameChars)) > 0 then
  begin
    ControlName := string(ControlNameChars);
    ControlID := GetDlgCtrlID(AHandle);
    if AnsiSameText(ControlName, 'button') then
      AddedControl := TMtclButton.Create(FHandle, AHandle, ControlID)
    else if AnsiSameText(ControlName, 'edit') then
      AddedControl := TMtclMemo.Create(FHandle, AHandle, ControlID)
    else
      AddedControl := nil;
    if Assigned(AddedControl) then
    begin
      FControls.Add(AddedControl);
      FControlsByID.Add(ControlID, AddedControl);
      FControlsByHandle.Add(AHandle, AddedControl);
    end;
  end;
end;

constructor TMtclDialog.TMtclDialogThread.Create(const AResource: Integer);
begin
  inherited Create(False);
  FResource := AResource;
  FControls := TObjectList<TMtclBaseControl>.Create(True);
  FControlsByID := TDictionary<Integer, TMtclBaseControl>.Create;
  FControlsByHandle := TDictionary<HWND, TMtclBaseControl>.Create;
end;

destructor TMtclDialog.TMtclDialogThread.Destroy;
begin
  FControlsByHandle.Free;
  FControlsByID.Free;
  FControls.Free;
  inherited;
end;

procedure TMtclDialog.TMtclDialogThread.Execute;
var
  CurrentMessage: TMsg;
begin
  TThread.NameThreadForDebugging('TMtclDialog.TMtclDialogThread ' +
    IntToStr(FResource));
  FHandle := CreateDialogParam(hInstance, MAKEINTRESOURCE(FResource), 0,
    MakeObjectInstance(MtclDialogProc), 0);
  ShowWindow(FHandle, SW_SHOWNORMAL);
  EnumChildWindows(FHandle, @EnumWindowsProc, Integer(Self));
  InvalidateRect(FHandle, nil, True);
  AtomicExchange(FState, cDialogStateInitialized);
{$BOOLEVAL OFF}
  while not Terminated do
  begin
    if PeekMessage(CurrentMessage, 0, 0, 0, PM_REMOVE) and
      not IsDialogMessage(FHandle, CurrentMessage) then
    begin
      TranslateMessage(CurrentMessage);
      DispatchMessage(CurrentMessage);
    end;
    Sleep(1);
  end;
  DestroyWindow(FHandle);
end;

function TMtclDialog.TMtclDialogThread.Get<T>(const AControlID: Integer): T;
var
  ResultControl: TMtclBaseControl;
begin
  if FControlsByID.TryGetValue(AControlID, ResultControl) and
    (ResultControl is T) then
    Result := T(ResultControl)
  else
    Result := nil;
end;

procedure TMtclDialog.TMtclDialogThread.Hide;
begin
  ShowWindow(FHandle, SW_HIDE);
end;

procedure TMtclDialog.TMtclDialogThread.MtclDialogProc(var AMessage: TMessage);
var
  CurrentControl: TMtclBaseControl;
begin
  case AMessage.Msg of
    WM_CLOSE:
      DestroyWindow(FHandle);
    WM_COMMAND:
      begin
        CurrentControl := Get<TMtclBaseControl>(AMessage.WParamLo);
        if Assigned(CurrentControl) then
          CurrentControl.Dispatch(AMessage);
      end;
  else
    DefaultHandler(AMessage);
  end;
end;

procedure TMtclDialog.TMtclDialogThread.Show;
begin
  while FState = 0 do
    Sleep(10);
  ShowWindow(FHandle, SW_SHOWNORMAL);
end;

{ TMtclDialog }

procedure TMtclDialog.Close;
begin
  FreeAndNil(FDialogThread);
end;

constructor TMtclDialog.Create(const AResource: Integer);
begin
  FDialogThread := TMtclDialogThread.Create(AResource);
end;

destructor TMtclDialog.Destroy;
begin
  FDialogThread.Free;
  inherited;
end;

function TMtclDialog.Get<T>(const AControlID: Integer): T;
begin
  Result := FDialogThread.Get<T>(AControlID);
end;

function TMtclDialog.GetHandle: HWND;
begin
  Result := FDialogThread.Handle;
end;

procedure TMtclDialog.Hide;
begin
  FDialogThread.Hide;
end;

procedure TMtclDialog.SetHandle(const Value: HWND);
begin
  FDialogThread.Handle := Value;
end;

procedure TMtclDialog.Show;
begin
  FDialogThread.Show;
end;

end.
