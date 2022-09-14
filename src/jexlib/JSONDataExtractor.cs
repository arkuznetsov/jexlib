/*----------------------------------------------------------
Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/jexlib/
----------------------------------------------------------*/

using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;
using ScriptEngine.HostedScript.Library;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace oscriptcomponent
{
    /// <summary>
    /// Предоставляет методы для упаковки / распаковки данных по алгоритму Deflate
    /// </summary>
    [ContextClass("ИзвлечениеДанныхJSON", "JSONDataExtractor")]
    public class JSONDataExtractor : AutoContext<JSONDataExtractor>
    {
        private JToken _jsonData;

        /// <summary>
        /// Устанавливает строку JSON для последующей обработки
        /// </summary>
        /// <param name="JSONString">Строка. Строка JSON.</param>
        [ContextMethod("УстановитьСтроку", "SetString")]
        public void SetString(string JSONString)
        {

            _jsonData = JToken.Parse(JSONString);

        }

        /// <summary>
        /// Читает файл, содержащий данные JSON для последующей обработки
        /// </summary>
        /// <param name="JSONFileName">Строка. Путь к файлу.</param>
        /// <param name="encoding">КолировкаТекста. кодировка файла.</param>
        [ContextMethod("ОткрытьФайл", "OpenFile")]
        public void OpenFile(string JSONFileName, IValue encoding = null)
        {

            StreamReader _fileReader;

            try
            {
                if (encoding != null)
                    _fileReader = ScriptEngine.Environment.FileOpener.OpenReader(JSONFileName, TextEncodingEnum.GetEncoding(encoding));
                else
                    _fileReader = ScriptEngine.Environment.FileOpener.OpenReader(JSONFileName, System.Text.Encoding.UTF8);
            }
            catch (Exception e)
            {
                throw new RuntimeException(e.Message, e);
            }

            _jsonData = JToken.Parse(_fileReader.ReadToEnd());

            _fileReader.Close();

        }

        /// <summary>
        /// Выполняет выборку из JSON по указанному JSON-path
        /// </summary>
        /// <param name="path">Строка. JSON-path.</param>
        /// <returns>Строка - Выбранные данные</returns>
        [ContextMethod("Выбрать")]
        public IValue Select(string path)
        {

            IValue result;

            List<JToken> parseResult = _jsonData.SelectTokens(path).ToList();

            if (parseResult.Count() == 0)
            {
                result = ValueFactory.Create("");
            }
            else if (parseResult.Count() == 1)
            {
                if (parseResult[0].Type == JTokenType.Integer)
                {
                    result = ValueFactory.Create(Convert.ToInt32(((JValue)parseResult[0]).Value));
                }
                else if (parseResult[0].Type == JTokenType.Float)
                {
                    result = ValueFactory.Create(Convert.ToDecimal(((JValue)parseResult[0]).Value));
                }
                else if (parseResult[0].Type == JTokenType.Boolean)
                {
                    result = ValueFactory.Create(Convert.ToBoolean(((JValue)parseResult[0]).Value));
                }
                else if (parseResult[0].Type == JTokenType.String)
                {
                    result = ValueFactory.Create(Convert.ToString(((JValue)parseResult[0]).Value));
                }
                else if (parseResult[0].Type == JTokenType.Object)
                {
                    result = ValueFactory.Create(parseResult[0].ToString());
                }
                else
                {
                    result = ValueFactory.Create("");
                }
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                StringWriter sw = new StringWriter(sb);

                using (JsonWriter writer = new JsonTextWriter(sw))
                {
                    writer.Formatting = Formatting.Indented;

                    writer.WriteStartArray();
                    foreach (JToken token in parseResult)
                    {
                        writer.WriteToken(token.CreateReader(), true);
                    }
                    writer.WriteEndArray();
                }
                result = ValueFactory.Create(sb.ToString());
            }

            return result;
            
        }

        /// <summary>
        /// Создает ИзвлечениеДанныхJSON
        /// </summary>
        /// <returns>ИзвлечениеДанныхJSON</returns>
        [ScriptConstructor]
        public static IRuntimeContextInstance Constructor()
        {
            return new JSONDataExtractor();
        }

    }
}