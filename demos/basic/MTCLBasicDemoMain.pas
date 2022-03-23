(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCLBasicDemoMain;

{$I ..\..\source\CompilerVersions.inc}

interface

uses
  {$IFDEF DelphiXE2up}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  {$ENDIF}
  {$IFDEF Delphi2010up}
  Generics.Collections,
  {$ELSE}
  Contnrs,
  {$ENDIF}
  MTCL.Dialog, MTCL.Edit, MTCL.Button, MTCL.Progress;

type
  TExampleThread = class(TThread)
  private
    FExampleText: string;
    FExampleThreadDialog: TMtclDialog;
    procedure DialogButtonClick(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(const AExampleText: string);
    procedure Show;
    procedure Hide;
  end;

  TfrmMultithreadTestMain = class(TForm)
    btnNewThread: TButton;
    btnShowAllWindows: TButton;
    btnHideAllWindows: TButton;
    edtThreadText: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewThreadClick(Sender: TObject);
    procedure btnHideAllWindowsClick(Sender: TObject);
    procedure btnShowAllWindowsClick(Sender: TObject);
  private
    {$IFDEF Delphi2010up}
    FExampleThreads: TObjectList<TExampleThread>;
    {$ELSE}
    FExampleThreads: TObjectList;
    {$ENDIF}
  public
    { Public-Deklarationen }
  end;

var
  frmMultithreadTestMain: TfrmMultithreadTestMain;

implementation

{$R *.dfm}
{$R MTCLBasicDemoDialog.res}

{ TExampleThread }

constructor TExampleThread.Create(const AExampleText: string);
begin
  inherited Create(False);
  FExampleText := AExampleText;
end;

procedure TExampleThread.DialogButtonClick(Sender: TObject);
begin
  Terminate;
end;

procedure TExampleThread.Execute;
var
  ExampleControl: TMtclEdit;
  ResButton, SecondButton: TMtclButton;
  ProgressBar: TMtclProgress;
  i, j, ProgressLeft: Integer;
begin
  {$IFDEF Delphi2010up}
  TThread.NameThreadForDebugging('TExampleThread: ' + FExampleText);
  {$ENDIF}
  FExampleThreadDialog := TMtclDialog.Create(1901);
  try
    FExampleThreadDialog.Show;
    {$IFDEF Delphi2010up}
    ExampleControl := FExampleThreadDialog.Get<TMtclEdit>(4001);
    ResButton := FExampleThreadDialog.Get<TMtclButton>(IDOK);
    SecondButton := FExampleThreadDialog.GetNew<TMtclButton>;
    ProgressBar := FExampleThreadDialog.GetNew<TMtclProgress>;
    {$ELSE}
    ExampleControl := FExampleThreadDialog.Get(4001) as TMtclEdit;
    ResButton := FExampleThreadDialog.Get(IDOK) as TMtclButton;
    SecondButton := FExampleThreadDialog.GetNew(TMtclButton) as TMtclButton;
    ProgressBar := FExampleThreadDialog.GetNew(TMtclProgress) as TMtclProgress;
    {$ENDIF}
	  ResButton.OnClick := DialogButtonClick;
    SecondButton.SetBounds(ExampleControl.Left, 2 * ExampleControl.Top + ExampleControl.Height,
      ResButton.Width, ResButton.Height);
    SecondButton.Text := 'Dynamisch';
    SecondButton.OnClick := DialogButtonClick;
    ProgressBar.Min := 0;
    ProgressBar.Max := 15;
    ProgressLeft := 2 * SecondButton.Left + SecondButton.Width;
    ProgressBar.SetBounds(ProgressLeft, SecondButton.Top, ResButton.Left - ProgressLeft - SecondButton.Left, SecondButton.Height);
    for i := 1 to 15 do
    begin
      ExampleControl.Font.Height := 13 + Random(10);
      ExampleControl.Left := ExampleControl.Left + 10;
      Sleep(100);
      ExampleControl.Left := ExampleControl.Left - 10;
      for j := 0 to 10 do
      begin
        ExampleControl.Text := ExampleControl.Text + FExampleText;
        if Terminated then
          Exit;
        Sleep(100);
      end;
      ExampleControl.Text := ExampleControl.Text + #13#10;
      ProgressBar.Progress := i;
    end;
  finally
    FExampleThreadDialog.Free;
  end;
end;

procedure TExampleThread.Hide;
begin
  FExampleThreadDialog.Hide;
end;

procedure TExampleThread.Show;
begin
  FExampleThreadDialog.Show;
end;

procedure TfrmMultithreadTestMain.btnHideAllWindowsClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FExampleThreads.Count - 1 do
    {$IFDEF Delphi2010up}
    FExampleThreads[i].Hide;
    {$ELSE}
    TExampleThread(FExampleThreads[i]).Hide;
    {$ENDIF}
end;

procedure TfrmMultithreadTestMain.btnNewThreadClick(Sender: TObject);
var
  NewThread: TExampleThread;
begin
  NewThread := TExampleThread.Create(edtThreadText.Text);
  FExampleThreads.Add(NewThread);
end;

procedure TfrmMultithreadTestMain.btnShowAllWindowsClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FExampleThreads.Count - 1 do
    {$IFDEF Delphi2010up}
    FExampleThreads[i].Show;
    {$ELSE}
    TExampleThread(FExampleThreads[i]).Show;
    {$ENDIF}
end;

procedure TfrmMultithreadTestMain.FormCreate(Sender: TObject);
begin
  {$IFDEF Delphi2010up}
  FExampleThreads := TObjectList<TExampleThread>.Create(True);
  {$ELSE}
  FExampleThreads := TObjectList.Create(True);
  {$ENDIF}
end;

procedure TfrmMultithreadTestMain.FormDestroy(Sender: TObject);
begin
  FExampleThreads.Free;
end;

end.
