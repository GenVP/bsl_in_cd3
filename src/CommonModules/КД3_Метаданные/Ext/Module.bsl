﻿// Создает дополнительные реквизиты для контекстной подсказки, создает на закладках обработчиков 
// элементы выбора конфигураций (источника или приемника) и поля HTML-документов
//
// Параметры:
//  Обработчики - Массив - массив имен реквизитов с текстом обработчиков
//
Процедура ПриСозданииНаСервере(Обработчики, Форма, Объект, Отказ) Экспорт
	
	ТипСтрока = Новый ОписаниеТипов("Строка");
	ДобавляемыРеквизиты = Новый Массив;
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_Обработчики", Новый ОписаниеТипов("СписокЗначений")));
	ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_Конфигурация", Новый ОписаниеТипов("СправочникСсылка.Конфигурации")));
	Для Каждого ИмяОбработчика Из Обработчики Цикл
		ДобавляемыРеквизиты.Добавить(Новый РеквизитФормы("КД3_" + ИмяОбработчика, ТипСтрока));
	КонецЦикла;
	Форма.ИзменитьРеквизиты(ДобавляемыРеквизиты, Новый Массив);
	
	ДоступныеКонфигурации = ПолучитьКонфигурации(Форма.СписокКонвертаций);
	
	Для Каждого ИмяОбработчика Из Обработчики Цикл
		
		ЭлементЭталон = Форма.Элементы[ИмяОбработчика];
		ЭлементЭталон.Видимость = Ложь;
		
		Элемент = Форма.Элементы.Добавить("КД3_Конфигурация_" + ИмяОбработчика, Тип("ПолеФормы"), ЭлементЭталон.Родитель);
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "КД3_Конфигурация";
		Элемент.Заголовок = "Конфигурация контекстной подсказки";
		Элемент.УстановитьДействие("ПриИзменении", "КД3_ПриИзмененииКонфигурации");
		Элемент.СписокВыбора.ЗагрузитьЗначения(ДоступныеКонфигурации);
		Элемент.РежимВыбораИзСписка = Истина;
		Если ДоступныеКонфигурации.Количество() > 0 Тогда
			Форма["КД3_Конфигурация"] = ДоступныеКонфигурации[0];
		КонецЕсли;
		
		Элемент = Форма.Элементы.Добавить("КД3_" + ИмяОбработчика, Тип("ПолеФормы"), ЭлементЭталон.Родитель);
		Элемент.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элемент.ПутьКДанным = "КД3_" + ИмяОбработчика;
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элемент.УстановитьДействие("ДокументСформирован", "КД3_ДокументСформирован");
		Элемент.УстановитьДействие("ПриНажатии", "КД3_HTMLПриНажатии");
		
	КонецЦикла;
	
	Форма["КД3_Обработчики"].ЗагрузитьЗначения(Обработчики);
	
КонецПроцедуры

// Вызывается при изменения конвертаций в которые входит объект
// Изменяет доступные для выбора конфигурации связанные с подкчказкой
//
Процедура ПриИзмененииКонвертаций(Форма, Объект) Экспорт
	
	ДоступныеКонфигурации = ПолучитьКонфигурации(Форма.СписокКонвертаций);
	Для Каждого ЭлементСписка Из Форма["КД3_Обработчики"] Цикл
		ИмяОбработчика = ЭлементСписка.Значение;
		Элемент = Форма.Элементы["КД3_Конфигурация_" + ИмяОбработчика];
		Элемент.СписокВыбора.ЗагрузитьЗначения(ДоступныеКонфигурации);
		Если ДоступныеКонфигурации.Найти(Форма["КД3_Конфигурация"]) = Неопределено Тогда
			Если ДоступныеКонфигурации.Количество() = 0 Тогда
				Форма["КД3_Конфигурация"] = ПредопределенноеЗначение("Справочник.Конфигурации.ПустаяСсылка");
			Иначе
				Форма["КД3_Конфигурация"] = ДоступныеКонфигурации[0];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает конфигурации в переданный список конвертаций
//
// Параметры:
//  СписокКонвертаций - СписокЗначений - список конвертаций
//
// Возвращаемое значение:
//  Массив - массив конфигураций
//
Функция ПолучитьКонфигурации(СписокКонвертаций) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Конвертации.Конфигурация КАК Конфигурация
	|ИЗ
	|	Справочник.Конвертации КАК Конвертации
	|ГДЕ
	|	Конвертации.Ссылка В(&СписокКонвертаций)";
	Запрос.УстановитьПараметр("СписокКонвертаций", СписокКонвертаций);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Конфигурации = Новый Массив;
	Иначе
		Конфигурации = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Конфигурация");
	КонецЕсли;
	
	Возврат Конфигурации;
	
КонецФункции

Функция ПолучитьФайлМакетаИсходников() Экспорт
	Возврат ПоместитьВоВременноеХранилище(ПолучитьОбщийМакет("КД3_src"));
КонецФункции

// Возвращает сохраненные описания по метаданным конфигурации
// Метаданные генерируются в ЗагрузитьОписаниеМетаданных()
// 
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//
// Возвращаемое значение:
//  Строка - адрес во временном хранилище сохраненных метаданных
//
Функция КоллекцияМетаданных(Конфигурация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БезопасноеХранилищеДанных.Данные КАК Данные
	|ИЗ
	|	РегистрСведений.БезопасноеХранилищеДанных КАК БезопасноеХранилищеДанных
	|ГДЕ
	|	БезопасноеХранилищеДанных.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", КлючКэшаНастроек(Конфигурация));
	РезультатЗапроса = Запрос.Выполнить();
	
	МетаданныеJSON = Неопределено;
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			МетаданныеJSON = Выборка.Данные.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Если МетаданныеJSON = Неопределено Тогда
		ЗагрузитьОписаниеМетаданных(Конфигурация, МетаданныеJSON);
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(МетаданныеJSON);
	
КонецФункции

// Возвращает ключ под которым сохраняются описания метаданных конфигурации в кэше
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//
// Возвращаемое значение:
//  Строка - ключ настроек
//
Функция КлючКэшаНастроек(Конфигурация)
	
	Возврат "КД3_" + XMLСтрока(Конфигурация);
	
КонецФункции

// Выполняет заполнение описания метаданных по метаданным загруженным в КД3
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - конфигурация
//  МетаданныеJSON - Строка - если передана переменная, то в нее
//                            помещается строка JSON с описание метаданных
//
Процедура ЗагрузитьОписаниеМетаданных(Конфигурация, МетаданныеJSON) Экспорт
	
	КорневыеТипы = Новый Соответствие;
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Справочник, "Справочник");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Документ, "Документ");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрСведений, "РегистрСведений");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрНакопления, "РегистрНакопления");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.РегистрБухгалтерии, "РегистрБухгалтерии");
	КорневыеТипы.Вставить(Перечисления.ТипыОбъектов.Перечисление, "Перечисление");
	
	КоллекцияМетаданных = Новый Структура;
	КоллекцияМетаданных.Вставить("catalogs", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "Справочники", КорневыеТипы));
	КоллекцияМетаданных.Вставить("documents", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "Документы", КорневыеТипы));
	КоллекцияМетаданных.Вставить("infoRegs", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "РегистрыСведений", КорневыеТипы));
	КоллекцияМетаданных.Вставить("accumRegs", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "РегистрыНакопления", КорневыеТипы));
	КоллекцияМетаданных.Вставить("accountRegs", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "РегистрыБухгалтерии", КорневыеТипы));
	//КоллекцияМетаданных.Вставить("dataProc", ОписатьКоллекциюОбъектовМетаданых(Метаданные.Обработки));
	//КоллекцияМетаданных.Вставить("reports", ОписатьКоллекциюОбъектовМетаданых(Метаданные.Отчеты));
	КоллекцияМетаданных.Вставить("enums", ОписатьКоллекциюОбъектовМетаданых(Конфигурация, "Перечисления", КорневыеТипы));
	
	Файл = Новый ЗаписьJSON();
	Файл.УстановитьСтроку();
	Попытка
		ЗаписатьJSON(Файл, КоллекцияМетаданных);
		МетаданныеJSON = Файл.Закрыть();
	Исключение
		МетаданныеJSON = "";
		ТекстСообщения = "Не удалось сохранить коллекцию метаданных:" + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
	МенеджерЗаписи = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Владелец = КлючКэшаНастроек(Конфигурация);
	МенеджерЗаписи.Данные = Новый ХранилищеЗначения(МетаданныеJSON);
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		ТекстСообщения = "Не удалось сохранить метаданные конфигурации в ИБ" + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	
КонецПроцедуры

Функция ОписатьКоллекциюОбъектовМетаданых(Конфигурация, Коллекция, КорневыеТипы)
	
	ОписаниеКоллекции = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя,
	|	Объекты.Тип КАК Тип
	|ПОМЕСТИТЬ Объекты
	|ИЗ
	|	Справочник.Объекты КАК Объекты
	|ГДЕ
	|	Объекты.Родитель В
	|			(ВЫБРАТЬ
	|				Объекты.Ссылка КАК Ссылка
	|			ИЗ
	|				Справочник.Объекты КАК Объекты
	|			ГДЕ
	|				Объекты.Владелец = &Конфигурация
	|				И Объекты.Наименование = &Коллекция)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Ссылка КАК Ссылка,
	|	Объекты.Имя КАК Имя,
	|	Объекты.Тип КАК Тип
	|ИЗ
	|	Объекты КАК Объекты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Значения.Владелец КАК Объект,
	|	Значения.Ссылка КАК Ссылка,
	|	Значения.Наименование КАК Наименование,
	|	Значения.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Значения КАК Значения
	|ГДЕ
	|	Значения.Владелец В
	|			(ВЫБРАТЬ
	|				Объекты.Ссылка
	|			ИЗ
	|				Объекты)
	|ИТОГИ ПО
	|	Объект
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Свойства.Владелец КАК Объект,
	|	Свойства.Вид КАК Вид,
	|	Свойства.Ссылка КАК Ссылка,
	|	Свойства.Наименование КАК Наименование,
	|	Свойства.Синоним КАК Синоним
	|ИЗ
	|	Справочник.Свойства КАК Свойства
	|ГДЕ
	|	Свойства.Владелец В
	|			(ВЫБРАТЬ
	|				ОБъекты.Ссылка
	|			ИЗ
	|				ОБъекты)
	|ИТОГИ ПО
	|	Объект,
	|	Вид";
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("Коллекция", Коллекция);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаОбъектМетаданных = РезультатЗапроса[1].Выбрать();
	ВыборкаЗначенияОбъектов = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаСвойстваОбъектов = РезультатЗапроса[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОбъектМетаданных.Следующий() Цикл
		
		ОписаниеРеквизитов = Новый Структура();
		
		КорневойТип = КорневыеТипы[ВыборкаОбъектМетаданных.Тип];
		ПолноеИмя = КорневойТип + "." + ВыборкаОбъектМетаданных.Имя;
		
		Если КорневойТип = "Перечисление" ИЛИ КорневойТип = "Справочник" Тогда
			Если ВыборкаЗначенияОбъектов.НайтиСледующий(ВыборкаОбъектМетаданных.Ссылка, "Объект") Тогда
				Выборка = ВыборкаЗначенияОбъектов.Выбрать();
				Пока Выборка.Следующий() Цикл
					Если НЕ ПустаяСтрока(Выборка.Наименование) Тогда
						ОписаниеРеквизитов.Вставить(Выборка.Наименование, Выборка.Синоним);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ВыборкаСвойстваОбъектов.НайтиСледующий(ВыборкаОбъектМетаданных.Ссылка, "Объект") Тогда
			ВыборкаВидыСвойств = ВыборкаСвойстваОбъектов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			ВидыСвойств = Новый Массив;
			ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Реквизит);
			Если КорневойТип = "РегистрСведений" ИЛИ КорневойТип = "РегистрНакопления" ИЛИ КорневойТип = "РегистрБухгалтерии" Тогда
				ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Измерение);
				ВидыСвойств.Добавить(Перечисления.ВидыСвойств.Ресурс);
			КонецЕсли;
			
			Для Каждого ВидСвойства Из ВидыСвойств Цикл
				Если ВыборкаВидыСвойств.НайтиСледующий(ВидСвойства, "Вид") Тогда
					Выборка = ВыборкаВидыСвойств.Выбрать();
					Пока Выборка.Следующий() Цикл
						ОписаниеРеквизитов.Вставить(Выборка.Наименование, Выборка.Синоним);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ОписаниеКоллекции.Вставить(ВыборкаОбъектМетаданных.Имя, Новый Структура("properties", ОписаниеРеквизитов));
		
	КонецЦикла;
	
	Возврат ОписаниеКоллекции;
	
КонецФункции

// Возвращает текущую версию компоненты в макете
//
Функция ВерсияИсходников() Экспорт
	Возврат СтрЗаменить(Метаданные.ОбщиеМакеты.КД3_src.Комментарий, ".", "_");
КонецФункции
