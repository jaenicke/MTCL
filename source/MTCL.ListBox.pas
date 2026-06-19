(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.ListBox;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  System.Classes, Winapi.Windows, Winapi.Messages,
  {$ELSE}
  Classes, Windows, Messages,
  {$ENDIF}
  MTCL.BaseControl;

type
  // A single-selection list (LISTBOX). Items are added with Add; the current
  // selection is ItemIndex / SelText. OnChange fires on LBN_SELCHANGE.
  TMtclListBox = class(TMtclBaseControl)
  private
    FOnChange: TNotifyEvent;
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
  protected
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
    procedure Add(const AItem: String);
    procedure Clear;
    function Count: Integer;
    function SelText: String;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TMtclListBox }

constructor TMtclListBox.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  ListHandle: HWND;
begin
  ListHandle := CreateWindowEx(WS_EX_CLIENTEDGE, 'LISTBOX', nil,
    WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_VSCROLL or LBS_NOTIFY or LBS_HASSTRINGS,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, ListHandle, ADialogItem);
end;

procedure TMtclListBox.Add(const AItem: String);
begin
  SendMessage(Handle, LB_ADDSTRING, 0, LPARAM(PChar(AItem)));
end;

procedure TMtclListBox.Clear;
begin
  SendMessage(Handle, LB_RESETCONTENT, 0, 0);
end;

function TMtclListBox.Count: Integer;
begin
  Result := SendMessage(Handle, LB_GETCOUNT, 0, 0);
end;

function TMtclListBox.GetItemIndex: Integer;
begin
  Result := SendMessage(Handle, LB_GETCURSEL, 0, 0);
end;

procedure TMtclListBox.SetItemIndex(const Value: Integer);
begin
  SendMessage(Handle, LB_SETCURSEL, Value, 0);
end;

function TMtclListBox.SelText: String;
var
  Index, Len: Integer;
begin
  Result := '';
  Index := GetItemIndex;
  if Index < 0 then
    Exit;
  Len := SendMessage(Handle, LB_GETTEXTLEN, Index, 0);
  if Len <= 0 then
    Exit;
  SetLength(Result, Len);
  SendMessage(Handle, LB_GETTEXT, Index, LPARAM(PChar(Result)));
end;

procedure TMtclListBox.WMCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = LBN_SELCHANGE) and Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
