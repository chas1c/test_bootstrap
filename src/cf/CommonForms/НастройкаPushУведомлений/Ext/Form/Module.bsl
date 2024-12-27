﻿&НаКлиенте
Процедура ЗагрузитьСертификат(Команда)
	ЗагрузитьСертификатЗавершение();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗагрузитьСертификатЗавершение()
	Попытка
		ОписаниеПомещенногоФайла = Ждать ПоместитьФайлНаСерверАсинх(,,,, УникальныйИдентификатор);
		Если Не ОписаниеПомещенногоФайла = Неопределено Тогда
			АдресСертификата = ОписаниеПомещенногоФайла.Адрес;
			СертификатЗагружен = Не ПустаяСтрока(АдресСертификата);
		КонецЕсли;
	Исключение
		Ждать ПредупреждениеАсинх(НСтр("ru='Ошибка помещения файла на сервер'", "ru"));
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если АдресСертификата <> "" Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресСертификата);
		Константы.СертификатМобильногоПриложенияIOS.Установить(Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных()));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Сертификат = Константы.СертификатМобильногоПриложенияIOS.Получить().Получить();
	СертификатЗагружен = ЗначениеЗаполнено(Сертификат);
	ИспользоватьPushУведомленияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьPushУведомленияПриИзменении(Элемент)
	ИспользоватьPushУведомленияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИспользоватьPushУведомленияПриИзмененииНаСервере()
	Если Объект.ИспользоватьPushУведомления = Перечисления.PushУведомления.ИспользоватьВспомогательныйСервис Тогда
		Элементы.Настройки.Видимость = Истина;
		Элементы.Настройки.ТекущаяСтраница = Элементы.Сервис;
		//Элементы.Локальные.Видимость = Ложь;
		//Элементы.Сервис.Видимость = Истина;
	ИначеЕсли Объект.ИспользоватьPushУведомления = Перечисления.PushУведомления.ОтправлятьНепосредственно Тогда
		Элементы.Настройки.Видимость = Истина;
		Элементы.Настройки.ТекущаяСтраница = Элементы.Локальные;
		//Элементы.Локальные.Видимость = Истина;
		//Элементы.Сервис.Видимость = Ложь;
	Иначе
		Элементы.Настройки.Видимость = Ложь;
		//Элементы.Локальные.Видимость = Ложь;
		//Элементы.Сервис.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЛогин(Команда)
	ПерейтиПоНавигационнойСсылке("https://pushnotifications.1c.com/push/publishers/new");
КонецПроцедуры

