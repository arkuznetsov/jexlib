[![GitHub release](https://img.shields.io/github/release/ArKuznetsov/jexlib.svg?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)
[![GitHub license](https://img.shields.io/github/license/ArKuznetsov/jexlib.svg?style=flat-square)](https://github.com/ArKuznetsov/jexlib/blob/master/LICENSE)
[![GitHub Releases](https://img.shields.io/github/downloads/ArKuznetsov/jexlib/latest/total?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/ArKuznetsov/jexlib/total?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)

[![Build Status](https://img.shields.io/github/workflow/status/ArKuznetsov/jexlib/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/arkuznetsov/jexlib/actions/)
[![Quality Gate](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=alert_status)](https://open.checkbsl.org/dashboard/index/jexlib)
[![Coverage](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=coverage)](https://open.checkbsl.org/dashboard/index/jexlib)
[![Tech debt](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=sqale_index)](https://open.checkbsl.org/dashboard/index/jexlib)

<div style="text-align:right"><a href="https://checkbsl.org"><img alt="Checked by Silver Bulleters SonarQube BSL plugin" src="https://web-files.do.bit-erp.ru/sonar/b_t.png" style="width:400px"/></a></div>

# Oscript JSON data extractor component

## Компонента извлечения данных из JSON по указанному пути JSON-Path для oscript

## Примеры использования

### Извлечение данных по пути JSON-Path из строки

```bsl
#Использовать jexlib

СтрокаJSON = "[{""Имя"":""Вася"",""Пол"":""Мужской"",""Возраст"":29},{""Имя"":""Люба"",""Пол"":""Женский"",""Возраст"":30}]";

ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();

ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

Результат = ИзвлечениеДанных.Выбрать("$..Имя");

Сообщить(Результат);
// [
//   "Вася",
//   "Люба"
// ]

Результат = ИзвлечениеДанных.Выбрать("$..[?(@.Возраст >= 30)].Имя");

Сообщить(Результат);
// "Люба"

```

### Извлечение данных по пути JSON-Path из файла

```bsl
#Использовать jexlib

ИмяВходящегоФайла = "d:\tmp\inputFile.json";
// inputFile.json
//
// [
//   {
//     "Имя"":"Вася"",
//     "Пол"":"Мужской",
//     "Возраст":29
//   },
//   {
//     "Имя":"Люба",
//     "Пол":"Женский",
//     "Возраст":30
//   }
// ]

ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();

ИзвлечениеДанных.ОткрытьФайл(ИмяВходящегоФайла, КодировкаТекста.UTF8);

Результат = ИзвлечениеДанных.Выбрать("$[0].Пол");

Сообщить(Результат);
// "Мужской"

```

### Извлечение данных по пути JSON-Path из потока

```bsl
#Использовать jexlib

ИмяВходящегоФайла = "d:\tmp\inputFile.json";
// inputFile.json
//
// [
//   {
//     "Имя"":"Вася"",
//     "Пол"":"Мужской",
//     "Возраст":29
//   },
//   {
//     "Имя":"Люба",
//     "Пол":"Женский",
//     "Возраст":30
//   }
// ]

ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();

Поток = Новый ФайловыйПоток(ПутьКФайлу, РежимОткрытияФайла.Открыть);

ИзвлечениеДанных.ОткрытьПоток(Поток, КодировкаТекста.UTF8);

Результат = ИзвлечениеДанных.Выбрать("$[1].Пол");

Сообщить(Результат);
// "Женский"

```

## Агрегатные функции над результатом выборки


| **Функция** | **Применимо к типу выборки** | **Тип результата** | **Назначение** |
|-|-|-|-|
| **length()** | Массив, Соответствие | Число | - получает количество значений |
| **sum()** | Массив из Число | Число | - получает сумму значений в массиве |
| **avg()** | Массив из Число | Число | - получает среднее значение в массиве |
| **min()** | Массив из Число | Число | - получает минимальное значение в массиве |
| **max()** | Массив из Число | Число | - получает максимальное значение в массиве |
| **first()** | Массив из Произвольный | Произвольный | - получает первое значение из массива |
| **last()** | Массив из Произвольный | Произвольный | - получает последнее значение из массива |
| **keys()** | Массив, Соответствие | Массив из Строка | - получает список полей в соответствии или список индексов в массиве |

### Пример

```bsl
#Использовать jexlib

СтрокаJSON = "[{""Имя"":""Вася"",""Пол"":""Мужской"",""Возраст"":29},{""Имя"":""Люба"",""Пол"":""Женский"",""Возраст"":30}]";

ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();

ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

// Количество
Результат = ИзвлечениеДанных.Выбрать("$.Возраст.length()");

Сообщить(Результат); // 2

// Сумма
Результат = ИзвлечениеДанных.Выбрать("$.Возраст.sum()");

Сообщить(Результат); // 59

// Среднее
Результат = ИзвлечениеДанных.Выбрать("$.Возраст.avg()");

Сообщить(Результат); // 29.5

// Минимум
Результат = ИзвлечениеДанных.Выбрать("$.Возраст.min()");

Сообщить(Результат); // 29

// Максимум
Результат = ИзвлечениеДанных.Выбрать("$.Возраст.max()");

Сообщить(Результат); // 30

// Первое
Результат = ИзвлечениеДанных.Выбрать("$[*].first()");

Сообщить(Результат); // {"Имя": "Вася", "Пол": "Мужской", "Возраст": 29}

// Последнее
Результат = ИзвлечениеДанных.Выбрать("$[*].last()");

Сообщить(Результат); // {"Имя": "Люба", "Пол": "Женский", "Возраст": 30}

// Поля
Результат = ИзвлечениеДанных.Выбрать("$..[?(@.Возраст >= 30)].keys()");

Сообщить(Результат); // ["Имя", "Пол", "Возраст"]

```
