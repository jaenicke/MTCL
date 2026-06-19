(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.RadioButton;

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
  // An auto radio button. Auto radio buttons in the same group mutually exclude
  // each other. Derives from TMtclButton to reuse OnClick.
  TMtclRadioButton = class(TMtclButton)
  private
    function GetChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
    property Checked: Boolean read GetChecked write SetChecked;
  end;

implementation

{ TMtclRadioButton }

constructor TMtclRadioButton.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  RadioHandle: HWND;
begin
  RadioHandle := CreateWindowEx(0, 'BUTTON', nil, WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_AUTORADIOBUTTON,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, RadioHandle, ADialogItem);
end;

function TMtclRadioButton.GetChecked: Boolean;
begin
  Result := SendMessage(Handle, BM_GETCHECK, 0, 0) = BST_CHECKED;
end;

procedure TMtclRadioButton.SetChecked(const Value: Boolean);
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
