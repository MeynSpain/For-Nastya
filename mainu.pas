unit MainU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  GasStationUnit, FillingUnit; //2 моих модуля основной и форма заполнения

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuIFile: TMenuItem;
    MenuFileCreatetxt: TMenuItem;
    MenuFileCreateTip: TMenuItem;
    MenuFileSaveTip: TMenuItem;
    MenuFileSaveTxt: TMenuItem;
    MenuSPFindAllPrice: TMenuItem;
    MenuSPFindKol_l: TMenuItem;
    MenuSPFindFuel: TMenuItem;
    MenuSPFindOtch: TMenuItem;
    MenuSPFindName: TMenuItem;
    MenuSPFindFam: TMenuItem;
    MenuSPFindCod: TMenuItem;
    MenuSpFind: TMenuItem;
    MenuSortLitr: TMenuItem;
    MenuSortAllPrice: TMenuItem;
    MenuSortPrice_l: TMenuItem;
    MenuSortFuel: TMenuItem;
    MenuSortCod: TMenuItem;
    MenuSortOtch: TMenuItem;
    MenuSortName: TMenuItem;
    MenuSortFam: TMenuItem;
    MenuSpDel: TMenuItem;
    MenuSortFIO: TMenuItem;
    MenuSort: TMenuItem;
    MenuSpCreate: TMenuItem;
    MenuSp: TMenuItem;
    MenuFileOpenTip: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SGMain: TStringGrid;
    SGSort: TStringGrid;
    procedure MenuFileCreatetxtClick(Sender: TObject);
    procedure MenuFileCreateTipClick(Sender: TObject);
    procedure MenuFileOpenTipClick(Sender: TObject);
    procedure MenuFileSaveTipClick(Sender: TObject);
    procedure MenuFileSaveTxtClick(Sender: TObject);
    procedure MenuSortAllPriceClick(Sender: TObject);
    procedure MenuSortCodClick(Sender: TObject);
    procedure MenuSortFamClick(Sender: TObject);
    procedure MenuSortFIOClick(Sender: TObject);
    procedure MenuSortFuelClick(Sender: TObject);
    procedure MenuSortLitrClick(Sender: TObject);
    procedure MenuSortNameClick(Sender: TObject);
    procedure MenuSortOtchClick(Sender: TObject);
    procedure MenuSortPrice_lClick(Sender: TObject);
    procedure MenuSpCreateClick(Sender: TObject);
    procedure MenuSpDelClick(Sender: TObject);
    procedure MenuSPFindAllPriceClick(Sender: TObject);
    procedure MenuSPFindCodClick(Sender: TObject);
    procedure MenuSPFindFamClick(Sender: TObject);
    procedure MenuSPFindFuelClick(Sender: TObject);
    procedure MenuSPFindKol_lClick(Sender: TObject);
    procedure MenuSPFindNameClick(Sender: TObject);
    procedure MenuSPFindOtchClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

  Head:PUzel;  //голова списка
  f:GASFile; //переменная типизированного файла
  FName:String; //Имя файла
  t:TextFile; //Текстовая переменая

implementation



{$R *.lfm}

{ TMainForm }

procedure TMainForm.MenuFileCreatetxtClick(Sender: TObject);
begin
  CreateTxTFile(t);
end;

procedure TMainForm.MenuFileCreateTipClick(Sender: TObject); //Создание типизированного файла
begin
   CreateTipFile(f, FName);
end;

procedure TMainForm.MenuFileOpenTipClick(Sender: TObject);//Создание списка из типизированного файла
begin
  if SaveDialog1.Execute then       //Вызываем SaveDialog
     FName:=SaveDialog1.FileName;
  if (FName = '') or (FName = ' ') then     //Если не выбрали, то выводим сообщение
     DefaultMessageBox('Что то пошло не так, возможно вы файлик не выбрали','Ой, ошибочка вышла',0)
  else
      begin      //Если все хорошо,то
         AssignFile(f,FName); //Связываем файлик
         BuildFromFile(f,Head); //загружаем из файла
      end;
end;

procedure TMainForm.MenuFileSaveTipClick(Sender: TObject);  //Сохранение в типизированный файл
begin
   if SaveDialog1.Execute then       //Вызываем SaveDialog
     FName:=SaveDialog1.FileName;
  if (FName = '') or (FName = ' ') then     //Если не выбрали, то выводим сообщение
     DefaultMessageBox('Что то пошло не так, возможно вы файлик не выбрали','Ой, ошибочка вышла',0)
  else
      begin      //Если все хорошо,то
         AssignFile(f,FName); //Связываем файлик
         SaveSPinTipFile(f,Head);   // сохраняем
      end;
end;

procedure TMainForm.MenuFileSaveTxtClick(Sender: TObject); //Сохранение в текстовый файл
begin
    SaveInTxt(t, Head);
end;

procedure TMainForm.MenuSortAllPriceClick(Sender: TObject); //сортировка по цене за все
begin
  Sort_AllPrice(Head);
end;

procedure TMainForm.MenuSortCodClick(Sender: TObject);//Сортировать по коду покупки
begin
  Sort_Cod(Head);
end;

procedure TMainForm.MenuSortFamClick(Sender: TObject);//сортировка по фамилии
begin
  Sort_Fam(Head);
end;

procedure TMainForm.MenuSortFIOClick(Sender: TObject); //Сортировка по ФИО
begin
  Sort_FIO(Head);
end;

procedure TMainForm.MenuSortFuelClick(Sender: TObject);//Сортировать по Виду топлива
begin
  Sort_Fuel(Head);
end;

procedure TMainForm.MenuSortLitrClick(Sender: TObject); //Сортировка по кол-ву литров
begin
  Sort_Kol_l(Head);
end;

procedure TMainForm.MenuSortNameClick(Sender: TObject);  //сортировка по имени
begin
  Sort_Name(Head);
end;

procedure TMainForm.MenuSortOtchClick(Sender: TObject); //Сортировка по Отчеству
begin
  Sort_Otch(Head);
end;

procedure TMainForm.MenuSortPrice_lClick(Sender: TObject);//сортировка по цене за литр
begin
  Sort_Price_l(Head);
end;

procedure TMainForm.MenuSpCreateClick(Sender: TObject);//переход к форме заполнения
begin
  FormFilling.Visible:=true;
end;

procedure TMainForm.MenuSpDelClick(Sender: TObject); //Удаление списка
begin
  DelSpisok(Head); //удаляем список
  SGMain.RowCount:=1; //и очищаем главную табличку
  SGSort.RowCount:=1; //И вторую
end;

procedure TMainForm.MenuSPFindAllPriceClick(Sender: TObject);//Поиск по общей сумме покупки
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_AllPrice(Head); //И ищем
end;

procedure TMainForm.MenuSPFindCodClick(Sender: TObject); //Поиск по коду покупки
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Cod(Head);  //И ищем
end;

procedure TMainForm.MenuSPFindFamClick(Sender: TObject); //Поиск по фамилии
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Fam(Head);  //И ищем
end;

procedure TMainForm.MenuSPFindFuelClick(Sender: TObject); //Поиск по топливу
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Fuel(Head); //И ищем
end;

procedure TMainForm.MenuSPFindKol_lClick(Sender: TObject);//Поиск по литражу
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Kol_l(Head); //И ищем
end;

procedure TMainForm.MenuSPFindNameClick(Sender: TObject);  //Поиск по Имени
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Name(Head); //И ищем
end;

procedure TMainForm.MenuSPFindOtchClick(Sender: TObject); //Поиск по отчеству
begin
  SGSort.RowCount:=1;//очищаем первую табличку
  Find_Otch(Head); //И ищем
end;

end.

