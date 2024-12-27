﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().Имя = "" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	АдресСервера = "wss://1cdialog.com:443";
	ИмяИБ = Метаданные.КраткаяИнформация;
	
	Если СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Элементы.СтраницаОтменитьРегистрацию.Видимость = Истина;
		Элементы.СтраницаЗапросаКода.Видимость = Ложь;
		Элементы.СтраницаРегистрации.Видимость = Ложь;
	Иначе
		Заголовок = НСтр("ru = 'Регистрация в системе взаимодействия'", "ru");
		Элементы.СтраницаОтменитьРегистрацию.Видимость = Ложь;
		Элементы.СтраницаЗапросаКода.Видимость = Истина;
		Элементы.СтраницаРегистрации.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКодРегистрации(Команда)
	
	ВыполнитьПолучениеКодаРегистрации();
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыполнитьПолучениеКодаРегистрации()
	
	ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия();
	ПараметрыРегистрации.АдресСервера = АдресСервера;
	ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
	ПараметрыРегистрации.ИмяИнформационнойБазы = ИмяИБ;
	РегистрацияВыполнена = Ждать СистемаВзаимодействия.ВыполнитьРегистрациюИнформационнойБазыАсинх(ПараметрыРегистрации);
	
	Ждать ПредупреждениеАсинх(РегистрацияВыполнена.ТекстСообщения);
	
	Элементы.СтраницаОтменитьРегистрацию.Видимость = Ложь;
	Элементы.СтраницаЗапросаКода.Видимость = Ложь;
	Элементы.СтраницаРегистрации.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Зарегистрировать(Команда)
	
	ВыполнитьЗарегистрировать();
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыполнитьЗарегистрировать()
	
	ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия();
	ПараметрыРегистрации.АдресСервера = АдресСервера;
	ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
	ПараметрыРегистрации.ИмяИнформационнойБазы = ИмяИБ;
	ПараметрыРегистрации.КодАктивации = КодРегистрации;
	РегистрацияВыполнена = Ждать СистемаВзаимодействия.ВыполнитьРегистрациюИнформационнойБазыАсинх(ПараметрыРегистрации);
	
	Если Не РегистрацияВыполнена.РегистрацияВыполнена Тогда
		Ждать ПредупреждениеАсинх(НСтр("ru='Ошибка регистрации информационной базы'", "ru"));
		Возврат;
	КонецЕсли;
	
	ВыполнитьИнициализацию();
	
	БотКлиент.ПриНачалеРаботыСистемы();
	
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьИнициализацию()
	
	БотСервер.Инициализация();

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРегистрацию(Команда)
	
	ВыполнитьОтменуРегистрации();
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыполнитьОтменуРегистрации()
	
	Ждать СистемаВзаимодействия.ОтменитьРегистрациюИнформационнойБазыАсинх();
	
	БотСервер.Отключение();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура EMailИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Элементы.ПолучитьКодРегистрации.Доступность =
		НЕ ПустаяСтрока(АдресСервера)
		И НЕ ПустаяСтрока(Текст)
		И НЕ ПустаяСтрока(ИмяИБ);

	Элементы.Зарегистрировать.Доступность = 
		НЕ ПустаяСтрока(АдресСервера)
		И НЕ ПустаяСтрока(Текст)
		И НЕ ПустаяСтрока(ИмяИБ)
		И НЕ ПустаяСтрока(КодРегистрации);
КонецПроцедуры

&НаКлиенте
Процедура АдресСервераИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.ПолучитьКодРегистрации.Доступность =
		НЕ ПустаяСтрока(Текст)
		И НЕ ПустаяСтрока(АдресЭлектроннойПочты)
		И НЕ ПустаяСтрока(ИмяИБ);
		
	Элементы.Зарегистрировать.Доступность = 
		НЕ ПустаяСтрока(Текст)
		И НЕ ПустаяСтрока(АдресЭлектроннойПочты)
		И НЕ ПустаяСтрока(ИмяИБ)
		И НЕ ПустаяСтрока(КодРегистрации);

КонецПроцедуры

&НаКлиенте
Процедура ИмяИБИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.ПолучитьКодРегистрации.Доступность =
		НЕ ПустаяСтрока(АдресСервера)
		И НЕ ПустаяСтрока(АдресЭлектроннойПочты)
		И НЕ ПустаяСтрока(Текст);
	
	Элементы.Зарегистрировать.Доступность = 
		НЕ ПустаяСтрока(АдресСервера)
		И НЕ ПустаяСтрока(АдресЭлектроннойПочты)
		И НЕ ПустаяСтрока(Текст)
		И НЕ ПустаяСтрока(КодРегистрации);

КонецПроцедуры

&НаКлиенте
Процедура КодРегистрацииИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Элементы.Зарегистрировать.Доступность = 
		НЕ ПустаяСтрока(АдресСервера)
		И НЕ ПустаяСтрока(АдресЭлектроннойПочты)
		И НЕ ПустаяСтрока(ИмяИБ)
		И НЕ ПустаяСтрока(Текст);

КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеОтключенияПриИзменении(Элемент)
	
	Элементы.ОтменитьРегистрацию.Доступность = ПодтверждениеОтключения;

КонецПроцедуры
