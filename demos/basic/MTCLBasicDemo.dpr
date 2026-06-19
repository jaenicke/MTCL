program MTCLBasicDemo;

uses
  Forms,
  MTCLBasicDemoMain in 'MTCLBasicDemoMain.pas' {Form31},
  MTCL.Dialog in '..\..\source\MTCL.Dialog.pas',
  MTCL.Edit in '..\..\source\MTCL.Edit.pas',
  MTCL.Memo in '..\..\source\MTCL.Memo.pas',
  MTCL.BaseElement in '..\..\source\MTCL.BaseElement.pas',
  MTCL.BaseControl in '..\..\source\MTCL.BaseControl.pas',
  MTCL.Button in '..\..\source\MTCL.Button.pas',
  MTCL.Progress in '..\..\source\MTCL.Progress.pas',
  MTCL.StaticText in '..\..\source\MTCL.StaticText.pas',
  MTCL.CheckBox in '..\..\source\MTCL.CheckBox.pas',
  MTCL.RadioButton in '..\..\source\MTCL.RadioButton.pas',
  MTCL.GroupBox in '..\..\source\MTCL.GroupBox.pas',
  MTCL.ComboBox in '..\..\source\MTCL.ComboBox.pas',
  MTCL.ListBox in '..\..\source\MTCL.ListBox.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMultithreadTestMain, frmMultithreadTestMain);
  Application.Run;
end.
