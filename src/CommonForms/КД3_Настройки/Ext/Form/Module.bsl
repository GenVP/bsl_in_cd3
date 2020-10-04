﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = КД3_Метаданные.ЗагрузитьНастройки();
	
	Тема = Настройки.Тема;
	НеЗагружатьМетаданные = Настройки.НеЗагружатьМетаданные;
	НеОтображатьКартуКода = Настройки.НеОтображатьКартуКода;
	ПодсветкаЯзыкаЗапросов = Настройки.ПодсветкаЯзыкаЗапросов;
	
	ИмяТемы = НовоеИмяТемы(Тема, ПодсветкаЯзыкаЗапросов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкиНаСервере();
	// Сохранение настроек в клиентском кэше
	КД3_МетаданныеКлиент.СохранитьНастройкиВКэше(ЭтотОбъект);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиНаСервере()
	
	Настройки = Новый Структура;
	Настройки.Вставить("ИмяТемы", ИмяТемы);
	Настройки.Вставить("Тема", Тема);
	Настройки.Вставить("ПодсветкаЯзыкаЗапросов", ПодсветкаЯзыкаЗапросов);
	Настройки.Вставить("НеЗагружатьМетаданные", НеЗагружатьМетаданные);
	Настройки.Вставить("НеОтображатьКартуКода", НеОтображатьКартуКода);
	
	КД3_Метаданные.СохранитьНастройки(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТемаПриИзменении(Элемент)
	
	ИмяТемы = НовоеИмяТемы(Тема, ПодсветкаЯзыкаЗапросов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсветкаЯзыкаЗапросовПриИзменении(Элемент)
	
	ИмяТемы = НовоеИмяТемы(Тема, ПодсветкаЯзыкаЗапросов);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НовоеИмяТемы(Тема, ПодсветкаЯзыкаЗапросов)
	
	Возврат Тема + ?(ПодсветкаЯзыкаЗапросов, "-query", "");
	
КонецФункции