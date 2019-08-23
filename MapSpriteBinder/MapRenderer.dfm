object frMapRenderer: TfrMapRenderer
  Left = 0
  Top = 0
  Width = 565
  Height = 419
  TabOrder = 0
  TabStop = True
  OnMouseWheel = FrameMouseWheel
  OnResize = FrameResize
  object pRenderer: TPanel
    Left = 0
    Top = 0
    Width = 565
    Height = 419
    Align = alClient
    TabOrder = 0
    object imRenderLayer: TImage
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 544
      Height = 398
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alClient
      OnMouseDown = imRenderLayerMouseDown
      OnMouseMove = imRenderLayerMouseMove
      OnMouseUp = imRenderLayerMouseUp
      ExplicitLeft = 0
      ExplicitTop = 6
      ExplicitWidth = 685
      ExplicitHeight = 661
    end
    object sbRendererHorz: TScrollBar
      AlignWithMargins = True
      Left = 1
      Top = 401
      Width = 546
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 17
      Margins.Bottom = 0
      Align = alBottom
      Max = 200
      Min = 100
      PageSize = 1
      Position = 200
      TabOrder = 0
      OnChange = sbRendererHorzChange
    end
    object sbRendererVert: TScrollBar
      Left = 547
      Top = 1
      Width = 17
      Height = 400
      Align = alRight
      Kind = sbVertical
      PageSize = 0
      TabOrder = 1
      OnChange = sbRendererHorzChange
    end
  end
  object tRenderer: TTimer
    Interval = 20
    OnTimer = tRendererTimer
    Left = 504
    Top = 16
  end
  object tInitResize: TTimer
    Interval = 100
    OnTimer = tInitResizeTimer
    Left = 504
    Top = 64
  end
end
