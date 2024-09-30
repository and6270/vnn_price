﻿
&НаКлиенте
Процедура УЦ_ТоварыПриИзмененииПосле(Элемент)
	текданные = элементы.Товары.ТекущиеДанные;  
	текданные.Характеристика = найтихарактеристику(текданные.Номенклатура,текданные.Характеристика); 
	текданные.цена = найтицену(текданные.Номенклатура,текданные.Характеристика);    
	текданные.ОстатокНаСкладе = найтиостаток(текданные.Номенклатура);
КонецПроцедуры

&НаСервере
Функция найтихарактеристику(Товар,Характеристика)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Наименование = &Наименование
	|	И ХарактеристикиНоменклатуры.Владелец = &Владелец";	
	Запрос.УстановитьПараметр("Владелец", Товар);
	Запрос.УстановитьПараметр("Наименование", Строка(Характеристика));
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		возврат ВыборкаДетальныеЗаписи.ссылка;
	КонецЦикла;	 
	возврат Характеристика;	
КонецФункции

&НаСервере
Функция найтицену(Товар,Характеристика) 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыСрезПоследних
		|ГДЕ
		|	ЦеныНоменклатурыСрезПоследних.Номенклатура = &Номенклатура
		|	И ЦеныНоменклатурыСрезПоследних.Характеристика = &Характеристика
		|	И ЦеныНоменклатурыСрезПоследних.ВидЦены = &ВидЦены";	
	Запрос.УстановитьПараметр("Номенклатура", Товар);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);	 
	Запрос.УстановитьПараметр("ВидЦены", Справочники.ВидыЦен.НайтиПоНаименованию("Розничная"));
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			возврат ВыборкаДетальныеЗаписи.Цена;
	КонецЦикла;
	возврат 0;
КонецФункции 

&НаСервере
Функция найтиостаток(Товар)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки КАК ТоварыНаСкладахОстатки
	|ГДЕ
	|	ТоварыНаСкладахОстатки.Склад = &Склад
	|	И ТоварыНаСкладахОстатки.Номенклатура = &Номенклатура";	
	Запрос.УстановитьПараметр("Номенклатура", Товар);
	Запрос.УстановитьПараметр("Склад", Объект.Магазин.СкладПродажи);	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		возврат ВыборкаДетальныеЗаписи.КоличествоОстаток;
	КонецЦикла;
	возврат 0;
КонецФункции

&НаКлиенте
Процедура УЦ_ВнешнееСобытиеПосле(Источник, Событие, Данные)
	для каждого строка из объект.Товары цикл
		если НЕ ЗначениеЗаполнено(строка.цена) или НЕ ЗначениеЗаполнено(строка.ОстатокНаСкладе) тогда   
			строка.Характеристика = найтихарактеристику(строка.Номенклатура,строка.Характеристика); 
			строка.цена = найтицену(строка.Номенклатура,строка.Характеристика);    
			строка.ОстатокНаСкладе = найтиостаток(строка.Номенклатура);
		конецесли;
	конеццикла;
КонецПроцедуры

&НаКлиенте
Процедура УЦ_ТоварыПриАктивизацииСтрокиПосле(Элемент)     
	попытка
		текданные = элементы.Товары.ТекущиеДанные;  
		текданные.Характеристика = найтихарактеристику(текданные.Номенклатура,текданные.Характеристика); 
		текданные.цена = найтицену(текданные.Номенклатура,текданные.Характеристика);    
		текданные.ОстатокНаСкладе = найтиостаток(текданные.Номенклатура);
	исключение
	конецпопытки;
КонецПроцедуры
            