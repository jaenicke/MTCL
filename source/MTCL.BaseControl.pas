(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.BaseControl;

interface

uses
  Winapi.Windows, Winapi.Messages;

type
  TMtclBaseControl = class(TInterfacedObject)
  private
  var
    FDialog, FHandle: HWND;
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
  protected
    procedure Init; virtual;
  public
    constructor Create(const ADialog, AControl: HWND; const ADialogItem: Integer); virtual;

    procedure SetBounds(const ALeft, ATop, AWidth, AHeight: Integer); virtual;

    property Dialog: HWND read FDialog write FDialog;
    property Handle: HWND read FHandle write FHandle;
    property DialogItem: Integer read FDialogItem write FDialogItem;

    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

implementation

{ TMtclBaseControl }

constructor TMtclBaseControl.Create(const ADialog, AControl: HWND;
  const ADialogItem: Integer);
begin
  FDialog := ADialog;
  FHandle := AControl;
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
      FWidth := WindowRect.Width;
      FHeight := WindowRect.Height;
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

end.
