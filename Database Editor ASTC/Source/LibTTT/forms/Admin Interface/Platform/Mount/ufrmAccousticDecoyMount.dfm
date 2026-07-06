object frmAccousticDecoyMount: TfrmAccousticDecoyMount
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = '   Accoustic Decoy Mount'
  ClientHeight = 262
  ClientWidth = 395
  Color = clBtnShadow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnlMainBackground: TPanel
    Left = 0
    Top = 0
    Width = 395
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentBackground = False
    TabOrder = 0
    object pnl2ControlPage: TPanel
      Left = 5
      Top = 70
      Width = 385
      Height = 144
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 10
      Color = 2499101
      ParentBackground = False
      TabOrder = 0
      object pgc1: TPageControl
        Left = 10
        Top = 10
        Width = 365
        Height = 124
        ActivePage = tsGeneral
        Align = alClient
        TabHeight = 25
        TabOrder = 0
        TabWidth = 75
        object tsGeneral: TTabSheet
          Caption = 'General'
          object txtQuantity: TStaticText
            Left = 96
            Top = 18
            Width = 63
            Height = 18
            Caption = 'Quantity  :'
            TabOrder = 0
          end
          object edtQuantity: TEdit
            Left = 96
            Top = 41
            Width = 68
            Height = 22
            NumbersOnly = True
            TabOrder = 1
            OnChange = edtChange
          end
        end
      end
    end
    object pnl1Title: TPanel
      Left = 5
      Top = 5
      Width = 385
      Height = 65
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 4
      Color = 2499101
      ParentBackground = False
      TabOrder = 1
      object txtClass: TLabel
        Left = 10
        Top = 10
        Width = 81
        Height = 16
        Caption = 'Mount Name :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edtName: TEdit
        Tag = 4
        Left = 10
        Top = 30
        Width = 365
        Height = 24
        AutoSize = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object pnl3Button: TPanel
      Left = 5
      Top = 214
      Width = 385
      Height = 43
      Align = alBottom
      BevelOuter = bvNone
      Color = 2499101
      ParentBackground = False
      TabOrder = 2
      object btnApply: TButton
        Left = 210
        Top = 2
        Width = 80
        Height = 30
        Caption = 'Apply'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnApplyClick
      end
      object btnOK: TButton
        Left = 125
        Top = 2
        Width = 80
        Height = 30
        Caption = 'OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 295
        Top = 2
        Width = 80
        Height = 30
        Caption = 'Cancel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnCancelClick
      end
    end
  end
end
