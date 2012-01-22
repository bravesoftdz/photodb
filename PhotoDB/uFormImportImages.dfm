object FormImportImages: TFormImportImages
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Import pictures'
  ClientHeight = 348
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    415
    348)
  PixelsPerInch = 96
  TextHeight = 13
  object LbImportFrom: TLabel
    Left = 8
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Import pictures from:'
  end
  object LbDirectoryFormat: TLabel
    Left = 8
    Top = 58
    Width = 83
    Height = 13
    Caption = 'Directory format:'
  end
  object LbImportTo: TLabel
    Left = 8
    Top = 196
    Width = 90
    Height = 13
    Caption = 'Import pictures to:'
  end
  object LbLabel: TLabel
    Left = 8
    Top = 104
    Width = 29
    Height = 13
    Caption = 'Label:'
  end
  object LbDate: TLabel
    Left = 8
    Top = 150
    Width = 27
    Height = 13
    Caption = 'Date:'
  end
  object PeImportFromPath: TPathEditor
    Left = 8
    Top = 27
    Width = 374
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    LoadingText = 'Loading...'
    CanBreakLoading = False
    ExplicitWidth = 370
  end
  object CbFormatCombo: TComboBox
    Left = 8
    Top = 77
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = 'YYYY/MM/DD (LABEL)'
    Items.Strings = (
      'YYYY/MM/DD (LABEL)'
      'DD/MM/YYYY')
  end
  object BtnSelectPathFrom: TButton
    Left = 388
    Top = 27
    Width = 19
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 2
    OnClick = BtnSelectPathFromClick
    ExplicitLeft = 384
  end
  object PeImportToPath: TPathEditor
    Left = 8
    Top = 215
    Width = 374
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    LoadingText = 'Loading...'
    CanBreakLoading = False
    ExplicitWidth = 370
  end
  object BtnSelectPathTo: TButton
    Left = 388
    Top = 215
    Width = 19
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 4
    OnClick = BtnSelectPathToClick
    ExplicitLeft = 384
  end
  object WedLabel: TWatermarkedEdit
    Left = 8
    Top = 123
    Width = 399
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    WatermarkText = 'WatermarkedEdit1'
    ExplicitWidth = 395
  end
  object DtpDate: TDateTimePicker
    Left = 8
    Top = 169
    Width = 233
    Height = 21
    Date = 40929.867802500000000000
    Time = 40929.867802500000000000
    TabOrder = 6
  end
  object CbOnlyImages: TCheckBox
    Left = 8
    Top = 246
    Width = 399
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Import only supported images'
    TabOrder = 7
    ExplicitWidth = 395
  end
  object BtnOk: TButton
    Left = 335
    Top = 315
    Width = 74
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Ok'
    TabOrder = 8
    ExplicitLeft = 331
  end
  object BtnCancel: TButton
    Left = 253
    Top = 315
    Width = 76
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = BtnCancelClick
    ExplicitLeft = 249
  end
  object CbDeleteAfterImport: TCheckBox
    Left = 8
    Top = 269
    Width = 399
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Delete files after import'
    TabOrder = 10
    ExplicitWidth = 395
  end
  object WlExtendedMode: TWebLink
    Left = 8
    Top = 324
    Width = 80
    Height = 13
    Cursor = crHandPoint
    Text = 'Extended mode'
    ImageIndex = 0
    IconWidth = 0
    IconHeight = 0
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
  object CbAddToCollection: TCheckBox
    Left = 8
    Top = 292
    Width = 399
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Add files to collection after copying files'
    TabOrder = 12
    ExplicitWidth = 395
  end
end
