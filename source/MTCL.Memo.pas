(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Memo;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  System.Classes, Winapi.Windows, Winapi.Messages,
  {$ELSE}
  Classes, Windows, Messages,
  {$ENDIF}
  MTCL.Edit;

type
  TMtclMemo = class(TMtclEdit)
  private
    FLines: TStringList;
    FUpdate: Integer;
  protected
    function GetLines: TStringList;
    procedure TextChanged(Sender: TObject);
  public
    constructor Create(const ADialog, AControl: HWND; const ADialogItem: Integer); override;
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property Lines: TStringList read GetLines;
  end;

implementation

{ TMtclMemo }

procedure TMtclMemo.BeginUpdate;
begin
  inc(FUpdate);
end;

constructor TMtclMemo.Create(const ADialog, AControl: HWND; const ADialogItem: Integer);
begin
  inherited Create(ADialog, AControl, ADialogItem);
  FLines := TStringList.Create;
  Lines.OnChange := TextChanged;
end;

constructor TMtclMemo.Create(const ADialog: HWND; const ADialogItem: Integer);
var
  EditHandle: HWND;
begin
  FLines := TStringList.Create;
  EditHandle := CreateWindowEx(0, 'EDIT', nil, WS_CHILD or WS_VISIBLE or WS_VSCROLL or ES_LEFT or ES_MULTILINE or ES_AUTOVSCROLL,
    0, 0, 0, 0, ADialog, ADialogItem, GetWindowLong(ADialog, GWL_HINSTANCE), nil);
  inherited Create(ADialog, EditHandle, ADialogItem);
end;

procedure TMtclMemo.EndUpdate;
begin
  if FUpdate > 0 then
    Dec(FUpdate);
  if FUpdate = 0 then
    Text := FLines.Text;
end;

function TMtclMemo.GetLines: TStringList;
begin
  Result := FLines;
end;

procedure TMtclMemo.TextChanged(Sender: TObject);
begin
  if FUpdate = 0 then
    Text := FLines.Text;
end;

end.
