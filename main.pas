unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, ActiveX, DateUtils,
  IdTCPConnection, IdTCPClient, IdHTTP, OleCtrls, SHDocVw, ExtCtrls,
  PerlRegEx, Grids, DBGrids, DB, ADODB, Buttons;

const
  TYFILE = 'ABC.INI';
  pages_of_awebfile = 20;

type
  TYPage = packed record
    pagetitle: string;
    keyword: string;
    pageAUTHOR: string;
    pageurl: string;
    curmxid: longint;
    nextmxid: LongInt;
    nexturl: string;
    thisurl: string;
    pagemainid: LongInt;
    pagecount: LongInt;

    maxclick: LongInt;
    maxreply: LongInt;

  end;

  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TBitBtn;
    btnend: TBitBtn;
    btnfirst: TBitBtn;
    btnnext: TBitBtn;
    btnprior: TBitBtn;
    Btnseepage: TButton;
    btntoday: TButton;
    con1: TADOConnection;
    dbgrd1: TDBGrid;
    ds1: TDataSource;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    HTTP1: TIdHTTP;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    PerlRegEx1: TPerlRegEx;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    qrylist: TADOQuery;
    qrytmp: TADOQuery;
    spl1: TSplitter;
    tbl1: TADOTable;
    tbl1CURURL: TWideStringField;
    tbl1DSDesigner: TDateTimeField;
    tbl1DSDesigner2: TWideStringField;
    tbl1DSDesigner3: TWideStringField;
    tbl1ID: TAutoIncField;
    tbl1lasturl: TWideStringField;
    tbl1MAINURL: TWideStringField;
    wb1: TWebBrowser;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnendClick(Sender: TObject);
    procedure btnfirstClick(Sender: TObject);
    procedure btnnextClick(Sender: TObject);
    procedure btnpriorClick(Sender: TObject);
    procedure BtnseepageClick(Sender: TObject);
    procedure btntodayClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    istoday: Boolean;
    procedure post_info_fromURL(url: string);
    function app_path(): string;
    function bodytext_fromhtm(url: string): string;
    function change_imgURL: string;
    procedure do_allpost;
    function Do_OnePage(url: string): string;
    function getid_datetime(content: string): TDate;
    function getOneAuthorContent(bodystr: string): string;
    function NpageURL(aurl: string; npage: LongInt): string;
    function pageIndex(aurl: string): integer;
    function page_authorname(bodystr: string): string;
    function page_lefturl(aurl: string): string;
    function page_nextpageURL(bodystr: string): string;
    function Page_title(bodystr: string): string;
    function Post_id_string(STR: string): string;
    function Post_Id(aurl: string): integer;
    function rat(const SubStr: string; const S: string): Integer;
    function Reverse(S: string): string;
    procedure save_nexturl(LASTURL: string; lastpagenum: LongInt);
    procedure seeonepage(apage: Integer);
    procedure Do_OnPost_From_aURL(firsturl: string; areyou_SAVE: Boolean); //从某一页面开始
    procedure Do_OnPost_From_Lasttime(firsturl: string); //从上次生成的页开始
    procedure Do_OnPost_From_endpage(firsturl: string); //从最尾页的最后开始
    function todayurl(url: string): string;
    function urlPATH(url: string): string;
    procedure web_begintitle;
    procedure web_endline;
  end;

type
  twordthread = class(TThread)
  protected
    procedure execute; override;
    function fromnet: Boolean;
  end;

var
  Form1: TForm1;
  atypage: typage;

  authorname: string;
  bodytext: string;
  mainpath: string;
  thistxtpage: integer;
  _pageid: longint;

implementation

{$R *.dfm}

function TForm1.app_path: string;
begin
  result := extractfilepath(Application.ExeName);
end;

function TForm1.bodytext_fromhtm(url: string): string;
var
  i: integer;
begin
  result := '';
  try
    bodytext := '';
    try
      bodytext := UTF8Decode(Http1.Get(trim(url)));
    except
    end;
    i := 1;
    while bodytext = '' do
    begin
      try
        bodytext := UTF8Decode(Http1.Get(trim(url)));
      except
      end;
      inc(i);
      if i > 5 then
      begin
        Label5.Caption := ('实在打不开,退出！' + trim(url));
        save_nexturl(trim(url), pageIndex(url));
        exit;
      end;
    end;
  except
    exit;
  end;
  Result := bodytext; // TODO:
end;

procedure TForm1.btn1Click(Sender: TObject);
begin

  wb1.Navigate(mainpath + 'today.html');

end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  wb1.Navigate('http://bbs.tianya.cn/list.jsp?item=stocks&sub=1');
end;

procedure TForm1.btnendClick(Sender: TObject);
var
  i: Integer;
begin

  for i := 1 to 1000 do
  begin

    if not FileExists(mainpath + inttostr(i) + '.htm') then
      Break;
  end;
  thistxtpage := i - 1;

  seeonepage(thistxtpage);

end;

procedure TForm1.btnfirstClick(Sender: TObject);
begin
  thistxtpage := 1;
  seeonepage(thistxtpage);
end;

procedure TForm1.btnnextClick(Sender: TObject);
begin
  thistxtpage := thistxtpage + 1;
  seeonepage(thistxtpage);
end;

procedure TForm1.btnpriorClick(Sender: TObject);
begin
  if thistxtpage > 1 then
  begin
    thistxtpage := thistxtpage - 1;
    seeonepage(thistxtpage);
  end
end;

procedure TForm1.BtnseepageClick(Sender: TObject);
var
  wordthread: twordthread;
begin
  wordthread := twordthread.Create(FALSE);
end;

procedure TForm1.btntodayClick(Sender: TObject);
var
  wordthread: twordthread;
begin
  istoday := true;
  wordthread := twordthread.Create(FALSE);

  //  istoday := false;
    //  Do_OnPost_From_aURL(Edit3.Text);
end;

function TForm1.change_imgURL: string;
var
  reg: TPerlRegEx; //声明正则表达式变量
begin
  reg := TPerlRegEx.Create(nil); //建立
  reg.Subject := Memo1.Text; //这是要替换的源字符串
  reg.RegEx := 'img src=(.*)original=\"'; //这是表达式, 在这里是准备替换掉的子串
  reg.Replacement := 'img src="'; //要替换成的新串
  reg.ReplaceAll; //执行全部替换

  Memo1.Lines.Clear;
  Memo1.Lines.add(reg.Subject);

  FreeAndNil(reg); //或 reg.Free
end;

procedure TForm1.dbgrd1DblClick(Sender: TObject);
begin
  case Application.MessageBox('是否继续看', '继续', MB_YESNO +
    MB_ICONQUESTION) of
    IDYES:
      begin
        Edit3.Text := tbl1.fieldbyname('mainurl').AsString;
        Edit2.Text := tbl1.fieldbyname('主贴作者').AsString;
        Edit1.Text := tbl1.fieldbyname('主贴标题').AsString;
        //   Do_OnPost_From_aURL(Edit3.Text);
        thistxtpage := 1;
        mainpath := extractfilepath(Application.ExeName) +
          Post_id_string(tbl1.fieldbyname('mainurl').AsString) + '\';
        seeonepage(thistxtpage);
      end;
    IDNO:
      begin

      end;
  end;

end;

procedure TForm1.do_allpost;
var
  atitle: string;
  aurl: string;
begin
  istoday := True;
  qrylist.Close;
  qrylist.SQL.Clear;
  qrylist.SQL.Add('select * from tyurl where mainurl like "%stocks%"');
  qrylist.Open;

  Memo2.Lines.Clear;

  qrylist.First;
  while not qrylist.Eof do
  begin
    aurl := qrylist.fieldbyname('mainurl').AsString;
    atitle := qrylist.fieldbyname('主贴标题').asstring;

    aurl := todayurl(aurl);
    Memo2.Lines.Add('<BR></BR>');
    Memo2.Lines.Add('<BR><B>' + atitle + '</B></BR>');
    Memo2.Lines.Add('点击数:' + FormatFloat('#,###',atypage.maxclick) + '    访问数:' +
      FormatFloat('#,###',atypage.maxreply));
    Label5.Caption := atitle;

    _pageid := qrylist.fieldbyname('ID').asinteger;
    if Pos('股市', atitle) > 0 then
    begin
      Do_OnPost_From_endpage(aurl);
      Memo2.Lines.SaveToFile(mainpath + 'today.html');
      wb1.Navigate(mainpath + 'today.html');

    end;
    qrylist.Next;
  end;
  istoday := false;
  Memo2.Lines.SaveToFile(mainpath + 'today.html');
  wb1.Navigate(mainpath + 'today.html');

  Label5.Caption := '今日信息下载完成于:' + FormatDateTime('yyyy-mm-dd hh-mm-ss', now);

end;

function TForm1.Do_OnePage(url: string): string;
var
  i: integer;
  content: string;
  strtitle: string;
begin
  result := '';

  bodytext := bodytext_fromhtm(url);
  strtitle := Page_title(bodytext);
  atypage.pagetitle := strtitle;

  result := page_nextpageURL(bodytext);

  authorname := page_authorname(bodytext);
  atypage.pageAUTHOR := authorname;
  atypage.pageurl := url;

  if _pageid = 0 then
  begin
    Edit1.Text := strtitle;
    Edit3.Text := url;
    Edit2.Text := authorname;

    qrytmp.close;
    qrytmp.sql.Clear;
    qrytmp.SQL.Add('select *  from tyurl  where mainurl like ' + Quotedstr('%-' +
      trim(IntToStr(Post_Id(url))) + '%'));

    qrytmp.open;

    if qrytmp.RecordCount < 1 then
    begin
      tbl1.append;
      tbl1.edit;
      tbl1.fieldbyname('主贴标题').asstring := Edit1.Text;
      tbl1.fieldbyname('主贴作者').asstring := Trim(Edit2.Text);
      tbl1.fieldbyname('lasturl').asstring := result;
      tbl1.fieldbyname('mainurl').asstring := result;
      tbl1.post;
      _pageid := tbl1.fieldbyname('id').asinteger;
    end;
  end;
  memo1.lines.add('<br>' + url + '</br>');
  memo1.lines.add('<br>' + '===============' + '</br>');

  content := '正文';
  i := 1;

  while Trim(content) <> '' do
  begin
    content := getOneAuthorContent(bodytext);
    if Trim(content) <> '' then
      if getid_datetime(content) > today - 2 then
      begin
        Memo2.Lines.Add(content);
      end;

    memo1.lines.add('</br>');
    memo1.lines.add(content);
    i := i + 1;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  label5.Caption := '';
  memo1.Lines.Clear;

  if tbl1.Active = false then
    tbl1.Open;
  tbl1.Sort := 'id ';

  edit1.clear;
  edit2.clear;
  edit3.clear;
end;

function TForm1.getid_datetime(content: string): TDate;
var
  npos: integer;
  datastr: string;
begin
  //js_resTime="2015-11-22 14:53:37">

  result := EncodeDate(2000, 1, 1);
  npos := Pos('js_resTime="', content);

  datastr := Copy(content, npos + 12, 10);
  datastr := StringReplace(datastr, '-', '/', [rfReplaceAll]);
  try
    result := strtodate(datastr);
  except
  end;

end;

//<div class="atl-item" _host="

function TForm1.getOneAuthorContent(bodystr: string): string;
var
  firststr, endstr: string;
  t2: string;
  firstpos, endpos: integer;
  m2: integer;
  strtmp: string;
begin
  result := '';
  firststr := '<div class="atl-item" _host="' + authorname + '"';

  endstr := '<div class="atl-reply">'; //'<div class="atl-item" _host="'
  firstpos := pos(firststr, bodystr);
  if firstpos > 0 then
  begin
    strtmp := Copy(bodystr, firstpos + 1, length(bodystr));
    bodytext := Copy(bodytext, firstpos + 50, Length(bodytext));

    endpos := pos(endstr, strtmp);
    if endpos > 0 then
      result := '<' + copy(strtmp, 1, endpos - 2 - length(endstr));
  end
  else
    bodytext := '';

end;

function TForm1.NpageURL(aurl: string; npage: LongInt): string;
var
  str: string;
  npos: integer;
  lefttitle, righttitle: string;
begin
  //http://bbs.tianya.cn/post-stocks-1408771-2.shtml
  npos := rat('-', aurl);
  lefttitle := Copy(aurl, 1, npos);
  npos := rat('.', aurl);
  righttitle := Copy(aurl, npos, Length(aurl));
  result := lefttitle + Trim(inttostr(npage)) + righttitle;
  //ShowMessage(result);
end;

function TForm1.pageIndex(aurl: string): integer;
var
  str: string;
  npos: integer;
  lefttitle, righttitle: string;
begin
  //http://bbs.tianya.cn/post-stocks-1408771-2.shtml
  result := 0;
  try
    npos := rat('-', aurl);
    lefttitle := Copy(aurl, npos + 1, Length(aurl));

    npos := pos('.', lefttitle);
    lefttitle := Copy(lefttitle, 1, npos - 1);

    result := StrToInt(lefttitle);
  except
  end;
end;

function TForm1.page_authorname(bodystr: string): string;
var
  t1: string;
  t2: string;
  pageall: string;
  firstpos, endpos: integer;
  m2: integer;
  strtmp: string;
begin
  t1 := '<div class="atl-info">';

  firstpos := pos(t1, bodystr);
  //  strtmp := Copy(bodytext, firstpos, Length(bodytext));
  strtmp := Copy(bodytext, firstpos, 200);

  t1 := 'uname="';
  firstpos := pos(t1, strtmp);
  strtmp := Copy(strtmp, firstpos + 7, 50);

  t1 := '"';
  firstpos := pos(t1, strtmp);
  strtmp := Copy(strtmp, 1, firstpos - 1);

  result := strtmp;

end;

function TForm1.page_lefturl(aurl: string): string;
var
  str: string;
  npos: integer;
  lefttitle, righttitle: string;
begin
  //http://bbs.tianya.cn/post-stocks-1408771-2.shtml
  npos := rat('-', aurl);
  lefttitle := Copy(aurl, 1, npos - 1);
  lefttitle := Trim(Copy(lefttitle, 8, Length(lefttitle)));
  result := lefttitle;

end;

function TForm1.page_nextpageURL(bodystr: string): string;
var
  firststr, endstr: string;
  t2: string;
  firstpos, endpos: integer;
  m2: integer;
  strtmp: string;
begin

  //      js_replycount="156475"
//          js_clickcount="723217"
//            pageCount : 1515,

  firststr := 'js_replycount="';
  endpos := pos(firststr, bodystr);
  if endpos > 0 then
  begin
    strtmp := Copy(bodystr, endpos + 15, 30);
    endpos := pos('"', strtmp);
    try
      atypage.maxreply := StrToInt(Copy(strtmp, 1, endpos - 1));
    except
    end;

  end;

  firststr := 'js_clickcount="';
  endpos := pos(firststr, bodystr);
  if endpos > 0 then
  begin
    strtmp := Copy(bodystr, endpos + 15, 30);
    endpos := pos('"', strtmp);
    try
      atypage.maxclick := StrToInt(Copy(strtmp, 1, endpos - 1));
    except
    end;

  end;

  firststr := 'pageCount : ';
  endpos := pos(firststr, bodystr);
  if endpos > 0 then
  begin
    strtmp := Copy(bodystr, endpos + 12, 30);
    endpos := pos(',', strtmp);
    try
      atypage.pagecount := StrToInt(Copy(strtmp, 1, endpos - 1));
    except
    end;

  end;

  result := '';
  firststr := '<a href=';
  endstr := 'class="js-keyboard-next">下页</a>';
  endpos := pos(endstr, bodystr);
  if endpos > 0 then
  begin
    strtmp := Copy(bodystr, endpos - 100, 99);
    firstpos := rat(firststr, strtmp);
    strtmp := Copy(strtmp, firstpos + 9, Length(strtmp));
    strtmp := StringReplace(strtmp, ' ', '', [rfReplaceAll]);
    strtmp := StringReplace(strtmp, '"', '', [rfReplaceAll]);
    strtmp := StringReplace(strtmp, 'href=', '', [rfReplaceAll]);
    atypage.nexturl := 'http://bbs.tianya.cn' + strtmp;
    result := 'http://bbs.tianya.cn' + strtmp;
  end
end;

function TForm1.Page_title(bodystr: string): string;
var
  reg: TPerlRegEx; //声明正则表达式变量
  A1, A2: Integer;
  STR1, STR2: string;
begin
  result := '';
  STR1 := '<title>';
  STR2 := '</title>';
  a1 := Pos(STR1, bodystr);
  str1 := Copy(bodystr, A1 + 7, 200);

  a2 := Pos(STR2, str1);
  result := Copy(str1, 1, a2 - 1);
end;

//http://bbs.tianya.cn/post-stocks-1637790-1.shtml

function TForm1.Post_id_string(STR: string): string;
var
  A1, A2: INTEGER;
  STRTMP: string;
begin
  RESULT := '';
  A1 := RAT('-', STR);
  STRTMP := COPY(STR, 1, A1 - 1);
  A1 := RAT('-', STRtmp);
  result := copy(strtmp, a1 + 1, length(strtmp));
end;

function TForm1.Post_Id(aurl: string): integer;
var
  str: string;
  npos: integer;
  lefttitle, righttitle: string;
begin
  result := 0;
  try
    npos := rat('-', aurl);
    lefttitle := Copy(aurl, 1, NPOS - 1);

    npos := rat('-', lefttitle);
    righttitle := Trim(Copy(lefttitle, npos + 1, Length(lefttitle)));

    result := StrToInt(righttitle);
  except
  end;
end;

function TForm1.rat(const SubStr, S: string): Integer;
begin
  result := Pos(Reverse(SubStr), Reverse(S));
  if (result <> 0) then
    result := ((Length(S) - Length(SubStr)) + 1) - result + 1;
end;

function TForm1.Reverse(S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := Length(S) downto 1 do
  begin
    Result := Result + Copy(S, i, 1);
  end;
end;

procedure TForm1.save_nexturl(LASTURL: string; lastpagenum: LongInt);
begin

  qrytmp.close;
  qrytmp.sql.Clear;
  qrytmp.SQL.Add('update tyurl set lasturl=:lastuRl, lastpagenum=:lastpagenum where id=:id');
  qrytmp.Parameters.ParamByName('id').Value := _pageid;
  qrytmp.Parameters.ParamByName('LASTURL').Value := LASTURL;
  qrytmp.Parameters.ParamByName('lastpagenum').Value := lastpagenum;
  qrytmp.ExecSQL;

end;

procedure TForm1.seeonepage(apage: Integer);
var
  atxtfile: string;
begin
  //
  atxtfile := mainpath + inttostr(apage) + '.htm';
  if FileExists(atxtfile) then
    wb1.Navigate(atxtfile)
  else
  begin
    Label5.Caption := ('文件不存在，请返回');
  end;
end;

procedure TForm1.Do_OnPost_From_aURL(firsturl: string; areyou_SAVE: Boolean);
var
  i: integer;
begin
  memo1.Clear;
  mainpath := extractfilepath(Application.ExeName) + Post_id_string(firsturl) + '\';
  if not DirectoryExists(mainpath) then
    MkDir(mainpath);

  atypage.nexturl := Do_OnePage(firsturl);

  Label5.Caption := '正在处理第' + inttostr(pageIndex(firsturl)) + '/' + inttostr(atypage.pagecount)
    + '页';

  i := 1;
  while atypage.nexturl <> '' do
  begin
    aTyPage.curmxid := pageIndex(atypage.nexturl);
    atypage.nexturl := Do_OnePage(atypage.nexturl);
    save_nexturl(atypage.nexturl, aTyPage.curmxid);
    Inc(i);
    Label5.Caption := '正在处理第' + inttostr(aTyPage.curmxid) + '页' + '/' +
      inttostr(atypage.pagecount)
      + '页';

    if (aTyPage.curmxid mod pages_of_awebfile = 0) then
    begin
      web_endline;
      memo1.Lines.SaveToFile(mainpath + inttostr(aTyPage.curmxid div pages_of_awebfile) + '.htm');
      Memo1.Lines.Clear;
      web_begintitle;
    end;

    if areyou_SAVE then
      if i = 5 then
      begin
        web_endline;
        memo1.Lines.SaveToFile(mainpath + '001.htm');
        wb1.Navigate(mainpath + '001.htm');
      end;
  end;

  web_endline;

  memo1.Lines.SaveToFile(mainpath + inttostr((aTyPage.curmxid div pages_of_awebfile) + 1) + '.htm');
  Memo1.Lines.Clear;

  thistxtpage := 1;
  if areyou_SAVE then
  begin
    seeonepage(thistxtpage);
    Label5.Caption := '下载完成';
  end;

end;

procedure TForm1.Do_OnPost_From_Lasttime(firsturl: string);
var
  i: Integer;
  xurl: string;
begin
  if Trim(firsturl) = '' then
    Exit;

  for i := 1 to 1000 do
  begin
    if not FileExists(urlPATH(firsturl) + inttostr(i) + '.htm') then
      Break;
  end;
  thistxtpage := i;

  i := (i - 2) * pages_of_awebfile + 1;

  xurl := NpageURL(firsturl, i);
  Do_OnPost_From_aURL(xurl, FALSE);

end;

procedure TForm1.Do_OnPost_From_endpage(firsturl: string);
var
  i: Integer;
  xurl: string;
begin
  if Trim(firsturl) = '' then
    Exit;

  Do_OnPost_From_aURL(firsturl, FALSE);

end;

function TForm1.todayurl(url: string): string;
begin
  //
  RESULT := '';
  try
    post_info_fromURL(url);
    RESULT := NpageURL(url, atypage.pagecount - 2);
  except
  end;
end;

function TForm1.urlPATH(url: string): string;
begin
  //
  result := extractfilepath(Application.ExeName) + Post_id_string(url) + '\';
end;

procedure TForm1.web_begintitle;
begin
  memo1.lines.add(' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">    ');
  memo1.lines.add('<html xmlns="http://www.w3.org/1999/xhtml">   ');
  memo1.lines.add('<head>            ');
  memo1.lines.add('<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />   ');
  memo1.lines.add('<title> xx</title>    ');
  memo1.lines.add('  <style type="text/css"> ');
  memo1.lines.add('<!--   ');
  memo1.lines.add('.mywidth {  ');
  memo1.lines.add('	width: 800px;  ');
  memo1.lines.add('}    ');
  memo1.lines.add('-->   ');
  memo1.lines.add('</style>  ');
  memo1.lines.add('</head>  ');

  memo1.lines.add('<body  class="mywidth"> ');
end;

procedure TForm1.web_endline;
begin
  memo1.lines.add('</body> ');
end;

{ twordthread }

procedure twordthread.execute;
begin
  inherited;
  //
  FreeOnTerminate := True;
  if Form1.istoday then
    Form1.do_allpost
  else
    fromnet;
end;

function twordthread.fromnet: Boolean;
begin
  CoInitialize(nil);

  form1.Do_OnPost_From_aURL(form1.edit3.text, TRUE);
  CoUninitialize;

end;

procedure TForm1.post_info_fromURL(url: string);
begin
  bodytext := bodytext_fromhtm(url);

  atypage.thisurl := url;
  atypage.pagetitle := Page_title(bodytext);
  atypage.pageurl := url;
  atypage.pageAUTHOR := page_authorname(bodytext);
  atypage.pagemainid := Post_Id(url);
  atypage.nexturl := page_nextpageURL(bodytext);
  atypage.curmxid := pageIndex(url); //   atypage的其他属性均在    page_nextpageURL

  Edit1.Text := atypage.pagetitle;
  Edit2.Text := atypage.pageAUTHOR;
  Edit3.Text := url;
end;

end.

