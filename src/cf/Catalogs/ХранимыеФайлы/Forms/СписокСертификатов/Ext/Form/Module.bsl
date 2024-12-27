﻿
&НаКлиенте
Перем СоответствиеСертификатов;

&НаКлиенте
Перем ПараметрыВыбора;

&НаКлиенте
Перем ВыбраныйСертификат;

//////////////////////////////////////////////////////////////////////////////// 
// Общие процедуры и функции 
// 

// определяет типы хранилищ сертификатов, сертификаты которых требуется поместить в список
// ПараметрыВыбора_Вход - список типов хранилищ сертификатов
&НаКлиенте
Процедура Установка(ПараметрыВыбора_Вход) Экспорт

	ПараметрыВыбора = ПараметрыВыбора_Вход;

КонецПроцедуры

// возвращает результаты выбора в форме
&НаКлиенте
Функция ПолучитьРезультатВыбора()

	Если Параметры.МножественныйВыбор Тогда
		ВыбранныеСертификаты = Новый Массив;
		Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаДляВыбора.ПолучитьСтрокиДляОбработки() Цикл
			ВыбранныеСертификаты.Добавить(СоответствиеСертификатов[ТаблицаДляВыбора[ВыделеннаяСтрока]]);
		КонецЦикла;
		Возврат ВыбранныеСертификаты;
	Иначе
		Возврат ВыбраныйСертификат;
	КонецЕсли;	

КонецФункции

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьСертификатыПриОткрытии();

КонецПроцедуры

&НаКлиенте
Асинх Процедура УстановитьСертификатыПриОткрытии()

	СоответствиеСертификатов = Новый Соответствие;
	// Заполнение таблицы сертификатов
	МенеджерКриптографии = Новый МенеджерКриптографии();
	Попытка
		ИнициализированныйМенеджерКриптографии = Ждать МенеджерКриптографии.ИнициализироватьАсинх("", "", 75);
	Исключение
		Сообщить(НСтр("ru='Ошибка инициализации менеджера криптографии'", "ru"));
		Возврат;
	КонецПопытки;
	Контекст = Новый Структура(
		"МенеджерКриптографии, ХранилищеПолучено", 
		МенеджерКриптографии, Новый Массив());	
	УстановитьСледующееХранилищеСертификатов(, Контекст); 
#Если НЕ МобильныйКлиент Тогда
	Элементы.ФормаПоказатьСписок.Видимость = Ложь;
#Иначе
	Элементы.ФормаПоказатьСписок.Видимость = Истина;
#КонецЕсли

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ТаблицаДляВыбора.МножественныйВыбор = Параметры.МножественныйВыбор;
	Элементы.ТаблицаДляВыбора.РежимВыделения = ?(Параметры.МножественныйВыбор, РежимВыделенияТаблицы.Множественный, РежимВыделенияТаблицы.Одиночный);
	Если Параметры.МножественныйВыбор Тогда
		Заголовок = НСтр("ru = 'Список сертификатов получателей'", "ru");
	Иначе
		Заголовок = НСтр("ru = 'Сертификат для создания подписи'", "ru");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Не Параметры.МножественныйВыбор Тогда
		СтандартнаяОбработка = Ложь;
		Если Не ВыбраннаяСтрока = Неопределено Тогда 
			ВыбраныйСертификат = СоответствиеСертификатов[ТаблицаДляВыбора[ВыбраннаяСтрока]];
			Закрыть(ВыбраныйСертификат);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляВыбораПриИзмененииСоставаВыделенныхСтрок(Элемент)

	Элементы.ОсуществлениеВыбора.Доступность = Элементы.ТаблицаДляВыбора.ПолучитьСтрокиДляОбработки().Количество() > 0;

КонецПроцедуры

&НаКлиенте
Процедура ОсуществлениеВыбораНажатие(Команда)

	Если Параметры.МножественныйВыбор Тогда
		Закрыть(ПолучитьРезультатВыбора());
	Иначе
		ТекущиеДанные = Элементы.ТаблицаДляВыбора.ТекущиеДанные;
		Если Не ТекущиеДанные = Неопределено Тогда 
			ВыбраныйСертификат = СоответствиеСертификатов[ТекущиеДанные];
			Закрыть(ВыбраныйСертификат);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСписок(Команда)

#Если МобильныйКлиент Тогда 
	УстановитьСертификатыПриПоказеСписка();
#КонецЕсли

КонецПроцедуры

#Если МобильныйКлиент Тогда 

&НаКлиенте
Асинх Процедура УстановитьСертификатыПриПоказеСписка()

	МенеджерКриптографии = Новый МенеджерКриптографии();
	Попытка
		ИнициализированныйМенеджерКриптографии = Ждать МенеджерКриптографии.ИнициализироватьАсинх("", "", 1);
	Исключение
		Сообщить(НСтр("ru='Ошибка инициализации менеджера криптографии'", "ru"));
		Возврат;
	КонецПопытки;
	// проверяем, что этим сертификатом файл еще не подписан
	Контекст = Новый Структура(
		"МенеджерКриптографии, ХранилищеПолучено", 
		МенеджерКриптографии, Новый Массив());	
	Оповещение = Новый ОписаниеОповещения(
		"ПолучитьСертификатыПослеЗакрытияСпискаСертификатов",
		ЭтотОбъект,
		Контекст);
	МенеджерКриптографии.ПоказатьСписокСертификатов(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификатыПослеЗакрытияСпискаСертификатов(Контекст) Экспорт	

	ТаблицаДляВыбора.Очистить();
	УстановитьСледующееХранилищеСертификатов(, Контекст); 

КонецПроцедуры

#КонецЕсли

&НаКлиенте
Асинх Процедура УстановитьСледующееХранилищеСертификатов(Хранилище, Контекст) Экспорт	

	Если Хранилище <> Неопределено Тогда
		Контекст.ХранилищеПолучено.Добавить(Истина);
		СертификатыХранилища = Ждать Хранилище.ПолучитьВсеАсинх();
		ТекущаяДата = ТекущаяДата();
		Для Каждого Сертификат Из СертификатыХранилища Цикл
			Если Сертификат.ДатаОкончания < ТекущаяДата Тогда 
				Продолжить; // отфильтровываем истекшие сертификаты
			КонецЕсли;
			НоваяСтрока = ТаблицаДляВыбора.Добавить();
			СоответствиеСертификатов.Вставить(НоваяСтрока, Сертификат);
			НоваяСтрока.СертификатПредставление = Сертификат.Субъект.CN + НСтр("ru = ' выдан '", "ru") + Сертификат.Издатель.CN + НСтр("ru = ' действителен до '", "ru") + Сертификат.ДатаОкончания;
			НоваяСтрока.ТипХранилища = Контекст.Представление;
		КонецЦикла;
	КонецЕсли;
	Если Контекст.ХранилищеПолучено.Количество() = ПараметрыВыбора.Количество() Тогда
		Возврат;
	КонецЕсли;
	ТекущееХраналище = ПараметрыВыбора[Контекст.ХранилищеПолучено.Количество()];
	Контекст2 =  Новый Структура(
		"МенеджерКриптографии, ХранилищеПолучено, Представление", 
		Контекст.МенеджерКриптографии, Контекст.ХранилищеПолучено, Строка(ТекущееХраналище));
	Хранилище = Ждать Контекст.МенеджерКриптографии.ПолучитьХранилищеСертификатовАсинх(ТекущееХраналище.Значение);
	УстановитьСледующееХранилищеСертификатов(Хранилище, Контекст2);

КонецПроцедуры

