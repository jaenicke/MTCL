(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.Button;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes,
  MTCL.BaseControl;

type
  TMtclButton = class(TMtclBaseControl)
  private
    FOnClick: TNotifyEvent;
    procedure SetOnClick(const Value: TNotifyEvent);
    function GetOnClick: TNotifyEvent;
  protected
    procedure Init; override;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  public
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

implementation

{ TMtclButton }

function TMtclButton.GetOnClick: TNotifyEvent;
begin
  Result := FOnClick;
end;

procedure TMtclButton.Init;
begin

end;

procedure TMtclButton.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;

procedure TMtclButton.WMCommand(var Message: TWMCommand);
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

end.
