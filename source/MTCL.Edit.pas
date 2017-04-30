(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Edit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  MTCL.BaseControl;

type
  TMtclEdit = class(TMtclBaseControl)
  private
    function GetText: WideString;
    procedure SetText(const Value: WideString);
    function GetTextLength: Integer;
    function GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
  protected
    procedure Init; override;
  public
    property Text: WideString read GetText write SetText;
  end;

implementation

{ TMtclMemo }

function TMtclEdit.GetText: WideString;
var
  Len: Integer;
begin
  Len := GetTextLength;
  SetString(Result, PChar(nil), Len);
  if Len <> 0 then
  begin
    Len := Len - GetTextBuffer(PChar(Result), Len + 1);
    if Len > 0 then
      SetLength(Result, Length(Result) - Len);
  end;
end;

function TMtclEdit.GetTextBuffer(Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := SendMessage(Handle, WM_GETTEXT, BufSize, LPARAM(Buffer));
end;

function TMtclEdit.GetTextLength: Integer;
begin
  Result := SendMessage(Handle, WM_GETTEXTLENGTH, 0, 0);
end;

procedure TMtclEdit.Init;
begin
end;

procedure TMtclEdit.SetText(const Value: WideString);
begin
  SetDlgItemText(Dialog, DialogItem, PChar(Value));
end;

end.
