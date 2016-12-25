object Form1: TForm1
  Left = 59
  Top = 105
  Width = 1153
  Height = 609
  Caption = #22825#28079#35770#22363#24555#35835'  '#21525#21521#38451' lxy7105@126.com'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 401
    Top = 0
    Width = 12
    Height = 571
    Color = clActiveCaption
    ParentColor = False
  end
  object pnl3: TPanel
    Left = 0
    Top = 0
    Width = 401
    Height = 571
    Align = alLeft
    Caption = 'pnl3'
    TabOrder = 0
    object dbgrd1: TDBGrid
      Left = 1
      Top = 1
      Width = 399
      Height = 569
      Align = alClient
      DataSource = ds1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dbgrd1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'ID'
          Visible = False
        end
        item
          Expanded = False
          FieldName = #26368#21518#26085#26399
          Visible = False
        end
        item
          Expanded = False
          FieldName = #20027#36148#26631#39064
          Visible = True
        end>
    end
  end
  object pnl4: TPanel
    Left = 413
    Top = 0
    Width = 724
    Height = 571
    Align = alClient
    Caption = 'pnl4'
    TabOrder = 1
    object pnl1: TPanel
      Left = 1
      Top = 1
      Width = 722
      Height = 144
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 48
        Width = 57
        Height = 16
        AutoSize = False
        Caption = #29256#20027':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 80
        Width = 65
        Height = 16
        AutoSize = False
        Caption = #32593#22336':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 16
        Width = 73
        Height = 16
        AutoSize = False
        Caption = #36148#23376#26631#31614
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 112
        Width = 393
        Height = 24
        AutoSize = False
        Caption = 'Label5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Btnseepage: TButton
        Left = 592
        Top = 48
        Width = 113
        Height = 49
        Caption = #30475#36148
        TabOrder = 0
        OnClick = BtnseepageClick
      end
      object Edit1: TEdit
        Left = 80
        Top = 16
        Width = 345
        Height = 21
        TabOrder = 1
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 80
        Top = 48
        Width = 505
        Height = 21
        TabOrder = 2
        Text = 'Edit2'
      end
      object Edit3: TEdit
        Left = 80
        Top = 80
        Width = 505
        Height = 21
        TabOrder = 3
        Text = 'Edit3'
      end
      object btn1: TButton
        Left = 512
        Top = 16
        Width = 113
        Height = 25
        Caption = #30452#25509#25171#24320
        TabOrder = 4
        OnClick = btn1Click
      end
      object Memo1: TMemo
        Left = 736
        Top = 24
        Width = 113
        Height = 105
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Memo1')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object btnprior: TBitBtn
        Left = 584
        Top = 112
        Width = 35
        Height = 25
        Caption = '<<<'
        TabOrder = 6
        OnClick = btnpriorClick
      end
      object btnnext: TBitBtn
        Left = 632
        Top = 112
        Width = 33
        Height = 25
        Caption = '>>>'
        TabOrder = 7
        OnClick = btnnextClick
      end
      object btnfirst: TBitBtn
        Left = 528
        Top = 111
        Width = 51
        Height = 25
        Caption = #39318
        TabOrder = 8
        OnClick = btnfirstClick
      end
      object btnend: TBitBtn
        Left = 672
        Top = 111
        Width = 33
        Height = 25
        Caption = #23614
        TabOrder = 9
        OnClick = btnendClick
      end
      object btntoday: TButton
        Left = 432
        Top = 16
        Width = 75
        Height = 25
        Caption = #20170#22825#21160#24577
        TabOrder = 10
        OnClick = btntodayClick
      end
      object Memo2: TMemo
        Left = 784
        Top = 64
        Width = 73
        Height = 73
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Mem'
          'o1')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 11
      end
      object btn2: TBitBtn
        Left = 630
        Top = 15
        Width = 75
        Height = 25
        Caption = #22825#28079#32929#24066
        TabOrder = 12
        OnClick = btn2Click
      end
    end
    object pnl2: TPanel
      Left = 1
      Top = 145
      Width = 722
      Height = 425
      Align = alClient
      Caption = 'pnl2'
      TabOrder = 1
      object wb1: TWebBrowser
        Left = 1
        Top = 1
        Width = 720
        Height = 423
        Align = alClient
        TabOrder = 0
        ControlData = {
          4C0000006A4A0000B82B00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object HTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 744
    Top = 328
  end
  object PerlRegEx1: TPerlRegEx
    Options = []
    Left = 984
    Top = 520
  end
  object tbl1: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 'tyurl'
    Left = 338
    Top = 337
    object tbl1ID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object tbl1MAINURL: TWideStringField
      FieldName = 'MAINURL'
      Size = 255
    end
    object tbl1CURURL: TWideStringField
      FieldName = 'CURURL'
      Size = 255
    end
    object tbl1lasturl: TWideStringField
      FieldName = 'lasturl'
      Size = 255
    end
    object tbl1DSDesigner: TDateTimeField
      FieldName = #26368#21518#26085#26399
    end
    object tbl1DSDesigner2: TWideStringField
      FieldName = #20027#36148#26631#39064
      Size = 255
    end
    object tbl1DSDesigner3: TWideStringField
      FieldName = #20027#36148#20316#32773
      Size = 255
    end
  end
  object con1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\2014prg\'#22825#28079#30475#36148'\ty.' +
      'mdb;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 586
    Top = 353
  end
  object ds1: TDataSource
    DataSet = tbl1
    Left = 506
    Top = 345
  end
  object qrytmp: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 418
    Top = 329
  end
  object qrylist: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 518
    Top = 185
  end
end
