(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Dialog;

{$I CompilerVersions.inc}

interface

uses
  {$IFDEF DelphiXE2up}
  System.Classes, Winapi.Windows, System.SysUtils, Winapi.Messages, System.TypInfo, System.Generics.Collections,
  {$ELSE}
  Classes, Windows, SysUtils, Messages, TypInfo,
  {$IFDEF Delphi2010up}
  Generics.Collections, Rtti,
  {$ELSE}
  Contnrs,
  {$ENDIF}
  {$ENDIF}
  MTCL.BaseElement, MTCL.BaseControl, MTCL.Button, MTCL.Memo;

const
  cDialogStateInitialized = 1;

type
  TMtclBaseControlClass = class of TMtclBaseControl;

  TMtclDialogThread = class(TThread)
  private
    FResource: Integer;
    FHandle: HWND;
    {$IFDEF Delphi2010up}
    FControls: TObjectList<TMtclBaseControl>;
    FControlsByID: TDictionary<Integer, TMtclBaseControl>;
    FControlsByHandle: TDictionary<HWND, TMtclBaseControl>;
    {$ELSE}
    FControls: TObjectList;
    {$ENDIF}
    FState: Integer;
    FLastControlID: Integer;
    procedure AddControl(const AHandle: HWND);
    procedure MtclDialogProc(var AMessage: TMessage);
    function GetNewControlID: Integer;
    function CreateControlOnThread(const AClass: TMtclBaseControlClass): TMtclBaseControl;
  protected
    procedure Execute; override;
  public
    constructor Create(const AResource: Integer);
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    procedure WaitForReady;
    {$IFDEF Delphi2010up}
    function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
    function GetNew<T: TMtclBaseControl>: T;
    {$ELSE}
    function Get(const AControlID: Integer): TMtclBaseControl;
    function GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
    {$ENDIF}
    property Handle: HWND read FHandle write FHandle;
  end;

  // The dialog window itself. Derives from TMtclBaseElement so its size and
  // position can be changed through Left/Top/Width/Height/SetBounds. The actual
  // window lives on the dialog thread; Handle is read from there and the bounds
  // are read on first access (once the thread has created the window).
  TMtclDialog = class(TMtclBaseElement)
  private
    FDialogThread: TMtclDialogThread;
    FReady: Boolean;
  protected
    function GetHandle: HWND; override;
    procedure SetHandle(const Value: HWND); override;
    procedure EnsureReady; override;
  public
    constructor Create(const AResource: Integer);
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    procedure Close;
    {$IFDEF Delphi2010up}
    function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
    function GetNew<T: TMtclBaseControl>: T;
    {$ELSE}
    function Get(const AControlID: Integer): TMtclBaseControl;
    function GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
    {$ENDIF}
  end;

implementation

const
  // Private message used to marshal control creation onto the dialog thread.
  // WM_APP range (not WM_USER) because a dialog reserves WM_USER..WM_USER+n for
  // its dialog-manager messages (DM_GETDEFID = WM_USER+0, DM_SETDEFID = WM_USER+1).
  WM_MTCL_CREATECONTROL = WM_APP + 1;

type
  PMtclCreateRequest = ^TMtclCreateRequest;
  TMtclCreateRequest = record
    ControlClass: TMtclBaseControlClass;
    Control: TMtclBaseControl;
  end;

function EnumWindowsProc(AHandle: HWND; ADialog: TMtclDialogThread): Bool; stdcall;
begin
  ADialog.AddControl(AHandle);
  Result := True;
end;

{ TMtclDialogThread }

procedure TMtclDialogThread.AddControl(const AHandle: HWND);
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
      {$IFDEF Delphi2010up}
      FControlsByID.Add(ControlID, AddedControl);
      FControlsByHandle.Add(AHandle, AddedControl);
      {$ENDIF}
      if ControlID > FLastControlID then
        FLastControlID := ControlID;
    end;
  end;
end;

constructor TMtclDialogThread.Create(const AResource: Integer);
begin
  inherited Create(False);
  FResource := AResource;
  FState := CreateEvent(nil, True, False, nil);
  {$IFDEF Delphi2010up}
  FControls := TObjectList<TMtclBaseControl>.Create(True);
  FControlsByID := TDictionary<Integer, TMtclBaseControl>.Create;
  FControlsByHandle := TDictionary<HWND, TMtclBaseControl>.Create;
  {$ELSE}
  FControls := TObjectList.Create(True);
  {$ENDIF}
end;

destructor TMtclDialogThread.Destroy;
begin
  {$IFDEF Delphi2010up}
  FControlsByHandle.Free;
  FControlsByID.Free;
  {$ENDIF}
  FControls.Free;
  inherited;
end;

procedure TMtclDialogThread.Execute;
var
  CurrentMessage: TMsg;
  DummyHandle: THandle;
begin
  {$IFDEF Delphi2010up}
  TThread.NameThreadForDebugging('TMtclDialogThread ' + IntToStr(FResource));
  {$ENDIF}
  FHandle := CreateDialogParam(hInstance, MAKEINTRESOURCE(FResource), 0, MakeObjectInstance(MtclDialogProc), 0);
  ShowWindow(FHandle, SW_SHOWNORMAL);
  EnumChildWindows(FHandle, @EnumWindowsProc, Integer(Self));
  InvalidateRect(FHandle, nil, True);
  SetEvent(FState);
  while not Terminated do
  begin
    // Drain every message currently waiting before going back to sleep.
    // The previous "single PeekMessage + Sleep(1)" loop processed at most one
    // message per millisecond. Under load that starved WM_PAINT/WM_CTLCOLOR and
    // caused controls to flicker or stay invisible (and it busy-spun the CPU).
    while PeekMessage(CurrentMessage, 0, 0, 0, PM_REMOVE) do
    begin
      if CurrentMessage.Message = WM_QUIT then
      begin
        Terminate;
        Break;
      end;
      if not IsDialogMessage(FHandle, CurrentMessage) then
      begin
        TranslateMessage(CurrentMessage);
        DispatchMessage(CurrentMessage);
      end;
    end;
    if Terminated then
      Break;
    // Block until new input arrives (including cross-thread SendMessage, which is
    // how control creation and property changes from other threads reach us) or
    // until the timeout elapses, so a Terminate from another thread is noticed.
    MsgWaitForMultipleObjects(0, DummyHandle, False, 100, QS_ALLINPUT);
  end;
  DestroyWindow(FHandle);
end;

{$IFDEF Delphi2010up}
function TMtclDialogThread.Get<T>(const AControlID: Integer): T;
var
  ResultControl: TMtclBaseControl;
begin
  if FControlsByID.TryGetValue(AControlID, ResultControl) and (ResultControl is TClass(T)) then
    Result := T(ResultControl)
  else
{$IFDEF DelphiXEup}
    Result := nil;
{$ELSE}
    Result := TValue.Empty.AsType<T>;
{$ENDIF}
end;

function TMtclDialogThread.GetNew<T>: T;
begin
  Result := T(CreateControlOnThread(TMtclBaseControlClass(T)));
end;
{$ELSE}
function TMtclDialogThread.Get(const AControlID: Integer): TMtclBaseControl;
var
  i: Integer;
begin
  for i := 0 to FControls.Count - 1 do
    if TMtclBaseControl(FControls[i]).DialogItem = AControlID then
    begin
      Result := TMtclBaseControl(FControls[i]);
      Exit;
    end;
  Result := nil;
end;

function TMtclDialogThread.GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
begin
  Result := CreateControlOnThread(AClass);
end;
{$ENDIF}

function TMtclDialogThread.CreateControlOnThread(const AClass: TMtclBaseControlClass): TMtclBaseControl;
var
  Request: TMtclCreateRequest;
begin
  Request.ControlClass := AClass;
  Request.Control := nil;
  // Marshal the creation onto the dialog thread. SendMessage blocks until the
  // dialog thread has handled WM_MTCL_CREATECONTROL, so on return Request.Control
  // is set and the control is registered in the collections - all done on the
  // thread that owns the parent dialog and runs its message loop.
  SendMessage(FHandle, WM_MTCL_CREATECONTROL, WPARAM(@Request), 0);
  Result := Request.Control;
end;

function TMtclDialogThread.GetNewControlID: Integer;
begin
  Inc(FLastControlID);
  Result := FLastControlID;
end;

procedure TMtclDialogThread.Hide;
begin
  ShowWindow(FHandle, SW_HIDE);
end;

procedure TMtclDialogThread.MtclDialogProc(var AMessage: TMessage);
var
  CurrentControl: TMtclBaseControl;
  Request: PMtclCreateRequest;
begin
  case AMessage.Msg of
    WM_CLOSE:
      DestroyWindow(FHandle);
    WM_MTCL_CREATECONTROL:
      begin
        // Runs on the dialog thread (sent here from GetNew via SendMessage), so
        // the new child window is owned by the same thread as its parent dialog
        // and by the message loop that paints it. Creating it on the caller's
        // thread (the old Synchronize-on-main-thread approach) gave the child a
        // different owning thread than its parent and led to invisible controls.
        Request := PMtclCreateRequest(AMessage.WParam);
        Request^.Control := Request^.ControlClass.Create(FHandle, GetNewControlID);
        FControls.Add(Request^.Control);
        {$IFDEF Delphi2010up}
        FControlsByID.Add(Request^.Control.DialogItem, Request^.Control);
        FControlsByHandle.Add(Request^.Control.Handle, Request^.Control);
        {$ENDIF}
        AMessage.Result := 1;
      end;
    WM_COMMAND:
      begin
        {$IFDEF Delphi2010up}
        CurrentControl := Get<TMtclBaseControl>(AMessage.WParamLo);
        {$ELSE}
        CurrentControl := Get(AMessage.WParamLo);
        {$ENDIF}
        if Assigned(CurrentControl) then
          CurrentControl.Dispatch(AMessage);
      end;
  else
    DefaultHandler(AMessage);
  end;
end;

procedure TMtclDialogThread.Show;
begin
  WaitForSingleObject(FState, INFINITE);
  ShowWindow(FHandle, SW_SHOWNORMAL);
end;

procedure TMtclDialogThread.WaitForReady;
begin
  WaitForSingleObject(FState, INFINITE);
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

{$IFDEF Delphi2010up}
function TMtclDialog.Get<T>(const AControlID: Integer): T;
begin
  Result := FDialogThread.Get<T>(AControlID);
end;

function TMtclDialog.GetNew<T>: T;
begin
  Result := FDialogThread.GetNew<T>;
end;
{$ELSE}
function TMtclDialog.Get(const AControlID: Integer): TMtclBaseControl;
begin
  Result := FDialogThread.Get(AControlID);
end;

function TMtclDialog.GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
begin
  Result := FDialogThread.GetNew(AClass);
end;
{$ENDIF}

function TMtclDialog.GetHandle: HWND;
begin
  if Assigned(FDialogThread) then
    Result := FDialogThread.Handle
  else
    Result := 0;
end;

procedure TMtclDialog.Hide;
begin
  FDialogThread.Hide;
end;

procedure TMtclDialog.SetHandle(const Value: HWND);
begin
  if Assigned(FDialogThread) then
    FDialogThread.Handle := Value;
end;

procedure TMtclDialog.EnsureReady;
begin
  // Wait until the dialog thread has actually created the window, then read its
  // initial bounds once. After this the inherited Left/Top/Width/Height getters
  // and SetBounds operate on the live dialog window.
  if not FReady and Assigned(FDialogThread) then
  begin
    FDialogThread.WaitForReady;
    InitBounds;
    FReady := True;
  end;
end;

procedure TMtclDialog.Show;
begin
  FDialogThread.Show;
end;

end.
