﻿
&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Обработчики = Новый Массив;
	Обработчики.Добавить("АлгоритмПриОбработке");
	Обработчики.Добавить("АлгоритмВыборкаДанных");
	
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
Процедура КД3_СтраницыПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОбработке Тогда
		ИмяОбработчика = "АлгоритмПриОбработке";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ВыборкаДанных Тогда
		ИмяОбработчика = "АлгоритмВыборкаДанных";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ДокументСформирован(Элемент)
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя);
	КД3_МетаданныеКлиент.ОбновитьМетаданные(ЭтотОбъект, ИмяОбработчика);
	КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПриИзмененииКонфигурации(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданные(ЭтотОбъект);
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
