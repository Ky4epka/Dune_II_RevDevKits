object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 608
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pTools: TPanel
    Left = 0
    Top = 0
    Width = 698
    Height = 12
    Align = alTop
    TabOrder = 0
  end
  object pRightBox: TPanel
    Left = 512
    Top = 12
    Width = 186
    Height = 596
    Align = alRight
    Caption = 'No selected cell'
    TabOrder = 1
    ExplicitTop = 57
    ExplicitHeight = 407
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 184
      Height = 594
      ActivePage = tsMap
      Align = alClient
      TabOrder = 0
      object tsMap: TTabSheet
        Caption = 'Map'
        ExplicitHeight = 377
        object Label1: TLabel
          Left = 13
          Top = 12
          Width = 103
          Height = 13
          Caption = 'Associated athlas:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edAssociatedAthlasFileNameValue: TEdit
          Left = 13
          Top = 28
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'edFileNameValue'
        end
        object btAssociatedAthlasSelect: TButton
          Left = 139
          Top = 28
          Width = 25
          Height = 21
          Caption = '...'
          TabOrder = 1
          OnClick = btAssociatedAthlasSelectClick
        end
      end
      object tsCell: TTabSheet
        Caption = 'Cell'
        ImageIndex = 1
        ExplicitHeight = 377
        object pCellInfo: TPanel
          Left = 0
          Top = 0
          Width = 176
          Height = 566
          Align = alClient
          Caption = 'No selected cell'
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          ExplicitHeight = 377
          object pBindedCellInfo: TPanel
            Left = 1
            Top = 1
            Width = 174
            Height = 564
            Align = alClient
            ParentBackground = False
            ParentColor = True
            TabOrder = 0
            ExplicitTop = -3
            ExplicitHeight = 420
            object Label2: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'CellName:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitWidth = 55
            end
            object Label3: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 108
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'PathCost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 112
              ExplicitWidth = 51
            end
            object Label4: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 157
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'GroundSpeedScale'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 166
              ExplicitWidth = 106
            end
            object Label5: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 206
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'AirSpeedScale'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 220
              ExplicitWidth = 81
            end
            object Label6: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 55
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 58
              ExplicitWidth = 45
            end
            object Label11: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 255
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Can has spice'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 274
              ExplicitWidth = 76
            end
            object Label9: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 405
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Can buildings places'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 439
              ExplicitWidth = 113
            end
            object Label10: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 300
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Spice value'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 324
              ExplicitWidth = 64
            end
            object Label12: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 450
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Can ground units places'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 489
              ExplicitWidth = 134
            end
            object Label13: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 349
              Width = 162
              Height = 13
              Margins.Left = 5
              Margins.Top = 5
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Caption = 'Minimap color'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold, fsItalic]
              ParentFont = False
              ExplicitTop = 378
              ExplicitWidth = 79
            end
            object edCellNameValue: TEdit
              AlignWithMargins = True
              Left = 6
              Top = 24
              Width = 162
              Height = 21
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Color = clInfoText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clYellow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              Text = 'edCellNameValue'
              ExplicitTop = 29
            end
            object edPathCostValue: TEdit
              AlignWithMargins = True
              Left = 6
              Top = 126
              Width = 162
              Height = 21
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Color = clInfoText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clYellow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              Text = '0'
              OnChange = edPathCostValueChange
              ExplicitLeft = 1
              ExplicitTop = 118
              ExplicitWidth = 172
            end
            object edCellAirSpeedScaleValue: TEdit
              AlignWithMargins = True
              Left = 6
              Top = 224
              Width = 162
              Height = 21
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Color = clInfoText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clYellow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              Text = '0'
              ExplicitLeft = 9
              ExplicitTop = 155
              ExplicitWidth = 172
            end
            object edCellGroundSpeedScaleValue: TEdit
              AlignWithMargins = True
              Left = 6
              Top = 175
              Width = 162
              Height = 21
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Color = clInfoText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clYellow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
              Text = '0'
              ExplicitLeft = 9
              ExplicitTop = 214
              ExplicitWidth = 172
            end
            object pCellPosition: TPanel
              AlignWithMargins = True
              Left = 6
              Top = 73
              Width = 162
              Height = 25
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              BevelKind = bkSoft
              TabOrder = 4
              ExplicitTop = 83
              object Label7: TLabel
                Left = 1
                Top = 1
                Width = 20
                Height = 19
                Align = alLeft
                Alignment = taCenter
                AutoSize = False
                Caption = 'X:'
              end
              object Label8: TLabel
                Left = 70
                Top = 1
                Width = 20
                Height = 19
                Align = alLeft
                Alignment = taCenter
                AutoSize = False
                Caption = 'Y:'
              end
              object edCellPositionXValue: TEdit
                Left = 21
                Top = 1
                Width = 49
                Height = 19
                Align = alLeft
                TabOrder = 0
                Text = '0'
                ExplicitLeft = 56
                ExplicitTop = 14
                ExplicitHeight = 21
              end
              object edCellPositionYValue: TEdit
                Left = 90
                Top = 1
                Width = 49
                Height = 19
                Align = alLeft
                TabOrder = 1
                Text = '0'
                ExplicitLeft = 130
                ExplicitTop = -4
                ExplicitHeight = 39
              end
            end
            object cbCellCanHasSpiceValue: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 273
              Width = 162
              Height = 17
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Caption = 'Value'
              TabOrder = 5
              ExplicitLeft = 49
              ExplicitTop = 270
              ExplicitWidth = 96
            end
            object cbCellCanBuildingsPlacesValue: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 423
              Width = 162
              Height = 17
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Caption = 'Value'
              TabOrder = 6
              ExplicitLeft = -7
              ExplicitTop = 334
              ExplicitWidth = 172
            end
            object edCellSpiceValue: TEdit
              AlignWithMargins = True
              Left = 6
              Top = 318
              Width = 162
              Height = 21
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Alignment = taCenter
              Color = clInfoText
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clYellow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              Text = '0'
              ExplicitLeft = 9
              ExplicitTop = 188
              ExplicitWidth = 172
            end
            object cbCellCanGroundUnitsPlacesValue: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 468
              Width = 162
              Height = 17
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              Caption = 'Value'
              TabOrder = 8
              ExplicitLeft = 1
              ExplicitTop = 339
              ExplicitWidth = 172
            end
            object pCellMinimapColorValue: TPanel
              AlignWithMargins = True
              Left = 6
              Top = 367
              Width = 162
              Height = 28
              Margins.Left = 5
              Margins.Top = 0
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              BevelKind = bkSoft
              TabOrder = 9
              ExplicitTop = 401
            end
          end
          object pCellNotBinded: TPanel
            Left = 1
            Top = 1
            Width = 174
            Height = 564
            Align = alClient
            ParentBackground = False
            ParentColor = True
            TabOrder = 1
            ExplicitLeft = 105
            ExplicitTop = 538
            ExplicitWidth = 64
            ExplicitHeight = 38
            DesignSize = (
              174
              564)
            object btAddCell: TButton
              Left = 27
              Top = 242
              Width = 121
              Height = 25
              Anchors = []
              Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1103#1095#1077#1081#1082#1091
              TabOrder = 0
              OnClick = btAddCellClick
              ExplicitLeft = 26
              ExplicitTop = 181
            end
          end
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 56
    Top = 152
  end
  object SaveDialog: TSaveDialog
    Filter = 'Windows bitmap (*.bmp)|*.bmp'
    Left = 104
    Top = 152
  end
  object MainMenu: TMainMenu
    Left = 120
    Top = 80
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Action = aNewMapBind
      end
      object Open1: TMenuItem
        Action = aOpen
      end
      object Save1: TMenuItem
        Action = aSave
      end
      object Saveto1: TMenuItem
        Action = aSaveTo
      end
      object asd1: TMenuItem
        Caption = '-------------'
        Enabled = False
      end
      object Exit1: TMenuItem
        Action = aExit
      end
    end
  end
  object ActionList: TActionList
    Left = 176
    Top = 88
    object aNewMapBind: TAction
      Caption = 'New map bind'
      OnExecute = aNewMapBindExecute
    end
    object aOpen: TAction
      Caption = 'Open'
      ShortCut = 16463
      OnExecute = aOpenExecute
    end
    object aSave: TAction
      Caption = 'Save'
      ShortCut = 16467
      OnExecute = aSaveExecute
    end
    object aSaveTo: TAction
      Caption = 'Save to...'
      OnExecute = aSaveToExecute
    end
    object aExit: TAction
      Caption = 'Exit'
      OnExecute = aExitExecute
    end
  end
end
