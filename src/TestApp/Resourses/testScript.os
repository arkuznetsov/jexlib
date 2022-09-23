// Отладочный скрипт
// в котором уже подключена наша компонента

ИзвлечениеДанных = Новый ИзвлечениеДанныхJSON();

СтрокаJSON = "{
             |	""Stores"": [
             |		""Lambton Quay"",
             |		""Willis Street""
             |	],
             |	""Manufacturers"": [
             |		{
             |			""Name"": ""Acme Co"",
             |			""Products"": [
             |				{
             |					""Name"": ""Anvil"",
             |					""Price"": 50
             |				}
             |			]
             |		},
             |		{
             |			""Name"": ""Contoso"",
             |			""Products"": [
             |				{
             |					""Name"": ""Elbow Grease"",
             |					""Price"": 99.95
             |				},
             |				{
             |					""Name"": ""Headlight Fluid"",
             |					""Price"": 4
             |				}
             |			]
             |		}
             |	]
             |}";

ИзвлечениеДанных.УстановитьСтроку(СтрокаJSON);

Результат = ИзвлечениеДанных.Выбрать("$.Manufacturers[?(@.Name == 'Acme Co')].Name");
Сообщить(Результат);
Сообщить("Ок!");