object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 488
  ClientWidth = 889
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 488
    Align = alClient
    BevelKind = bkSoft
    TabOrder = 0
    ExplicitWidth = 467
    ExplicitHeight = 456
    object spMain_FocusIndicator: TShape
      Left = 1
      Top = 1
      Width = 642
      Height = 482
      Align = alClient
      Brush.Style = bsClear
      Pen.Style = psDot
      Visible = False
      OnMouseDown = spMain_FocusIndicatorMouseDown
      ExplicitLeft = 8
      ExplicitTop = 48
      ExplicitWidth = 65
      ExplicitHeight = 65
    end
    object imMainLayer: TImage
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 640
      Height = 480
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alClient
      OnMouseDown = imMainLayerMouseDown
      ExplicitLeft = 4
      ExplicitTop = 1
      ExplicitWidth = 461
      ExplicitHeight = 450
    end
    object spZoomArea: TShape
      Left = 136
      Top = 168
      Width = 65
      Height = 65
      Brush.Style = bsClear
      Pen.Color = clRed
      OnMouseDown = spZoomAreaMouseDown
      OnMouseMove = spZoomAreaMouseMove
      OnMouseUp = spZoomAreaMouseUp
    end
    object edMain_FocusControl: TEdit
      Left = 120
      Top = 502
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 0
      OnEnter = edMain_FocusControlEnter
      OnExit = edMain_FocusControlExit
      OnKeyDown = edMain_FocusControlKeyDown
      OnMouseDown = edMain_FocusControlMouseDown
    end
  end
  object Panel2: TPanel
    Left = 648
    Top = 0
    Width = 241
    Height = 488
    Align = alRight
    BevelKind = bkSoft
    TabOrder = 1
    ExplicitLeft = 467
    ExplicitHeight = 456
    object pSecond: TPanel
      Left = 1
      Top = 1
      Width = 235
      Height = 235
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvSpace
      TabOrder = 0
      object imSecondLayer: TImage
        Left = 1
        Top = 1
        Width = 229
        Height = 229
        Align = alClient
        ExplicitLeft = 24
        ExplicitTop = 40
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pTools: TPanel
      Left = 1
      Top = 236
      Width = 235
      Height = 247
      Align = alClient
      TabOrder = 1
      ExplicitHeight = 215
      object gbSecondTools: TGroupBox
        Left = 1
        Top = 1
        Width = 233
        Height = 184
        Align = alTop
        Caption = #1051#1080#1085#1079#1072
        TabOrder = 0
        object lbSecond_AreaSize: TLabel
          Left = 72
          Top = 19
          Width = 120
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088'  '#1086#1073#1083#1072#1089#1090#1080' ('#1087#1080#1082#1089'.)'
        end
        object lbAreaFind_Desc: TLabel
          Left = 3
          Top = 72
          Width = 85
          Height = 13
          Caption = '-- '#1055#1086#1080#1089#1082' '#1086#1073#1083#1072#1089#1090#1080
        end
        object cbSecond_ToolsUse: TCheckBox
          Left = 3
          Top = 16
          Width = 38
          Height = 17
          Caption = #1042#1082#1083'.'
          TabOrder = 0
          OnClick = cbSecond_ToolsUseClick
        end
        object seSecond_AreaSize: TSpinEdit
          Left = 72
          Top = 36
          Width = 121
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = seSecond_AreaSizeChange
        end
        object btAreaFind_Activate: TButton
          Left = 16
          Top = 113
          Width = 121
          Height = 25
          Caption = #1040#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = btAreaFind_ActivateClick
        end
        object btAreaFind_Deactivate: TButton
          Left = 16
          Top = 113
          Width = 121
          Height = 25
          Caption = #1044#1077#1072#1082#1090#1080#1074#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 3
          OnClick = btAreaFind_DeactivateClick
        end
        object btAreaFind_Forget: TButton
          Left = 16
          Top = 149
          Width = 121
          Height = 25
          Caption = #1047#1072#1073#1099#1090#1100
          TabOrder = 4
          OnClick = btAreaFind_ForgetClick
        end
        object btAreaFind_Remember: TButton
          Left = 16
          Top = 148
          Width = 121
          Height = 25
          Caption = #1047#1072#1087#1086#1084#1085#1080#1090#1100
          TabOrder = 5
          OnClick = btAreaFind_RememberClick
        end
        object cbAreaFind_Use: TCheckBox
          Left = 3
          Top = 90
          Width = 38
          Height = 17
          Caption = #1042#1082#1083'.'
          TabOrder = 6
          OnClick = cbAreaFind_UseClick
        end
      end
    end
  end
  object tWindowController: TTimer
    OnTimer = tWindowControllerTimer
    Left = 496
    Top = 328
  end
  object tRenderer: TTimer
    Interval = 25
    OnTimer = tRendererTimer
    Left = 536
    Top = 328
  end
  object tAreaFind: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tAreaFindTimer
    Left = 584
    Top = 328
  end
end
