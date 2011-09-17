object FormFindPerson: TFormFindPerson
  Left = 0
  Top = 0
  Caption = 'FormFindPerson'
  ClientHeight = 379
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    530
    379)
  PixelsPerInch = 96
  TextHeight = 13
  object LbFindPerson: TLabel
    Left = 8
    Top = 5
    Width = 60
    Height = 13
    Caption = 'Find person:'
  end
  object ImSearch: TImage
    Left = 8
    Top = 26
    Width = 16
    Height = 16
    Picture.Data = {
      055449636F6E0000010001001010000001002000680400001600000028000000
      1000000020000000010020000000000040040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000032A19F0070C5FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000032A19F006CC5FF3CC9FDFF0962BAF3
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000032A19F0068C5FF2DBEFDFF0962BAF30032A160
      00000000000000000000000000000000545454205454549F545454BF868484FF
      545454BF5454548000359A9F0063C5FF1DB3FDFF0962BAF30032A16000000000
      00000000000000000000000054545460868484FFB6B5B5FFEBE7E7FFE5E1E1FF
      D6D2D2FFF7F4F4FF868484FF1998DCFF0962BAF30032A1600000000000000000
      000000000000000054545430868484FFECEBEBFFDABC95FFB87116FFC28632FF
      B87623FFCDB193FFF7F4F4FF868484FF00369770000000000000000000000000
      0000000000000000545454AFF7F4F4FFDEBF9AFFB86800FFFDE8A3FFFFF8B9FF
      F8DE95FFB86800FFC8AC8DFFF7F4F4FF54545480000000000000000000000000
      0000000000000000868484FFFDFCFCFFBC7212FFFFFFDEFFFFECA6FFFFF1ADFF
      FFEDA6FFF8D07BFFB5721EFFF7F4F4FF868484FF000000000000000000000000
      0000000000000000868484FFFDFCFCFFBE6B00FFFFFFDEFFFFEAAFFFFFECB3FF
      FFEAB0FFFFDF92FFB26A0FFFF7F4F4FF868484FF000000000000000000000000
      0000000000000000868484FFFDFCFCFFB76A07FFFFFFDEFFFFEDC2FFFFEDC4FF
      FFEDC2FFF8D293FFB5721EFFF7F4F4FF868484FF000000000000000000000000
      0000000000000000868484FFF7F4F4FFDEBF9AFFC5832DFFFFFFDEFFFFFFDEFF
      FFFFDEFFC5832DFFCAB59EFFF7F4F4FF5454549F000000000000000000000000
      000000000000000054545450888888FFF7F4F4FFDABC95FFC28638FFCC9959FF
      BE8134FFCDB193FFF7F4F4FF868484FF54545420000000000000000000000000
      0000000000000000000000005454549F878686FFF7F4F4FFF7F4F4FFF7F4F4FF
      F7F4F4FFF7F4F4FF868484FF5454546000000000000000000000000000000000
      0000000000000000000000000000000054545450868484FF868484FF868484FF
      868484FF868484FF545454400000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFF0000FFF30000FFE10000FFC10000E0030000C0070000800F0000
      800F0000800F0000800F0000800F0000800F0000800F0000C01F0000E03F0000
      FFFF0000}
  end
  object WedPersonFilter: TWatermarkedEdit
    Left = 30
    Top = 24
    Width = 492
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = WedPersonFilterChange
    WatermarkText = 'Find person'
  end
  object BtnOk: TButton
    Left = 447
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BtnOk'
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    Left = 366
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BtnCancel'
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object LvPersons: TListView
    Left = 8
    Top = 51
    Width = 514
    Height = 291
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Image'
        MaxWidth = 110
        MinWidth = 110
        Width = 110
      end
      item
        Caption = 'Name'
        Width = 350
      end>
    DoubleBuffered = True
    FullDrag = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    SmallImages = ImlPersons
    TabOrder = 3
    ViewStyle = vsReport
    OnDblClick = LvPersonsDblClick
  end
  object LsAdding: TLoadingSign
    Left = 336
    Top = 348
    Width = 24
    Height = 24
    Visible = False
    Active = True
    FillPercent = 50
    SignColor = clBlack
    MaxTransparencity = 255
  end
  object TmrSearch: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TmrSearchTimer
    Left = 24
    Top = 328
  end
  object ImlPersons: TImageList
    ColorDepth = cd32Bit
    Height = 100
    Width = 100
    Left = 80
    Top = 328
  end
end
