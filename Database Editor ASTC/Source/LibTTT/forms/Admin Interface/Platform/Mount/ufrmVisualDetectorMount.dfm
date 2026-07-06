object frmVisualDetectorMount: TfrmVisualDetectorMount
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = '   Visual Detector Mount'
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
          object lblBlindZones: TStaticText
            Left = 15
            Top = 19
            Width = 74
            Height = 18
            Caption = 'Blind Zones :'
            TabOrder = 0
          end
          object lblObserver: TStaticText
            Left = 112
            Top = 41
            Width = 101
            Height = 18
            Caption = 'Observer Height :'
            TabOrder = 1
          end
          object edtObserver: TEdit
            Left = 220
            Top = 39
            Width = 68
            Height = 22
            TabOrder = 2
            OnChange = edtChange
            OnKeyPress = edtNumeralKeyPress
          end
          object lblFeetObserver: TStaticText
            Left = 294
            Top = 41
            Width = 27
            Height = 18
            Caption = 'feet'
            TabOrder = 3
          end
          object pnlBlindZone: TPanel
            Left = 15
            Top = 42
            Width = 66
            Height = 65
            TabOrder = 4
            OnClick = pnlBlindZoneClick
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
        Left = 177
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
        Left = 344
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
