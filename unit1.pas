unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo2: TMemo;
    Vyhladat: TButton;
    Pridat: TButton;
    Vymazat: TButton;
    sortByCode: TButton;
    sortByName: TButton;
    Zmenit: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure VyhladatClick(Sender: TObject);
    procedure PridatClick(Sender: TObject);
    procedure VymazatClick(Sender: TObject);
    procedure sortByCodeClick(Sender: TObject);
    procedure sortByNameClick(Sender: TObject);
    procedure ReloadClick(Sender: TObject);
    procedure ZmenitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure recognize();
    procedure vypis();
    procedure prepis();
    procedure zapis();
    procedure spocitanie();
    procedure statistika();
  private
    { private declarations }
  public
    { public declarations }
  end;
  type
    zoznam=record
      kod:string;
      nazov:string;
      sort:integer;
    end;

var
  Form1: TForm1;
  tovar:array [1..100] of zoznam;
  upperkase:array [1..100] of string;
  search:array [1..100] of zoznam;
  doc:TextFile;
  lines,a,i,b,x,k,
  ovocie,zelenina,pecivo,mrazene,drogeria,maso:integer;
  znak:char;
  change:boolean;
  input,input2:string;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,k:integer;
begin
  Label4.Caption:=('Kód');
  Label5.Caption:=('Názov');
  Label7.Caption:=('Zadajte kód/názov');
  for i:=1 to 100 do begin
    tovar[i].nazov:='';
    tovar[i].kod:='';
  end;
  x:=0;
  k:=1;
  AssignFile(doc,'\\comenius\public\market\timb\tovar.txt');
  Reset(doc);
  readln(doc,lines);
  while not eof(doc) do begin
    inc(x);
    for i:=1 to 6 do begin
      read(doc,znak);
      tovar[k].kod:=tovar[k].kod+znak;
    end;
    read(doc,znak);
    readln(doc,tovar[k].nazov);
    inc(k);
  end;
  CloseFile(doc);
  vypis();
  prepis();

end;

procedure TForm1.VyhladatClick(Sender: TObject);
var q,n:integer;
begin
  recognize;
   if (b=0) then begin  //ak sa nevyhladava ziadne pismeno
     n:=0;
     for i:=1 to x do begin
       q:=0;
             for k:=1 to a do begin
               if (tovar[i].kod[k]=input[k]) then begin   //zhoda medzi znakmi
                 inc(q);
               end;
             end;
               if (q=a) then begin                    //nacitanie do pomocneho pola
                  inc(n);
                 search[n].kod:=tovar[i].kod;
                 search[n].nazov:=tovar[i].nazov;
               end;

     end;
     if (n=0) then begin
                 ShowMessage('Tovar s týmto kódom sa nenachádza v databáze!');
     end else begin
       Memo1.Clear;
         for i:=1 to n do             //vypis pomocneho pola
         Memo1.Append(search[i].kod+';'+search[i].nazov);
     end;
   end else if (b<>0)then begin       //ak sa vyhladava aj pismeno
     n:=0;
          for i:=1 to x do begin
            q:=0;
                   for k:=1 to b do begin
                     if (upperkase[i][k]=input[k]) then begin
                       inc(q);
                     end;
                   end;
                     if (q=b) then begin        //nacitanie do pomocneho pola
                       inc(n);
                       search[n].kod:=tovar[i].kod;
                       search[n].nazov:=tovar[i].nazov;
                     end;
          end;
     if (n=0) then begin
                 ShowMessage('Tovar s týmto názvom sa nenachádza v databáze!');
     end else begin
       Memo1.Clear;
         for i:=1 to n do             //vypis pomocneho pola
         Memo1.Append(search[i].kod+';'+search[i].nazov);
     end;

   end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  vypis();
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin

end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.PridatClick(Sender: TObject);
var g,c,d:integer;
begin
  input:=(Edit4.Text);
  input2:=(Edit5.Text);
  a:=0;
  b:=0;
  c:=0;
  d:=0;
  if (input='') then begin
     ShowMessage('Zadajte kód tovaru!');
  end else
  if (input2='') then begin
     ShowMessage('Zadajte názov tovaru!');
  end else begin
  for i:=1 to 7 do begin
      case input[i] of
        '0'..'9' : inc(a);
        'A'..'Z' : inc(b);
      end;
      case UpperCase(input2[i]) of
        '0'..'9' : inc(c);
        'A'..'Z' : inc(d);
      end;
    end;

 g:=0;
  if (a=6) then begin
     if (d<>0) then begin
       for i:=1 to x do begin
         if (input=tovar[i].kod) then begin
             inc(g);
         end;
       end;
       if (g=0) then begin
                tovar[x+1].kod:=Edit4.Text;
                tovar[x+1].nazov:=Edit5.Text;

       end else
            ShowMessage('Tovar s týmto kodom sa už nachádza v databáze!');
     end else if (d=0) AND (a<>0) then ShowMessage('Neplatny názov tovaru!');
  end else if (a<6) OR (a>6) then
      ShowMessage('Zadajte správny formát kódu![6 cifier]');

      spocitanie();
  end;
  prepis();

  zapis();
  vypis();
end;
procedure TForm1.VymazatClick(Sender: TObject);
var q:integer;
begin
  recognize();
  if (b=0) then begin
    if (a<6) AND (a<>0) then
     ShowMessage('Zadajte správny formát kódu![6 cifier]');
   end;
  if (a=6) then begin  //ak je to cislo
    q:=0;
     for i:=1 to x do begin
       if (tovar[i].kod=input) then begin
         for k:=i to (x-1) do begin
         tovar[k].nazov:=tovar[k+1].nazov;
         tovar[k].kod:=tovar[k+1].kod;
         inc(q);
         end;
         tovar[x].kod:='';
         tovar[x].nazov:='';
       end;
     end;
     if (q=0) then
     ShowMessage('Tovar s týmto kódom sa nenachádza v databáze!');
   end else if (b<>0) then begin
     q:=0;
    for i:=1 to x do begin
      inc(q);
       if (upperkase[i]=input) then begin
          q:=q-1;
         for k:=i to (x-1) do begin
           tovar[k].nazov:=tovar[k+1].nazov;
           tovar[k].kod:=tovar[k+1].kod;

         end;
         tovar[x].kod:='';
         tovar[x].nazov:='';
       end;
     end;
     if (q=x) then
     ShowMessage('Tovar s týmto názvom sa nenachádza v databáze!');
   end;

  spocitanie();

  prepis();
  zapis();
  vypis();
end;

procedure TForm1.sortByCodeClick(Sender: TObject);
var nazov,kod:string;
begin
  Memo1.Clear;
  Memo1.Append(IntToStr(x));
  for i:=1 to x do begin
     tovar[i].sort:=StrToInt(tovar[i].kod);
  end;
 i:=1;
  repeat
     if (StrToInt(tovar[i].kod)>StrToInt(tovar[i+1].kod)) then begin
       kod:=(tovar[i].kod);
       tovar[i].kod:=tovar[i+1].kod;
       tovar[i+1].kod:=(kod);

       nazov:=tovar[i].nazov;
       tovar[i].nazov:=tovar[i+1].nazov;
       tovar[i+1].nazov:=nazov;
       i:=0;
     end;
    inc(i);
  until (i=x);
  prepis();
  for i:=1 to x do begin
      Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
  end;
end;

procedure TForm1.sortByNameClick(Sender: TObject);
var f,q,k,t,r:integer;
var a,kod,nazov :string;
var L:char;
var nums:array [1..100] of string;
    abcd:array [1..26] of char;
    alf:array ['A'..'Z'] of integer;
begin
 q:=0;
  for L:='A' to 'Z' do begin
    inc(q);
    abcd[q]:=L;
  end;


  Memo1.Clear;
  Memo1.Append(IntToStr(x));
  q:=0;
  for L:='A' to 'Z' do begin
    inc(q);
    alf[L]:=q;
  end;
  q:=0;
     for i:=1 to x do begin
      f:=1;
      k:=1;
      inc(q);
         t:=length(upperkase[i]);
         repeat
                if (upperkase[i][k]=abcd[f]) then begin
                  nums[q]:=nums[q]+IntToStr(alf[abcd[f]]);
                  inc(k);
                  f:=1;
                end else
                if (upperkase[i][k]=' ') then begin
                  nums[q]:=nums[q]+'0';
                  inc(k);
                  f:=1;
                end else
                begin
                  inc(f);
                end;
         until (k=2);
     end;

     i:=1;
  repeat
     if (StrToInt(nums[i])>StrToInt(nums[i+1])) then begin
       kod:=(nums[i]);
       nums[i]:=nums[i+1];
       nums[i+1]:=(kod);
        nazov:=tovar[i].nazov;
       tovar[i].nazov:=tovar[i+1].nazov;
       tovar[i+1].nazov:=nazov;

       kod:=(tovar[i].kod);
       tovar[i].kod:=tovar[i+1].kod;
       tovar[i+1].kod:=(kod);
       i:=0;
     end;
    inc(i);
  until (i=x);
  prepis();
  for i:=1 to x do begin
      Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
  end;

 {q:=0;
 for i:=1 to x do begin
   k:=1;
   inc(q);
   t:=length(upperkase[i]);
   repeat
     case (upperkase[i][k]) of
       'A' :begin nums[q]:=nums[q]+'1';  inc(k); end;
       'B' :begin nums[q]:=nums[q]+'2';  inc(k); end;
       'C' :begin nums[q]:=nums[q]+'3';  inc(k); end;
       'D' :begin nums[q]:=nums[q]+'4';  inc(k); end;
       'E' :begin nums[q]:=nums[q]+'5';  inc(k); end;
       'F' :begin nums[q]:=nums[q]+'6';  inc(k); end;
       'G' :begin nums[q]:=nums[q]+'7';  inc(k); end;
       'H' :begin nums[q]:=nums[q]+'8';  inc(k); end;
       'I' :begin nums[q]:=nums[q]+'9';  inc(k); end;
       'J' :begin nums[q]:=nums[q]+'10';  inc(k); end;
       'K' :begin nums[q]:=nums[q]+'11';  inc(k); end;
       'L' :begin nums[q]:=nums[q]+'12';  inc(k); end;
       'M' :begin nums[q]:=nums[q]+'13';  inc(k); end;
       'N' :begin nums[q]:=nums[q]+'14';  inc(k); end;
       'O' :begin nums[q]:=nums[q]+'15';  inc(k); end;
       'P' :begin nums[q]:=nums[q]+'16';  inc(k); end;
       'Q' :begin nums[q]:=nums[q]+'17';  inc(k); end;
       'R' :begin nums[q]:=nums[q]+'18';  inc(k); end;
       'S' :begin nums[q]:=nums[q]+'19';  inc(k); end;
       'T' :begin nums[q]:=nums[q]+'20';  inc(k); end;
       'U' :begin nums[q]:=nums[q]+'21';  inc(k); end;
       'V' :begin nums[q]:=nums[q]+'22';  inc(k); end;
       'W' :begin nums[q]:=nums[q]+'23';  inc(k); end;
       'X' :begin nums[q]:=nums[q]+'24';  inc(k); end;
       'Y' :begin nums[q]:=nums[q]+'25';  inc(k); end;
       'Z' :begin nums[q]:=nums[q]+'26';  inc(k); end;
       ' ' :begin nums[q]:=nums[q]+''; inc(k);  end;
     end;

   until (k=t+1);
 end;
 for i:=1 to x do begin
       Memo1.Append(nums[i]);
 end;

 i:=1;
 repeat
     if (StrToInt(nums[i])>StrToInt(nums[i+1])) then begin
       kod:=(tovar[i].kod);
       tovar[i].kod:=tovar[i+1].kod;
       tovar[i+1].kod:=(kod);

       nazov:=tovar[i].nazov;
       tovar[i].nazov:=tovar[i+1].nazov;
       tovar[i+1].nazov:=nazov;
       i:=0;
     end;
    inc(i);
  until (i=x);

  for i:=1 to x do begin
      Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
  end; }

end;
procedure TForm1.ReloadClick(Sender: TObject);
begin
  vypis();
end;

procedure TForm1.ZmenitClick(Sender: TObject);
var c,d,q :integer;
begin
 a:=0;
 b:=0;
 c:=0;
 d:=0;
  input:=UpperCase(Edit2.Text);
  input2:=Edit3.Text;
  if (input='') then begin
     ShowMessage('Zadajte kód/názov tovaru ktorý chcete zmeniť!');
  end else
  if (input2='') then begin
     ShowMessage('Zadajte nový kód/názov tovaru!');
  end else begin
    for i:=1 to 6 do begin
      case input[i] of
        '0'..'9' : inc(a);
        'A'..'Z' : inc(b);
      end;
      case UpperCase(input2[i]) of
        '0'..'9' : inc(c);
        'A'..'Z' : inc(d);
      end;
    end;

  if (a=6) then begin  //vyhladavanie podla kodu
    q:=0;
    for i:=1 to x do begin
      if (input=tovar[i].kod) then begin
        inc(q);
        if (c=6) then         //meni sa kod
           tovar[i].kod:=input2
        else if (d<>0) then   //meni sa nazov
           tovar[i].nazov:=input2
        else ShowMessage('Nesprávny formát kódu!');
      end;
    end;
    if (q=0) then ShowMessage('Tovar s takým kódom sa nenachádza v databáze!');
  end  else
  if (b<>0) then begin  //vyhladavanie podla nazvu
    q:=0;
    for i:=1 to x do begin
      if (input=upperkase[i]) then begin
        inc(q);
        if (c=6) then         //meni sa kod
           tovar[i].kod:=input2
        else if (d<>0) then   //meni sa nazov
           tovar[i].nazov:=input2
        else ShowMessage('Nesprávny formát kódu!');
      end;
    end;
    if (q=0) then ShowMessage('Tovar s takým názvom sa nenachádza v databáze!');
  end;
  prepis();
  zapis();
  vypis();
end;
end;
procedure TForm1.recognize();
begin
  a:=0;
  b:=0;
  input:='';
  input:=UpperCase(Edit1.Text);
 if (input='') then
   ShowMessage('Prázdne pole!')
 else
  for i:=1 to 7 do begin
       case input[i] of
         '0'..'9' : inc(a);
         'A'..'Z' : inc(b);
       end;
  end;

 spocitanie();

  for i:=1 to x do begin
      search[i].kod:='';
      search[i].nazov:='';
  end;
  vypis();
end;

procedure TForm1.vypis();
begin
   Memo1.Clear;
   Memo1.Append(IntToStr(x));
  for i:=1 to x do
        Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
 statistika();
end;
procedure TForm1.prepis();
begin
  for i:=1 to x do
     upperkase[i]:=UpperCase(tovar[i].nazov);
  end;
procedure TForm1.spocitanie();
begin
  x:=0;
  for i:=1 to 100 do begin
     if (tovar[i].nazov<>'') then
       inc(x);
  end;
 end;
procedure TForm1.statistika();
begin
 ovocie:=0;
 zelenina:=0;
 pecivo:=0;
 mrazene:=0;
 drogeria:=0;
 maso:=0;
  for i:=1 to x do begin
     case (tovar[i].kod[2]) of
       '1' : inc(ovocie);
       '2' : inc(zelenina);
       '3' : inc(pecivo);
       '4' : inc(mrazene);
       '5' : inc(drogeria);
       '6' : inc(maso);
     end;
  end;
  Memo2.Clear;
  for i:=1 to 6 do begin
     case (i) of
       1 : Memo2.Append('Ovocie: '+IntToStr(ovocie));
       2 : Memo2.Append('Zelenina: '+IntToStr(zelenina));
       3 : Memo2.Append('Pečivo: '+IntToStr(pecivo));
       4 : Memo2.Append('Mrazené: '+IntToStr(mrazene));
       5 : Memo2.Append('Drogéria: '+IntToStr(drogeria));
       6 : Memo2.Append('Mäso: '+IntToStr(maso));
     end;
  end;
end;
procedure TForm1.zapis();
begin
  AssignFile(doc,'\\comenius\public\market\timb\tovar.txt');
  Rewrite(doc);
  writeLn(doc,x);
  for i:=1 to x do begin
      writeLn(doc,tovar[i].kod+';'+tovar[i].nazov);
  end;
  closeFile(doc);
end;

end.

