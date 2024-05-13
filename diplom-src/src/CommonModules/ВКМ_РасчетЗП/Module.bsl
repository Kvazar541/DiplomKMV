
Функция РассчитатьОсновныеНачисления(Регистратор) Экспорт 
	
	НаборЗаписей = РегистрыРасчета.ВКМ_ОсновныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
	НаборЗаписей.Прочитать();
	
	НаборЗаписейНДФЛ = РегистрыРасчета.ВКМ_Удержания.СоздатьНаборЗаписей();
	НаборЗаписейНДФЛ.Отбор.Регистратор.Установить(Регистратор);
	НаборЗаписейНДФЛ.Прочитать();

	Запрос = Новый Запрос;
	Запрос.Текст =                                              
		"ВЫБРАТЬ
		|	ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
		|	ВКМ_ОсновныеНачисленияДанныеГрафика.ВидРасчета КАК ВидРасчета,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.РабочихДнейПериодДействия, 0) КАК Норма,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.РабочихДнейФактическийПериодДействия, 0) КАК Факт,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.РабочихДнейБазовыйПериод, 0) КАК База,
		|	ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.РезультатБаза КАК РезультатБаза,
		|	ВКМ_УсловияОплатыСотрудников.Оклад КАК Оклад,
		|	ВКМ_ВыполненныеСотрудникомРаботыОстатки.Сотрудник КАК Сотрудник,
		|	ЕСТЬNULL(ВКМ_ВыполненныеСотрудникомРаботыОстатки.ЧасовКОплатеОстаток, 0) КАК СуммаЧасовВыполненныхРабот,
		|	ЕСТЬNULL(ВКМ_ВыполненныеСотрудникомРаботыОстатки.СуммаКОплатеОстаток, 0) КАК СуммаЗаВыполненныеРаботы
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(
		|			Регистратор = &Регистратор
		|				И ПериодРегистрации = &ПериодРегистрации) КАК ВКМ_ОсновныеНачисленияДанныеГрафика
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(
		|				&Массив,
		|				&Массив,
		|				,
		|				Регистратор = &Регистратор
		|					И ПериодРегистрации = &ПериодРегистрации) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления
		|		ПО ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников КАК ВКМ_УсловияОплатыСотрудников
		|		ПО ВКМ_ОсновныеНачисленияДанныеГрафика.Сотрудник = ВКМ_УсловияОплатыСотрудников.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВКМ_ВыполненныеСотрудникомРаботы.Остатки КАК ВКМ_ВыполненныеСотрудникомРаботыОстатки
		|		ПО ВКМ_ОсновныеНачисленияДанныеГрафика.Сотрудник = ВКМ_ВыполненныеСотрудникомРаботыОстатки.Сотрудник
		|ГДЕ
		|	ВКМ_УсловияОплатыСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода";
	
	Массив = Новый Массив;
	Массив.Добавить("Сотрудник");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Регистратор.ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Регистратор.ПериодРегистрации));
	Запрос.УстановитьПараметр("Массив", Массив);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("ПериодРегистрации", Регистратор.ПериодРегистрации);

	РезультатЗапроса = Запрос.Выполнить(); 
	ТЗ = РезультатЗапроса.Выгрузить();
	Выборка = РезультатЗапроса.Выбрать();
	Отбор = Новый Структура("НомерСтроки");
	Для каждого Запись Из НаборЗаписей Цикл
		Отбор.НомерСтроки = Запись.НомерСтроки;
		Если Выборка.НайтиСледующий(Отбор) Тогда
			Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад Тогда
				Запись.Результат = Выборка.Оклад * Выборка.Факт / Выборка.Норма;
			ИначеЕсли Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск Тогда
				Запись.Результат = Выборка.РезультатБаза * Выборка.Факт / Выборка.База;
			ИначеЕсли Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ПроцентЗаВыполненныеРаботы Тогда
				Запись.Результат = Выборка.СуммаЗаВыполненныеРаботы;
			КонецЕсли;
		КонецЕсли; 
		
		Выборка.Сбросить();
		
	КонецЦикла;
	
	Отбор = Новый Структура("НомерСтроки");
	Для каждого Запись Из НаборЗаписейНДФЛ Цикл
		Отбор.НомерСтроки = Запись.НомерСтроки;
		Если Выборка.НайтиСледующий(Отбор) Тогда
			Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад Тогда
				Запись.Результат = (Выборка.Оклад * Выборка.Факт / Выборка.Норма) * 13 / 100;
			ИначеЕсли Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск Тогда
				Запись.Результат = (Выборка.РезультатБаза * Выборка.Факт / Выборка.База) * 13 / 100;
			ИначеЕсли Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ПроцентЗаВыполненныеРаботы Тогда
				Запись.Результат = Выборка.СуммаЗаВыполненныеРаботы * 13 / 100;
			КонецЕсли;
		КонецЕсли; 
		
		Выборка.Сбросить();
		
	КонецЦикла; 

	НаборЗаписей.Записать(Истина, Истина);
	НаборЗаписейНДФЛ.Записать(Истина, Истина); 
	Возврат ТЗ;
		
КонецФункции

Процедура РассчитатьПремию(Регистратор) Экспорт
	
	НаборЗаписей = РегистрыРасчета.ВКМ_ДополнительныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
	НаборЗаписей.Прочитать();
	
	НаборЗаписейНДФЛ = РегистрыРасчета.ВКМ_Удержания.СоздатьНаборЗаписей();
	НаборЗаписейНДФЛ.Отбор.Регистратор.Установить(Регистратор);
	НаборЗаписейНДФЛ.Прочитать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ДополнительныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ВКМ_ДополнительныеНачисления.ВидРасчета КАК ВидРасчета,
		|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник КАК Сотрудник,
		|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.СуммаПремии КАК СуммаПремии
		|ИЗ
		|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВКМ_НачислениеФиксированнойПремии.СписокСотрудников КАК ВКМ_НачислениеФиксированнойПремииСписокСотрудников
		|		ПО ВКМ_ДополнительныеНачисления.Сотрудник = ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник
		|ГДЕ
		|	ВКМ_ДополнительныеНачисления.ПериодРегистрации = &ПериодРегистрации
		|	И ВКМ_ДополнительныеНачисления.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("ПериодРегистрации", Регистратор.ПериодРегистрации);
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТЗ = РезультатЗапроса.Выгрузить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Отбор = Новый Структура("НомерСтроки");
	Для каждого Запись Из НаборЗаписей Цикл
		Отбор.НомерСтроки = Запись.НомерСтроки;
		Если Выборка.НайтиСледующий(Отбор) Тогда
			Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия Тогда
				Запись.Результат = Выборка.СуммаПремии;
			КонецЕсли;
		КонецЕсли;
		
		Выборка.Сбросить();
		
	КонецЦикла; 
	
	Отбор = Новый Структура("НомерСтроки");
	Для каждого Запись Из НаборЗаписейНДФЛ Цикл
		Отбор.НомерСтроки = Запись.НомерСтроки;
		Если Выборка.НайтиСледующий(Отбор) Тогда
			Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия Тогда
				Запись.Результат = Выборка.СуммаПремии * 13 / 100;
			КонецЕсли;
		КонецЕсли;
		
		Выборка.Сбросить();
		
	КонецЦикла; 
	
	НаборЗаписей.Записать(Истина, Истина); 
	НаборЗаписейНДФЛ.Записать(Истина, Истина); 
	
КонецПроцедуры



