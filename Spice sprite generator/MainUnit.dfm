object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 353
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 563
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 96
    ExplicitWidth = 185
    object btGenerate: TButton
      Left = 11
      Top = 10
      Width = 116
      Height = 25
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 0
      OnClick = btGenerateClick
    end
    object btSave: TButton
      Left = 432
      Top = 10
      Width = 116
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btSaveClick
    end
    object tbRatio: TTrackBar
      Left = 152
      Top = 8
      Width = 150
      Height = 45
      Max = 100
      PageSize = 5
      Frequency = 5
      TabOrder = 2
      OnChange = tbRatioChange
    end
    object seValue: TSpinEdit
      Left = 307
      Top = 10
      Width = 61
      Height = 22
      MaxValue = 100
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = seValueChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 281
    Height = 312
    Align = alLeft
    TabOrder = 1
    ExplicitTop = 47
    object Label1: TLabel
      AlignWithMargins = True
      Left = 1
      Top = 6
      Width = 279
      Height = 13
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alTop
      Alignment = taCenter
      Caption = #1054#1088#1080#1075#1080#1085#1072#1083
      ExplicitLeft = 80
      ExplicitTop = 8
      ExplicitWidth = 49
    end
    object Panel3: TPanel
      Left = 8
      Top = 25
      Width = 262
      Height = 262
      BevelKind = bkSoft
      Constraints.MinHeight = 262
      Constraints.MinWidth = 262
      TabOrder = 0
      object imOriginalSprite: TImage
        Left = 1
        Top = 1
        Width = 256
        Height = 256
        Align = alClient
        Stretch = True
        ExplicitLeft = 16
        ExplicitTop = 40
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
  object Panel4: TPanel
    Left = 281
    Top = 41
    Width = 281
    Height = 312
    Align = alLeft
    TabOrder = 2
    ExplicitLeft = 8
    object Label2: TLabel
      AlignWithMargins = True
      Left = 1
      Top = 6
      Width = 279
      Height = 13
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alTop
      Alignment = taCenter
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
      ExplicitWidth = 53
    end
    object Panel5: TPanel
      Left = 8
      Top = 25
      Width = 262
      Height = 262
      BevelKind = bkSoft
      Constraints.MinHeight = 262
      Constraints.MinWidth = 262
      TabOrder = 0
      object imResultSprite: TImage
        Left = 1
        Top = 1
        Width = 256
        Height = 256
        Align = alClient
        Stretch = True
        ExplicitLeft = 16
        ExplicitTop = 40
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 521
    Top = 49
  end
end
