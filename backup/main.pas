unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Psock, NMHttp;

const TYFILE = 'ABC.INI';
type
  typage = packed record
    title: string[40];
    keyword: string[40];
    url: string[255];
  end;

  TForm1 = class(TForm)
    http1: TNMHTTP;
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label5: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure getfromfile();
    procedure savetofile();
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    function trimaabb(straa: string): string;
    procedure calclist(strbb: string);
    procedure clearbtn();
    procedure sharebtn(btn: integer; ss: string);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure splitnames();
    procedure Button18Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  atypage: typage;
  listx: array[0..13, 0..1] of string;
  names: array[0..3] of string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  t1, t2, t3, pageall: string;
  m1, m2, m3: integer;
  aa: string;
  s2, bb: string;
  i: integer;
  cc, dd, idname, idname1, cstr: string;
  mystr: string;
  x1, x2, x3, x4: integer;
  h1, h2, h3: integer;
begin
//以上处理标题部分
  memo1.Clear;
  try
    Http1.Get(trim(edit3.text));
    aa := http1.Body;
  except
    SHOWMESSAGE('网络阻塞!');
    exit;
  end;

  t1 := '<table><tr><td>分页链接：[<a style=text-decoration:underline;';
  m1 := pos(t1, aa);

  t2 := '</td></tr></table><TABLE align=center border=0 cellSpacing=0 width';
  m2 := pos(t2, aa);
  pageall := copy(aa, m1 + length(t1), m2 - m1 - length(t1));
  calclist(pageall);

  bb := '<TABLE cellspacing=0 border=0 bgcolor=f5f9fa width=100% ><TR><TD WIDTH=100 ALIGN=RIGHT VALIGN=bottom></TD><TD><font size=-1 color=green><br><center>作者：<a href="/browse/Listwriter.asp?vwriter=';
  h1 := length(bb);

  cc := '&idwriter=0&key=0"   target=_blank>';
  h2 := length(cc);

  dd := '</font>　</center></TD><TD WIDTH=100 ALIGN=RIGHT VALIGN=bottom>&nbsp;</TD></TR></table>';
  h3 := length(dd);

  i := pos(bb, aa);
  splitnames;

  mystr := '';
  while (i > 0) do
  begin
    aa := copy(aa, i + h1, length(aa) - h1);
    i := pos(bb, aa);

    x1 := pos(cc, aa);
    x2 := pos(dd, aa);
    idname := copy(aa, h2 + x1, x2 - x1 - h2);
    idname1 := copy(idname, 1, pos('</a>', idname) - 1);
    if (checkbox1.checked) then
    begin
      if (((trim(idname1) = trim(names[0])) or
         (trim(idname1) = trim(names[1])) or
         (trim(idname1) = trim(names[2])) or
         (trim(idname1) = trim(names[3])))
         and  (length(trim(idname1))>0))
       then
      begin
        mystr := mystr + idname + chr(10) + chr(13);
        cstr := copy(aa, x2 + h3, i - x2 - h3);
        cstr := stringreplace(cstr, '<br>', chr(13) + chr(10), [rfReplaceAll, rfIgnoreCase]);
        mystr := mystr + cstr + chr(10) + chr(13);
        mystr := mystr + '●☆☆☆'  +chr(13)+chr(10)  ;
      end
    end
    else
    begin
      mystr := mystr + idname + chr(10) + chr(13);
      cstr := copy(aa, x2 + h3, i - x2 - h3);
      cstr := stringreplace(cstr, '<br>', chr(13) + chr(10), [rfReplaceAll, rfIgnoreCase]);
      mystr := mystr + cstr+ chr(10) + chr(13) ;
      //+ chr(10) + chr(13)
      mystr := mystr + '●☆☆☆' + chr(13)+chr(10)  ;
    end;

  end;

  if length(mystr) < 1 then
  begin
    memo1.Lines.Add('本版中 版主没有发言!!');
    exit;
  end;


  memo1.Lines.Add(mystr);
  memo1.lines.Add('               ');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  checkbox1.Checked := true;
  label5.Caption := '';
  memo1.Lines.Clear;
  combobox1.Clear;
  clearbtn;
  getfromfile();
  edit1.Text := atypage.title;
  edit2.Text := atypage.keyword;
  edit3.Text := atypage.url;
end;

procedure TForm1.Button3Click(Sender: TObject);
var xx1, xx2, xx3, xx4: string;
  n1, n2, n3, n4: integer;
  aa: string;
begin
  xx1 := '<table><tr><td>分页链接：[<a style=text-decoration:underline;';
  n1 := length(xx1);
  Http1.Get(trim(edit3.text));
  aa := http1.Body;
  aa := copy(aa, pos(xx1, aa) + n1 + 6, length(aa) - pos(xx1, aa) - n1 - 7);
  xx2 := copy(aa, 1, pos('>', aa));
  showmessage(xx2);
end;


procedure TForm1.getfromfile;
var
  datafile: file of typage;
  i: integer;
begin
//
  combobox1.Clear;
  assignfile(datafile, TYFILE);
  if not fileexists(TYFILE) then
    raise exception.create('没有相应历史记录');

  reset(datafile);

  try
    i := 1;
    while not eof(datafile) do begin
      read(datafile, atypage);
      combobox1.Items.Add(atypage.title);
      i := i + 1;
    end;
  finally
    closefile(datafile);
  end;
end;

procedure TForm1.savetofile;
var
  datafile: file of typage;
begin
//
  assignfile(datafile, TYFILE);
  if fileexists(TYFILE) then
    reset(datafile)
  else
    rewrite(datafile);

  atypage.title := edit1.text;
  atypage.keyword := edit2.text;
  atypage.url := edit3.text;
  seek(datafile, filesize(datafile));

  try
    write(datafile, atypage);
  finally
    closefile(datafile);
  end;
end;



procedure TForm1.Button2Click(Sender: TObject);
var
  datafile: file of typage;
begin
//
  assignfile(datafile, TYFILE);
  if fileexists(TYFILE) then
    reset(datafile)
  else
    rewrite(datafile);

  atypage.title := edit1.text;
  atypage.keyword := edit2.text;
  atypage.url := edit3.text;
  seek(datafile, filesize(datafile));

  try
    write(datafile, atypage);
  finally
    closefile(datafile);
  end;
  getfromfile();
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  datafile: file of typage;
  i: integer;
begin
//
  assignfile(datafile, TYFILE);
  if not fileexists(TYFILE) then
    raise exception.create('没有相应历史记录');

  reset(datafile);

  try
    i := 1;
    while not eof(datafile) do begin
      read(datafile, atypage);
      if combobox1.Text = atypage.title then
      begin
        edit1.Text := atypage.title;
        edit2.Text := atypage.keyword;
        edit3.Text := atypage.url;
      end;
      i := i + 1;
    end;
  finally
    closefile(datafile);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  edit1.Clear;
  edit2.Clear;
  edit3.Clear;
end;

function TForm1.trimaabb(straa: string): string;
var
  xx1, xx2: integer;
begin
  result := '';
  xx1 := pos('<', straa);
  xx2 := pos('>', straa);
  while (xx1 > 0) do begin
    if ((xx1 > 0) and (xx2 > xx1)) then
    begin
      straa := copy(straa, 0, xx1 - 1) + copy(straa, xx2 + 1, length(straa) - xx2);
    end;
    xx1 := pos('<', straa);
    xx2 := pos('>', straa);
  end;
  result := straa;
end;

procedure TForm1.calclist(strbb: string);
var tmpstr: string;
  k1, k2, k3: integer;
  xxx: string;
  i: integer;
begin
  clearbtn();
  k1 := pos('href=', strbb);
  k2 := pos('</a>', strbb);
  k3 := pos('<font color=black>[', strbb);
  xxx := copy(strbb, k3 + 19, 5);
  xxx := copy(xxx, 1, pos(']', xxx) - 1);
  label5.Caption := '第' + xxx + '页';
  //  MEMO1.Lines.Add(STRBB);
  i := 0;

  while (k1 > 0) do begin
    tmpstr := copy(strbb, k1, k2 - k1);
    strbb := copy(strbb, k2 + 4, length(strbb) - k2 - 3);
    listx[i][0] := copy(tmpstr, 6, pos('>', tmpstr) - 6);
    tmpstr := copy(tmpstr, pos('>', tmpstr) + 1, length(tmpstr) - pos('>', tmpstr) + 1);
    tmpstr := trimaabb(tmpstr);
    listx[i][1] := tmpstr;
//    showmessage(tmpstr);
    if (copy(tmpstr, 1, 1) = '[') then
      tmpstr := copy(tmpstr, 2, length(tmpstr) - 2);

    sharebtn(i, tmpstr);
    k1 := pos('href=', strbb);
    k2 := pos('</a>', strbb);
    i := i + 1;
  end;
end;



procedure TForm1.clearbtn;
begin
  button5.Caption := '';
  button6.Caption := '';
  button7.Caption := '';
  button8.Caption := '';
  button9.Caption := '';
  button10.Caption := '';
  button11.Caption := '';
  button12.Caption := '';
  button13.Caption := '';
  button14.Caption := '';
  button15.Caption := '';
  button16.Caption := '';
  button17.Caption := '';
  button5.Visible := false;
  button6.Visible := false;
  button7.Visible := false;
  button8.Visible := false;
  button9.Visible := false;
  button10.Visible := false;
  button11.Visible := false;
  button12.Visible := false;
  button13.Visible := false;
  button14.Visible := false;
  button15.Visible := false;
  button16.Visible := false;
  button17.Visible := false;
end;

procedure TForm1.sharebtn(btn: integer; ss: string);
begin
  case btn of
    0:
      begin
        button5.caption := ss;
        button5.visible := true;
      end;
    1:
      begin
        button6.caption := ss;
        button6.visible := true;
      end;
    2:
      begin
        button7.caption := ss;
        button7.visible := true;
      end;
    3:
      begin
        button8.caption := ss;
        button8.visible := true;
      end;
    4:
      begin
        button9.caption := ss;
        button9.visible := true;
      end;
    5:
      begin
        button10.caption := ss;
        button10.visible := true;
      end;

    6:
      begin
        button11.caption := ss;
        button11.visible := true;
      end;

    7:
      begin
        button12.caption := ss;
        button12.visible := true;
      end;
    8:
      begin
        button13.caption := ss;
        button13.visible := true;
      end;

    9:
      begin
        button14.caption := ss;
        button14.visible := true;
      end;
    10:
      begin
        button15.caption := ss;
        button15.visible := true;
      end;
    11:
      begin
        button16.caption := ss;
        button16.visible := true;
      end;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var i: integer;
begin
  for i := 0 to 12 do begin
    if (TRIM(listx[i][1]) = TRIM((sender as tbutton).Caption)) then
    begin
      edit3.Text := TRIM(listx[i][0]);
      button1.Click;
    end;
  end;


end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  edit3.Text := listx[1][0];
  button1.click;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  edit3.Text := listx[2][0];
  button1.click;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  edit3.Text := listx[3][0];
  button1.click;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  edit3.Text := listx[4][0];
  button1.click;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  edit3.Text := listx[5][0];
  button1.click;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  edit3.Text := listx[6][0];
  button1.click;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  edit3.Text := listx[7][0];
  button1.click;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  edit3.Text := listx[8][0];
  button1.click;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  edit3.Text := listx[9][0];
  button1.click;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  edit3.Text := listx[10][0];
  button1.click;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  edit3.Text := listx[11][0];
  button1.click;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  edit3.Text := listx[12][0];
  button1.click;
end;

procedure TForm1.splitnames;
var strk: string;
  i, mm: integer;
begin
//
//  edit2.Text := '中国|湖北|洪湖|地方';
  names[0] := '';
  names[1] := '';
  names[2] := '';
  names[3] := '';

  strk := edit2.Text;
  i := 0;
  while pos('|', strk) > 0 do
  begin
    mm := pos('|', strk);
    names[i] := copy(strk, 1, mm-1);
    strk := copy(strk, mm + 1, length(strk) - mm );
    i := i + 1;
  end;
  names[i] := strk;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  splitnames;
  showmessage(names[0] + '-' + names[1] + '-' + names[2] + '-' + names[3]);
end;

end.

