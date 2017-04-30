(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

  Copyright (c) 2017, ADDIPOS GmbH jaenicke.github@outlook.com
*)
unit MTCLBasicDemoMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  MTCL.Dialog, MTCL.Edit, MTCL.Button;

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
    FExampleThreads: TObjectList<TExampleThread>;
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
  i, j: Integer;
begin
  TThread.NameThreadForDebugging('TExampleThread: ' + FExampleText);
  FExampleThreadDialog := TMtclDialog.Create(1901);
  try
    FExampleThreadDialog.Show;
    ExampleControl := FExampleThreadDialog.Get<TMtclEdit>(4001);
    FExampleThreadDialog.Get<TMtclButton>(IDOK).OnClick := DialogButtonClick;
    for i := 0 to 10 do
    begin
      for j := 0 to 10 do
      begin
        ExampleControl.Text := ExampleControl.Text + FExampleText;
        if Terminated then
          Exit;
        Sleep(100);
      end;
      ExampleControl.Text := ExampleControl.Text + #13#10;
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
  CurrentDialog: TExampleThread;
begin
  for CurrentDialog in FExampleThreads do
    CurrentDialog.Hide;
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
  CurrentDialog: TExampleThread;
begin
  for CurrentDialog in FExampleThreads do
    CurrentDialog.Show;
end;

procedure TfrmMultithreadTestMain.FormCreate(Sender: TObject);
begin
  FExampleThreads := TObjectList<TExampleThread>.Create(True);
end;

procedure TfrmMultithreadTestMain.FormDestroy(Sender: TObject);
begin
  FExampleThreads.Free;
end;

end.
