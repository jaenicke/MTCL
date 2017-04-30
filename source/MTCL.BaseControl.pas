(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.BaseControl;

interface

uses
  Winapi.Windows;

type
  TMtclBaseControl = class(TInterfacedObject)
  private
  var
    FDialog, FHandle: HWND;
    FDialogItem: Integer;
  protected
    procedure Init; virtual;

  public
    constructor Create(const ADialog, AControl: HWND;
      const ADialogItem: Integer); virtual;
    property Dialog: HWND read FDialog write FDialog;
    property Handle: HWND read FHandle write FHandle;
    property DialogItem: Integer read FDialogItem write FDialogItem;
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

procedure TMtclBaseControl.Init;
begin

end;

end.
