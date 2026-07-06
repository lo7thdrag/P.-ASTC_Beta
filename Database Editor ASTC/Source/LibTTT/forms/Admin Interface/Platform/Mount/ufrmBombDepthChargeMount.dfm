object frmBombDepthChargeMount: TfrmBombDepthChargeMount
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = '   Bomb/Depth Charge Mount'
  ClientHeight = 478
  ClientWidth = 434
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
    Width = 434
    Height = 478
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object pnl2ControlPage: TPanel
      Left = 0
      Top = 65
      Width = 434
      Height = 370
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 10
      Color = 2499101
      ParentBackground = False
      TabOrder = 0
      object PageControl1: TPageControl
        Left = 10
        Top = 10
        Width = 414
        Height = 350
        ActivePage = General
        Align = alClient
        TabHeight = 30
        TabOrder = 0
        TabWidth = 75
        object General: TTabSheet
          Caption = 'General'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblClassName: TStaticText
            Left = 12
            Top = 18
            Width = 72
            Height = 18
            Caption = 'Class Name :'
            TabOrder = 0
          end
          object edtClassName: TEdit
            Tag = 4
            Left = 12
            Top = 41
            Width = 366
            Height = 22
            Enabled = False
            TabOrder = 1
          end
          object lblMountExtension: TStaticText
            Left = 12
            Top = 79
            Width = 104
            Height = 18
            Caption = 'Mount Extension :'
            TabOrder = 2
          end
          object cbMountExtension: TComboBox
            Left = 12
            Top = 102
            Width = 366
            Height = 22
            Style = csDropDownList
            TabOrder = 3
            OnChange = cbMountExtensionChange
            Items.Strings = (
              'Mount 1'
              'Mount 2'
              'Mount 3'
              'Mount 4'
              'Mount 5'
              'Mount 6'
              'Mount 7'
              'Mount 8'
              'Mount 9'
              'Aft Mount'
              'Forward Mount'
              'Port Mount'
              'Starboard Mount')
          end
          object lblQuantity: TStaticText
            Left = 129
            Top = 146
            Width = 59
            Height = 18
            Caption = 'Quantity :'
            TabOrder = 4
          end
          object edtQuantity: TEdit
            Left = 208
            Top = 144
            Width = 68
            Height = 22
            TabOrder = 5
            OnChange = edtChange
            OnKeyPress = edtNumeralKeyPress
          end
        end
      end
    end
    object pnl1Title: TPanel
      Left = 0
      Top = 0
      Width = 434
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
        Width = 78
        Height = 14
        Caption = 'Mount Name :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edtName: TEdit
        Tag = 4
        Left = 10
        Top = 30
        Width = 414
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
      Left = 0
      Top = 435
      Width = 434
      Height = 43
      Align = alBottom
      BevelOuter = bvNone
      Color = 2499101
      ParentBackground = False
      TabOrder = 2
      object btnApply: TButton
        Left = 261
        Top = 6
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
        Left = 177
        Top = 6
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
        Left = 344
        Top = 6
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
