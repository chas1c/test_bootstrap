﻿
&НаКлиенте
Процедура ПоказатьПрайсЛист(Команда)
	ТабличныйДокумент = ПечатнаяФормаПрайсЛиста();
	Если ТабличныйДокумент <> Неопределено Тогда
		ТабличныйДокумент.Показать(НСтр("ru = 'Прайс-лист'", "ru"));
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПечатнаяФормаПрайсЛиста()
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Истина;
	ТабличныйДокумент.ОтображатьЗаголовки = Истина;
	
	Сформирован = Ложь;
	ТабМакет = Справочники.Товары.ПолучитьМакет("МакетПрайсЛиста"); 

	Шапка = ТабМакет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(Шапка);

	ОбластьНоменклатура = ТабМакет.ПолучитьОбласть("ОбластьНоменклатура");
	
	Запрос = Новый Запрос;
    Запрос.Текст =  "ВЫБРАТЬ
                    |    Товары.Код КАК Код,
                    |    Товары.Наименование КАК Наименование,
                    |    Товары.Артикул КАК Артикул,
                    |    Товары.ФайлКартинки КАК Картинка,
                    |    Товары.Описание КАК Описание,
                    |    Товары.Вид КАК Вид,
                    |    ЦеныТоваров.Цена КАК Цена
                    |ИЗ
                    |    РегистрСведений.ЦеныТоваров КАК ЦеныТоваров
                    |        ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Товары КАК Товары
                    |        ПО ЦеныТоваров.Товар = Товары.Ссылка
                    |ГДЕ
                    |    Товары.ЭтоГруппа = ЛОЖЬ
                    |    И ЦеныТоваров.ВидЦен = &ВидЦен
                    |
                    |УПОРЯДОЧИТЬ ПО
                    |    Вид,
                    |    Товары.Родитель.Код,
                    |    Код";

    Запрос.УстановитьПараметр("ВидЦен", Справочники.ВидыЦен.Розничная);
						
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбластьНоменклатура.Параметры.Заполнить(Выборка);
		
		Описание = "";
		
		Чтение = Новый ЧтениеHTML();
		Чтение.УстановитьСтроку(Выборка.Описание);
		
		ДокDOM = Новый ПостроительDOM();
		HTML = ДокDOM.Прочитать(Чтение);
		
		Если Не HTML.ЭлементДокумента = Неопределено Тогда
			Для Каждого Узел из HTML.ЭлементДокумента.ДочерниеУзлы Цикл 
				Если Узел.ИмяУзла = "body" Тогда
					Для Каждого ЭлементОписания из Узел.ДочерниеУзлы Цикл 
						Описание = Описание + ЭлементОписания.ТекстовоеСодержимое;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ОбластьНоменклатура.Параметры.Описание = Описание;
		
		Если (Выборка.Картинка <> Null) Тогда 
			ОбластьНоменклатура.Параметры.ПараметрКартинки = Новый Картинка(Выборка.Картинка.ДанныеФайла.Получить());
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьНоменклатура, Выборка.Уровень());
		Сформирован = Истина;
	КонецЦикла;
	
	Если Сформирован Тогда
		Возврат ТабличныйДокумент;
	Иначе 	
		Возврат Неопределено;
	КонецЕсли;	
КонецФункции

&НаКлиенте
Процедура ПечатьШтрихкода(Команда)
	СтрокиДляОбработки = Элементы.Список.ПолучитьСтрокиДляОбработки();
	Если СтрокиДляОбработки.Количество() = 1 Тогда
		ТабличныйДокумент = ПечатнаяФормаШтрихкода(СтрокиДляОбработки[0]);
		Если ТабличныйДокумент <> Неопределено Тогда
			ТабличныйДокумент.Показать(НСтр("ru = 'Штрихкод'", "ru"));
		КонецЕсли;
	Иначе
		Сообщить(НСтр("ru = 'Действие недоступно для несколько строк списка'", "ru"));
	КонецЕсли;
КонецПроцедуры

 &НаСервере
Функция ПечатнаяФормаШтрихкода(Данные)
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Сформирован = Ложь;
    Объект = Данные.ПолучитьОбъект();
	Если Объект.ЭтоГруппа Тогда
		Сообщить(НСтр("ru = 'Действие недоступно для строки группировки списка'", "ru"));
	ИначеЕсли ПустаяСтрока(Объект.Штрихкод) Тогда 
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не задан штрихкод для '", "ru") + Строка(Данные);
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
	Иначе
		Объект.ПечатнаяФормаШтрихкода(ТабличныйДокумент);
		Сформирован = Истина;       
	КонецЕсли;	
	
	Если Сформирован Тогда
		Возврат ТабличныйДокумент;
	Иначе 	
		Возврат Неопределено;
	КонецЕсли;	
КонецФункции
