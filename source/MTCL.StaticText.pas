(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.StaticText;

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
  // A read-only caption (STATIC). The text is set through the inherited Text
  // property. The unit is named StaticText because "Label" is a reserved word.
  TMtclLabel = class(TMtclBaseControl)
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
  end;

implementation

{ TMtclLabel }

constructor TMtclLabel.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  StaticHandle: HWND;
begin
  StaticHandle := CreateWindowEx(0, 'STATIC', nil, WS_CHILD or WS_VISIBLE or SS_LEFT,
    0, 0, 0, 0, ADialog, ADialogItem, HInstance, nil);
  inherited Create(ADialog, StaticHandle, ADialogItem);
end;

end.
