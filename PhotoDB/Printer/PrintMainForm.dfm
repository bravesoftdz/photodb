object PrintForm: TPrintForm
  Left = 175
  Top = 207
  Caption = 'PrintForm'
  ClientHeight = 587
  ClientWidth = 754
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
  object ToolsPanel: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 527
    Align = alLeft
    TabOrder = 0
    DesignSize = (
      177
      527)
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 175
      Height = 89
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 72
        Width = 64
        Height = 13
        Caption = 'Print Formats:'
      end
      object BtnAddPrinter: TButton
        Left = 8
        Top = 8
        Width = 162
        Height = 25
        Caption = 'Add New Printer'
        TabOrder = 0
        OnClick = BtnAddPrinterClick
      end
      object Button2: TButton
        Left = 8
        Top = 40
        Width = 162
        Height = 25
        Caption = 'Printer Setup'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 422
      Width = 175
      Height = 104
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Label4: TLabel
        Left = 54
        Top = 57
        Width = 7
        Height = 13
        Caption = 'X'
      end
      object Label3: TLabel
        Left = 8
        Top = 36
        Width = 61
        Height = 13
        Caption = 'Custom Size:'
      end
      object EdWidth: TEdit
        Left = 8
        Top = 52
        Width = 41
        Height = 21
        Enabled = False
        TabOrder = 0
        Text = '10'
        OnExit = EdWidthExit
      end
      object ComboBox2: TComboBox
        Left = 112
        Top = 52
        Width = 49
        Height = 21
        Enabled = False
        TabOrder = 1
        Text = 'sm'
        OnChange = ComboBox2Change
        OnKeyPress = ComboBox2KeyPress
        Items.Strings = (
          'px'
          'mm'
          'sm'
          'in')
      end
      object EdHeight: TEdit
        Left = 64
        Top = 52
        Width = 41
        Height = 21
        Enabled = False
        TabOrder = 2
        Text = '15'
        OnExit = EdHeightExit
      end
      object CbUseCustomSize: TCheckBox
        Left = 8
        Top = 18
        Width = 153
        Height = 17
        Caption = 'Use custom size'
        TabOrder = 3
        OnClick = CbUseCustomSizeClick
      end
      object CbCropImage: TCheckBox
        Left = 8
        Top = 0
        Width = 162
        Height = 17
        Caption = 'Crop Images'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object WlGeneratePreview: TWebLink
        Left = 8
        Top = 80
        Width = 80
        Height = 16
        Cursor = crHandPoint
        Text = 'Make Image'
        ImageIndex = 0
        IconWidth = 16
        IconHeight = 16
        UseEnterColor = False
        EnterColor = clBlack
        EnterBould = False
        TopIconIncrement = 0
        ImageCanRegenerate = True
        UseSpecIconSize = True
        HightliteImage = False
      end
    end
    object LvMain: TEasyListview
      Left = 8
      Top = 88
      Width = 161
      Height = 328
      Anchors = [akLeft, akTop, akBottom]
      EditManager.Font.Charset = DEFAULT_CHARSET
      EditManager.Font.Color = clWindowText
      EditManager.Font.Height = -11
      EditManager.Font.Name = 'MS Sans Serif'
      EditManager.Font.Style = []
      Header.Columns.Items = {
        0600000001000000110000005445617379436F6C756D6E53746F726564FFFECE
        000600000080080001010001000000000000019E000000FFFFFF1F0001000000
        00000000000000000000000000000000}
      ImagesLarge = ImlFormatPreviews
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      Scrollbars.HorzEnabled = False
      Selection.AlphaBlend = True
      Selection.AlphaBlendSelRect = True
      Selection.BlendIcon = False
      Selection.FullRowSelect = True
      Selection.Gradient = True
      Selection.RoundRect = True
      TabOrder = 2
      View = elsThumbnail
      OnDblClick = LvMainDblClick
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 527
    Width = 754
    Height = 41
    Align = alBottom
    TabOrder = 1
    object OkButtonPanel: TPanel
      Left = 568
      Top = 1
      Width = 185
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnPrint: TButton
        Left = 88
        Top = 8
        Width = 90
        Height = 25
        Caption = 'Print'
        Enabled = False
        TabOrder = 0
        OnClick = BtnPrintClick
      end
      object BtnCancel: TButton
        Left = 7
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = BtnCancelClick
      end
    end
  end
  object RightPanel: TPanel
    Left = 624
    Top = 0
    Width = 130
    Height = 527
    Align = alRight
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 200
      Width = 28
      Height = 13
      Caption = 'Page:'
    end
    object ImCurrentFormat: TImage
      Left = 8
      Top = 320
      Width = 121
      Height = 198
    end
    object Label5: TLabel
      Left = 8
      Top = 304
      Width = 72
      Height = 13
      Caption = 'Current Format:'
    end
    object Panel1: TPanel
      Left = 8
      Top = 8
      Width = 113
      Height = 105
      BevelInner = bvLowered
      TabOrder = 0
      object ScrollingImageNavigator1: TScrollingImageNavigator
        Left = 2
        Top = 2
        Width = 109
        Height = 101
        ScrollingImage = FastScrollingImage1
        Shape.Left = 0
        Shape.Top = 0
        Shape.Width = 65
        Shape.Height = 65
        Shape.Brush.Style = bsClear
        Shape.Pen.Color = clRed
        Shape.Pen.Width = 2
        Align = alClient
      end
    end
    object ZoomInLink: TWebLink
      Left = 8
      Top = 120
      Width = 60
      Height = 16
      Cursor = crHandPoint
      Enabled = False
      Text = 'Zoom In'
      OnClick = ZoomInLinkClick
      ImageIndex = 0
      IconWidth = 16
      IconHeight = 16
      UseEnterColor = False
      EnterColor = clBlack
      EnterBould = False
      TopIconIncrement = 0
      ImageCanRegenerate = True
      Icon.Data = {
        0000010001001010000001002000680400001600000028000000100000002000
        0000010020000000000040040000000000000000000000000000000000000000
        0003000000240000003200000016000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000003F3B
        38603C4347C315232DB8000000680000001D0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000007E8D
        9CCC3685C3FF1F6B9CFF1A303FD0010000760000002600000002000000000000
        00000000000000000000000000000000000000000000000000000000000077D0
        EF9C39A2F5FF1B7BCAFF206DA0FF1F394CD9020000800000002F000000030000
        0000000000000000000000000000000000000000000000000000000000007FE5
        F20776D9F39044A8F5FF1E80D1FF1F71A6FF21435BE203060889000000210000
        0000000000040000000900000006000000000000000000000000000000000000
        0000000000007ADCF27C4BAEF6FB1D82D8FF1E73AEFF2C3D47CB0000005E0100
        00440D050668060202730000005F0000003B0000001200000000000000000000
        000000000000000000007BDDF06357B8F8F0759DBFFF84807FEB634E4ED2967C
        73E6C2ACA3F8BBA7A5F8846D6CE8291B1AB7000000680000001C000000000000
        00000000000000000000000000008CD6E326B8ADAB95BFA6A1FFE3CCAFFFF5E6
        C3FFFEFCEEFFFFFFFFFFFFFFFFFFD8C6C3FF44302FD000000064000000110000
        00000000000000000000000000000000000085605D83E9D4B7FFE3CD95FFECE4
        C8FFFF7348FFD3B56BFFFFFFFFFFFFFFFCFFCDB6A9FF1F1313A80000002C0000
        000000000000000000000000000088525211B8978DD7E7D3A0FFDBBA80FFE7CA
        A0FFFF0000FFD3B56BFFF1DABEFFF2E0C5FFEFDDBFFF58433FCC0000003A0000
        0000000000000000000000000000925E5E19C7AB9CECE4D29AFFFF7348FFFF00
        00FFFF0000FFFF0000FFFF7348FFE2B47CFFF0DDB5FF6E5953D0000000340000
        00000000000000000000000000008E5A5B0DB69384CDEDDEB3FFE3CB9BFFECDE
        BEFFFF0000FFE0C795FFE0C795FFDCBF82FFECD8B6FF584341B40000001B0000
        0000000000000000000000000000000000009A6A646CE0CCADFFFFFFF3FFFDFF
        FDFFFF7348FFE0C795FFD3B56BFFEEDBAAFFC8AC9DF82617185D000000030000
        000000000000000000000000000000000000905D5E07A0736896DECBB9FFFCF8
        EEFFF8F6DFFFECDFB4FFECDCB5FFCCAF9CF34B32317500000005000000000000
        000000000000000000000000000000000000000000008C5B5D0296646051AA82
        73ADBA9883DCB79684D49771689A3F28283C0000000100000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000FFF
        FFFF07FFFFFF01FFFFFF00FFFFFF008FFFFFC003FFFFE001FFFFF000FFFFF800
        FFFFF000FFFFF000FFFFF000FFFFF800FFFFF801FFFFFC03FFFFFFFFFFFF}
      UseSpecIconSize = True
      HightliteImage = False
    end
    object ZoomOutLink: TWebLink
      Left = 8
      Top = 140
      Width = 68
      Height = 16
      Cursor = crHandPoint
      Enabled = False
      Text = 'Zoom Out'
      OnClick = ZoomOutLinkClick
      ImageIndex = 0
      IconWidth = 16
      IconHeight = 16
      UseEnterColor = False
      EnterColor = clBlack
      EnterBould = False
      TopIconIncrement = 0
      ImageCanRegenerate = True
      Icon.Data = {
        0000010001001010000001002000680400001600000028000000100000002000
        0000010020000000000040040000000000000000000000000000000000000000
        0000000000040000002700000030000000100000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000403B396637444BC8101B24AF0000005A0000001200000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00007D90A1D32F83C4FF216592FD16232EC20000006200000016000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000077D1F196379FF3FF1B79C4FF226896FD162530C400000064000000150000
        0000000000000000000000000000000000000000000000000000000000000000
        000080E5F10674D5F49F3A9FF2FF1B7CC9FF236997FF142633C70000015A0000
        0008000000000000000700000007000000000000000000000000000000000000
        00000000000084E4EE0B72D4F4A33EA2F2FF1579C9FF326C95FF0D0E0F9B0000
        0048060102540903037000000064000000430000001900000001000000000000
        0000000000000000000084E4EE0372DAF68B53A6E7F78595A1FF706463DD775F
        59D9B49D93F3BFABA6F9937D7BEC3A2929C20000007600000022000000000000
        000000000000000000000000000082F0FD01AED7E147CAB7B4D7C8AF9FFFF1DE
        B9FFFBF2DAFFFFFFFFFFFFFFFFFFE9DCD9FF574140D900000067000000100000
        000000000000000000000000000000000000312D300ABF9D94D2ECD8ADFFE5D5
        A9FFF2ECD9FFFDFFFEFFFFFFFFFFFFFFFFFFD5BFB2FF211414A90000002C0000
        0000000000000000000000000000000000006B444240DDC9B3FEE2C98FFFFF73
        48FFFF7348FFFF7348FFFF7348FFECCBA5FFF3E5C8FF5B4642CF0000003A0000
        0000000000000000000000000000000000009567635AE6D6BCFFDBBC7BFFDC49
        00FFDC4900FFDC4900FFDC4900FFDFAA6DFFF1DFB7FF735E57D4000000360000
        0000000000000000000000000000000000009462603DDCC8AEFFE5CE98FFE4D1
        A5FFE8DBB4FFE3D0A3FFDEC691FFDABE82FFECD6ADFF614C49BE0000001F0000
        000000000000000000000000000000000000905C5F0FB58F7BCEF7F0D4FFFDFB
        F5FFF1E6CEFFDDC38CFFCDA655FFE6CF94FFD9BFABFF31202070000000050000
        00000000000000000000000000000000000000000000935F5E37C3A28FE4F8F2
        E9FFFCFAEAFFECDDB0FFEBD9AAFFE1CAB1FF674A46960000000D000000000000
        000000000000000000000000000000000000000000000000000094625E26A67B
        6E99C09F8AE5C5A690EFAF8A7DBF593D39610502030700000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000000000000087FF
        FFFF83FFFFFF81FFFFFF80FFFFFF804FFFFFC001FFFFE001FFFFF000FFFFF800
        FFFFF800FFFFF800FFFFF800FFFFF800FFFFFC01FFFFFE03FFFFFFFFFFFF}
      UseSpecIconSize = True
      HightliteImage = False
    end
    object FullSizeLink: TWebLink
      Left = 8
      Top = 160
      Width = 60
      Height = 16
      Cursor = crHandPoint
      Enabled = False
      Text = 'Full Size'
      OnClick = FullSizeLinkClick
      ImageIndex = 0
      IconWidth = 16
      IconHeight = 16
      UseEnterColor = False
      EnterColor = clBlack
      EnterBould = False
      TopIconIncrement = 0
      ImageCanRegenerate = True
      Icon.Data = {
        0000010001001010000001002000680400001600000028000000100000002000
        0000010020000000000040040000000000000000000000000000000000001A19
        19351D1C1B84080B0E84000000430000000A0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000007975
        76BF48799AFF215577F20B0F13A4000000470000000900000000000000000000
        00000000000000000000000000000000000000000000000000000000000074AD
        D1DC228AE1FF1974B2FF265879F30C1013A8000000490000000C000000000000
        00000000000000000000000000000000000000000000000000000000000076DC
        F75F53B7F8F42587DEFF1A74B2FF26597CF40D1217A90000004D0000000B0000
        0000000000000000000000000000000000000000000000000000000000000000
        00007DDFF15855B9F8F62689E0FF1A75B5FF245B80F60C151DA50000002F0000
        0000000000070000000F0000000B000000010000000000000000000000000000
        0000000000007EE0F15555B9F9F52187E2FF1F77B6FF3C4D58D7000000670501
        024E190D0E75130808810000006B000000420000001600000000000000000000
        000000000000000000007DE0F46155B8F9F3789DBFFF878381EF624F4FD4987D
        75E6C3ADA3F8C0ACA8F88C7473EA2E1D1DBB0000006D0000001F000000000000
        000000000000000000000000000083CDDB35A6A09E9DBCA4A0FFE0C9AEFFF5E7
        C3FFFFFBECFFFFFFFFFFFFFFFFFFD9C8C6FF483332D200000065000000110000
        000000000000000000000000000000000000684B4972E8D2BCFFE5CD98FFE9D8
        B4FFF2E3CDFFFDFAF6FFFFFEFDFFFFFAECFFC9B3AAFE1D1212A60000002B0000
        00000000000000000000000000007E48460BAF8D85C4D1802CFFE5CD98FFD180
        2CFFD1802CFFD1802CFFD1802CFFD1802CFFD1802CFF584746CB0000003A0000
        0000000000000000000000000000925D5D16C4A99BE6D1802CFFE5CD98FFD180
        2CFFF7EFD5FFD1802CFFD1802CFFF7EFD5FFD1802CFF746660D40000003C0000
        0000000000000000000000000000925C5D15C3A795E1D1802CFFE5CD98FFD180
        2CFFD1802CFFD1802CFFD1802CFFD1802CFFD1802CFF73645FCE000000320000
        00000000000000000000000000008E595C06AC8477B4F0E3C1FFECD5B1FFEDDE
        BFFFE4C798FFDBBD83FFD4B06BFFD8AE67FFECDBBCFF543F3DAE000000180000
        0000000000000000000000000000000000009562604CD0B599FCFFFFFBFFFFFF
        FFFFEFE6CDFFD8BB7BFFD5B66BFFF4E7C0FFBC9E91F421131452000000020000
        0000000000000000000000000000000000000000000095666171CFB6A0F5F5EE
        DFFFF7EFD5FFEDDFB5FFEBDCBBFFC2A18FEA422B296600000004000000000000
        000000000000000000000000000000000000000000000000000095635F3FA378
        6B9BB5907CE2B28D7EDA8F685F923822233400000000000000000000000007FF
        FFFF03FFFFFF01FFFFFF00FFFFFF8087FFFFC003FFFFE001FFFFF000FFFFF800
        FFFFF000FFFFF000FFFFF000FFFFF000FFFFF800FFFFFC01FFFFFE07FFFF}
      UseSpecIconSize = True
      HightliteImage = False
    end
    object FitToSizeLink: TWebLink
      Left = 6
      Top = 182
      Width = 64
      Height = 16
      Cursor = crHandPoint
      Enabled = False
      Text = 'Fit Image'
      OnClick = FitToSizeLinkClick
      ImageIndex = 0
      IconWidth = 16
      IconHeight = 16
      UseEnterColor = False
      EnterColor = clBlack
      EnterBould = False
      TopIconIncrement = 0
      ImageCanRegenerate = True
      Icon.Data = {
        0000010001001010000001002000680400001600000028000000100000002000
        0000010020000000000040040000000000000000000000000000000000001A19
        19351D1C1B84080B0E84000000430000000A0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000007975
        76BF48799AFF215577F20B0F13A4000000470000000900000000000000000000
        00000000000000000000000000000000000000000000000000000000000074AD
        D1DC228AE1FF1974B2FF265879F30C1013A8000000490000000C000000000000
        00000000000000000000000000000000000000000000000000000000000076DC
        F75F53B7F8F42587DEFF1A74B2FF26597CF40D1217A90000004D0000000B0000
        0000000000000000000000000000000000000000000000000000000000000000
        00007DDFF15855B9F8F62689E0FF1A75B5FF245B80F60C151DA50000002F0000
        0000000000070000000F0000000B000000010000000000000000000000000000
        0000000000007EE0F15555B9F9F52187E2FF1F77B6FF3C4D58D7000000670501
        024E190D0E75130808810000006B000000420000001600000000000000000000
        000000000000000000007DE0F46155B8F9F3789DBFFF878381EF624F4FD4987D
        75E6C3ADA3F8C0ACA8F88C7473EA2E1D1DBB0000006D0000001F000000000000
        000000000000000000000000000083CDDB35A6A09E9DBCA4A0FFE0C9AEFFF5E7
        C3FFFFFBECFFFFFFFFFFFFFFFFFFD9C8C6FF483332D200000065000000110000
        000000000000000000000000000000000000684B4972E8D2BCFFE5CD98FFE9D8
        B4FFF2E3CDFFFDFAF6FFFFFEFDFFFFFAECFFC9B3AAFE1D1212A60000002B0000
        00000000000000000000000000007E48460BAF8D85C4D1802CFFE5CD98FFD180
        2CFFD1802CFFD1802CFFD1802CFFD1802CFFD1802CFF584746CB0000003A0000
        0000000000000000000000000000925D5D16C4A99BE6D1802CFFE5CD98FFD180
        2CFFF7EFD5FFD1802CFFD1802CFFF7EFD5FFD1802CFF746660D40000003C0000
        0000000000000000000000000000925C5D15C3A795E1D1802CFFE5CD98FFD180
        2CFFD1802CFFD1802CFFD1802CFFD1802CFFD1802CFF73645FCE000000320000
        00000000000000000000000000008E595C06AC8477B4F0E3C1FFECD5B1FFEDDE
        BFFFE4C798FFDBBD83FFD4B06BFFD8AE67FFECDBBCFF543F3DAE000000180000
        0000000000000000000000000000000000009562604CD0B599FCFFFFFBFFFFFF
        FFFFEFE6CDFFD8BB7BFFD5B66BFFF4E7C0FFBC9E91F421131452000000020000
        0000000000000000000000000000000000000000000095666171CFB6A0F5F5EE
        DFFFF7EFD5FFEDDFB5FFEBDCBBFFC2A18FEA422B296600000004000000000000
        000000000000000000000000000000000000000000000000000095635F3FA378
        6B9BB5907CE2B28D7EDA8F685F923822233400000000000000000000000007FF
        FFFF03FFFFFF01FFFFFF00FFFFFF8087FFFFC003FFFFE001FFFFF000FFFFF800
        FFFFF000FFFFF000FFFFF000FFFFF000FFFFF800FFFFFC01FFFFFE07FFFF}
      UseSpecIconSize = True
      HightliteImage = False
    end
    object CbPageNumber: TComboBox
      Left = 8
      Top = 216
      Width = 113
      Height = 21
      Enabled = False
      TabOrder = 5
      Text = '1'
      OnClick = CbPageNumberClick
      Items.Strings = (
        '1')
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 240
      Width = 113
      Height = 57
      Caption = 'Print Pange'
      Enabled = False
      ItemIndex = 1
      Items.Strings = (
        'Only this Page'
        'All Pages')
      TabOrder = 6
    end
  end
  object FastScrollingImage1: TFastScrollingImage
    Left = 177
    Top = 0
    Width = 447
    Height = 527
    Zoom = 100.000000000000000000
    Align = alClient
    PopupMenu = PopupMenu1
    OnResize = FastScrollingImage1Resize
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 568
    Width = 754
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end>
  end
  object StHintText: TStaticText
    Left = 248
    Top = 104
    Width = 209
    Height = 169
    AutoSize = False
    BiDiMode = bdRightToLeft
    Caption = 'Hint text'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 5
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 384
    Top = 8
  end
  object PrintDialog1: TPrintDialog
    Left = 352
    Top = 8
  end
  object PageSetupDialog1: TPageSetupDialog
    MinMarginLeft = 0
    MinMarginTop = 0
    MinMarginRight = 0
    MinMarginBottom = 0
    MarginLeft = 2500
    MarginTop = 2500
    MarginRight = 2500
    MarginBottom = 2500
    PageWidth = 21000
    PageHeight = 29700
    Left = 416
    Top = 8
  end
  object ImlFormatPreviews: TImageList
    Height = 100
    Width = 100
    Left = 72
    Top = 128
  end
  object TerminateTimes: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TerminateTimesTimer
    Left = 320
    Top = 8
  end
  object SaveWindowPos1: TSaveWindowPos
    SetOnlyPosition = False
    RootKey = HKEY_CURRENT_USER
    Key = 'Software\Positions\Noname23'
    Left = 288
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 256
    Top = 8
    object CopyToFile1: TMenuItem
      Caption = 'Copy To File'
      OnClick = CopyToFile1Click
    end
  end
end
