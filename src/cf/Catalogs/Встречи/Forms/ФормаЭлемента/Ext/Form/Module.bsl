﻿&НаСервере
Процедура ЗаполнитьСписокВыбораВремени(ПолеВводаФормы, Интервал = 3600, Начало = '00010101080000', Окончание = '00010101200000') Экспорт
	
	СписокВремен = ПолеВводаФормы.СписокВыбора;
	СписокВремен.Очистить();
	
	ВремяСписка = НачалоЧаса(Начало);
	
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(Окончание) Цикл
		
		Если НЕ ЗначениеЗаполнено(ВремяСписка) Тогда
			ПредставлениеВремени = "00:00";
		Иначе
			ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + Интервал;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ЗаполнитьСписокВыбораВремени(Элементы.НачалоВремя);
	//ЗаполнитьСписокВыбораВремени(Элементы.ОкончаниеВремя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ПометитьНаУдалениеПриЗаписи) Тогда
		ПометитьНаУдалениеПриЗаписи.ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
		ПометитьНаУдалениеПриЗаписи = Справочники.Встречи.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_Встречи");
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыбранноеЗначение = НачалоДня(Объект.Начало) + (ВыбранноеЗначение - НачалоДня(ВыбранноеЗначение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыбранноеЗначение = НачалоДня(Объект.Окончание) + (ВыбранноеЗначение - НачалоДня(ВыбранноеЗначение));
	
КонецПроцедуры
