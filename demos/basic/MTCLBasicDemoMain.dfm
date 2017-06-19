object frmMultithreadTestMain: TfrmMultithreadTestMain
  Left = 0
  Top = 0
  Caption = 'frmMultithreadTestMain'
  ClientHeight = 294
  ClientWidth = 627
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnNewThread: TButton
    Left = 8
    Top = 39
    Width = 169
    Height = 25
    Caption = 'Neuer Thread'
    TabOrder = 0
    OnClick = btnNewThreadClick
  end
  object btnShowAllWindows: TButton
    Left = 183
    Top = 39
    Width = 169
    Height = 25
    Caption = 'Alle Fenster anzeigen'
    TabOrder = 1
    OnClick = btnShowAllWindowsClick
  end
  object btnHideAllWindows: TButton
    Left = 183
    Top = 8
    Width = 169
    Height = 25
    Caption = 'Alle Fenster verstecken'
    TabOrder = 2
    OnClick = btnHideAllWindowsClick
  end
  object edtThreadText: TEdit
    Left = 8
    Top = 10
    Width = 169
    Height = 21
    TabOrder = 3
    Text = 'abc123'
  end
end
