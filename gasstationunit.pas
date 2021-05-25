unit GasStationUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs;

type
  FIO_cl = record    //запись ФИО
    Fam:string[20]; //Фамилия
    Name:string[20]; //Имя
    Otch:string[20]; //Отчество
  end;

  GasStation = record  //ЗАпись автозаправки
    Cod:integer;  //код покупки
    FIO:FIO_cl;      //ФИО
    Fuel:string[16];  //Вид топлива
    Kol_l:integer;    //Колличество литров
    Price_l:Currency;  //Цена за литр
    All_Price:Currency;  //общаяя сумма покупки
  end;

  PUzel = ^GasList;   //списочек(указатель на тип узла GasList)
  GasList = record   //тип узла
    x:GasStation;  //сама запись
    next:PUzel;   //указатели
    pred:PUzel;
  end;

  GASFile = file of GasStation; //типизированный файл для записи

  {Все для создание списка}
  procedure AddFirst(var Head:PUzel;a:PUzel); {Вставить узел в голову списка}
  procedure AddAfter(var old:PUzel;a:PUzel); {Вставить узел после old}
  procedure AddInEnd(var Head, a:PUzel); //Вставка в конец списка Head-голова списка, a-вставляемывй узел
  procedure AddRec(var Rec:GasStation); //добавление записи
  procedure BuildSpisok(var Head:PUzel); {Построить список; Head-указатель на голову}
  procedure BuildFromFile(var f:GASFile;var Head:PUzel); //Создание списка из файла

  {Все для удаление списка и элементов}
  procedure DelFirstElement(var Head,a:PUzel); //выделение первого элемента из списка в а
  procedure DelElement(var old,a:PUzel);  //Нахождение элемента после old и возвращению его в пользование
  procedure Del(var a:PUzel); //удаление элемента а из списка
  procedure DelSpisok(var Head:PUzel);//Удаление списка
  function FindLast(var Head:PUzel):PUzel;  //Нахождение последнего узла

  {Все для Сохранения в файлы}
  procedure SaveRec(var f:GASFile;var Head:PUzel); //Сохранить список Head в  тип. файле
  procedure SaveInTxt(var f1:TextFile;var Head:PUzel);  //Сохранить список Head в текстовом файле
  function RecToStr(var Rec:GasStation):string; //перевод записи в строку
  procedure CreateTipFile(var f:GASFile;var FName:string); //Создание типизированного файла
  procedure CreateTxTFile(var f:TextFile); //Создание Текстового файл
  procedure SaveSPinTipFile(var f:GASFile;var  Head:PUzel); //Сохранение в типизированный файл


  {Добавление в таблички}
  procedure AddInSG(var a:PUzel); //добавляет запись в табличку по одной записи
  procedure AddInSG2(var Head:PUzel); //добавление списка во вторую таблицу  весь список
  procedure AddInSGSort(var a:PUzel); //добавляет запись во вторую таблицу по одной записи

  {Сортировки}
  procedure Sort_FIO(var Head:PUzel); //Сортировка по FIO
  procedure Sort_Fam(var Head:PUzel); //сортировка по фамилии
  procedure Sort_Name(var Head:PUzel); //сортировка по Имени
  procedure Sort_Otch(var Head:PUzel); //сортировка по отчеству
  procedure Sort_Cod(var Head:PUzel); //сортировка по коду покупки
  procedure Sort_Fuel(var Head:PUzel);//Сортировка по виду топлива
  procedure Sort_Price_l(var Head:PUzel);//Сортировка по цене за литр
  procedure Sort_Kol_l(var Head:PUzel); //сортировка по коду покупки
  procedure Sort_AllPrice(var Head:PUzel);//Сортировка по общей сумме

  {Поиск по ключу}
  procedure Find_Cod(var Head:PUzel);  //Поиск по коду покупки
  procedure Find_Fam(var Head:PUzel);  //Поиск по фамили
  procedure Find_Name(var Head:PUzel);  //Поиск по имени
  procedure Find_Otch(var Head:PUzel);  //Поиск по Отчеству
  procedure Find_Fuel(var Head:PUzel);  //Поиск по топливу
  procedure Find_Kol_l(var Head:PUzel);  //Поиск по литрам
  procedure Find_AllPrice(var Head:PUzel);  //Поиск по Общей сумме

  {Все остальное}
  procedure SGMain_Clear; //Очистка основной таблицы
  function FIOTOStr(var a:PUzel):String;//перевод FIO в строку
  procedure DeleteSpace(var s:string);  //Удаление пробелов
  function StrFormat(s:String; n:integer):String; //форматирование строки , n-размер строки


implementation

uses MainU, FillingUnit;  //Подключу модуль главный модуль, потому что хочу обращаться к форме из модуля

procedure AddFirst(var Head:PUzel;a:PUzel);   {Вставить узел в голову списка}
    begin
     a^.x.Cod:=1;
     a^.next:=Head; //Связываем а с головой добавляем его в начало списка
     if Head<> nil then Head^.pred:=a; //если список не пуст то делаем обратную связь
     Head:=a;  //переводим указатель на новую голову

    end;

procedure AddAfter(var old:PUzel;a:PUzel); {Вставить узел после old}
   begin
         a^.next:=old^.next; //связываем а со следующим
         old^.next:=a;   //old связываем с а
         if a^.next<>nil then a^.next^.pred:=a;  //если а не последний, то связываем следующий элемент за а с а
         a^.pred:=old;  //а связываем с old
   end;

procedure AddInEnd(var Head, a:PUzel); //Вставка в конец списка Head-голова списка, a-вставляемывй узел
var p:PUzel; //узел для прохода до конца списка
    i:Integer; //счетчик для поля cod
begin
  p:=Head;
  i:=2;
  while p^.next <> nil do
        begin
        p:=p^.next;    //идем до последнего элемента списка
        inc(i);//Увеличивае i на 1
        end;
  a^.x.Cod:=i; //заполняем поле cod
  AddAfter(p,a);//Вставляем узел а в конец
end;

procedure AddRec(var Rec:GasStation); //добавление записи
var l:integer; //для считывания литров(можно без нее)
    S:string; //Для считывания и удаления пробелов
begin
  with FormFilling do
  begin
      if not ((EditFam.Text = '') or (EditName.Text = '') or (EditOtch.Text = '') or (ComboBox1.Text = '')) and TryStrToInt(EditLitr.Text, l) then  //проверка на вводимые данные
         begin
            ShowMessage('Вошел');
            with Rec do  //считываем данные
            begin
               S:=EditFam.Text;  //Фамилия
               DeleteSpace(S); //Удаляем пробелы  в Фамилии
               FIO.Fam:=S;    //Записываем в поле фамилию без лишних пробелов

               S:=EditName.Text; //Имя
               DeleteSpace(S);  //Удаляем пробелы в Имени
               FIO.Name:=S;    //Все точно также

               S:=EditOtch.Text; //Отчество
               DeleteSpace(S); //Удаляем пробелы в Отчестве
               FIO.Otch:=S;

               Fuel:=ComboBox1.Text;  //вид топлива
               Kol_l:=l;             //количество литров
               case Fuel of       //цена (выбирается сама в зависимости от выбранного топлива
               'АИ-80':Price_l:=41.25;
               'АИ-92':Price_l:=46.78;
               'АИ-95':Price_l:=50.08;
               'АИ-98':Price_l:=53.12;
               'АИ-100':Price_l:=56.24;
               'Дизель':Price_l:=52.65;
               'Газ':Price_l:=29.66;
               end;
               All_Price:=Price_l*Kol_l;   //считаем сумму покупки
               ShowMessage(CurrToStr(All_Price));
            end;
         end
      else
      DefaultMessageBox('Одно или больше полей не заполнено', 'Ой, ошибочка вышла',0);
  end;

end;


procedure BuildSpisok(var Head:PUzel); {Построить список; Head-указатель на голову}
var
     a:PUzel; //а-элемент под который выделяем память
begin
           new(a); //выделяем память
           AddRec(a^.x);  //Считываем запись

    if (Head = nil) then //Если список пустой
        begin
           AddFirst(Head,a); //пихаем в голову списка
        end
    else                 //если же список уже есть
        begin
           AddInEnd(Head,a); //то пихаем в конец списка
        end;
        AddInSG(a);  //Добавляем Запис в табличку
end;

procedure DelFirstElement(var Head,a:PUzel); //выделение первого элемента из списка в а
begin
     a:=Head;  //а переводим на голову
     Head:=Head^.next; //передвигаем голову вперед
     if Head<>nil then Head^.pred:=nil;//если список не опустел, то обрываем связь головы с предыдущим элементом
     a^.next:=nil; //для перестраховки
     a^.pred:=nil; //обрываем все связи у а
end;

procedure DelElement(var old,a:PUzel);  //Нахождение элемента после old и возвращению его в пользование
begin
  if (old^.next = nil) then a:=nil   //Если за Old ничего нет, то a просто nil
     else
       if (old^.next^.next = nil) then    //Если Old предпоследний
          begin
               a:=old^.next;        //то а это последний элемент
               a^.pred:=nil;       //обрываем связь а с предыддущим
               old^.next:=nil;     //и old  с а обрываем
          end
       else             //если же а стоит где то посреди списка
       begin
         a:=old^.next;       //то берем а
         old^.next:=a^.next;    //old  связывам со следующим за а
         old^.next^.pred:=old;  //и следующий за с old
         a^.next:=nil;         //обрываем все
         a^.pred:=nil;         //связи у а
       end;
end;



procedure Del(var a:PUzel); //удаление элемента а из списка
var old,fut:PUzel; //old - перед а, fut - после а
begin
  old:=a^.pred;//предыдущий
  fut:=a^.next;//следующий

  if not (old = nil) then
  old^.next:=fut;//связываем элементы между которыми стоит а
  if not( fut = nil) then
  fut^.pred:=old;//связываем элементы между которыми стоит а
  {обрываем связи у а}
  a^.pred:=nil;  //обрываем связи у а
  a^.next:=nil;
end;

procedure DelSpisok(var Head:PUzel);//Удаление списка
 var
  a:PUzel;   //текущий элемент
 begin
  while Head<>nil do  //проходим до конца списка
   begin
    DelFirstElement(Head,a);//выделяем первый элемент
    Dispose(a);  //и освобождаем память
   end;
 end;

function FindLast(var Head:PUzel):PUzel;  //Нахождение последнего узла
var a:PUzel;
begin
  a:=Head;
  while (a^.next <> nil) do     //проходим по списку до последнего и
        a:=a^.next;
  FindLast:=a;        //находим последний
end;

procedure SaveRec(var f:GASFile;var Head:PUzel); //Сохранить список Head в  тип. файле
     var
     a: PUzel;  //текущий указатель
     FName: string;   //Имя файла
    begin
     a:=Head; //ставим текузий указатель на голову
     if MainForm.SaveDialog1.Execute then //открываем savedialog
      FName:= MainForm.SaveDialog1.FileName;  //Присваивам имя файла
      CloseFile(f); //на всякий случай закрываем файл(а то мало ли)
      rewrite(f);   //Перезаписываем(мы ведь все равно будем пихать весь список)
     while a<>nil do  //пробегаемся по списку
      begin
       write(f,a^.x);  //и записываем запись в файл
       a:=a^.next;  //и переходим к следующий
      end;
    end;

procedure SaveInTxt(var f1:TextFile;var Head:PUzel);  //Сохранить список Head в текстовом файле
var a:PUzel; //текущий указатель
    S:string; //строка для записи в текстовый файл
    FName:string; //Имя файла
begin
   a:=Head; //ставим текущий указатель на голову

   if MainForm.SaveDialog1.Execute then  //открываем savedialog
   FName:= MainForm.SaveDialog1.FileName;  //и присваиваем имя файла
   if (FName = '') or (FName = ' ') then     //Если не выбрали, то выводим сообщение
     DefaultMessageBox('Что то пошло не так, возможно вы файлик не выбрали','Ой, ошибочка вышла',0)
   else
     begin
         AssignFile(f1,FName);  //Связываем
         Append(t);   //Открываем
         WriteLn(t,'Список:');
       while (a <> nil) do   //проходимся по списку
             begin
                s:=RecToStr(a^.x); //пихаем в строку текущую запись
                WriteLn(f1,s); //записываем в файл
                a := a^.next; //переходм на следущий элемент
             end;
       CloseFile(t); //Закрываем
     end;


end;

function StrFormat( s:String; n:integer):String; //форматирование строки , n-размер строки
var s2:String; //в которую будем копировать и добавлять пробелы
    i:integer;
begin
   s2:=s; //копируем из одной в другую
   for i:=Length(s) to n do
       s2:=s2 + ' '; //добавляем недостающие пробелы
   StrFormat:=s2;
end;

function RecToStr(var Rec:GasStation):string; //перевод записи в строку
var
    s:string;
begin
   with Rec do
   begin    //перевод в строку с помощью ф-ии format
     s:=StrFormat(IntToStr(Cod),4) + StrFormat(FIO.Fam,25) + StrFormat(FIO.Name,25) + StrFormat(FIO.Otch,25) + StrFormat(Fuel,16) + StrFormat(CurrToStr(Price_l),5) + 'руб. '  + IntToStr(Kol_l) +' л. ' + CurrToStr(All_Price) + ' руб.';
   end;
   RecToStr:=s;
end;

procedure AddInSG(var a:PUzel); //добавляет запись в табличку
var i,j:Integer; //i- строка j- столбец
begin
   with a^.x do
   begin
      i:=Cod; //находим нужную строку
      with MainForm do   //работаем с главной формой
      begin
         SGMain.RowCount:=i+1;
         for j:=0 to 5 do
         begin
           case j of
           0:SGMain.Cells[j,i]:=IntToStr(Cod); //добавляем в код покупки
           1:SGMain.Cells[j,i]:=FIO.Fam+' '+FIO.Name+' '+FIO.Otch;//Добавляем ФИО клиента
           2:SGMain.Cells[j,i]:=Fuel;//Вид топлива
           3:SGMain.Cells[j,i]:=CurrToStr(Price_l);//цену за литр
           4:SGMain.Cells[j,i]:=IntToStr(Kol_l);//кол-во литров
           5:SGMain.Cells[j,i]:=CurrToStr(All_Price);//общая сумма
            end;
         end;
      end;
   end;
end;

procedure AddInSGSort(var a:PUzel); //добавляет запись во вторую таблицу по одной записи
var i,j:Integer; //i- строка j- столбец
begin
   with a^.x do
   begin
      i:=MainForm.SGSort.RowCount; //находим нужную строку
      with MainForm do   //работаем с главной формой
      begin
         SGSort.RowCount:=i+1;
         for j:=0 to 5 do
         begin
           case j of
           0:SGSort.Cells[j,i]:=IntToStr(Cod); //добавляем в код покупки
           1:SGSort.Cells[j,i]:=FIO.Fam+' '+FIO.Name+' '+FIO.Otch;//Добавляем ФИО клиента
           2:SGSort.Cells[j,i]:=Fuel;//Вид топлива
           3:SGSort.Cells[j,i]:=CurrToStr(Price_l);//цену за литр
           4:SGSort.Cells[j,i]:=IntToStr(Kol_l);//кол-во литров
           5:SGSort.Cells[j,i]:=CurrToStr(All_Price);//общая сумма
            end;
         end;
      end;
   end;
end;

procedure CreateTipFile(var f:GASFile;var FName:string); //Создание типизированного файла
begin
   FName:=InputBox('Создание типизированного файла', 'Введите имя файла','');  //Считываем имя файла
   if not((FName = '') and (FName = ' ')) then    //проверка на имя файла
      begin
         AssignFile(f,FName);
         Rewrite(f);            //ну и создание
         CloseFile(f);
      end
   else
   DefaultMessageBox('Возможно вы не правильно ввели имя файла','Ой, ошибочка вышла',0);
end;

procedure CreateTxTFile(var f:TextFile); //Создание Текстового файла
begin
   FName:=InputBox('Создание текстового файла файла', 'Введите имя файла','');  //Считываем имя файла
   FName:=FName+'.txt';
   if not((FName = '') and (FName = ' ')) then    //проверка на имя файла
      begin
         AssignFile(f,FName);  //Связываем
         if FileExists(FName) then
            Append(f)
            else
            Rewrite(f);            //ну и создание

         CloseFile(f);
      end
   else
   DefaultMessageBox('Возможно вы не правильно ввели имя файла','Ой, ошибочка вышла',0);
end;

procedure SGMain_Clear; //Очистка основной таблицы
var i, n:integer;    //i - строки, n-кол-во строк
begin
    with MainForm do    //обращаемся к главной форме
    begin
       n:=SGMain.RowCount;        //узнаем кол-во строк
       for i:= 1 to n - 1 do
           SGMain.Rows[i].Clear;    //и удаляем все строки кроме первой
    end;
end;

procedure BuildFromFile(var f:GASFile;var Head:PUzel); //Создание списка из файла
var a:PUzel; //текущий указатель
begin
   if not (Head = nil) then //если список уже не пустой
      begin
         DelSpisok(Head); //Если список не пустой, то удаляем
         SGMain_Clear; //Очищаем таблицу
      end;

    Reset(f);  //Открывем
    Seek(f,0); //на всякий случай перемещаем в самое начало файла, хотя reset  и так должен поместить указатель в начало
    while not(EoF(f)) do
    begin
       new(a); //выделяем память
       Read(f,a^.x);   //считываем запись из файла


      if (Head = nil) then //Если список пустой
          begin
             AddFirst(Head,a); //пихаем в голову списка
          end
      else                 //если же список уже есть
          begin
             AddInEnd(Head,a); //то пихаем в конец списка
          end;
          AddInSG(a);  //Добавляем Запис в табличку
     end;
    CloseFile(f);
end;

procedure SaveSPinTipFile(var f:GASFile;var  Head:PUzel); //Сохранение в типизированный файл
var a:PUzel; //Текущий указатель
begin
   Rewrite(f);  //Перезаписываем файл
   Reset(f);  //Открываем файл
   a:=Head; //Ставим указатель на голову списка
   while not(a = nil) do //Проходимся по списку
   begin
     Write(f,a^.x); //Записываем содержимое в файл
     a:=a^.next;  //перемещаем указатель на следующий
   end;
   CloseFile(f); //ЗАкрываем файлик
end;

procedure Sort_Fam(var Head:PUzel); //сортировка по фамилии
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.FIO.Fam > max^.x.FIO.Fam then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Name(var Head:PUzel); //сортировка по Имени
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.FIO.Name > max^.x.FIO.Name then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Otch(var Head:PUzel); //сортировка по отчеству
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.FIO.Otch > max^.x.FIO.Otch then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;


procedure Sort_FIO(var Head:PUzel); //Сортировка по FIO
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
    s1,s2:String; //строки для сравнения
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      s1:=FIOTOStr(max);   //переводим в строку fio текущей головы
      while a <> nil do    //проходимся по остальным элементам
      begin
        s2:=FIOTOStr(a);   //переводим в строку текущее FIO
        if s2 > s1 then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
        //ShowMessage('s1 = ' + s1 + ' s2 = ' + s2 + 'max = ' + max^.x.FIO.Fam);
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Cod(var Head:PUzel); //сортировка по коду покупки
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.cod > max^.x.cod then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Fuel(var Head:PUzel);//Сортировка по виду топлива
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.Fuel > max^.x.Fuel then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Price_l(var Head:PUzel);//Сортировка по цене за литр
var a, h, max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.Price_l > max^.x.Price_l then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_Kol_l(var Head:PUzel); //сортировка по коду покупки
var a, h,max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.Kol_l > max^.x.Kol_l then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

procedure Sort_AllPrice(var Head:PUzel);//Сортировка по общей сумме
var a, h, max:PUzel; //a - текущий элемент , h-новая голова списка в которым будем копировать
begin
   h:=nil;    //сюда копируем
   while Head<> nil do       //проходим по списку пока голова не обнулится
   begin
      max:=Head;       //максимальный узел ставим на голову
      a:=Head;         //а тоже на голову
      while a <> nil do    //проходимся по остальным элементам
      begin
        if a^.x.All_Price > max^.x.All_Price then   //сравниваем строки
        max:=a;          //находим максимальный
        a:=a^.next;    //переходим к следующему элементу
      end;
      if (max = Head) then    //если максимальный совпал с головой
         DelFirstElement(Head,max)   //то удаляем из списка голову
      else      //если другой
        Del(max);  //то удаляем его

         max^.next:=h; //Связываем а с головой добавляем его в начало списка
         if h<> nil then h^.pred:=max; //если список не пуст то делаем обратную связь
         h:=max;  //переводим указатель на новую голову

   end;
  Head:=h;   //переводим указатель головы на новый отсортированный список
  AddInSG2(Head);  //выводим на экран
end;

function FIOTOStr(var a:PUzel):String;//перевод FIO в строку
var s:String;
begin
  s:=a^.x.FIO.Fam + ' ' + a^.x.FIO.Name + ' ' + a^.x.FIO.Otch;
  FIOTOStr:=s;
end;

procedure AddInSG2(var Head:PUzel); //добавление списка во вторую таблицу
var i,j:Integer; //i- строка j- столбец
    a:PUzel;//текущий элемент
begin
   a:=Head;
   i:=1;
   while a <> nil do  // проходим по списку
     begin
           with a^.x do
           begin

              with MainForm do   //работаем с главной формой
              begin
                 SGSort.RowCount:=i+1;
                 for j:=0 to 5 do
                 begin
                   case j of
                   0:SGSort.Cells[j,i]:=IntToStr(Cod); //добавляем в код покупки
                   1:SGSort.Cells[j,i]:=FIO.Fam+' '+FIO.Name+' '+FIO.Otch;//Добавляем ФИО клиента
                   2:SGSort.Cells[j,i]:=Fuel;//Вид топлива
                   3:SGSort.Cells[j,i]:=CurrToStr(Price_l) + ' руб.';//цену за литр
                   4:SGSort.Cells[j,i]:=IntToStr(Kol_l);//кол-во литров
                   5:SGSort.Cells[j,i]:=CurrToStr(All_Price)+ ' руб.';//общая сумма
                    end;
                 end;
              end;
           end;
         a:=a^.next;
         Inc(i);
     end;
end;

procedure Find_Cod(var Head:PUzel);  //Поиск по коду покупки
var a:PUzel; //текущий
    CodKey:integer; //ключ для поиска
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   if TryStrToInt(InputBox('Поиск','Введите Код покупки',''),CodKey) then    //Считываем код покупки
      begin
         while a <> nil do  //проходим по списку
           begin
              if a^.x.Cod = CodKey then   //если нашли соответсвие
                 begin
                 AddInSGSort(a);    //то выводим
                 Inc(fl); //увеличиваем
                 end;
              a:=a^.next; //Переходим к следующему элементу
           end;
       if (fl = 0)  then
          DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
     end
   else
      DefaultMessageBox('Что-то пошло не так, возможно вы что-то не правильно ввели','Ой, ошибочка вышла',0);

end;

procedure Find_Fam(var Head:PUzel);  //Поиск по фамилии
var a:PUzel; //текущий
    FamKey:String; //Фамилия(ключ для поиска)
    s:String; //текущая фамилия в записи
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   FamKey:=InputBox('Поиск','Введите Фамилию','');
   DeleteSpace(FamKey);

   while a <> nil do  //проходим по списку
     begin
       s:=a^.x.FIO.Fam; //присвиваем фамилию в строку
       DeleteSpace(s); //чтобы после всего удалить пробелы
        if s = FamKey then   //если нашли соответсвие
           begin
           AddInSGSort(a);    //то выводим
           Inc(fl); //увеличиваем
           end;
        a:=a^.next; //Переходим к следующему элементу
     end;
 if (fl = 0)  then
    DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
end;

procedure Find_Name(var Head:PUzel);  //Поиск по имени
var a:PUzel; //текущий
    NameKey:String; //Имя(ключ для поиска)
    s:String; //текущая фамилия в записи
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   NameKey:=InputBox('Поиск','Введите Имя','');
   DeleteSpace(NameKey);   //Удаляем ненужные пробелы из имени(Так, на всякий случай)
   while a <> nil do  //проходим по списку
     begin
       s:=a^.x.FIO.Name; //присвиваем Имя в строку
       DeleteSpace(s); //чтобы после всего удалить пробелы
        if s = NameKey then   //если нашли соответсвие
           begin
           AddInSGSort(a);    //то выводим
           Inc(fl); //увеличиваем
           end;
        a:=a^.next; //Переходим к следующему элементу
     end;
 if (fl = 0)  then
    DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
end;

procedure Find_Otch(var Head:PUzel);  //Поиск по Отчеству
var a:PUzel; //текущий
    OtchKey:String; //Отчество(ключ для поиска)
    s:String; //текущая фамилия в записи
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   OtchKey:=InputBox('Поиск','Введите Отчество','');
   DeleteSpace(OtchKey);   //Удаляем ненужные пробелы из имени(Так, на всякий случай)
   while a <> nil do  //проходим по списку
     begin
       s:=a^.x.FIO.Otch; //присвиваем Отчество в строку
       DeleteSpace(s); //чтобы после всего удалить пробелы
        if s = OtchKey then   //если нашли соответсвие
           begin
           AddInSGSort(a);    //то выводим
           Inc(fl); //увеличиваем
           end;
        a:=a^.next; //Переходим к следующему элементу
     end;
 if (fl = 0)  then
    DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
end;

procedure Find_Fuel(var Head:PUzel);  //Поиск по топливу
var a:PUzel; //текущий
    FuelKey:String; //Топливо(ключ для поиска)
    s:String; //текущая фамилия в записи
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   FuelKey:=InputBox('Поиск','Введите Вид топлива, но вводите точь в точь, как в форме заполнения','');
   DeleteSpace(FuelKey);   //Удаляем ненужные пробелы из имени(Так, на всякий случай)
   while a <> nil do  //проходим по списку
     begin
       s:=a^.x.Fuel; //присвиваем толпиво в строку
       DeleteSpace(s); //чтобы после всего удалить пробелы
        if s = FuelKey then   //если нашли соответсвие
           begin
           AddInSGSort(a);    //то выводим
           Inc(fl); //увеличиваем
           end;
        a:=a^.next; //Переходим к следующему элементу
     end;
 if (fl = 0)  then
    DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
end;

procedure Find_Kol_l(var Head:PUzel);  //Поиск по литрам
var a:PUzel; //текущий
    LitrKey:integer; //ключ для поиска
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   if TryStrToInt(InputBox('Поиск','Введите кол-во литро',''),LitrKey) then    //Считываем код покупки
      begin
         while a <> nil do  //проходим по списку
           begin
              if a^.x.Kol_l = LitrKey then   //если нашли соответсвие
                 begin
                 AddInSGSort(a);    //то выводим
                 Inc(fl); //увеличиваем
                 end;
              a:=a^.next; //Переходим к следующему элементу
           end;
       if (fl = 0)  then
          DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
     end
   else
      DefaultMessageBox('Что-то пошло не так, возможно вы что-то не правильно ввели','Ой, ошибочка вышла',0);

end;

procedure Find_AllPrice(var Head:PUzel);  //Поиск по Общей сумме
var a:PUzel; //текущий
    PriceKey:Currency; //ключ для поиска
    fl:integer;  //кол-во совпадений
begin
   fl:=0;
   a:=Head; //ставим в начало списка
   if TryStrToCurr(InputBox('Поиск','Введите сумму покупки',''),PriceKey) then    //Считываем код покупки
      begin
         while a <> nil do  //проходим по списку
           begin
              if abs(a^.x.All_Price - PriceKey) <= 50 then   //если нашли соответсвие
                 begin
                 AddInSGSort(a);    //то выводим
                 Inc(fl); //увеличиваем
                 end;
              a:=a^.next; //Переходим к следующему элементу
           end;
       if (fl = 0)  then
          DefaultMessageBox('Эхх... Не хотел вам это говорить, но видимо все таки придется. Я очень сожалею, но мы не смогли найти совпадений. Я ооооочень сожалею','Прошу извинить',0);
     end
   else
      DefaultMessageBox('Что-то пошло не так, возможно вы что-то не правильно ввели','Ой, ошибочка вышла',0);

end;




procedure DeleteSpace(var s:string);  //Удаление пробелов
var
     dlina,i:integer;
begin
  i:=1;
  dlina:=Length(s);   //считываем длину строки
  while  (s[i] = ' ') do //удаляем первые пробелы
  begin
    delete(s,i,1);
  end;
  while (i < dlina) do  //удаляем все остальные оставляя лишь один между словами
  begin
    if (s[i] = ' ') and (s[i+1] =  ' ') then
       begin
       Delete(s,i,2);
       dec(i);
       end;
      inc(i);
  end;
  if s[dlina] = ' ' then  //удаление последнего пробела после всех слов
     delete(s,dlina  , 1)
end;

finalization
DelSpisok(Head); //удаление


end.

