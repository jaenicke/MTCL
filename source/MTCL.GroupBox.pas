(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.GroupBox;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  Winapi.Windows, Winapi.Messages,
  {$ELSE}
  Windows, Messages,
  {$ENDIF}
  MTCL.BaseControl;

type
  // A visual frame with a caption (BUTTON / BS_GROUPBOX). Create it before the
  // controls it visually surrounds so it stays behind them. The caption is set
  // through the inherited Text property.
  TMtclGroupBox = class(TMtclBaseControl)
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
  end;

implementation

{ TMtclGroupBox }

constructor TMtclGroupBox.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  GroupHandle: HWND;
begin
  GroupHandle := CreateWindowEx(0, 'BUTTON', nil, WS_CHILD or WS_VISIBLE or BS_GROUPBOX,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, GroupHandle, ADialogItem);
end;

end.
