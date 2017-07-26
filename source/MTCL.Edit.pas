(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Edit;

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
  TMtclEdit = class(TMtclBaseControl)
  protected
    procedure Init; override;
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
  end;

implementation

{ TMtclMemo }

constructor TMtclEdit.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  EditHandle: HWND;
begin
  EditHandle := CreateWindowEx(0, 'EDIT', nil, WS_CHILD or WS_VISIBLE or WS_VSCROLL or ES_LEFT or ES_AUTOVSCROLL,
    0, 0, 0, 0, ADialog, ADialogItem, GetWindowLong(ADialog, GWL_HINSTANCE), nil);
  inherited Create(ADialog, EditHandle, ADialogItem);
end;

procedure TMtclEdit.Init;
begin
  inherited;
end;

end.
