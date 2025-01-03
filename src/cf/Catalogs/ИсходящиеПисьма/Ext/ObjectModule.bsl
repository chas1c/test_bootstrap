﻿
Процедура ПередЗаписью(Отказ)

	МассивАдресов = Получатели.ВыгрузитьКолонку("ЭлектроннаяПочта");
	Получатель = СтрСоединить(МассивАдресов, "; ");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Получатели.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Поле ""Адрес"" не заполнено'", "ru");
		Сообщение.Поле = "Получатели";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Получатели"));
	
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры
