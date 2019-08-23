object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Map Builder'
  ClientHeight = 569
  ClientWidth = 1062
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object imLayer: TImage
    Left = 0
    Top = 0
    Width = 1062
    Height = 569
    Align = alClient
    OnMouseDown = imLayerMouseDown
    OnMouseMove = imLayerMouseMove
    OnMouseUp = imLayerMouseUp
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 160
    ExplicitHeight = 120
  end
  object edLayer_Focus: TEdit
    Left = -24
    Top = -50
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'edLayer_Focus'
    OnEnter = edLayer_FocusEnter
    OnExit = edLayer_FocusExit
    OnKeyDown = edLayer_FocusKeyDown
    OnKeyUp = edLayer_FocusKeyUp
  end
  object MainMenu1: TMainMenu
    Left = 528
    Top = 96
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Action = aMap_Open
      end
      object N3: TMenuItem
        Action = aMap_Close
      end
      object N5: TMenuItem
        Action = aMap_Save
      end
      object N6: TMenuItem
        Action = aMap_SaveAs
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object N11: TMenuItem
        Action = aMap_ExportLayer
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Action = FileExit1
      end
    end
    object N8: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    end
    object N9: TMenuItem
      Caption = #1042#1080#1076
    end
  end
  object ActionList1: TActionList
    Left = 592
    Top = 112
    object aMap_Open: TAction
      Caption = '&'#1054#1090#1082#1088#1099#1090#1100'...'
      ShortCut = 16463
      OnExecute = aMap_OpenExecute
    end
    object aMap_Close: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ShortCut = 16471
      OnExecute = aMap_CloseExecute
    end
    object aMap_Save: TAction
      Caption = '&'#1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 16467
      OnExecute = aMap_SaveExecute
    end
    object aMap_SaveAs: TAction
      Caption = '&'#1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
      OnExecute = aMap_SaveAsExecute
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = #1042'&'#1099#1093#1086#1076
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
    end
    object aMap_ExportLayer: TAction
      Caption = '&'#1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100'...'
      ShortCut = 16453
      OnExecute = aMap_ExportLayerExecute
    end
  end
  object tRenderer: TTimer
    Interval = 10
    OnTimer = tRendererTimer
    Left = 560
    Top = 296
  end
  object tInitializer: TTimer
    Interval = 500
    OnTimer = tInitializerTimer
    Left = 624
    Top = 8
  end
  object OpenDialog: TOpenDialog
    Filter = 'Map file (*.mf)|*.mf'
    Left = 560
    Top = 184
  end
  object SaveDialog: TSaveDialog
    Left = 560
    Top = 240
  end
  object tNav: TTimer
    Enabled = False
    OnTimer = tNavTimer
    Left = 560
    Top = 352
  end
  object SavePictureDialog: TSavePictureDialog
    OnTypeChange = SavePictureDialogTypeChange
    Left = 544
    Top = 16
  end
end
