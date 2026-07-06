object BlindZonesAttachmentForm: TBlindZonesAttachmentForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Blind Zones'
  ClientHeight = 308
  ClientWidth = 584
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 275
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grbFirstBlindZone: TGroupBox
      Left = 8
      Top = 8
      Width = 481
      Height = 121
      Enabled = False
      TabOrder = 0
      object lblCentreFirst: TStaticText
        Left = 12
        Top = 32
        Width = 44
        Height = 17
        Caption = 'Centre :'
        TabOrder = 0
      end
      object TrackCentreFirst: TTrackBar
        Left = 81
        Top = 32
        Width = 336
        Height = 45
        Max = 359
        PageSize = 1
        Frequency = 60
        TabOrder = 1
        OnChange = trckbrGeneralChange
      end
      object edtCentreFirst: TEdit
        Left = 415
        Top = 32
        Width = 50
        Height = 21
        NumbersOnly = True
        TabOrder = 2
        Text = '0'
        OnChange = edtGeneralChange
      end
      object lblWidthFirst: TStaticText
        Left = 12
        Top = 72
        Width = 39
        Height = 17
        Caption = 'Width :'
        TabOrder = 3
      end
      object TrackWidthFirst: TTrackBar
        Tag = 1
        Left = 81
        Top = 72
        Width = 336
        Height = 45
        Max = 360
        PageSize = 1
        Frequency = 60
        TabOrder = 4
        OnChange = trckbrGeneralChange
      end
      object edtWidthFirst: TEdit
        Left = 415
        Top = 72
        Width = 50
        Height = 21
        NumbersOnly = True
        TabOrder = 5
        Text = '0'
        OnChange = edtGeneralChange
      end
    end
    object grbSecondBlindZone: TGroupBox
      Left = 8
      Top = 147
      Width = 481
      Height = 122
      Enabled = False
      TabOrder = 1
      object lblCentreSecond: TStaticText
        Left = 12
        Top = 32
        Width = 44
        Height = 17
        Caption = 'Centre :'
        TabOrder = 0
      end
      object TrackCentreSecond: TTrackBar
        Tag = 2
        Left = 81
        Top = 32
        Width = 336
        Height = 45
        Max = 359
        PageSize = 1
        Frequency = 60
        TabOrder = 1
        OnChange = trckbrGeneralChange
      end
      object edtCentreSecond: TEdit
        Left = 415
        Top = 32
        Width = 50
        Height = 21
        NumbersOnly = True
        TabOrder = 2
        Text = '0'
        OnChange = edtGeneralChange
      end
      object lblWidthSecond: TStaticText
        Left = 12
        Top = 72
        Width = 39
        Height = 17
        Caption = 'Width :'
        TabOrder = 3
      end
      object TrackWidthSecond: TTrackBar
        Tag = 3
        Left = 81
        Top = 72
        Width = 336
        Height = 45
        Max = 360
        PageSize = 1
        Frequency = 60
        TabOrder = 4
        OnChange = trckbrGeneralChange
      end
      object edtWidthSecond: TEdit
        Left = 415
        Top = 72
        Width = 50
        Height = 21
        NumbersOnly = True
        TabOrder = 5
        Text = '0'
        OnChange = edtGeneralChange
      end
    end
    object lblForwardFirst: TStaticText
      Left = 516
      Top = 5
      Width = 44
      Height = 17
      Caption = 'Forward'
      TabOrder = 2
    end
    object lblForwardSecond: TStaticText
      Left = 516
      Top = 144
      Width = 44
      Height = 17
      Caption = 'Forward'
      TabOrder = 3
    end
    object cbFirstBlindZone: TCheckBox
      Left = 20
      Top = 5
      Width = 97
      Height = 17
      Caption = 'First Blind Zone'
      TabOrder = 4
      OnClick = cbFirstBlindZoneClick
    end
    object cbSecondBlindZone: TCheckBox
      Left = 20
      Top = 144
      Width = 105
      Height = 17
      Caption = 'Second Blind Zone'
      TabOrder = 5
      OnClick = cbSecondBlindZoneClick
    end
    object pnlFirstBlind: TPanel
      Left = 502
      Top = 28
      Width = 73
      Height = 73
      TabOrder = 6
    end
    object pnlSecondBlind: TPanel
      Left = 502
      Top = 167
      Width = 73
      Height = 73
      TabOrder = 7
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 275
    Width = 584
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnApply: TButton
      Left = 421
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 0
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 502
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 340
      Top = 5
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = btnOKClick
    end
  end
end
