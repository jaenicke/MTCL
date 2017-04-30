(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Memo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes,
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
    constructor Create(const ADialog, AControl: HWND;
      const ADialogItem: Integer); override;
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

constructor TMtclMemo.Create(const ADialog, AControl: HWND;
  const ADialogItem: Integer);
begin
  inherited;
  FLines := TStringList.Create;
  Lines.OnChange := TextChanged;
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
