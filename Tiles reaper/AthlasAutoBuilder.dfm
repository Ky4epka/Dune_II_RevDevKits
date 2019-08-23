object dlgAthlasAutobuilder: TdlgAthlasAutobuilder
  Left = 0
  Top = 0
  Caption = 'dlgAthlasAutobuilder'
  ClientHeight = 425
  ClientWidth = 671
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 257
    Height = 425
    Align = alLeft
    Caption = 'Select directory'
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitHeight = 225
    object DriveComboBox: TDriveComboBox
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 247
      Height = 19
      Align = alTop
      DirList = DirectoryListBox
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 16
      ExplicitWidth = 233
    end
    object DirectoryListBox: TDirectoryListBox
      AlignWithMargins = True
      Left = 5
      Top = 43
      Width = 247
      Height = 354
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 65
      ExplicitWidth = 145
      ExplicitHeight = 97
    end
    object btGotcha: TButton
      Left = 2
      Top = 400
      Width = 253
      Height = 23
      Align = alBottom
      Caption = 'GOTCHA!'
      TabOrder = 2
      OnClick = btGotchaClick
    end
  end
  object Panel1: TPanel
    Left = 257
    Top = 0
    Width = 414
    Height = 425
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 264
    ExplicitTop = 16
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 412
      Height = 423
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 0
      ExplicitLeft = 48
      ExplicitTop = 184
      ExplicitWidth = 185
      ExplicitHeight = 41
      object Label1: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 404
        Height = 13
        Align = alTop
        Caption = 'Building log:'
        ExplicitWidth = 57
      end
      object memBuildingLog: TMemo
        Left = 1
        Top = 20
        Width = 410
        Height = 361
        Align = alClient
        Lines.Strings = (
          'memBuildingLog')
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object Panel3: TPanel
        Left = 1
        Top = 381
        Width = 410
        Height = 41
        Align = alBottom
        TabOrder = 1
        ExplicitLeft = 40
        ExplicitTop = 336
        ExplicitWidth = 185
        object gCurrentMapProgress: TGauge
          Left = 1
          Top = 1
          Width = 408
          Height = 20
          Align = alTop
          Progress = 0
        end
        object gTotalProgress: TGauge
          Left = 1
          Top = 21
          Width = 408
          Height = 19
          Align = alClient
          Progress = 0
          ExplicitLeft = 2
          ExplicitTop = 9
          ExplicitHeight = 20
        end
      end
    end
  end
end
