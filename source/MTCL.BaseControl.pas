(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCL.BaseControl;

interface

{$I CompilerVersions.inc}

uses
  {$IFDEF DelphiXE2up}
  System.Classes, Winapi.Windows, Winapi.Messages, Vcl.Graphics,
  {$ELSE}
  Classes, Windows, Messages, Graphics,
  {$ENDIF}
  MTCL.BaseElement;

type
  // Which edges of the control are tied to the corresponding edges of the parent
  // dialog. When the dialog is resized, an anchored edge keeps its distance to
  // that parent edge (analogous to VCL anchors). Own identifiers (ma...) are used
  // instead of VCL's ak... so both can be referenced in the same unit.
  TMtclAnchorKind = (maLeft, maTop, maRight, maBottom);
  TMtclAnchors = set of TMtclAnchorKind;

const
  cDefaultAnchors = [maLeft, maTop];

type
  // A child control living inside a dialog. Position/size/visibility/text come
  // from TMtclBaseElement; this class adds the parent dialog, the dialog item
  // id, the subclassed window procedure, the font and the anchors.
  TMtclBaseControl = class(TMtclBaseElement)
  private
    FDialog: HWND;
    FOriginalWndProc: Pointer;
    FDialogItem: Integer;
    FFont: TFont;
    FAnchors: TMtclAnchors;
  protected
    procedure Init; virtual;
    procedure WndProc(var AMsg: TMessage); virtual;
    procedure FontChanged(Sender: TObject); virtual;
    procedure InitBounds; override;
  public
    constructor Create(const ADialog, AControl: HWND; const ADialogItem: Integer); overload; virtual;
    constructor Create(const ADialog: HWND; const ADialogItem: Integer); overload; virtual;
    destructor Destroy; override;

    property Dialog: HWND read FDialog write FDialog;
    property DialogItem: Integer read FDialogItem write FDialogItem;
    property Font: TFont read FFont;
    property Anchors: TMtclAnchors read FAnchors write FAnchors;
  end;

implementation

uses Types;

{$IFNDEF Delphi2009up}
type
  // NativeInt was introduced in Delphi 2009. Alias it to Integer for older
  // compilers (e.g. Delphi 7); on Win32 a pointer fits into an Integer.
  NativeInt = Integer;
{$ENDIF}

{ TMtclBaseControl }

constructor TMtclBaseControl.Create(const ADialog, AControl: HWND; const ADialogItem: Integer);
begin
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FAnchors := cDefaultAnchors;
  FDialog := ADialog;
  FHandle := AControl;
  FDialogItem := ADialogItem;
  FOriginalWndProc := Pointer(GetWindowLong(FHandle, GWL_WNDPROC));
  SetWindowLong(FHandle, GWL_WNDPROC, NativeInt(MakeObjectInstance(WndProc)));
  Init;
end;

constructor TMtclBaseControl.Create(const ADialog: HWND; const ADialogItem: Integer);
begin
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FAnchors := cDefaultAnchors;
  FDialog := ADialog;
  FDialogItem := ADialogItem;
  Init;
end;

destructor TMtclBaseControl.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TMtclBaseControl.FontChanged(Sender: TObject);
begin
  SendMessage(Handle, WM_SETFONT, FFont.Handle, 1);
end;

procedure TMtclBaseControl.Init;
begin
  Visible := True;
  InitBounds;
  FFont.Handle := CreateFont(13, 0, 0, 0, FW_DONTCARE, 0, 0, 0, ANSI_CHARSET,
      OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
      DEFAULT_PITCH or FF_DONTCARE, 'Tahoma');
end;

procedure TMtclBaseControl.InitBounds;
var
  WindowRect: TRect;
begin
  if GetWindowRect(Handle, WindowRect) then
  begin
    SetLastError(0);
    // we could use 2 for param cPoints because BottomRight is directly beneath TopLeft in memory, but this would not be clean
    if (MapWindowPoints(HWND_DESKTOP, FDialog, WindowRect.TopLeft, 1) <> 0) or (GetLastError = 0) then
    begin
      FLeft := WindowRect.Left;
      FTop := WindowRect.Top;
    end;
    SetLastError(0);
    if (MapWindowPoints(HWND_DESKTOP, FDialog, WindowRect.BottomRight, 1) <> 0) or (GetLastError = 0) then
    begin
      FWidth := WindowRect.Right - WindowRect.Left;
      FHeight := WindowRect.Bottom - WindowRect.Top;
    end;
  end;
end;

procedure TMtclBaseControl.WndProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_CLOSE:
      DestroyWindow(Handle);
    WM_COMMAND:
      Dispatch(AMsg);
  else
    AMsg.Result := CallWindowProc(FOriginalWndProc, Handle, AMsg.Msg, AMsg.WParam, AMsg.LParam);
  end;
end;

end.
