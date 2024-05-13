
&НаКлиенте
Процедура ОтпускаСотрудниковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтоАдресВременногоХранилища(ВыбранноеЗначение) Тогда
		
		ПолучитьВыбранныеЗначения(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры  

 &НаСервере
Процедура ПолучитьВыбранныеЗначения(Адрес)
	
	НовыеДанные = ПолучитьИзВременногоХранилища(Адрес);
	
	Для Каждого Строка Из НовыеДанные Цикл
		
		ЗаполнитьЗначенияСвойств(Объект.ОтпускаСотрудников.Добавить(), Строка);
		
	КонецЦикла;
	
КонецПроцедуры  

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	ТаблицаОтпускаСотрудников = ПолучитьИзВременногоХранилища(Параметры.ТаблицаОтпускаСотрудников); 
	
	ПериодНачало = НачалоГода(ТаблицаОтпускаСотрудников[0].ДатаНачала);
	ПериодОкончание = КонецГода(ТаблицаОтпускаСотрудников[0].ДатаНачала);
	Год = Строка(ГОД(ТаблицаОтпускаСотрудников[0].ДатаНачала)); 
	
	ЭтаФорма.Заголовок = "График отпусков за: " + Год;
	
	
	ГрафикОтпусков.АвтоОпределениеПолногоИнтервала = Ложь;
	ГрафикОтпусков.УстановитьПолныйИнтервал(ПериодНачало, ПериодОкончание);
	
	ГрафикОтпусков.Очистить(); 
	
	Серия = ГрафикОтпусков.УстановитьСерию("Отпуск");
	
	Для Каждого Строка Из ТаблицаОтпускаСотрудников Цикл
		
		Точка = ГрафикОтпусков.УстановитьТочку(Строка.Сотрудник);
		
		Значение = ГрафикОтпусков.ПолучитьЗначение(Точка, Серия);
		
		Интервал = Значение.Добавить();
		Интервал.Начало = Строка.ДатаНачала;
		Интервал.Конец = Строка.ДатаОкончания;
			
	КонецЦикла;

КонецПроцедуры
