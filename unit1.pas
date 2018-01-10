unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Vyhladat: TButton;
    Pridat: TButton;
    Vymazat: TButton;
    sortByCode: TButton;
    sortByName: TButton;
    Reload: TButton;
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
  private
    { private declarations }
  public
    { public declarations }
  end;
  type
    zoznam=record
      kod:string;
      nazov:string;
    end;

var
  Form1: TForm1;
  tovar:array [1..100] of zoznam;
  upperkase:array [1..100] of string;
  search:array [1..100] of zoznam;
  doc:TextFile;
  lines,a,i,b,x,k:integer;
  znak:char;
  change:boolean;
  input,input2:string;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,k:integer;
begin

  for i:=1 to 100 do begin
    tovar[i].nazov:='';
    tovar[i].kod:='';
  end;
  x:=0;
  k:=1;
  AssignFile(doc,'tovar.txt');
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
       if (upperkase[i]=input) then begin
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
     ShowMessage('Tovar s týmto názvom sa nenachádza v databáze!');
   end;

  spocitanie();

  prepis();
  zapis();
  vypis();
end;

procedure TForm1.sortByCodeClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Append(IntToStr(x));
  for i:=x downto 1 do begin
    if (tovar[i].kod<>'') then
      Memo1.Append(tovar[i].kod+';'+tovar[i].nazov);
  end;
end;

procedure TForm1.sortByNameClick(Sender: TObject);
begin
  vypis();
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
procedure TForm1.zapis();
begin
  AssignFile(doc,'tovar.txt');
  Rewrite(doc);
  writeLn(doc,x);
  for i:=1 to x do begin
      writeLn(doc,tovar[i].kod+';'+tovar[i].nazov);
  end;
  closeFile(doc);
end;

end.

