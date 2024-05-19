# Дипломный проект профессии «1C-программист: с нуля до middle»

## Кастомизация конфигурации «Управление IT-фирмой для компании «Ваш компьютерный мастер»

### Инструкция по начальной настройке программы

1.	Для пользователей необходимо установить следующие роли:

Для специалистов:
- Базовые права БСП
- Запуск тонкого клиента
- Добавление изменение документа обслуживание клиента
- Специалист

Для менеджеров:
- Базовые права БСП
- Добавление изменение контрагентов
- Запуск тонкого клиента
- Добавление изменение документа обслуживание клиента
- Менеджер

Для Бухгалтеров ИТ Фирмы:
- Базовые права БСП
- Добавление изменение документов покупки
- Добавление изменение документов продажи
- Добавление изменение контрагентов
- Запуск тонкого клиента
- Чтение вариантов отчетов
- Добавление изменение документа обслуживание клиента
- БухгалтерИТФирмы

Для кадровиков-рассчетчиков:
- Базовые права БСП
- Запуск тонкого клиента
- Чтение вариантов отчетов
- Добавление изменение документа начисление зарплаты
- Добавление изменение документа начисление фиксированной премии
- Добавление изменение документа выплата зарплаты
- Добавление изменение документа график отпусков
- Кадровик-рассчетчик

2. Необходимо заполнить константы:
- ТокенУправленияТелеграмБотом
- ИдентификаторГруппыДляОповещения
- НоменклатураАбонентскаяПлата
- НоменклатураРаботыСпециалиста

3. Заполнить регистр сведений «Условия оплаты сотрудников»
- Для каждого сотрудника в каждом месяце необходимо установить его оклад
- Для специалистов – процент от выполняемых работ. Для прочих сотрудников его нужно оставить нулевым.
4. Создать элементы справочника «Графики работы» (например - пятидневка).
5. С помощью обработки «Заполнение графика» заполнить регистр сведений «Графики работы». 
- В обработке необходимо выбрать тип графика работы, задать период на который необходимо заполнить регистр и указать какие дни недели будут выходными (для пятидневки например 6, 7).
6. С помощью документа «График отпусков» заполнить регистр сведений «График отпусков».
  - При проведении документа создаются записи в регистре в соответствии с указанными данными.
7. Для контрагентов нужно создать договора с видом «Абонентское обслуживание» и заполнить информацию о его условиях.

------

### Описание интерфейса

- В подсистему «Обслуживание клиентов» включены только те объекты, которые связаны с вопросами обслуживания клиентов.
- В подсистему «Добавленные объекты» включены все объекты необходимые для тестирования нового функционала.

------

### Инструкция по запуску автотеста:

1) Нужно создать следующие клиенты тестирования и путь к используемой базе:

Имя	              Доп.параметры
Менеджер	        /N"Менеджер"
Специалист5     	/N"Специалист5"
БухгалтерИТФирмы	/N"БухгалтерИТФирмы"

![2024-05-17_17-54-03](https://github.com/Kvazar541/DiplomKMV/assets/148319677/3e55a551-6d08-4ccb-bcf0-a9232f2073f9)



- В подсистему «Обслуживание клиентов» включены только те объекты, которые связаны с вопросами обслуживания клиентов.
- В подсистему «Добавленные объекты» включены все объекты необходимые для тестирования нового функционала.

------

### Цель дипломного проекта

Разработать и подготовить к эксплуатации новый функциональный блок в конфигурации «Управление IT-фирмой».

Вам нужно:

- реализовать новые подсистемы «Работа с заявками клиентов» и «Расчёт управленческой зарплаты» в соответствии с требованиями заказчика,
- подготовить отчёты по новой функциональности,
- оформить инструкцию по начальной настройке,
- подготовить автотест для проверки корректности работы подсистемы «Работа с заявками клиентов»,
- загрузить результат работы в новый репозиторий на GitHub.

------

### Чек-лист готовности к работе над проектом

1. Установите [учебную версию](https://drive.google.com/file/d/1zMZCr5NnLtrkqV1ziCS5u_G8mDri07Rs/view?usp=sharing) платформы 1С:Предприятие 8.3.22.2411.
2. Скачайте и установите [Liberica JDK 11](https://releases.1c.ru/project/Liberica11FullJDK).
3. Скачайте и установите 1С:EDT [последней актуальной версии](https://edt.1c.ru/).
4. Зарегистрируйтесь на github.com и создайте форк от этого репозитория.
5. С помощью 1С:EDT клонируйте свой форк репозитория.

Если все этапы чек-листа пройдены, можете начинать работу над проектом. Успехов.

------

### Инструменты и дополнительные материалы для выполнения задания
- Для учебной версии платформы [архив с дистрибутивом Vanessa Automation](https://u.netology.ru/backend/uploads/lms/content_assets/file/7038/download.html). **В дистрибутиве заменены обращения при подключении тест-клиента с файла 1cv8c.exe на 1cv8ct.exe**.
- Для остальных версий платформы нужно скачать Vanessa Automation из [официального гит-репозитория](https://pr-mex.github.io/vanessa-automation/dev/).

------

### Описание задания

Компания «Ваш компьютерный мастер» использует конфигурацию «Управление IT-фирмой» от стороннего поставщика. Вам поставлена задача добавить в конфигурацию модуль для работы с заявками на обслуживание клиентов и модуль для расчёта управленческой заработной платы.

Исходная версия конфигурации размещена в [этом репозитории](https://github.com/netology-code/fonecmid-diplom/tree/main/diplom-src). Для доработки конфигурации нужно использовать 1C:EDT. При доработке конфигурации максимально задействуйте функциональность библиотеки стандартных подсистем.

Для добавленных объектов, реквизитов, методов используйте префикс ВКМ_. Если меняется программный код существующих методов, изменения должны быть выделены комментариями.

Все добавленные объекты должны быть размещены в новой служебной подсистеме ВКМ_ДобавленныеОбъекты. В добавленных объектах не должно быть ошибок, выявляемых встроенным механизмом проверки 1C:EDT.

Для передачи результата изменённую конфигурацию загрузите в отдельный репозиторий на [github.com](https://github.com). Чтобы результаты работы можно было проверить, репозиторий должен быть публичным.

Вместе с результатами работы должны быть переданы инструкция по начальной настройке новой подсистемы и сценарий для автоматизированного тестирования модуля работы с заявками клиентов.

В блок Releases репозитория должен быть добавлен dt-файл демонстрационной базы с введёнными тестовыми данными, которые показывают работу всех механизмов системы.

------

### Подробные требования к подсистемам

- [Работа с заявками клиентов](tasks/tickets.md).
- [Расчёт управленческой зарплаты](tasks/hrm.md).
- [Отчёты](tasks/reports.md).
- [Инструкция по начальной настройке](tasks/docs.md).
- [Тестирование](tasks/testing.md).

------

### Дорожная карта (roadmap)

Работа над проектом рассчитана на один месяц. Для планирования своего времени рекомендуем опираться на дорожную карту. Придерживайтесь указанного разделения проекта на этапы и задачи исполнителя.

- 1-я неделя. Разработка подсистемы «Работа с заявками клиентов».
- 2-я неделя. Разработка подсистемы «Расчёт управленческой зарплаты».
- 3-я неделя. Разработка отчётов, автотеста и инструкции по начальной настройке.
- 4-я неделя. Оформление репозитория, демонстрационной базы, отправка проекта на проверку дипломному руководителю.
- 5-я неделя. Получение обратной связи от руководителя и доработка проекта с повторной проверкой при необходимости.

------

### Правила сдачи работы

Решение нужно передать в виде ссылки на публичный репозиторий на github.com, в котором размещены:

1. Исходный код доработанной конфигурации в формате 1C:EDT.
2. Сценарий автотеста и инструкция по запуску автотеста.
3. Инструкция по начальной настройке доработанной конфигурации.
4. В списке релизов файл с демонстрационной базой в формате *dt.

------

### Критерии оценки

Зачёт по дипломной работе можно получить, если работа соответствует критериям:

1. Репозиторий содержит исходный код конфигурации в формате 1C:EDT.
2. Функциональность конфигурации не имеет существенных ошибок и соответствует техническому заданию.
3. В добавленных объектах нет ошибок, выявляемых проверками 1C:EDT с набором плагинов и составом проверок по умолчанию.
4. Автотест запускается и соответствует техническому заданию.
5. Инструкция по начальному запуску описывает шаги, необходимые для начала использования доработанной конфигурации.
6. Демонстрационная база содержит достаточный набор данных, соответствующий требованиям.

