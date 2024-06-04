Функция СоздатьРеализацииЗаПериодВФоне(Период, Организация) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(ВКМ_ГрафикиРаботы.Дата, МЕСЯЦ) КАК МесяцВПериоде
		|ПОМЕСТИТЬ ВТ_МесяцаВПериоде
		|ИЗ
		|	РегистрСведений.ВКМ_ГрафикиРаботы КАК ВКМ_ГрафикиРаботы
		|ГДЕ
		|	ВКМ_ГрафикиРаботы.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка КАК Договор,
		|	ДоговорыКонтрагентов.Владелец КАК Контрагент,
		|	ДоговорыКонтрагентов.ВКМ_ДействуетС КАК ВКМ_ДействуетС,
		|	ДоговорыКонтрагентов.ВКМ_ДействуетПо КАК ВКМ_ДействуетПо
		|ПОМЕСТИТЬ ВТ_Договора
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
		|	И ДоговорыКонтрагентов.ВКМ_ДействуетС >= &ДатаНачала
		|	И ДоговорыКонтрагентов.ВКМ_ДействуетПо <= &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_МесяцаВПериоде.МесяцВПериоде КАК МесяцВПериоде,
		|	ВТ_Договора.Договор КАК Договор,
		|	ВТ_Договора.Контрагент КАК Контрагент,
		|	ВТ_Договора.ВКМ_ДействуетС КАК ДействуетС,
		|	ВТ_Договора.ВКМ_ДействуетПо КАК ДействуетПо
		|ПОМЕСТИТЬ ВТ_ДоговораИМесяца
		|ИЗ
		|	ВТ_МесяцаВПериоде КАК ВТ_МесяцаВПериоде,
		|	ВТ_Договора КАК ВТ_Договора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка КАК Реализация,
		|	НАЧАЛОПЕРИОДА(РеализацияТоваровУслуг.Дата, МЕСЯЦ) КАК Месяц,
		|	РеализацияТоваровУслуг.Договор КАК Договор
		|ПОМЕСТИТЬ ВТ_ВсеРеализацииВПериоде
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И РеализацияТоваровУслуг.Договор.ВидДоговора = &ВидДоговора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДоговораИМесяца.Договор КАК Договор,
		|	ВТ_ДоговораИМесяца.МесяцВПериоде КАК МесяцВПериоде,
		|	ВТ_ВсеРеализацииВПериоде.Реализация КАК Реализация,
		|	ВТ_ДоговораИМесяца.Контрагент КАК Контрагент,
		|	ВТ_ДоговораИМесяца.ДействуетС КАК ДействуетС,
		|	ВТ_ДоговораИМесяца.ДействуетПо КАК ДействуетПо
		|ИЗ
		|	ВТ_ДоговораИМесяца КАК ВТ_ДоговораИМесяца
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВсеРеализацииВПериоде КАК ВТ_ВсеРеализацииВПериоде
		|		ПО ВТ_ДоговораИМесяца.МесяцВПериоде = ВТ_ВсеРеализацииВПериоде.Месяц
		|			И ВТ_ДоговораИМесяца.Договор = ВТ_ВсеРеализацииВПериоде.Договор";

	
	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
		
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ = РезультатЗапроса.Выгрузить();
	
	Выборка = РезультатЗапроса.Выбрать(); 
	
	ТекСтрокаВыборки = 0;
	
	Пока Выборка.Следующий() И ТекСтрокаВыборки < Выборка.Количество() Цикл
		
		ТекСтрокаВыборки = ТекСтрокаВыборки + 1;
		
		Если Не ЗначениеЗаполнено(Выборка.Реализация) И 
			Выборка.МесяцВПериоде >= Выборка.ДействуетС И
			Выборка.МесяцВПериоде <= Выборка.ДействуетПо Тогда
			
			ДокументРеализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
			ДокументРеализация.Дата = Выборка.МесяцВПериоде; 
			ДокументРеализация.Контрагент = Выборка.Контрагент;
			ДокументРеализация.Комментарий = "Документ создан автоматической обработкой";
			ДокументРеализация.Организация = Организация;
			ДокументРеализация.Договор = Выборка.Договор;
			ДокументРеализация.Ответственный = ПараметрыСеанса.ТекущийПользователь;
			ДокументРеализация.ВыполнитьАвтозаполнение();
			
			Если Не ДокументРеализация.ПроверитьЗаполнение() Тогда
				ТекстСообщения = СтрШаблон("Для договора %1. В периоде %2 Реализация не была создана", Выборка.Договор, Выборка.МесяцВПериоде);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Иначе
				ДокументРеализация.Записать(РежимЗаписиДокумента.Проведение); 
			КонецЕсли; 
			
		КонецЕсли;
		ДлительныеОперации.СообщитьПрогресс(ТекСтрокаВыборки/Выборка.Количество() * 100);	
	КонецЦикла;
	
	Возврат "Документы созданы!";
	
КонецФункции
