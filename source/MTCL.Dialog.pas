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
  MTCL.BaseControl, MTCL.Button, MTCL.Memo;

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
    FResultControl: TMtclBaseControl;
    FResultClass: TMtclBaseControlClass;
    {$ENDIF}
    FState: Integer;
    FLastControlID: Integer;
    procedure AddControl(const AHandle: HWND);
    procedure MtclDialogProc(var AMessage: TMessage);
    function GetNewControlID: Integer;
    {$IFNDEF Delphi2010up}
    procedure CreateNewControl;
    {$ENDIF}
  protected
    procedure Execute; override;
  public
    constructor Create(const AResource: Integer);
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    {$IFDEF Delphi2010up}
    function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
    function GetNew<T: TMtclBaseControl>: T;
    {$ELSE}
    function Get(const AControlID: Integer): TMtclBaseControl;
    function GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
    {$ENDIF}
    property Handle: HWND read FHandle write FHandle;
  end;

  TMtclDialog = class
  private
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
    {$IFDEF Delphi2010up}
    function Get<T: TMtclBaseControl>(const AControlID: Integer): T;
    function GetNew<T: TMtclBaseControl>: T;
    {$ELSE}
    function Get(const AControlID: Integer): TMtclBaseControl;
    function GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
    {$ENDIF}
  end;

implementation

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
begin
  {$IFDEF Delphi2010up}
  TThread.NameThreadForDebugging('TMtclDialogThread ' + IntToStr(FResource));
  {$ENDIF}
  FHandle := CreateDialogParam(hInstance, MAKEINTRESOURCE(FResource), 0, MakeObjectInstance(MtclDialogProc), 0);
  ShowWindow(FHandle, SW_SHOWNORMAL);
  EnumChildWindows(FHandle, @EnumWindowsProc, Integer(Self));
  InvalidateRect(FHandle, nil, True);
  SetEvent(FState);
{$BOOLEVAL OFF}
  while not Terminated do
  begin
    if PeekMessage(CurrentMessage, 0, 0, 0, PM_REMOVE) and not IsDialogMessage(FHandle, CurrentMessage) then
    begin
      TranslateMessage(CurrentMessage);
      DispatchMessage(CurrentMessage);
    end;
    Sleep(1);
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
var
  ResultControl: TMtclBaseControl;
begin
  TThread.Synchronize(Self, procedure
    begin
      ResultControl := TMtclBaseControlClass(T).Create(Self.Handle, Self.GetNewControlID);
    end);
  Result := T(ResultControl);
  FControls.Add(Result);
  FControlsByID.Add(Result.DialogItem, Result);
  FControlsByHandle.Add(Result.Handle, Result);
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

procedure TMtclDialogThread.CreateNewControl;
begin
  FResultControl := FResultClass.Create(Self.Handle, Self.GetNewControlID);
end;

function TMtclDialogThread.GetNew(const AClass: TMtclBaseControlClass): TMtclBaseControl;
begin
  FResultClass := AClass;
  TThread.Synchronize(Self, CreateNewControl);
  Result := FResultControl;
  FControls.Add(Result);
end;
{$ENDIF}

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
begin
  case AMessage.Msg of
    WM_CLOSE:
      DestroyWindow(FHandle);
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
