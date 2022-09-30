﻿// ----------------------------------------------------------
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/jexlib/
// ----------------------------------------------------------

// #Использовать "build"

Перем юТест;
Перем ТекущийКаталог;

////////////////////////////////////////////////////////////////////
// Программный интерфейс

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт

	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;

	ВсеТесты.Добавить("ТестДолжен_СоздатьКомпоненту");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьДанныеИзСтрокиJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьДанныеИзФайлаJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьДанныеИзПотокаJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьСтроковоеЗначениеИзJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьЦелоеЧислоИзJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьПлавающееЧислоИзJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьСтрокуJSONИзJSON");
	ВсеТесты.Добавить("ТестДолжен_ИзвлечьСоответствиеИзJSON");

	ПередЗапускомТестов();

	Возврат ВсеТесты;

КонецФункции // ПолучитьСписокТестов()

Процедура ПередЗапускомТестов()

	ТекущийКаталог = ПолучитьПеременнуюСреды("OSC_TEST_CWD");
	Если НЕ ЗначениеЗаполнено(ТекущийКаталог) Тогда
		ТекущийКаталог = ТекущийСценарий().Каталог;
	КонецЕсли;

	ПутьККомпоненте = ПолучитьПеременнуюСреды("OSC_TEST_LIB");
	Если НЕ ЗначениеЗаполнено(ПутьККомпоненте) Тогда
		ПутьККомпоненте = ОбъединитьПути(ТекущийКаталог, "src", "jexlib", "bin");
		ПутьККомпоненте = ОбъединитьПути(ПутьККомпоненте, "Debug", "net452", "jexlib.dll");
	КонецЕсли;

	Попытка
		ПодключитьВнешнююКомпоненту(ПутьККомпоненте);
		Сообщить("Компонента подключена.");
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(СтрШаблон("Ошибка подключения компоненты:%1%2", Символы.ПС, ТекстОшибки));
	КонецПопытки;

КонецПроцедуры // ПередЗапускомТестов()

Процедура ТестДолжен_СоздатьКомпоненту() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

КонецПроцедуры // ТестДолжен_СоздатьКомпоненту()

Процедура ТестДолжен_ИзвлечьДанныеИзСтрокиJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$.Manufacturers[?(@.Name == 'Acme Co')].Name");

	ТестовоеЗначение = "Acme Co";

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьДанныеИзСтрокиJSON()

Процедура ТестДолжен_ИзвлечьДанныеИзФайлаJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	ПутьКТестовомуКаталогу = ОбъединитьПути(ТекущийКаталог, "test");
	ОбеспечитьКаталог(ПутьКТестовомуКаталогу);

	ИмяТестовогоФайла = "testFile1.json";
	ПутьКФайлу = ОбъединитьПути(ПутьКТестовомуКаталогу, ИмяТестовогоФайла);

	Текст = Новый ТекстовыйДокумент();
	Текст.УстановитьТекст(ДанныеJSON());
	Текст.Записать(ПутьКФайлу, КодировкаТекста.UTF8);

	ИзвлечениеДанных.ОткрытьФайл(ПутьКФайлу, КодировкаТекста.UTF8);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Name == 'Anvil')].Price");

	ТестовоеЗначение = 50;

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьДанныеИзФайлаJSON()

Процедура ТестДолжен_ИзвлечьДанныеИзПотокаJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	ПутьКТестовомуКаталогу = ОбъединитьПути(ТекущийКаталог, "test");
	ОбеспечитьКаталог(ПутьКТестовомуКаталогу);

	ИмяТестовогоФайла = "testFile1.json";
	ПутьКФайлу = ОбъединитьПути(ПутьКТестовомуКаталогу, ИмяТестовогоФайла);

	Текст = Новый ТекстовыйДокумент();
	Текст.УстановитьТекст(ДанныеJSON());
	Текст.Записать(ПутьКФайлу, КодировкаТекста.UTF8);

	Поток = Новый ФайловыйПоток(ПутьКФайлу, РежимОткрытияФайла.Открыть);
	
	ИзвлечениеДанных.ОткрытьПоток(Поток, КодировкаТекста.UTF8);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Name == 'Anvil')].Price");

	ТестовоеЗначение = 50;

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьДанныеИзФайлаJSON()

Процедура ТестДолжен_ИзвлечьСтроковоеЗначениеИзJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Price >= 50 && @.Name == 'Elbow Grease')].Name");

	ТестовоеЗначение = "Elbow Grease";

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьСтроковоеЗначениеИзJSON()

Процедура ТестДолжен_ИзвлечьЦелоеЧислоИзJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Name == 'Anvil')].Price");

	ТестовоеЗначение = 50;

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьЦелоеЧислоИзJSON()

Процедура ТестДолжен_ИзвлечьПлавающееЧислоИзJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Price >= 50 && @.Name == 'Elbow Grease')].Price");

	ТестовоеЗначение =  99.95;

	юТест.ПроверитьРавенство(Результат, ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьПлавающееЧислоИзJSON()

Процедура ТестДолжен_ИзвлечьСтрокуJSONИзJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Price >= 50)]");

	ТестовоеЗначение = "[
	                   |  {
	                   |    ""Name"": ""Anvil"",
	                   |    ""Price"": 50
	                   |  },
	                   |  {
	                   |    ""Name"": ""Elbow Grease"",
	                   |    ""Price"": 99.95
	                   |  }
	                   |]";

	Результат = СтрЗаменить(Результат, Символы.ВК, "");
	ТестовоеЗначение = СтрЗаменить(ТестовоеЗначение, Символы.ВК, "");

	юТест.ПроверитьРавенство(СокрЛП(Результат), ТестовоеЗначение, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьСтрокуJSONИзJSON()

Процедура ТестДолжен_ИзвлечьСоответствиеИзJSON() Экспорт

	ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();
	юТест.ПроверитьРавенство(ТипЗнч(ИзвлечениеДанных),
	                         Тип("ИзвлечениеДанныхJSON"),
	                         "Не удалось создать компоненту ИзвлечениеДанныхJSON"); 

	СтрокаJSON = ДанныеJSON();

	ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

	Результат = ИзвлечениеДанных.Выбрать("$..Products[?(@.Price >= 50)]", Ложь);

	// "[
	// |  {
	// |    ""Name"": ""Anvil"",
	// |    ""Price"": 50
	// |  },
	// |  {
	// |    ""Name"": ""Elbow Grease"",
	// |    ""Price"": 99.95
	// |  }
	// |]";

	юТест.ПроверитьРавенство(Результат.Количество(), 2, "Ошибка выборки данных из JSON"); 

КонецПроцедуры // ТестДолжен_ИзвлечьСоответствиеИзJSON()

Процедура ОбеспечитьКаталог(ПутьККаталогу)

	ВремКаталог = Новый Файл(ПутьККаталогу);
	Если НЕ (ВремКаталог.Существует() И ВремКаталог.ЭтоКаталог()) Тогда
		СоздатьКаталог(ПутьККаталогу);
	КонецЕсли;

КонецПроцедуры // ОбеспечитьКаталог()

Функция ДанныеJSON()

	Возврат "{
	        |  ""Stores"": [
	        |    ""Lambton Quay"",
	        |    ""Willis Street""
	        |  ],
	        |  ""Manufacturers"": [
	        |    {
	        |      ""Name"": ""Acme Co"",
	        |      ""Products"": [
	        |        {
	        |          ""Name"": ""Anvil"",
	        |          ""Price"": 50
	        |        }
	        |      ]
	        |    },
	        |    {
	        |      ""Name"": ""Contoso"",
	        |      ""Products"": [
	        |        {
	        |          ""Name"": ""Elbow Grease"",
	        |          ""Price"": 99.95
	        |        },
	        |        {
	        |          ""Name"": ""Headlight Fluid"",
	        |          ""Price"": 4
	        |        }
	        |      ]
	        |    }
	        |  ]
	        |}";

КонецФункции // ДанныеJSON()
