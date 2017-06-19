(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Progress;

interface

uses
  Windows, Messages, CommCtrl, Classes,
  MTCL.BaseControl;

type
  TMtclProgress = class(TMtclBaseControl)
  private
    function GetMax: Word;
    function GetMin: Word;
    function GetProgress: Integer;
    procedure SetMax(const Value: Word);
    procedure SetMin(const Value: Word);
    procedure SetProgress(const Value: Integer);
  public
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
    property Min: Word read GetMin write SetMin;
    property Max: Word read GetMax write SetMax;
    property Progress: Integer read GetProgress write SetProgress;
  end;

implementation

{ TMtclProgress }

constructor TMtclProgress.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  EditHandle: HWND;
begin
  EditHandle := CreateWindowEx(0, PROGRESS_CLASS, nil, WS_CHILD or WS_VISIBLE,
    0, 0, 0, 0, ADialog, ADialogItem, GetWindowLong(ADialog, GWL_HINSTANCE), nil);
  inherited Create(ADialog, EditHandle, ADialogItem);
end;

function TMtclProgress.GetMax: Word;
begin
  Result := SendMessage(Handle, PBM_GETRANGE, 1, 0);
end;

function TMtclProgress.GetMin: Word;
begin
  Result := SendMessage(Handle, PBM_GETRANGE, 0, 0);
end;

function TMtclProgress.GetProgress: Integer;
begin
  Result := SendMessage(Handle, PBM_GETPOS, 0, 0);
end;

procedure TMtclProgress.SetMax(const Value: Word);
begin
  SendMessage(Handle, PBM_SETRANGE32, Min, Value);
end;

procedure TMtclProgress.SetMin(const Value: Word);
begin
  SendMessage(Handle, PBM_SETRANGE32, Value, Max);
end;

procedure TMtclProgress.SetProgress(const Value: Integer);
begin
  SendMessage(Handle, PBM_SETPOS, Value, 0);
end;

end.
