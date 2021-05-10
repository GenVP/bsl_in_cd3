﻿
&НаКлиенте
Перем КД3_ИзмененныйРеквизит Экспорт;

&НаСервере
Процедура КД3_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Обработчики = Новый СписокЗначений;
	
	Если ЭтоКонвертацияXDTO Тогда
		Обработчики.Добавить("АлгоритмПриОтправкеДанных");
		Обработчики.Добавить("АлгоритмПередПолучениемДанных");
		Обработчики.Добавить("АлгоритмПриПолученииДанных");
		Обработчики.Добавить("АлгоритмПослеЗагрузкиВсехДанныхТекст");
		СтраницыОбработчиков = Элементы.ОбработчикиXDTO;
	Иначе
		Обработчики.Добавить("АлгоритмПередВыгрузкойОбъекта");
		Обработчики.Добавить("АлгоритмПриВыгрузкеОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъекта");
		Обработчики.Добавить("АлгоритмПослеВыгрузкиОбъектаВФайлОбмена");
		Обработчики.Добавить("АлгоритмПоследовательностьПолейПоиска", , Истина);
		Обработчики.Добавить("АлгоритмПередЗагрузкойОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПриЗагрузкеОбъекта", , Истина);
		Обработчики.Добавить("АлгоритмПослеЗагрузкиОбъекта", , Истина);
		СтраницыОбработчиков = Элементы.ОбработчикиXML;
	КонецЕсли;
	КД3_Метаданные.ПриСозданииНаСервере(ЭтотОбъект, Отказ, ЭтоКонвертацияXDTO, Обработчики, СтраницыОбработчиков);
	
	Если ЭтоКонвертацияXDTO И НЕ Объект.ИспользоватьДляОтправки Тогда
		// Исправление текущей страницы на видимую при этих условиях
		Элементы.ОбработчикиXDTO.ТекущаяСтраница = Элементы.Страница_ПриКонвертацииДанныхXDTO;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ПередЗаписьюПеред(Отказ, ПараметрыЗаписи)
	КД3_МетаданныеКлиент.ПередЗаписью(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура КД3_СтраницыПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ОбработчикиXDTO Тогда
		КД3_ОбработчикиXDTOПриСменеСтраницыПосле(Элементы.ОбработчикиXDTO, Элементы.ОбработчикиXDTO.ТекущаяСтраница)
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ОбработчикиXML Тогда
		КД3_ОбработчикиXMLПриСменеСтраницыПосле(Элементы.ОбработчикиXML, Элементы.ОбработчикиXML.ТекущаяСтраница);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ОбработчикиXDTOПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОтправке Тогда
		ИмяОбработчика = "АлгоритмПриОтправкеДанных";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриКонвертацииДанныхXDTO Тогда
		ИмяОбработчика = "АлгоритмПередПолучениемДанных";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПередЗаписьюПолученныхДанных Тогда
		ИмяОбработчика = "АлгоритмПриПолученииДанных";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеЗагрузкиВсехДанных Тогда
		ИмяОбработчика = "АлгоритмПослеЗагрузкиВсехДанныхТекст";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_ОбработчикиXMLПриСменеСтраницыПосле(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.Страница_ПередВыгрузкой Тогда
		ИмяОбработчика = "АлгоритмПередВыгрузкойОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриВыгрузке Тогда
		ИмяОбработчика = "АлгоритмПриВыгрузкеОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеВыгрузки Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеВыгрузкиВФайл Тогда
		ИмяОбработчика = "АлгоритмПослеВыгрузкиОбъектаВФайлОбмена";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПоляПоиска Тогда
		ИмяОбработчика = "АлгоритмПоследовательностьПолейПоиска";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПередЗагрузкой Тогда
		ИмяОбработчика = "АлгоритмПередЗагрузкойОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриЗагрузке Тогда
		ИмяОбработчика = "АлгоритмПриЗагрузкеОбъекта";
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПослеЗагрузки Тогда
		ИмяОбработчика = "АлгоритмПослеЗагрузкиОбъекта";
	Иначе
		Возврат;
	КонецЕсли;
	КД3_МетаданныеКлиент.ПриСменеСтраницы(ЭтотОбъект, ИмяОбработчика);
	
КонецПроцедуры

&НаКлиенте
Процедура КД3_АлгоритмПослеЗагрузкиВсехДанныхПриИзмененииПосле(Элемент)
	КД3_МетаданныеКлиент.УстановитьТекстПриТолькоПросмотр(ЭтотОбъект,
		"КД3_АлгоритмПослеЗагрузкиВсехДанныхТекст", АлгоритмПослеЗагрузкиВсехДанныхТекст);
КонецПроцедуры

&НаСервере
&После("ОбработкаВыбораНаСервере")
Процедура КД3_ОбработкаВыбораНаСервере()
	КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, ЭтоКонвертацияXDTO);
КонецПроцедуры

&НаСервере
&После("ДополнитьСоставКонвертации")
Процедура КД3_ДополнитьСоставКонвертации(Конвертация, ЭлементКонвертации, ОтказДобавления)
	Если НЕ ОтказДобавления Тогда
		КД3_Метаданные.ПриИзмененииКонвертаций(ЭтотОбъект, ЭтоКонвертацияXDTO);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
&После("УстановитьВидимость")
Процедура КД3_УстановитьВидимость()
	Если ЭтоКонвертацияXDTO Тогда
		Элементы.АлгоритмПослеЗагрузкиВсехДанныхТекст.Видимость = Ложь;
		Элементы.КД3_АлгоритмПослеЗагрузкиВсехДанныхТекст.Видимость = ЗначениеЗаполнено(АлгоритмПослеЗагрузкиВсехДанныхСсылка)
			И ПоказатьТекстАлгоритмаПослеЗагрузкиВсехДанных;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурации(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ПриИзмененииКонфигурацииКорреспондента(Элемент)
	КД3_МетаданныеКлиент.ОбновитьМетаданныеКонфигурации(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_ДокументСформирован(Элемент)
	ИмяОбработчика = Сред(Элемент.Имя, 5);
	КД3_МетаданныеКлиент.ИнициализацияРедактора(ЭтотОбъект, Элемент.Имя);
	Если Элемент.ТолькоПросмотр Тогда
		КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, ЭтотОбъект[ИмяОбработчика]);
		КД3_МетаданныеКлиент.УстановитьТолькоПросмотр(ЭтотОбъект, Элемент.Имя, Истина);
	Иначе
		КД3_МетаданныеКлиент.ОповещатьОбИзменениях(ЭтотОбъект, Элемент.Имя);
		КД3_МетаданныеКлиент.УстановитьТекст(ЭтотОбъект, Элемент.Имя, Объект[ИмяОбработчика]);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КД3_Подключаемый_HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	КД3_МетаданныеКлиент.ОбработатьСобытиеHTML(ЭтотОбъект, Элемент, ДанныеСобытия);
КонецПроцедуры
