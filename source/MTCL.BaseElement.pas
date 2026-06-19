(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.BaseElement;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  Winapi.Windows, Winapi.Messages;
  {$ELSE}
  Windows, Messages;
  {$ENDIF}

type
  // Common base for everything that wraps a window handle. It provides position,
  // size, visibility and text. Both TMtclBaseControl (a child control inside a
  // dialog) and TMtclDialog (the dialog window itself) derive from it, so both
  // expose Left/Top/Width/Height/Visible/Text and SetBounds.
  TMtclBaseElement = class(TInterfacedObject)
  protected
    FHandle: HWND;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FVisible: Boolean;
    function GetHandle: HWND; virtual;
    procedure SetHandle(const Value: HWND); virtual;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetVisible: Boolean;
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    function GetText: String;
    procedure SetText(const Value: String);
    function GetTextLength: Integer;
    function GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
    // Reads the current window bounds into the cached fields. The base reads the
    // screen rectangle (correct for a top-level window such as the dialog);
    // TMtclBaseControl overrides it to translate into coordinates relative to
    // the parent dialog.
    procedure InitBounds; virtual;
    // Hook invoked before a property is read or written. The base does nothing
    // (a control's handle exists from construction on). TMtclDialog uses it to
    // wait until its window has actually been created by the dialog thread and
    // to read the initial bounds on first access.
    procedure EnsureReady; virtual;
  public
    procedure SetBounds(const ALeft, ATop, AWidth, AHeight: Integer); virtual;

    property Handle: HWND read GetHandle write SetHandle;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Visible: Boolean read GetVisible write SetVisible;
    property Text: String read GetText write SetText;
  end;

implementation

uses Types;

{$IFNDEF Delphi2009up}
type
  // NativeInt was introduced in Delphi 2009. Alias it to Integer for older
  // compilers (e.g. Delphi 7); on Win32 a pointer fits into an Integer.
  NativeInt = Integer;
{$ENDIF}

{ TMtclBaseElement }

function TMtclBaseElement.GetHandle: HWND;
begin
  Result := FHandle;
end;

procedure TMtclBaseElement.SetHandle(const Value: HWND);
begin
  FHandle := Value;
end;

function TMtclBaseElement.GetLeft: Integer;
begin
  EnsureReady;
  Result := FLeft;
end;

function TMtclBaseElement.GetTop: Integer;
begin
  EnsureReady;
  Result := FTop;
end;

function TMtclBaseElement.GetWidth: Integer;
begin
  EnsureReady;
  Result := FWidth;
end;

function TMtclBaseElement.GetHeight: Integer;
begin
  EnsureReady;
  Result := FHeight;
end;

function TMtclBaseElement.GetVisible: Boolean;
begin
  EnsureReady;
  Result := FVisible;
end;

procedure TMtclBaseElement.SetLeft(const Value: Integer);
begin
  EnsureReady;
  SetBounds(Value, FTop, FWidth, FHeight);
end;

procedure TMtclBaseElement.SetTop(const Value: Integer);
begin
  EnsureReady;
  SetBounds(FLeft, Value, FWidth, FHeight);
end;

procedure TMtclBaseElement.SetWidth(const Value: Integer);
begin
  EnsureReady;
  SetBounds(FLeft, FTop, Value, FHeight);
end;

procedure TMtclBaseElement.SetHeight(const Value: Integer);
begin
  EnsureReady;
  SetBounds(FLeft, FTop, FWidth, Value);
end;

procedure TMtclBaseElement.SetVisible(const Value: Boolean);
var
  ShowValue: Integer;
begin
  EnsureReady;
  if FVisible <> Value then
  begin
    FVisible := Value;
    if FVisible then
      ShowValue := SW_SHOW
    else
      ShowValue := SW_HIDE;
    ShowWindow(GetHandle, ShowValue);
  end;
end;

procedure TMtclBaseElement.SetBounds(const ALeft, ATop, AWidth, AHeight: Integer);
begin
  EnsureReady;
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
  SetWindowPos(GetHandle, 0, ALeft, ATop, AWidth, AHeight, SWP_NOACTIVATE or SWP_NOZORDER);
end;

function TMtclBaseElement.GetText: String;
var
  Len: Integer;
begin
  EnsureReady;
  Len := GetTextLength;
  SetString(Result, PChar(nil), Len);
  if Len <> 0 then
  begin
    Len := Len - GetTextBuffer(PChar(Result), Len + 1);
    if Len > 0 then
      SetLength(Result, Length(Result) - Len);
  end;
end;

function TMtclBaseElement.GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := SendMessage(GetHandle, WM_GETTEXT, BufSize, LPARAM(Buffer));
end;

function TMtclBaseElement.GetTextLength: Integer;
begin
  Result := SendMessage(GetHandle, WM_GETTEXTLENGTH, 0, 0);
end;

procedure TMtclBaseElement.SetText(const Value: String);
begin
  EnsureReady;
  SendMessage(GetHandle, WM_SETTEXT, 0, NativeInt(PChar(Value)));
end;

procedure TMtclBaseElement.InitBounds;
var
  WindowRect: TRect;
begin
  if GetWindowRect(GetHandle, WindowRect) then
  begin
    FLeft := WindowRect.Left;
    FTop := WindowRect.Top;
    FWidth := WindowRect.Right - WindowRect.Left;
    FHeight := WindowRect.Bottom - WindowRect.Top;
  end;
  FVisible := IsWindowVisible(GetHandle);
end;

procedure TMtclBaseElement.EnsureReady;
begin
  // Nothing to do by default; TMtclDialog overrides this.
end;

end.
