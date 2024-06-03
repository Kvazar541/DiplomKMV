﻿#language: ru

@tree
@exportscenarios
@ТипШага: Диплом. Тестирование новых объектов
@Описание: Данный шаг позволяет создать документ Обслуживание клиента от имени менеджера
@ПримерИспользования: И создание нового документа Обслуживание клиента

Функционал: Проверка создания нового документа Обслуживание клиента

Как Менеджер я хочу
автоматизировать процесс создания нового документа Обслуживание клиента 
чтобы получить автоматизированный сценарий тестирования для использования в регрессе   

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Создание нового документа Обслуживание клиента
	И Я подключаю клиент тестирования "Менеджер" из таблицы клиентов тестирования
	И я закрываю все окна клиентского приложения
	* Я открываю форму списка документа ОбслуживаниеКлиентов
		И В командном интерфейсе я выбираю "Обслуживание клиентов" "Обслуживание клиентов"
		Тогда открылось окно "Обслуживание клиентов"
	* Я Создаю новый документ	
		И я нажимаю на кнопку с именем 'ФормаСоздать'
		Тогда открылось окно "Обслуживание клиента (создание)"
		И я нажимаю кнопку выбора у поля с именем 'Дата'
		И в поле с именем 'Дата' я ввожу текст "10.10.2023  0:00:00"
		И я нажимаю кнопку выбора у поля с именем 'Клиент'
		Тогда открылось окно "Контрагенты"
		И в таблице 'Список' я перехожу к строке:
			| "Наименование" |
			| "Контрагент1"  |
		И я нажимаю на кнопку с именем 'ФормаВыбрать'
		Тогда открылось окно "Обслуживание клиента (создание) *"
		И я нажимаю кнопку выбора у поля с именем 'Договор'
		Тогда открылось окно "Договоры контрагентов"
		И в таблице 'Список' я перехожу к строке:
			| "Наименование"          |
			| "ОсновнойДоговор1-2023" |
		И в таблице 'Список' я выбираю текущую строку
		Тогда открылось окно "Обслуживание клиента (создание) *"
		И я нажимаю кнопку выбора у поля с именем 'Специалист'
		Тогда открылось окно "Выбор пользователя"
		И в таблице 'ПользователиСписок' я перехожу к строке:
			| "Полное имя"  |
			| "Специалист5" |
		И в таблице 'ПользователиСписок' я выбираю текущую строку
		Тогда открылось окно "Обслуживание клиента (создание) *"
		И в поле "Описание проблемы" я ввожу текст "Необходимо обновить конфигурацию"
		И я нажимаю на кнопку "Записать"
		Тогда открылось окно "Обслуживание клиента * от *"
		И Я закрываю окно "Обслуживание клиента * от *"
		Тогда открылось окно "Обслуживание клиентов"
		И я закрываю TestClient "Менеджер"