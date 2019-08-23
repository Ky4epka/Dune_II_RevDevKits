object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 430
  ClientWidth = 639
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
  object pTools: TPanel
    Left = 0
    Top = 0
    Width = 639
    Height = 57
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 519
    object lFileName: TLabel
      Left = 13
      Top = 4
      Width = 54
      Height = 13
      Caption = 'FileName:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edFileNameValue: TEdit
      Left = 13
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'edFileNameValue'
    end
    object btFileNameSelect: TButton
      Left = 139
      Top = 20
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btFileNameSelectClick
    end
    object btSaveTo: TButton
      Left = 212
      Top = 20
      Width = 75
      Height = 21
      Caption = 'SaveTo'
      TabOrder = 2
      OnClick = btSaveToClick
    end
    object btPackMap: TButton
      Left = 316
      Top = 20
      Width = 75
      Height = 21
      Caption = 'Pack map'
      TabOrder = 3
      OnClick = btPackMapClick
    end
    object seSimilarPercent: TSpinEdit
      Left = 424
      Top = 19
      Width = 121
      Height = 22
      MaxValue = 100
      MinValue = 0
      TabOrder = 4
      Value = 0
      OnChange = seSimilarPercentChange
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 424
    Top = 216
  end
  object SaveDialog: TSaveDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 472
    Top = 216
  end
end
