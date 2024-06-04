
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.ОбработкаЗаказов.Записывать = Истина;
	Движения.ОстаткиТоваров.Записывать = Истина; 
	Движения.ВКМ_ВыставленнаяКлиентуАбонентскаяПлата.Записывать = Истина;  
	
	//Движения по регистру ОбработкаЗаказов
	Движение = Движения.ОбработкаЗаказов.Добавить();
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Договор = Договор;
	Движение.Заказ = Основание;
	Движение.СуммаОтгрузки = СуммаДокумента;
	
	//Движения по регистру ОстаткиТоваров
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;

	//Движения по регистру ВКМ_ВыставленнаяКлиентуАбонентскаяПлата
	Для Каждого Строка Из Услуги Цикл 
		
		Если Строка.Номенклатура = Константы.ВКМ_НоменклатураАбонентскаяПлата.Получить() Тогда
			СуммаАбонентскойПлаты = Строка.Сумма;
		КонецЕсли;
				
	КонецЦикла; 
	
	Если ЗначениеЗаполнено(СуммаАбонентскойПлаты) Тогда
		Движение = Движения.ВКМ_ВыставленнаяКлиентуАбонентскаяПлата.Добавить();
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Договор = Договор;
	    Движение.СуммаКОплате = СуммаАбонентскойПлаты;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПокупателя.Организация КАК Организация,
	               |	ЗаказПокупателя.Контрагент КАК Контрагент,
	               |	ЗаказПокупателя.Договор КАК Договор,
	               |	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента,
	               |	ЗаказПокупателя.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Товары,
	               |	ЗаказПокупателя.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	ТоварыОснования = Выборка.Товары.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), ТоварыОснования);
	КонецЦикла;
	
	УслугиОснования = Выборка.Услуги.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Услуги.Добавить(), УслугиОснования);
	КонецЦикла;
	
	Основание = ДанныеЗаполнения;
	
КонецПроцедуры

//ВКМ_Процедура заполнения табличных частей документа 
Процедура ВыполнитьАвтозаполнение() Экспорт
	
	Товары.Очистить();
	Услуги.Очистить();
	Записать(); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ДоговорыКонтрагентов.ВКМ_АбонентскаяПлата, 0) КАК АбонентскаяПлата,
		|	ДоговорыКонтрагентов.Ссылка КАК СсылкаНаДоговор,
		|	ЕСТЬNULL(ДоговорыКонтрагентов.ВКМ_СтоимостьЧасаРаботы, 0) КАК СтоимостьЧасаРаботы
		|ПОМЕСТИТЬ ВТ_АбонентскаяПлата
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Договор
		|	И ДоговорыКонтрагентов.ВКМ_ДействуетС <= &Дата
		|	И ДоговорыКонтрагентов.ВКМ_ДействуетПо >= &Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВКМ_ВыполненныеКлиентуРаботыОбороты.КоличествоЧасовПриход, 0) КАК КоличествоЧасов,
		|	ЕСТЬNULL(ВКМ_ВыполненныеКлиентуРаботыОбороты.СуммаКОплатеПриход, 0) КАК СуммаВыполненныхРабот,
		|	ВКМ_ВыполненныеКлиентуРаботыОбороты.Договор КАК СсылкаНаДоговор
		|ПОМЕСТИТЬ ВТ_ДанныеРегистра
		|ИЗ
		|	РегистрНакопления.ВКМ_ВыполненныеКлиентуРаботы.Обороты(
		|			&НачалоМесяца,
		|			&КонецМесяца,
		|			,
		|			Клиент = &Контрагент
		|				И Договор = &Договор) КАК ВКМ_ВыполненныеКлиентуРаботыОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВКМ_НоменклатураАбонентскаяПлата.Значение КАК НоменклатураАбонентскаяПлата,
		|	ВКМ_НоменклатураРаботыСпециалиста.Значение КАК НоменклатураРаботыСпециалиста,
		|	ЕСТЬNULL(ВТ_АбонентскаяПлата.АбонентскаяПлата, 0) КАК АбонентскаяПлата,
		|	ЕСТЬNULL(ВТ_АбонентскаяПлата.СтоимостьЧасаРаботы, 0) КАК СтоимостьЧасаРаботы,
		|	ЕСТЬNULL(ВТ_ДанныеРегистра.КоличествоЧасов, 0) КАК КоличествоЧасов,
		|	ЕСТЬNULL(ВТ_ДанныеРегистра.СуммаВыполненныхРабот, 0) КАК СуммаВыполненныхРабот
		|ИЗ
		|	ВТ_АбонентскаяПлата КАК ВТ_АбонентскаяПлата
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ДанныеРегистра КАК ВТ_ДанныеРегистра
		|		ПО ВТ_АбонентскаяПлата.СсылкаНаДоговор = ВТ_ДанныеРегистра.СсылкаНаДоговор,
		|	Константа.ВКМ_НоменклатураАбонентскаяПлата КАК ВКМ_НоменклатураАбонентскаяПлата,
		|	Константа.ВКМ_НоменклатураРаботыСпециалиста КАК ВКМ_НоменклатураРаботыСпециалиста";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Дата));

	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ = РезультатЗапроса.Выгрузить();
	
	Если РезультатЗапроса.Пустой() Тогда  
		ОбщегоНазначения.СообщитьПользователю("Дата документа не сооствествует периоду действия абонентского договора!",,,,Истина);
		Возврат;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	Если Не ЗначениеЗаполнено(Выборка.НоменклатураАбонентскаяПлата) Или
		Не ЗначениеЗаполнено(Выборка.НоменклатураРаботыСпециалиста) Тогда
		ВызватьИсключение НСтр("ru='Не установлены значения констант. Проверьте заполненность констант - НоменклатураАбонентскаяПлата и НоменклатураРаботыСпециалиста.'");
	КонецЕсли;
	
	Если Выборка.АбонентскаяПлата <> 0 Тогда
		СтрокаАбонентскаяПлата = ЭтотОбъект.Услуги.Добавить();
		СтрокаАбонентскаяПлата.Номенклатура = Выборка.НоменклатураАбонентскаяПлата;
		СтрокаАбонентскаяПлата.Количество = 1;
		СтрокаАбонентскаяПлата.Цена = Выборка.АбонентскаяПлата;
		СтрокаАбонентскаяПлата.Сумма = Выборка.АбонентскаяПлата;
	КонецЕсли;
	
	Если Выборка.СуммаВыполненныхРабот <> 0 Тогда
		СтрокаВыполненныеРаботы = ЭтотОбъект.Услуги.Добавить();
		СтрокаВыполненныеРаботы.Номенклатура = Выборка.НоменклатураРаботыСпециалиста;
		СтрокаВыполненныеРаботы.Количество = Выборка.КоличествоЧасов;
		СтрокаВыполненныеРаботы.Цена = Выборка.СтоимостьЧасаРаботы;
		СтрокаВыполненныеРаботы.Сумма = Выборка.СуммаВыполненныхРабот;
	КонецЕсли; 
	
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	
	ОбщегоНазначения.СообщитьПользователю("Табличные части документа перезаполнены!");
		
КонецПроцедуры
/////////////////////////////////////////////////////


#КонецОбласти

#КонецЕсли
