object FormCreatePerson: TFormCreatePerson
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Person'
  ClientHeight = 322
  ClientWidth = 554
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClick = WedNameExit
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    554
    322)
  PixelsPerInch = 96
  TextHeight = 13
  object PbPhoto: TPaintBox
    Left = 8
    Top = 8
    Width = 254
    Height = 304
    PopupMenu = PmImageOptions
    OnClick = WedNameExit
    OnPaint = PbPhotoPaint
  end
  object LbName: TLabel
    Left = 272
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object BvSeparator: TBevel
    Left = 264
    Top = 8
    Width = 2
    Height = 306
    Anchors = [akLeft, akTop, akBottom]
    Shape = bsLeftLine
    ExplicitHeight = 321
  end
  object LbComments: TLabel
    Left = 272
    Top = 189
    Width = 54
    Height = 13
    Caption = 'Comments:'
  end
  object LbGroups: TLabel
    Tag = 2
    Left = 272
    Top = 122
    Width = 78
    Height = 13
    Caption = 'Related Groups:'
  end
  object LbBirthDate: TLabel
    Left = 272
    Top = 76
    Width = 60
    Height = 13
    Caption = 'LbBirthDate:'
  end
  object ImOK: TImage
    Left = 376
    Top = 8
    Width = 17
    Height = 16
    Picture.Data = {
      055449636F6E0000010001001010000001002000680400001600000028000000
      1000000020000000010020000000000040040000000000000000000000000000
      00000000000000000000000000000000000000000C8016600A8013BF0A8711FF
      098D0FFF088C0EFF07830CFF06760ABF05710960000000000000000000000000
      000000000000000000000000118A1F200F881BCF0F9818FF0FA817FF0FA816FF
      0EA715FF0EA714FF0DA614FF0DA613FF0A900FFF06760ACF05720A2000000000
      000000000000000014902520139422EF14A91FFF14AD1EFF14AD1DFF13AC1CFF
      12AB1BFF12AB1BFF11AA1AFF11AA19FF10A918FF0FA216FF087F0EEF06740B20
      000000000000000017982ACF19AF26FF19B225FF18B124FF18B124FF17B023FF
      17B022FF16AF21FF16AF20FF15AE20FF15AE1FFF14AD1EFF12A61BFF087B0FCF
      000000001B9E316045BC58FF5FCC6AFF5ACA65FF4BC557FF2ABA37FF38BE44FF
      7ED486FF29B835FF1AB327FF1AB326FF19B225FF18B125FF18B124FF11991BFF
      097A106028AB42BF76DB86FF69D175FF65D071FF60CE6CFF7AD684FFF1FBF2FF
      FFFFFFFFD5F2D8FF2DBC3BFF1EB72DFF1EB72DFF1DB62CFF1DB62BFF1CB52AFF
      0C8216BF49C566FF78D985FF74D781FF6FD57CFF86DC91FFF5FCF6FFFFFFFFFF
      FFFFFFFFFFFFFFFFD6F2D9FF31C041FF23BC34FF22BB33FF21BA32FF21BA31FF
      13931FFF65D883FF82DE90FF7EDC8CFF92E19DFFF6FDF7FFFFFFFFFFFFFFFFFF
      DAF5DEFFFFFFFFFFFFFFFFFFD6F3DAFF35C548FF27C03BFF26BF3AFF26BF39FF
      1AA22AFF69DB88FF8CE29AFF87E196FFE0F7E4FFFFFFFFFFFFFFFFFFAAE9B4FF
      72DA82FFBAEDC2FFFFFFFFFFFFFFFFFFD7F4DBFF39C94EFF2CC542FF2BC441FF
      1EA730FF54D275FF99EBABFF91E6A1FFC0F0C9FFF1FCF3FFB3EDBDFF80E191FF
      7CDF8DFF63D977FFB3EDBDFFFFFFFFFFFFFFFFFFD8F5DDFF3ECD55FF30C949FF
      1DA230FF39C95EBFA9F6BEFF9AEAAAFF96E9A7FF92E8A3FF8EE79FFF89E59BFF
      86E498FF81E394FF53D86CFFB5EFC0FFFFFFFFFFFFFFFFFF69DB7DFF39D255FF
      1A9C2FBF31C95A607BE79BFFA6F1B8FF9FEDB0FF9BECADFF97EBA9FF93EAA6FF
      8FE9A2FF8BE89EFF87E79BFF5DDE77FF9FECAFFFB7F0C3FF49D865FF33C350FF
      1B9D3160000000003DD267CFA5F6BDFFA8F2BBFFA4F0B6FFA0F0B3FF9CEFAFFF
      98EEACFF94ECA9FF90EBA5FF8DEAA2FF80E897FF60E17CFF54DE75FF24AC40CF
      000000000000000036D2622050DB78EFA8F8C1FFAFF7C3FFA9F3BCFFA5F2B9FF
      A1F2B5FF9DF1B2FF9AF0AFFF96EFABFF93EFA9FF88EDA4FF3CBF5AEF22AC3E20
      00000000000000000000000037D6652041D86DCF81ECA2FFB7FDCEFFB1FAC7FF
      ACF8C2FFA8F7BFFFA6F8BEFFA6FAC0FF70E18FFF32BE53CF26B4462000000000
      000000000000000000000000000000000000000038D7666042D96EBF5FE185FF
      76E898FF73E695FF59DA7DFF39C95FBF2CC05260000000000000000000000000
      00000000F00F0000C00300008001000080010000000000000000000000000000
      00000000000000000000000000000000000000008001000080010000C0030000
      F00F0000}
    Visible = False
  end
  object ImInvalid: TImage
    Left = 399
    Top = 8
    Width = 17
    Height = 16
    Picture.Data = {
      055449636F6E0000010001001010000001002000680400001600000028000000
      1000000020000000010020000000000040040000000000000000000000000000
      00000000000000000000000000000000000000000B12AD600913B2BF0619C3FF
      041FD3FF031ED2FF0416C0FF050DACBF060AA460000000000000000000000000
      000000000000000000000000101AB7200F1BB9CF0E2DDDFF093BFFFF0336FFFF
      0133FFFF0033FFFF0033FFFF0033FFFF0322D8FF070FAECF090DA92000000000
      00000000000000001520BE201628C8EF1B47F6FF1748FFFF1244FFFF0D3FFFFF
      083AFFFF0336FFFF0033FFFF0033FFFF0033FFFF012FF5FF0817BCEF0B11AD20
      00000000000000001929C8CF2854F7FF2656FFFF2051FFFF1B4CFFFF1648FFFF
      1143FFFF0C3EFFFF0739FFFF0235FFFF0033FFFF0033FFFF022FF5FF0C17B7CF
      000000001B2BCB604F69E7FF6F90FFFF678AFFFFA5B9FFFFC8D4FFFF4970FFFF
      1A4CFFFF1547FFFF3D65FFFFC1CEFFFF819BFFFF0134FFFF0033FFFF0728DFFF
      101AB7602A3CD5BF88A7FFFF7B9BFFFF7495FFFFDBE3FFFFFFFFFFFFF1F4FFFF
      4C74FFFF4870FFFFF1F4FFFFFFFFFFFFC2CFFFFF0A3CFFFF0537FFFF0134FFFF
      1220C2BF4D63E4FF8DAAFFFF88A6FFFF80A0FFFF93AEFFFFF7F9FFFFFFFFFFFF
      F2F5FFFFF1F5FFFFFFFFFFFFF1F4FFFF446CFFFF1345FFFF0E40FFFF093BFFFF
      112AD5FF6A82EFFF93AFFFFF90ACFFFF8CA9FFFF85A4FFFF98B1FFFFF7F9FFFF
      FFFFFFFFFFFFFFFFF2F5FFFF5077FFFF2253FFFF1D4EFFFF1749FFFF1244FFFF
      1435E4FF6E86F2FF99B3FFFF96B1FFFF92AEFFFF8EABFFFFA0B8FFFFF7F9FFFF
      FFFFFFFFFFFFFFFFF2F5FFFF567DFFFF2B5BFFFF2656FFFF2152FFFF1C4DFFFF
      1B3CE7FF5871F1FFA3BBFFFF9BB5FFFF98B2FFFFA8BEFFFFF8FAFFFFFFFFFFFF
      F8FAFFFFF8FAFFFFFFFFFFFFF2F5FFFF5A80FFFF2F5FFFFF2A5AFFFF2556FFFF
      213EE3FF3C57F2BFB0C7FFFFA1B9FFFF9DB6FFFFE6ECFFFFFFFFFFFFF8FAFFFF
      A4BCFFFFA2BAFFFFF8FAFFFFFFFFFFFFCEDAFFFF3968FFFF3463FFFF3362FFFF
      253DE0BF3350F660809AFBFFAAC1FFFFA3BBFFFFD0DCFFFFE7EDFFFFACC1FFFF
      95B0FFFF92AEFFFFA4BBFFFFE3EAFFFFA3BBFFFF4271FFFF3D6CFFFF395EF3FF
      2840E26000000000415FFCCFAAC0FFFFAAC0FFFFA5BCFFFFA2BAFFFF9EB7FFFF
      9BB4FFFF98B2FFFF94AFFFFF91ADFFFF85A4FFFF668DFFFF5B83FDFF324DEBCF
      00000000000000003858FF205371FFEFADC3FFFFAFC5FFFFA7BEFFFFA4BBFFFF
      A0B9FFFF9DB6FFFF9AB4FFFF96B1FFFF94B0FFFF8FABFEFF4865F5EF304BF020
      0000000000000000000000003858FF204362FFCF859FFFFFBCD1FFFFB3C9FFFF
      ABC2FFFFA8C0FFFFA7C0FFFFAAC3FFFF7995FEFF3E5CFACF3350F62000000000
      00000000000000000000000000000000000000003858FF604363FFBF627FFFFF
      7B96FFFF7995FFFF607DFFFF4362FFBF3858FF60000000000000000000000000
      00000000F00F0000C00300008001000080010000000000000000000000000000
      00000000000000000000000000000000000000008001000080010000C0030000
      F00F0000}
    Visible = False
  end
  object ImWarning: TImage
    Left = 422
    Top = 8
    Width = 17
    Height = 16
    Picture.Data = {
      055449636F6E0000010001001010000001002000680400001600000028000000
      1000000020000000010020000000000040040000000000000000000000000000
      0000000000000000000000000000000000000000009DDB6000A0DDBF00ACE5FF
      00B7ECFF00B6ECFF00ABE5FF009FDCBF009AD960000000000000000000000000
      00000000000000000000000000A6E12000A7E1CF00C0F0FF00D8FFFF00D6FFFF
      00D5FFFF00D4FFFF00D3FFFF00D2FFFF00B9EEFF009EDCCF009AD92000000000
      000000000000000000ABE52000B3E9EF00D6FBFF00DBFFFF00DAFFFF00D9FFFF
      55E5FFFF55E4FFFF00D6FFFF00D5FFFF00D4FFFF00CCFAFF00A5E1EF009AD920
      000000000000000000B3E9CF00DAFCFF00DFFFFF00DEFFFF00DDFFFF8DEFFFFF
      FFFFFFFFFFFFFFFF8DEEFFFF00D8FFFF00D7FFFF00D5FFFF00CDFAFF009FDCCF
      0000000000B4EC602CD5F6FF4AEBFFFF45EAFFFF34E7FFFF10E1FFFF55EAFFFF
      FFFFFFFFFFFFFFFF55E7FFFF00DAFFFF00D9FFFF00D8FFFF00D7FFFF00BCEEFF
      009AD9600CBEF0BF5EF2FFFF52EDFFFF4DECFFFF48EBFFFF43EAFFFF18E4FFFF
      38E7FFFF00DFFFFF00DEFFFF00DDFFFF00DCFFFF00DBFFFF00DAFFFF00D9FFFF
      009FDCBF2ED1F6FF5EF1FFFF5AF0FFFF55EFFFFF50EEFFFF4BEDFFFF42EBFFFF
      FFFFFFFFFFFFFFFF55EBFFFF00E0FFFF00DFFFFF00DEFFFF00DCFFFF00DBFFFF
      00AFE6FF50E0FAFF66F4FFFF62F3FFFF5DF2FFFF58F1FFFF53EFFFFF75F2FFFF
      FFFFFFFFFFFFFFFF71EFFFFF00E2FFFF00E1FFFF00E0FFFF00DFFFFF00DEFFFF
      00BEEEFF55E2FBFF6EF6FFFF6AF5FFFF65F4FFFF60F3FFFF5BF1FFFF8EF5FFFF
      FFFFFFFFFFFFFFFFAAF7FFFF00E5FFFF00E4FFFF00E3FFFF00E2FFFF00E1FFFF
      00C1EFFF38D9FCFF82F9FFFF71F7FFFF6DF6FFFF68F5FFFF63F4FFFFA5F8FFFF
      FFFFFFFFFFFFFFFFAAF8FFFF00E8FFFF00E7FFFF00E6FFFF00E4FFFF00E3FFFF
      00BAECFF10D0FDBFA1FCFFFF79F9FFFF75F8FFFF70F7FFFF6BF6FFFFCCFCFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF00EAFFFF00E9FFFF00E8FFFF00E7FFFF05E8FFFF
      00B1E8BF00CEFF606FEAFFFF8EFBFFFF7DFAFFFF78F9FFFF73F8FFFFCFFCFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF29F0FFFF00ECFFFF00EBFFFF00EAFFFF0BD3F6FF
      00B0E9600000000010D3FFCFA5F8FFFF89FCFFFF80FBFFFF7BFAFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFF97F9FFFF52F4FFFF28F0FFFF2AEBFDFF08BBEECF
      000000000000000000CFFF202AD9FFEFADF9FFFF99FDFFFF83FCFFFF7EFBFFFF
      79FAFFFF74F9FFFF6FF9FFFF6BF8FFFF6AF7FFFF75F3FEFF21C9F4EF00BAF020
      00000000000000000000000000CFFF2010D3FFCF76EAFFFFC3FEFFFFA9FEFFFF
      93FCFFFF8FFCFFFF94FCFFFFA3FDFFFF64E5FCFF0EC6F6CF00BFF32000000000
      000000000000000000000000000000000000000000CFFF6011D3FFBF41DEFFFF
      67E7FFFF66E7FFFF3FDCFEFF11CEFBBF00C7F960000000000000000000000000
      00000000F00F0000C00300008001000080010000000000000000000000000000
      00000000000000000000000000000000000000008001000080010000C0030000
      F00F0000}
    Visible = False
  end
  object WedName: TWatermarkedEdit
    Left = 272
    Top = 27
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = WedNameChange
    OnEnter = WedNameChange
    OnExit = WedNameExit
    OnKeyDown = WedNameKeyDown
    WatermarkText = 'Name of person'
  end
  object WmComments: TWatermarkedMemo
    Left = 272
    Top = 208
    Width = 274
    Height = 75
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    WatermarkText = 'Comments'
  end
  object BtnOk: TButton
    Left = 471
    Top = 289
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BtnOk'
    Enabled = False
    TabOrder = 9
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 390
    Top = 289
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BtnCancel'
    TabOrder = 4
    OnClick = BtnCancelClick
  end
  object WllGroups: TWebLinkList
    Left = 272
    Top = 141
    Width = 274
    Height = 42
    HorzScrollBar.Visible = False
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 2
    OnDblClick = WllGroupsDblClick
    VerticalIncrement = 5
    HorizontalIncrement = 5
    LineHeight = 0
    PaddingTop = 2
    PaddingLeft = 2
  end
  object DtpBirthDay: TDateTimePicker
    Left = 272
    Top = 95
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Date = 40796.048069189810000000
    Time = 40796.048069189810000000
    TabOrder = 1
  end
  object LsExtracting: TLoadingSign
    Left = 272
    Top = 289
    Width = 25
    Height = 25
    Visible = False
    Active = True
    FillPercent = 60
    Anchors = [akLeft, akBottom]
    SignColor = clBlack
    MaxTransparencity = 255
  end
  object LsAdding: TLoadingSign
    Left = 359
    Top = 289
    Width = 25
    Height = 25
    Visible = False
    Active = True
    FillPercent = 60
    Anchors = [akRight, akBottom]
    SignColor = clBlack
    MaxTransparencity = 255
  end
  object LsNameCheck: TLoadingSign
    Left = 272
    Top = 54
    Width = 16
    Height = 16
    Visible = False
    Active = True
    FillPercent = 50
    SignColor = clBlack
    MaxTransparencity = 255
  end
  object WlPersonNameStatus: TWebLink
    Left = 294
    Top = 54
    Width = 183
    Height = 16
    Cursor = crHandPoint
    Text = 'Found {0} persons with similar name!'
    Visible = False
    OnClick = WlPersonNameStatusClick
    ImageIndex = 0
    IconWidth = 0
    IconHeight = 16
    UseEnterColor = False
    EnterColor = clBlack
    EnterBould = False
    TopIconIncrement = 0
    ImageCanRegenerate = True
    UseSpecIconSize = True
    HightliteImage = False
    StretchImage = True
    CanClick = True
  end
  object PmImageOptions: TPopupMenu
    Left = 104
    Top = 48
    object MiLoadOtherImage: TMenuItem
      Caption = 'Load other image'
      OnClick = MiLoadOtherImageClick
    end
    object MiEditImage: TMenuItem
      Caption = 'Edit image'
      OnClick = MiEditImageClick
    end
  end
  object AeMain: TApplicationEvents
    OnMessage = AeMainMessage
    Left = 104
    Top = 144
  end
  object GroupsImageList: TImageList
    Left = 104
    Top = 96
  end
  object TmrCkeckName: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TmrCkeckNameTimer
    Left = 488
    Top = 48
  end
end
