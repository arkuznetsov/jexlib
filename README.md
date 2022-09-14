# Oscript JSON data extractor component

[![GitHub release](https://img.shields.io/github/release/ArKuznetsov/jexlib.svg?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)
[![GitHub license](https://img.shields.io/github/license/ArKuznetsov/jexlib.svg?style=flat-square)](https://github.com/ArKuznetsov/jexlib/blob/master/LICENSE)
[![GitHub Releases](https://img.shields.io/github/downloads/ArKuznetsov/jexlib/latest/total?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/ArKuznetsov/jexlib/total?style=flat-square)](https://github.com/ArKuznetsov/jexlib/releases)

[![Build Status](https://img.shields.io/github/workflow/status/ArKuznetsov/jexlib/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/arkuznetsov/jexlib/actions/)
[![Quality Gate](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=alert_status)](https://open.checkbsl.org/dashboard/index/jexlib)
[![Coverage](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=coverage)](https://open.checkbsl.org/dashboard/index/jexlib)
[![Tech debt](https://open.checkbsl.org/api/project_badges/measure?project=jexlib&metric=sqale_index)](https://open.checkbsl.org/dashboard/index/jexlib)

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

ИзвлечениеДанных.ОткрытьФайл(ИмяВходящегоФайла);

Результат = ИзвлечениеДанных.Выбрать("$[0].Пол");

Сообщить(Результат);
// "Мужской"

```
