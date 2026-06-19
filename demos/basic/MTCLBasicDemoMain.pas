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
  MTCL.Dialog, MTCL.BaseControl, MTCL.Edit, MTCL.Button, MTCL.Progress,
  MTCL.StaticText, MTCL.CheckBox, MTCL.RadioButton, MTCL.GroupBox,
  MTCL.ComboBox, MTCL.ListBox;

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

  // Opens a separate dialog that demonstrates the additional components
  // (label, check box, radio buttons, group box, combo box, list box). The
  // dialog stays open and interactive until it is closed or the program ends.
  TComponentDemoThread = class(TThread)
  private
    FDialog: TMtclDialog;
    FStatus: TMtclLabel;
    FCheck: TMtclCheckBox;
    FRadioA: TMtclRadioButton;
    FRadioB: TMtclRadioButton;
    FCombo: TMtclComboBox;
    FList: TMtclListBox;
    procedure CheckClick(Sender: TObject);
    procedure RadioClick(Sender: TObject);
    procedure ComboChange(Sender: TObject);
    procedure ListChange(Sender: TObject);
    procedure CloseClick(Sender: TObject);
  protected
    procedure Execute; override;
  end;

  TfrmMultithreadTestMain = class(TForm)
    btnNewThread: TButton;
    btnShowAllWindows: TButton;
    btnHideAllWindows: TButton;
    edtThreadText: TEdit;
    btnComponents: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewThreadClick(Sender: TObject);
    procedure btnHideAllWindowsClick(Sender: TObject);
    procedure btnShowAllWindowsClick(Sender: TObject);
    procedure btnComponentsClick(Sender: TObject);
  private
    {$IFDEF Delphi2010up}
    FExampleThreads: TObjectList<TExampleThread>;
    FComponentThreads: TObjectList<TComponentDemoThread>;
    {$ELSE}
    FExampleThreads: TObjectList;
    FComponentThreads: TObjectList;
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
    // Anchors: the edit fills the dialog, the buttons stay in their bottom
    // corners and the progress bar stretches along the bottom. Resize the dialog
    // (drag its border or the line below) and the controls reflow accordingly.
    ExampleControl.Anchors := [maLeft, maTop, maRight, maBottom];
    SecondButton.Anchors := [maLeft, maBottom];
    ProgressBar.Anchors := [maLeft, maRight, maBottom];
    ResButton.Anchors := [maRight, maBottom];
    FExampleThreadDialog.Width := FExampleThreadDialog.Width + 200;
    FExampleThreadDialog.Height := FExampleThreadDialog.Height + 120;
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

{ TComponentDemoThread }

procedure TComponentDemoThread.CheckClick(Sender: TObject);
begin
  if FCheck.Checked then
    FStatus.Text := 'Status: Aktiviert ein'
  else
    FStatus.Text := 'Status: Aktiviert aus';
end;

procedure TComponentDemoThread.RadioClick(Sender: TObject);
begin
  if FRadioA.Checked then
    FStatus.Text := 'Status: Option A'
  else if FRadioB.Checked then
    FStatus.Text := 'Status: Option B';
end;

procedure TComponentDemoThread.ComboChange(Sender: TObject);
begin
  FStatus.Text := 'ComboBox: ' + FCombo.SelText;
end;

procedure TComponentDemoThread.ListChange(Sender: TObject);
begin
  FStatus.Text := 'ListBox: ' + FList.SelText;
end;

procedure TComponentDemoThread.CloseClick(Sender: TObject);
begin
  Terminate;
end;

procedure TComponentDemoThread.Execute;
var
  Group: TMtclGroupBox;
  ComboLabel, ListLabel: TMtclLabel;
  CloseBtn: TMtclButton;
  DlgHandle: HWND;
begin
  {$IFDEF Delphi2010up}
  TThread.NameThreadForDebugging('TComponentDemoThread');
  {$ENDIF}
  // Created entirely in code - no dialog resource needed.
  FDialog := TMtclDialog.CreateNew;
  try
    FDialog.Show;
    FDialog.Text := 'MTCL Komponenten';
    FDialog.Width := 480;
    FDialog.Height := 320;
    {$IFDEF Delphi2010up}
    Group := FDialog.GetNew<TMtclGroupBox>;
    FCheck := FDialog.GetNew<TMtclCheckBox>;
    FRadioA := FDialog.GetNew<TMtclRadioButton>;
    FRadioB := FDialog.GetNew<TMtclRadioButton>;
    ComboLabel := FDialog.GetNew<TMtclLabel>;
    FCombo := FDialog.GetNew<TMtclComboBox>;
    ListLabel := FDialog.GetNew<TMtclLabel>;
    FList := FDialog.GetNew<TMtclListBox>;
    FStatus := FDialog.GetNew<TMtclLabel>;
    CloseBtn := FDialog.GetNew<TMtclButton>;
    {$ELSE}
    Group := FDialog.GetNew(TMtclGroupBox) as TMtclGroupBox;
    FCheck := FDialog.GetNew(TMtclCheckBox) as TMtclCheckBox;
    FRadioA := FDialog.GetNew(TMtclRadioButton) as TMtclRadioButton;
    FRadioB := FDialog.GetNew(TMtclRadioButton) as TMtclRadioButton;
    ComboLabel := FDialog.GetNew(TMtclLabel) as TMtclLabel;
    FCombo := FDialog.GetNew(TMtclComboBox) as TMtclComboBox;
    ListLabel := FDialog.GetNew(TMtclLabel) as TMtclLabel;
    FList := FDialog.GetNew(TMtclListBox) as TMtclListBox;
    FStatus := FDialog.GetNew(TMtclLabel) as TMtclLabel;
    CloseBtn := FDialog.GetNew(TMtclButton) as TMtclButton;
    {$ENDIF}

    // Group box created first so it stays behind the controls it surrounds.
    Group.Text := 'Optionen';
    Group.SetBounds(12, 8, 210, 110);
    FCheck.Text := 'Aktiviert';
    FCheck.SetBounds(24, 28, 180, 20);
    FCheck.OnClick := CheckClick;
    FRadioA.Text := 'Option A';
    FRadioA.SetBounds(24, 52, 180, 20);
    FRadioA.OnClick := RadioClick;
    FRadioB.Text := 'Option B';
    FRadioB.SetBounds(24, 76, 180, 20);
    FRadioB.OnClick := RadioClick;

    ComboLabel.Text := 'ComboBox:';
    ComboLabel.SetBounds(240, 10, 200, 16);
    ComboLabel.Anchors := [maTop, maRight];
    FCombo.SetBounds(240, 28, 210, 140);
    FCombo.Anchors := [maTop, maRight];
    FCombo.Add('Eins');
    FCombo.Add('Zwei');
    FCombo.Add('Drei');
    FCombo.Add('Vier');
    FCombo.ItemIndex := 0;
    FCombo.OnChange := ComboChange;

    ListLabel.Text := 'ListBox:';
    ListLabel.SetBounds(240, 58, 200, 16);
    ListLabel.Anchors := [maTop, maRight];
    FList.SetBounds(240, 76, 210, 150);
    FList.Anchors := [maTop, maRight, maBottom];
    FList.Add('Alpha');
    FList.Add('Beta');
    FList.Add('Gamma');
    FList.Add('Delta');
    FList.Add('Epsilon');
    FList.OnChange := ListChange;

    FStatus.Text := 'Status: -';
    FStatus.SetBounds(12, 250, 250, 20);
    FStatus.Anchors := [maLeft, maBottom];

    CloseBtn.Text := 'Schliessen';
    CloseBtn.SetBounds(372, 246, 84, 26);
    CloseBtn.Anchors := [maRight, maBottom];
    CloseBtn.OnClick := CloseClick;

    // Idle until the thread is terminated (Schliessen button or program end) or
    // the dialog window is closed via its system menu.
    DlgHandle := FDialog.Handle;
    while not Terminated and IsWindow(DlgHandle) do
      Sleep(50);
  finally
    FDialog.Free;
  end;
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

procedure TfrmMultithreadTestMain.btnComponentsClick(Sender: TObject);
var
  NewThread: TComponentDemoThread;
begin
  NewThread := TComponentDemoThread.Create(False);
  FComponentThreads.Add(NewThread);
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
  FComponentThreads := TObjectList<TComponentDemoThread>.Create(True);
  {$ELSE}
  FExampleThreads := TObjectList.Create(True);
  FComponentThreads := TObjectList.Create(True);
  {$ENDIF}
end;

procedure TfrmMultithreadTestMain.FormDestroy(Sender: TObject);
begin
  FComponentThreads.Free;
  FExampleThreads.Free;
end;

end.
