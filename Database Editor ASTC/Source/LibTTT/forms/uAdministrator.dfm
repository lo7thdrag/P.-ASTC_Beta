object frmAdministrator: TfrmAdministrator
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Administrator'
  ClientHeight = 277
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 277
    Align = alClient
    Color = 2499101
    ParentBackground = False
    TabOrder = 5
  end
  object btnClose: TButton
    Left = 390
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object btnEdit: TButton
    Left = 309
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Edit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnEditClick
  end
  object btnNew: TButton
    Left = 228
    Top = 247
    Width = 75
    Height = 25
    Caption = 'New'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnNewClick
  end
  object btnRemove: TButton
    Left = 147
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Remove'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnRemoveClick
  end
  object lvUserLogin: TListView
    Left = 8
    Top = 8
    Width = 457
    Height = 233
    Color = clWhite
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Username'
        Width = 100
      end
      item
        Caption = 'Password'
        Width = 100
      end
      item
        Caption = 'Privilege'
        Width = 100
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
end
