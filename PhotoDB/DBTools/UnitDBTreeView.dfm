object FormCreateDBFileTree: TFormCreateDBFileTree
  Left = 107
  Top = 134
  Width = 531
  Height = 404
  Caption = 'FormCreateDBFileTree'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 384
    Height = 347
    Align = alClient
    Images = ImageList1
    Indent = 19
    ReadOnly = True
    ShowRoot = False
    TabOrder = 0
    OnClick = TreeView1Click
    OnContextPopup = TreeView1ContextPopup
    OnExpanding = TreeView1Expanding
    OnExpanded = TreeView1Expanded
    OnGetImageIndex = TreeView1GetImageIndex
    OnGetSelectedIndex = TreeView1GetSelectedIndex
  end
  object Panel1: TPanel
    Left = 384
    Top = 0
    Width = 131
    Height = 347
    Align = alRight
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 65
      Height = 13
      Caption = 'Selected info:'
    end
    object Label2: TLabel
      Left = 8
      Top = 168
      Width = 23
      Height = 13
      Caption = 'ID = '
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Make Tree'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Panel2: TPanel
      Left = 8
      Top = 56
      Width = 106
      Height = 106
      BevelInner = bvLowered
      TabOrder = 1
      object Image1: TImage
        Left = 2
        Top = 2
        Width = 102
        Height = 102
        Center = True
        OnContextPopup = Image1ContextPopup
        OnMouseDown = Image1MouseDown
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 347
    Width = 515
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object ImageList1: TImageList
    Left = 224
    Top = 32
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 72
    object OpeninExplorer1: TMenuItem
      Caption = 'Open in Explorer'
      OnClick = OpeninExplorer1Click
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 192
    Top = 72
  end
  object SelectTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SelectTimerTimer
    Left = 160
    Top = 72
  end
  object DropFileSource1: TDropFileSource
    DragTypes = [dtCopy]
    OnFeedback = DropFileSource1Feedback
    Images = DragImageList
    ShowImage = True
    AllowAsyncTransfer = True
    Left = 160
    Top = 32
  end
  object DragImageList: TImageList
    BlendColor = clBlack
    BkColor = clBlack
    Left = 128
    Top = 72
  end
  object DropFileTarget1: TDropFileTarget
    DragTypes = []
    OptimizedMove = True
    Left = 128
    Top = 32
  end
  object DestroyTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = DestroyTimerTimer
    Left = 192
    Top = 32
  end
end
