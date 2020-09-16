﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Обработчики = Новый Массив;
	Обработчики.Добавить("АлгоритмПриОтправкеДанных");
	Обработчики.Добавить("АлгоритмПередПолучениемДанных");
	Обработчики.Добавить("АлгоритмПриПолученииДанных");
	
	КД3_Метаданные.ПриСозданииНаСервере(Обработчики, ЭтотОбъект, Объект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриОткрытииПосле(Отказ)
	КД3_МетаданныеКлиент.ПриОткрытии(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Объект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗакрытиемПосле(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Объект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ДокументСформирован(Элемент)
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ОбновитьМетаданные(ЭтотОбъект, ИмяОбработчика);
	КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриИзмененииКонфигурации(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданные(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОтправке Тогда
		ИмяОбработчика = "АлгоритмПриОтправкеДанных";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриКонвертацииДанныхXDTO Тогда
		ИмяОбработчика = "АлгоритмПередПолучениемДанных";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПередЗаписьюПолученныхДанных Тогда
		ИмяОбработчика = "АлгоритмПриПолученииДанных";
	Иначе
		Возврат;
	КонецЕсли;
	
	// Инициализация загрузки страницы и метаданных обработчика как только он станет видимым
	ИмяРеквизита = "КД3_" + ИмяОбработчика;
	Если ЭтотОбъект[ИмяРеквизита] = "" Тогда
		ЭтотОбъект[ИмяРеквизита] = КД3_Кэш()["КаталогИсходников"] + ИмяОбработчика + "\" + "index.html";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ВызватьКонструкторФорматнойСтроки(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры

&НаСервере
&После("ОбработкаВыбораНаСервере")
Процедура КД3_ОбработкаВыбораНаСервере()
	КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, Объект);
КонецПроцедуры

&НаСервере
&После("ДополнитьСоставКонвертации")
Процедура КД3_ДополнитьСоставКонвертации(Конвертация, ЭлементКонвертации, ОтказДобавления)
	Если НЕ ОтказДобавления Тогда
		КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, Объект);
	КонецЕсли;
КонецПроцедуры
