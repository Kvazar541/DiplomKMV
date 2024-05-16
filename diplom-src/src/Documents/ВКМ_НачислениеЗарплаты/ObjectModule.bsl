
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ПериодРегистрации = НачалоМесяца(ПериодРегистрации);
КонецПроцедуры       

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ВКМ_ОсновныеНачисления.Записывать = Истина;
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина; 
		
	//Формируем движения по основным начислениям и удержания по ним
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.Ссылка КАК Ссылка,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.Сотрудник КАК Сотрудник,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.ВидРасчета КАК ВидРасчета,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.ДатаНачала КАК ПериодДействияНачало,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.ДатаОкончания КАК ПериодДействияКонец,
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.ГрафикРаботы КАК ГрафикРаботы
		|ИЗ
		|	Документ.ВКМ_НачислениеЗарплаты.ОсновныеНачисления КАК ВКМ_НачислениеЗарплатыОсновныеНачисления
		|ГДЕ
		|	ВКМ_НачислениеЗарплатыОсновныеНачисления.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, Выборка);
			Движение.ПериодРегистрации = ПериодРегистрации;
			Движение.ПериодДействияКонец = КонецДня(Выборка.ПериодДействияКонец);
			Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск Тогда
				Движение.БазовыйПериодНачало = НачалоМесяца(ДобавитьМесяц(ПериодРегистрации, -12));
				Движение.БазовыйПериодКонец = ПериодРегистрации - 1;
			КонецЕсли;
			Движение = Движения.ВКМ_Удержания.Добавить();
			ЗаполнитьЗначенияСвойств(Движение, Выборка);
			Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
			Движение.ПериодРегистрации = ПериодРегистрации;
		КонецЦикла;
	КонецЕсли;  
		
	Движения.Записать();
	
	ДанныеДляДвижений = ВКМ_РасчетЗП.РассчитатьОсновныеНачисления(Ссылка);	
	
	//Формируем движения по регистру Накопления ВзаиморасчетыССотрудниками
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВКМ_ОсновныеНачисления.Сотрудник КАК Сотрудник,
	               |	СУММА(ВКМ_ОсновныеНачисления.Результат) КАК СуммаОсновныхНачислений
	               |ПОМЕСТИТЬ ВТ_ОсновныеНачисления
	               |ИЗ
	               |	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	               |ГДЕ
	               |	ВКМ_ОсновныеНачисления.ПериодРегистрации = &ПериодРегистрации
	               |	И ВКМ_ОсновныеНачисления.Регистратор = &Регистратор
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВКМ_ОсновныеНачисления.Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВКМ_Удержания.Сотрудник КАК Сотрудник,
	               |	СУММА(ВКМ_Удержания.Результат) КАК СуммаУдержаний
	               |ПОМЕСТИТЬ ВТ_Удержания
	               |ИЗ
	               |	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	               |ГДЕ
	               |	ВКМ_Удержания.ПериодРегистрации = &ПериодРегистрации
	               |	И ВКМ_Удержания.Регистратор = &Регистратор
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВКМ_Удержания.Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(ВТ_ОсновныеНачисления.Сотрудник, ВТ_Удержания.Сотрудник) КАК Сотрудник,
	               |	ЕСТЬNULL(ВТ_ОсновныеНачисления.СуммаОсновныхНачислений, 0) - ЕСТЬNULL(ВТ_Удержания.СуммаУдержаний, 0) КАК Сумма
	               |ИЗ
	               |	ВТ_ОсновныеНачисления КАК ВТ_ОсновныеНачисления
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Удержания КАК ВТ_Удержания
	               |		ПО ВТ_ОсновныеНачисления.Сотрудник = ВТ_Удержания.Сотрудник";
	
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.Сумма = Выборка.Сумма;
	КонецЦикла;
		
КонецПроцедуры


