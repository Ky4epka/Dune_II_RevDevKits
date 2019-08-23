object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 704
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pTools: TPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      759
      41)
    object Label1: TLabel
      Left = 10
      Top = 14
      Width = 30
      Height = 13
      Caption = #1060#1072#1081#1083':'
    end
    object edSelectedFile: TEdit
      Left = 47
      Top = 11
      Width = 121
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object btSelectFile: TButton
      Left = 173
      Top = 11
      Width = 26
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btSelectFileClick
    end
    object btCollect: TButton
      Left = 674
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Collect'
      TabOrder = 2
      OnClick = btCollectClick
    end
    object btAutobuilderDlg: TButton
      Left = 384
      Top = 10
      Width = 89
      Height = 25
      Caption = 'Autobuilder'
      TabOrder = 3
      OnClick = btAutobuilderDlgClick
    end
  end
  object pRenderer: TPanel
    Left = 0
    Top = 41
    Width = 759
    Height = 622
    Align = alClient
    TabOrder = 1
  end
  object pFooter: TPanel
    Left = 0
    Top = 663
    Width = 759
    Height = 41
    Align = alBottom
    TabOrder = 2
    object gProgress: TGauge
      Left = 568
      Top = 6
      Width = 100
      Height = 25
      Progress = 0
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 512
    Top = 81
  end
end
