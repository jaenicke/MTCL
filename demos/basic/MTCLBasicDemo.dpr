program MTCLBasicDemo;

uses
  Forms,
  MTCLBasicDemoMain in 'MTCLBasicDemoMain.pas' {Form31},
  MTCL.Dialog in '..\..\source\MTCL.Dialog.pas',
  MTCL.Edit in '..\..\source\MTCL.Edit.pas',
  MTCL.Memo in '..\..\source\MTCL.Memo.pas',
  MTCL.BaseControl in '..\..\source\MTCL.BaseControl.pas',
  MTCL.Button in '..\..\source\MTCL.Button.pas',
  MTCL.Progress in '..\..\source\MTCL.Progress.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMultithreadTestMain, frmMultithreadTestMain);
  Application.Run;
end.
