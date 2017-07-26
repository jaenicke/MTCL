(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.BaseControl;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  System.Classes, Winapi.Windows, Winapi.Messages;
  {$ELSE}
  Classes, Windows, Messages;
  {$ENDIF}

type
  TMtclBaseControl = class(TInterfacedObject)
  private
    FDialog, FHandle: HWND;
    FOriginalWndProc: Pointer;
    FDialogItem: Integer;
    FWidth: Integer;
    FTop: Integer;
    FHeight: Integer;
    FLeft: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    function GetText: String;
    procedure SetText(const Value: String);
    function GetTextLength: Integer;
    function GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
  protected
    procedure Init; virtual;
    procedure WndProc(var AMsg: TMessage); virtual;
  public
    constructor Create(const ADialog, AControl: HWND; const ADialogItem: Integer); overload; virtual;
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); overload; virtual;

    procedure SetBounds(const ALeft, ATop, AWidth, AHeight: Integer); virtual;

    property Dialog: HWND read FDialog write FDialog;
    property Handle: HWND read FHandle write FHandle;
    property DialogItem: Integer read FDialogItem write FDialogItem;

    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Text: String read GetText write SetText;
  end;

implementation

uses Types;

{ TMtclBaseControl }

constructor TMtclBaseControl.Create(const ADialog, AControl: HWND; const ADialogItem: Integer);
begin
  FDialog := ADialog;
  FHandle := AControl;
  FDialogItem := ADialogItem;
  FOriginalWndProc := Pointer(GetWindowLong(FHandle, GWL_WNDPROC));
  SetWindowLong(FHandle, GWL_WNDPROC, NativeInt(MakeObjectInstance(WndProc)));
  Init;
end;

constructor TMtclBaseControl.Create(const ADialog: HWND; const ADialogItem: Integer);
begin
  FDialog := ADialog;
  FDialogItem := ADialogItem;
  Init;
end;

function TMtclBaseControl.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TMtclBaseControl.GetLeft: Integer;
begin
  Result := FLeft;
end;

function TMtclBaseControl.GetTop: Integer;
begin
  Result := FTop;
end;

function TMtclBaseControl.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TMtclBaseControl.Init;
var
  WindowRect: TRect;
begin
  if GetWindowRect(FHandle, WindowRect) then
  begin
    SetLastError(0);
    // we could use 2 for param cPoints because BottomRight is directly beneath TopLeft in memory, but this would not be clean
    if (MapWindowPoints(HWND_DESKTOP, FDialog, WindowRect.TopLeft, 1) <> 0) or (GetLastError = 0) then
    begin
      FLeft := WindowRect.Left;
      FTop := WindowRect.Top;
    end;
    SetLastError(0);
    if (MapWindowPoints(HWND_DESKTOP, FDialog, WindowRect.BottomRight, 1) <> 0) or (GetLastError = 0) then
    begin
      FWidth := WindowRect.Right - WindowRect.Left;
      FHeight := WindowRect.Bottom - WindowRect.Top;
    end;
  end;
end;

procedure TMtclBaseControl.SetBounds(const ALeft, ATop, AWidth, AHeight: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
  SetWindowPos(FHandle, 0, ALeft, ATop, AWidth, AHeight, SWP_NOACTIVATE or SWP_NOZORDER);
end;

procedure TMtclBaseControl.SetHeight(const Value: Integer);
begin
  SetBounds(FLeft, FTop, FWidth, Value);
end;

procedure TMtclBaseControl.SetLeft(const Value: Integer);
begin
  SetBounds(Value, FTop, FWidth, FHeight);
end;

procedure TMtclBaseControl.SetTop(const Value: Integer);
begin
  SetBounds(FLeft, Value, FWidth, FHeight);
end;

procedure TMtclBaseControl.SetWidth(const Value: Integer);
begin
  SetBounds(FLeft, FTop, Value, FHeight);
end;

procedure TMtclBaseControl.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_CLOSE:
      DestroyWindow(FHandle);
    WM_COMMAND:
      Dispatch(AMsg);
  else
    AMsg.Result := CallWindowProc(FOriginalWndProc, FHandle, AMsg.Msg, AMsg.WParam, AMsg.LParam);
  end;
end;

function TMtclBaseControl.GetText: String;
var
  Len: Integer;
begin
  Len := GetTextLength;
  SetString(Result, PChar(nil), Len);
  if Len <> 0 then
  begin
    Len := Len - GetTextBuffer(PChar(Result), Len + 1);
    if Len > 0 then
      SetLength(Result, Length(Result) - Len);
  end;
end;

function TMtclBaseControl.GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := SendMessage(Handle, WM_GETTEXT, BufSize, LPARAM(Buffer));
end;

function TMtclBaseControl.GetTextLength: Integer;
begin
  Result := SendMessage(Handle, WM_GETTEXTLENGTH, 0, 0);
end;

procedure TMtclBaseControl.SetText(const Value: String);
begin
  SendMessage(Handle, WM_SETTEXT, 0, NativeInt(PChar(Value)));
end;

end.
