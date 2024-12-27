﻿
Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
#Если НЕ МобильныйАвтономныйСервер Тогда
	Если ИменаПараметровСеанса = Неопределено Тогда
		Пользователи.ОпределитьТекущегоПользователя();
		
		ПараметрыСеанса.ЯщикIMAP = "";
	КонецЕсли;
#КонецЕсли

	Если РольДоступна("Кассир") Тогда
		Настройки = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения");
		Если Настройки = Неопределено Тогда
			Настройки = Новый НастройкиКлиентскогоПриложения();
		КонецЕсли;
		Настройки.ВариантМасштабаКлиентскогоПриложения = ВариантМасштабаКлиентскогоПриложения.Компактный;
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения",,Настройки);
	КонецЕсли;

КонецПроцедуры
