object fmTools: TfmTools
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1048#1085#1089#1090#1088#1091#1084#1077#1085#1090#1099
  ClientHeight = 692
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcTools: TPageControl
    Left = 0
    Top = 0
    Width = 212
    Height = 692
    ActivePage = tsZoom
    Align = alClient
    TabOrder = 0
    object tsSegmentInfo: TTabSheet
      Caption = #1057#1077#1075#1084#1077#1085#1090
      object gbImage: TGroupBox
        Left = 0
        Top = 0
        Width = 204
        Height = 155
        Align = alTop
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        TabOrder = 0
        object pLayer: TPanel
          Left = 2
          Top = 15
          Width = 200
          Height = 114
          Align = alTop
          Caption = ' '
          TabOrder = 0
          object imLayer: TImage
            Left = 1
            Top = 1
            Width = 198
            Height = 112
            Align = alClient
            Stretch = True
            ExplicitLeft = 8
            ExplicitTop = 24
            ExplicitWidth = 105
            ExplicitHeight = 105
          end
        end
        object pLayerTools: TPanel
          Left = 2
          Top = 129
          Width = 200
          Height = 24
          Align = alClient
          TabOrder = 1
          DesignSize = (
            200
            24)
          object edLayerPath: TEdit
            Left = 3
            Top = 1
            Width = 168
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
            OnChange = edLayerPathChange
            OnClick = btLayerPathSelectClick
          end
          object btLayerPathSelect: TButton
            Left = 172
            Top = 1
            Width = 25
            Height = 21
            Anchors = [akRight, akBottom]
            Caption = '...'
            TabOrder = 1
            OnClick = btLayerPathSelectClick
          end
        end
      end
      object gbPosition: TGroupBox
        Left = 0
        Top = 155
        Width = 204
        Height = 158
        Align = alTop
        Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077
        TabOrder = 1
        DesignSize = (
          204
          158)
        object lbPosition_X: TLabel
          Left = 44
          Top = 24
          Width = 35
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = 'X'
        end
        object lbPosition_Y: TLabel
          Left = 106
          Top = 24
          Width = 35
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = 'Y'
          ExplicitLeft = 104
        end
        object lbPosition_Width: TLabel
          Left = 44
          Top = 100
          Width = 51
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = #1064#1080#1088#1080#1085#1072
        end
        object lbPosition_Height: TLabel
          Left = 106
          Top = 100
          Width = 51
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = #1042#1099#1089#1086#1090#1072
          ExplicitLeft = 104
        end
        object edPosition_X: TEdit
          Left = 44
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 0
          Text = '0'
        end
        object edPosition_Y: TEdit
          Left = 106
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 1
          Text = '0'
        end
        object udPosition_X: TUpDown
          Left = 79
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edPosition_X
          Max = 100000
          TabOrder = 2
          OnChanging = udPosition_XChanging
        end
        object udPosition_Y: TUpDown
          Left = 141
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edPosition_Y
          Max = 100000
          TabOrder = 3
          OnChanging = udPosition_XChanging
        end
        object edPosition_Width: TEdit
          Left = 44
          Top = 116
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 4
          Text = '0'
        end
        object udPosition_Width: TUpDown
          Left = 79
          Top = 116
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edPosition_Width
          Max = 100000
          TabOrder = 5
          OnChanging = udPosition_XChanging
        end
        object edPosition_Height: TEdit
          Left = 106
          Top = 116
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 6
          Text = '0'
        end
        object udPosition_Height: TUpDown
          Left = 141
          Top = 116
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edPosition_Height
          Max = 100000
          TabOrder = 7
          OnChanging = udPosition_XChanging
        end
        object cbPosition_AutoSize: TCheckBox
          Left = 11
          Top = 72
          Width = 188
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #1040#1074#1090#1086#1088#1072#1079#1084#1077#1088
          TabOrder = 8
          OnClick = cbPosition_AutoSizeClick
        end
      end
      object gbModificators: TGroupBox
        Left = 0
        Top = 313
        Width = 204
        Height = 56
        Align = alTop
        Caption = #1052#1086#1076#1080#1092#1080#1082#1072#1090#1086#1088#1099
        TabOrder = 2
        DesignSize = (
          204
          56)
        object cbModificators_Fixed: TCheckBox
          Left = 11
          Top = 24
          Width = 190
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 0
          OnClick = cbPosition_AutoSizeClick
        end
      end
      object gbSegControl: TGroupBox
        Left = 0
        Top = 369
        Width = 204
        Height = 64
        Align = alTop
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 3
        DesignSize = (
          204
          64)
        object btSegAdd: TButton
          Left = 14
          Top = 24
          Width = 82
          Height = 25
          Anchors = []
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btSegAddClick
        end
        object btSegRemove: TButton
          Left = 111
          Top = 24
          Width = 82
          Height = 25
          Anchors = []
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 1
          OnClick = btSegRemoveClick
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 433
        Width = 204
        Height = 105
        Align = alTop
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1086#1090#1088#1080#1089#1086#1074#1082#1080
        TabOrder = 4
        DesignSize = (
          204
          105)
        object btSeg_SendToFront: TButton
          Left = 14
          Top = 24
          Width = 75
          Height = 25
          Anchors = []
          Caption = #1042' '#1085#1072#1095#1072#1083#1086
          TabOrder = 0
          OnClick = btSeg_SendToFrontClick
        end
        object btSeg_SendToBack: TButton
          Left = 118
          Top = 24
          Width = 75
          Height = 25
          Anchors = []
          Caption = #1042' '#1082#1086#1085#1077#1094
          TabOrder = 1
          OnClick = btSeg_SendToBackClick
        end
        object btSeg_SendBefore: TButton
          Left = 14
          Top = 55
          Width = 75
          Height = 25
          Anchors = []
          Caption = #1055#1077#1088#1077#1076
          TabOrder = 2
          OnClick = btSeg_SendBeforeClick
        end
        object btSeg_SendAfter: TButton
          Left = 118
          Top = 55
          Width = 75
          Height = 25
          Anchors = []
          Caption = #1055#1086#1089#1083#1077
          TabOrder = 3
          OnClick = btSeg_SendAfterClick
        end
      end
      object gbCombine: TGroupBox
        Left = 0
        Top = 538
        Width = 204
        Height = 105
        Align = alTop
        Caption = #1050#1086#1084#1073#1080#1085#1080#1088#1086#1074#1072#1085#1080#1077
        TabOrder = 5
        object btCombine_Horz: TButton
          Left = 14
          Top = 24
          Width = 179
          Height = 25
          Caption = #1055#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080
          TabOrder = 0
          OnClick = btCombine_HorzClick
        end
        object btCombine_Vert: TButton
          Left = 14
          Top = 55
          Width = 179
          Height = 25
          Caption = #1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080
          TabOrder = 1
          OnClick = btCombine_VertClick
        end
      end
    end
    object tsZoom: TTabSheet
      Caption = #1051#1091#1087#1072
      ImageIndex = 1
      object gbZoomLayer: TGroupBox
        Left = 0
        Top = 23
        Width = 204
        Height = 210
        Align = alTop
        TabOrder = 0
        DesignSize = (
          204
          210)
        object imZoomLayer: TImage
          Left = 3
          Top = 11
          Width = 196
          Height = 190
          Anchors = [akLeft, akTop, akRight, akBottom]
          ExplicitWidth = 190
        end
      end
      object tbZoomScale: TTrackBar
        Left = 0
        Top = 233
        Width = 204
        Height = 26
        Align = alTop
        Max = 32
        Min = 1
        PageSize = 1
        Frequency = 8
        Position = 1
        PositionToolTip = ptBottom
        TabOrder = 1
        ThumbLength = 15
        OnChange = tbZoomScaleChange
      end
      object pZoomScale_Labels: TPanel
        Left = 0
        Top = 259
        Width = 204
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Label1: TLabel
          Left = 6
          Top = 0
          Width = 6
          Height = 13
          Alignment = taCenter
          Caption = '1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 53
          Top = 0
          Width = 6
          Height = 13
          Alignment = taCenter
          Caption = '8'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 96
          Top = 0
          Width = 12
          Height = 13
          Alignment = taCenter
          Caption = '16'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 143
          Top = 0
          Width = 12
          Height = 13
          Alignment = taCenter
          Caption = '16'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 182
          Top = 0
          Width = 12
          Height = 13
          Alignment = taCenter
          Caption = '32'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
      object cbZoom_Enable: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 198
        Height = 17
        Align = alTop
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100
        TabOrder = 3
        OnClick = cbZoom_EnableClick
      end
      object gbZoomPosition: TGroupBox
        Left = 0
        Top = 280
        Width = 204
        Height = 86
        Align = alTop
        Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077
        TabOrder = 4
        DesignSize = (
          204
          86)
        object lbZoomPosition_X: TLabel
          Left = 44
          Top = 24
          Width = 35
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = 'X'
          ExplicitLeft = 42
        end
        object lbZoomPosition_Y: TLabel
          Left = 106
          Top = 24
          Width = 35
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = 'Y'
          ExplicitLeft = 102
        end
        object edZoomPosition_X: TEdit
          Left = 44
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 0
          Text = '0'
          OnChange = edZoomPosition_XChange
        end
        object edZoomPosition_Y: TEdit
          Left = 106
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 1
          Text = '0'
          OnChange = edZoomPosition_XChange
        end
        object udZoomPosition_X: TUpDown
          Left = 79
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edZoomPosition_X
          TabOrder = 2
          OnChanging = udZoomPosition_XChanging
        end
        object udZoomPosition_Y: TUpDown
          Left = 141
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edZoomPosition_Y
          TabOrder = 3
          OnChanging = udZoomPosition_XChanging
        end
      end
    end
    object tsCommonInfo: TTabSheet
      Caption = #1054#1073#1097#1077#1077
      ImageIndex = 2
      object gbMap: TGroupBox
        Left = 0
        Top = 0
        Width = 204
        Height = 153
        Align = alTop
        Caption = #1050#1072#1088#1090#1072
        TabOrder = 0
        DesignSize = (
          204
          153)
        object lbMap_Width: TLabel
          Left = 44
          Top = 24
          Width = 51
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = #1064#1080#1088#1080#1085#1072
        end
        object lbMap_Height: TLabel
          Left = 106
          Top = 24
          Width = 51
          Height = 13
          Alignment = taCenter
          Anchors = [akTop]
          AutoSize = False
          Caption = #1042#1099#1089#1086#1090#1072
        end
        object edMap_Width: TEdit
          Left = 44
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 0
          Text = '0'
          OnChange = edMap_WidthChange
        end
        object udMap_Width: TUpDown
          Left = 79
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edMap_Width
          Max = 9999
          TabOrder = 1
          OnChanging = udMap_WidthChanging
        end
        object edMap_Height: TEdit
          Left = 106
          Top = 40
          Width = 35
          Height = 21
          Alignment = taCenter
          Anchors = [akTop]
          TabOrder = 2
          Text = '0'
          OnChange = edMap_WidthChange
        end
        object udMap_Height: TUpDown
          Left = 141
          Top = 40
          Width = 16
          Height = 21
          Anchors = [akTop]
          Associate = edMap_Height
          Max = 9999
          TabOrder = 3
          OnChanging = udMap_WidthChanging
        end
        object btLoadSegmentMap: TButton
          Left = 20
          Top = 80
          Width = 165
          Height = 25
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1088#1090#1091' '#1089#1077#1075#1084#1077#1085#1090#1086#1074
          TabOrder = 4
          OnClick = btLoadSegmentMapClick
        end
        object btCalcMapSize: TButton
          Left = 20
          Top = 111
          Width = 165
          Height = 25
          Caption = #1055#1088#1086#1089#1095#1080#1090#1072#1090#1100' '#1088#1072#1079#1084#1077#1088
          TabOrder = 5
          OnClick = btCalcMapSizeClick
        end
      end
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 160
    Top = 624
  end
end
