(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.CheckBox;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  Winapi.Windows, Winapi.Messages,
  {$ELSE}
  Windows, Messages,
  {$ENDIF}
  MTCL.BaseControl, MTCL.Button;

type
  // An auto check box. Derives from TMtclButton to reuse OnClick (fired on
  // BN_CLICKED, i.e. whenever the state is toggled).
  TMtclCheckBox = class(TMtclButton)
  private
    function GetChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
    property Checked: Boolean read GetChecked write SetChecked;
  end;

implementation

{ TMtclCheckBox }

constructor TMtclCheckBox.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  CheckHandle: HWND;
begin
  CheckHandle := CreateWindowEx(0, 'BUTTON', nil, WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_AUTOCHECKBOX,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, CheckHandle, ADialogItem);
end;

function TMtclCheckBox.GetChecked: Boolean;
begin
  Result := SendMessage(Handle, BM_GETCHECK, 0, 0) = BST_CHECKED;
end;

procedure TMtclCheckBox.SetChecked(const Value: Boolean);
var
  State: WPARAM;
begin
  if Value then
    State := BST_CHECKED
  else
    State := BST_UNCHECKED;
  SendMessage(Handle, BM_SETCHECK, State, 0);
end;

end.
