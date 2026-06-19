(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.ComboBox;

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
  // A drop-down list (COMBOBOX / CBS_DROPDOWNLIST). Items are added with Add;
  // the current selection is ItemIndex / SelText. OnChange fires on
  // CBN_SELCHANGE. The height passed to SetBounds also limits the drop-down.
  TMtclComboBox = class(TMtclBaseControl)
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

{ TMtclComboBox }

constructor TMtclComboBox.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  ComboHandle: HWND;
begin
  ComboHandle := CreateWindowEx(0, 'COMBOBOX', nil,
    WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_VSCROLL or CBS_DROPDOWNLIST,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, ComboHandle, ADialogItem);
end;

procedure TMtclComboBox.Add(const AItem: String);
begin
  SendMessage(Handle, CB_ADDSTRING, 0, LPARAM(PChar(AItem)));
end;

procedure TMtclComboBox.Clear;
begin
  SendMessage(Handle, CB_RESETCONTENT, 0, 0);
end;

function TMtclComboBox.Count: Integer;
begin
  Result := SendMessage(Handle, CB_GETCOUNT, 0, 0);
end;

function TMtclComboBox.GetItemIndex: Integer;
begin
  Result := SendMessage(Handle, CB_GETCURSEL, 0, 0);
end;

procedure TMtclComboBox.SetItemIndex(const Value: Integer);
begin
  SendMessage(Handle, CB_SETCURSEL, Value, 0);
end;

function TMtclComboBox.SelText: String;
var
  Index, Len: Integer;
begin
  Result := '';
  Index := GetItemIndex;
  if Index < 0 then
    Exit;
  Len := SendMessage(Handle, CB_GETLBTEXTLEN, Index, 0);
  if Len <= 0 then
    Exit;
  SetLength(Result, Len);
  SendMessage(Handle, CB_GETLBTEXT, Index, LPARAM(PChar(Result)));
end;

procedure TMtclComboBox.WMCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = CBN_SELCHANGE) and Assigned(FOnChange) then
    FOnChange(Self);
end;

end.
