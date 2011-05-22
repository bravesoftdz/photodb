object FormCDExport: TFormCDExport
  Left = 297
  Top = 164
  Caption = 'CD Export'
  ClientHeight = 471
  ClientWidth = 716
  Color = clBtnFace
  Constraints.MinHeight = 370
  Constraints.MinWidth = 700
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
  object CDListView: TListView
    Left = 0
    Top = 185
    Width = 716
    Height = 173
    Align = alClient
    Columns = <
      item
        Caption = 'FileName'
        Width = 500
      end
      item
        Caption = 'Size'
        Width = 100
      end
      item
        Caption = 'DB ID'
        Width = 100
      end>
    GridLines = True
    MultiSelect = True
    RowSelect = True
    PopupMenu = PopupMenuListView
    SmallImages = ImageListIcons
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = CDListViewDblClick
    OnEdited = CDListViewEdited
    OnEditing = CDListViewEditing
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 358
    Width = 716
    Height = 113
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      716
      113)
    object LabelExportDirectory: TLabel
      Left = 8
      Top = 8
      Width = 76
      Height = 13
      Caption = 'Export directory:'
    end
    object ButtonExport: TButton
      Left = 598
      Top = 80
      Width = 107
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Export'
      TabOrder = 5
      OnClick = ButtonExportClick
    end
    object CheckBoxDeleteFiles: TCheckBox
      Left = 8
      Top = 56
      Width = 409
      Height = 17
      Caption = 'Delete original files after export'
      TabOrder = 1
    end
    object CheckBoxModifyDB: TCheckBox
      Left = 8
      Top = 72
      Width = 409
      Height = 17
      Caption = 'Modify information on DB'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object EditExportDirectory: TEdit
      Left = 8
      Top = 24
      Width = 546
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
      Text = 'c:\'
    end
    object ButtonChooseDirectory: TButton
      Left = 560
      Top = 24
      Width = 145
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Choose'
      TabOrder = 3
      OnClick = ButtonChooseDirectoryClick
    end
    object CheckBoxCreatePortableDB: TCheckBox
      Left = 8
      Top = 88
      Width = 409
      Height = 17
      Caption = 'Create Portable DB'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object LsMain: TLoadingSign
      Left = 568
      Top = 80
      Width = 24
      Height = 24
      Visible = False
      Active = True
      FillPercent = 50
      Anchors = [akTop, akRight]
      SignColor = clBlack
      MaxTransparencity = 255
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 185
    Align = alTop
    TabOrder = 2
    DesignSize = (
      716
      185)
    object LabelInfo: TLabel
      Left = 64
      Top = 8
      Width = 641
      Height = 82
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Label information'
      WordWrap = True
    end
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 49
      Height = 49
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
        003008060000005702F98700000A074944415478DAED9AFB6F13D915C7CFCC78
        FCCAFB4D1E24CE6E36814D8000A5405BDEEF472021CBC256559BA83FB4527F58
        F8A9525569B57F4005ABAAAA5AA94AFA4B2B556209B0BC032490102040C22E2A
        B084C60101816C12DB49ECD89E47CFB933766CAF4DECC62A5A692F71CE8C6732
        F3FDDC7BEE39E7CEC0C177BC716F5BC0F700C9B8C8F5EBBD3634F5F859871FDA
        AE5555951D0B587DBB1F8D1D6D27DAB6B56B57DBDF2A404FCFED2614F3310916
        04013232D24114454849B1B2E3B44DCDEBF5323B393985DB3E70B99C2049327D
        45409FAD5BF7A3D6FF2B000947F3098AB7656767414E4E168A4E81C85E27AB6D
        865BFA4C4E4EC2F8F8388C8D8D833E2A9F6ED8F0938441120240E136342D78B3
        F5B979D950382F1F0C066388B0F801B46D157C3E3F0C0FBF6230B8DF81079A37
        6E5C634F3A008AAFC71BB458AD964CDBBB2580960950FCDC9C00B4F300DC6E0F
        3C7BF60C3C1E8F8320366D5ADB9634009CA44DD4F3B97959607BA704F4DBB3DF
        8ACC03C8306780C0F6D3A7CFD0ADC668B379F3E675AD730608882F9D5F020505
        B9A008922E7E06037C42D200C88E8C7C03CF9F3F67105BB6AC7F23C41B01503C
        85C6E3A525C550909FAF09E215500D527004D86D691424216900B43932321280
        68D8BA75434C778A09A0C7F6BE9CECECCCF2B252BADFCC4D104231FA99888028
        CE674A2A001D1F1A7A4AEE447362E9B66D1BED09017477DFBA62B558D6572F58
        A0890FDE49EB7745F4832ACA4177E270044032241580ECA3470F6982776CDFBE
        6943DC0028BE094DCBA29A856016CDA0CABACC5031F8514C5E508D3A04FEF03E
        4BF8482501C0E371C383070FE98BE61D3B36B7C605D0D57573302F2FD7565161
        631751FC0AFB68C20337D047C23A8D734266C23959045E32261580ACDD3E44AE
        644780F25901503CEBFD65CB1683C9640C5E5C555490A715662321E4343776BF
        F685C19B32732C4900547EDCBF7F9F8DC2CE9D5B5ADF0870EDDA8DBEFCFCDCDA
        8A8A77426E387371C5AB80EC558217673F828C101E36B9394904C56D0099DC4E
        55827FCB711C666D01789E4F1880ACDD6E87D1D1D1FE5DBBB62E8D0980E26D68
        066B6A16407A7A7A54006A8AA480E44171D2CCA4A6D02AA54F8242E74C609656
        385D8C9EF0146D9BE70536B2C89310C0C4840B27F4D7F445F9EEDDDBEC5101AE
        5EED3984BD7464D5AA1F440C7994F0A860F89F9635B7A2915128B4FA40CE7083
        EAC368E436050102A2029646C36A3505EF1B0F007DDFDFDF8F55AC74B8AE6EFB
        D15800C7D17DEA2B2BDF9D1D403FAEF8559876FAF44885FBE96E502C3E00570A
        F8A6FDEC5C83C1100640A321083C56B0E68400060606A8E86BDBB36747435480
        CECEEB7D656525B5A5A5257103F8FD3278A7319C7AF1527ECD5DC6F957F062E8
        1B0490D8B9B42E28289807A9A9A921202AEE5BD8BC8817E0C58B17949DFB1160
        692C0075F1E2F7D9C2245E008FC787C3EAD7CE4300D7A80B0687998B1EC5F3FE
        AE9F4F8B9EA6E2E212149D160420F16969D6997BE8F98509537579F8C3739A4C
        E78413EE7DF515ECDDBB938B0AD0D1D1AD2E59529D1080CBE5A6698D6EA1ED53
        D2F1F97CAD98FA9B43AF7DF66CFB111C89439565554C238FB72661169A0B38E1
        99464E9B1F9A05ED17FDF0DA3187D3097D5FDE8B0D70E54A97BA6AD5728C12A6
        B8019CCE290884445A3A3E7CF8880E50EDD21F01508BA6AFA6AC0604EC79D0F5
        992CA6A0D848885010B2D378FDEE9B3D505FBF2B36C0CA95CBC16C8E1FC0E198
        9C01C0D5D5C3070F1800D62E610067CE5C6400D5CB4BC1C85B58EDA4FA0D6036
        98834A2341C2A13480AE9EEBD0D0B03B3AC0E5CBD7D4DADA45909919BF0B391C
        38021C8AE144E6180FEEDFC691983E8A69FF70E8B54F9FBED0822ED454595D0E
        A255014C07E8E71C761602283C2BC93959A0521738DA5735BF098571381D70FB
        EEDDD800972E5D55972E5D3C2B00F9BB247320A3EFFA300AC981102A79C131F6
        1A575543746E2B9EFA99FE376C1217161663E84C65D7359854B0A619C0926AD0
        84AA9A520E828A699620141F9831308E95F5ADDEBBB06F5F5D4C80419BADD456
        5E5EFA2D00B22458A604A604623781A820F93181F931FECB5AD874B95CB8507F
        4993995DD76010212F2F9F899F794EA462044AC1498C595994704414CD654201
        22A09E3C1E8281C783FD8D8D7BA287D1F6F6CEE3858505F50B175606850744B3
        0444DF297A4DA40318F0C653130ECC0752104AAB81B4E74154FB701C1F2C2902
        FA29846667A7EB23AB9523042118558C3ABAE80880BE3BF7E1F5AB9136046888
        0570481084236BD6FC9809540242430040FF9E368C062CDED0627AC70C39C1CA
        09ADAC50C34022931245999C9C0C84E3660042DC14A714E0A061B4E283E2E95F
        FB85ABD851FEC31F7CB0377A2971F162870DCDE092DA25980B3299D040AF2A01
        B7A1DEE3651078354C186564A773928D84A22585A85995CA8A8C8C54564ACC56
        CC913A51E441340ACCFF6FDEB84B07CA11C01E1580DA850B57FA0AE6CDABADC2
        A524D5FE8A3AE3EF1CA647917C1562A77B8FC70B53531EDDA5C2855301171EA2
        C3010EDCDBC8F6FFB9E8D2B7AE3D30F0185EBE1CEEDFBFBF3E76394DEDFCF9CB
        4D685A7EB86A35988C26CD6DB0518F0B7CEC9E8D16AD0210817A67B6050D0134
        96EF8563832710A23DA45C9986DEDE5EDA694680D63702503B77EED2208E82AD
        B26A218BC35AAFC75770C5735E600E45021CBCB7097EB1E0E7E0F23AE0F8E049
        F8474D3B3B8FD601C3C3C3F60F3F6C987D49490DD3BE360A2B5740467A6ADCC2
        E23DAFF1CE3A88D57E5AB50F6B2401463D4E383B7401FE6A3B0E77EE30DF6F46
        80D6C8F3633E5641882B58FEAE5FBD7A45D201F6F5AE871525CB20D3980256C1
        08160C39226F004A597E4502AFEC071F7861C8F10ABE7C3500BF1AFF5DC78103
        FBE27FAC420D6B171B9ABEA2A27999D5D50B930A507F631314E40A906BCA806C
        531AA4623D6416448C6E3C2E29FCE0C18CEEF44D82C33F01A3535E78ED90A173
        7B2F97100035AC5FD8A3C5AAAAF7A0AC6C7ED200EABA364379310FE9A21972CC
        A99061B4228409E79A36D9DD98575C7E0F4C62761F9EF0C2E39753706DF78DC4
        01A87DF1C5F9267AAC4ED9B9B4747E520076756C83B5D5799061B0429E259D8D
        42264288E8FB2EEC75876F02DCB20F5EBA2438F7EF27D05D7F3DA6CEB81EAF9F
        3A758E41141717C1A245EFCF19607BFB4ED0DF2A0445A87ACEFD73DD7E18919E
        C2F33101FE72AB1B7A1ABBDEA831EE171C274F9E25776A494B4BCD24085A1A26
        338CBA5C13F051EFCFE0F3FDBF86AFC7C7E0B717FF05B70E74CEAA2FA1574C27
        4E9CB181FE8A8946A3A2A21C33AB256180D0444649EAC993FFB005FB1FD43FC2
        DFEA7E03BF3CF527E87DE210E0F7FD4A520102ADADED34B9D427B8692B2A2A84
        929222C8CACA4A0880DEC2684F195ED0013B7E3E458016DAE9FDA8236E5D737A
        CDFAF9E7A79AD07C8C426B45D100F9F9F960B198751860DB5A2F7B82A2C955C8
        6255499760AF590F1E6C6CFD5F3524E545F7B163276D68E82520A5581B01858E
        44C876D88B6E146E9FEBBDBFFFAF066FBB7DE701FE0B7E600BB89DFF75C20000
        000049454E44AE426082}
    end
    object LabelCDLabel: TLabel
      Left = 8
      Top = 96
      Width = 99
      Height = 13
      Caption = 'Create CD with label:'
    end
    object LabelPath: TLabel
      Left = 8
      Top = 140
      Width = 25
      Height = 13
      Caption = 'Path:'
    end
    object LabelExportSize: TLabel
      Left = 208
      Top = 96
      Width = 54
      Height = 13
      Caption = 'Export size:'
    end
    object ComboBoxPathList: TComboBoxExDB
      Left = 8
      Top = 155
      Width = 332
      Height = 22
      ItemsEx = <
        item
          Caption = '\'
        end>
      Style = csExDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnSelect = ComboBoxPathListSelect
      ShowDropDownMenu = True
      LastItemIndex = 0
      ShowEditIndex = 0
      HideItemIcons = False
      CanClickIcon = False
    end
    object ButtonAddItems: TButton
      Left = 346
      Top = 154
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Add items'
      TabOrder = 3
      OnClick = ButtonAddItemsClick
    end
    object ButtonRemoveItems: TButton
      Left = 441
      Top = 154
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Remove items'
      TabOrder = 4
      OnClick = ButtonRemoveItemsClick
    end
    object ButtonCreateDirectory: TButton
      Left = 568
      Top = 154
      Width = 137
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Create directory'
      TabOrder = 5
      OnClick = ButtonCreateDirectoryClick
    end
    object EditLabel: TWatermarkedEdit
      Left = 8
      Top = 112
      Width = 177
      Height = 21
      Color = 11206655
      TabOrder = 0
      WatermarkText = 'CDLabel'
    end
    object EditCDSize: TEdit
      Left = 208
      Top = 112
      Width = 217
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '0 Mb'
    end
  end
  object PopupMenuListView: TPopupMenu
    OnPopup = PopupMenuListViewPopup
    Left = 120
    Top = 216
    object Open1: TMenuItem
      Caption = 'Open'
      OnClick = Open1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object Cut1: TMenuItem
      Caption = 'Cut'
      OnClick = Cut1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      OnClick = Paste1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Rename1: TMenuItem
      Caption = 'Rename'
      OnClick = Rename1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = ButtonRemoveItemsClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object AddItems1: TMenuItem
      Caption = 'Add Items'
      OnClick = ButtonAddItemsClick
    end
  end
  object ImageListIcons: TImageList
    ColorDepth = cd32Bit
    Left = 24
    Top = 216
  end
  object DestroyTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = DestroyTimerTimer
    Left = 656
    Top = 8
  end
  object DropFileTarget1: TDropFileTarget
    DragTypes = [dtCopy]
    OnDrop = DropFileTarget1Drop
    ShowImage = False
    OptimizedMove = True
    Left = 216
    Top = 216
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 568
    Top = 8
  end
end
