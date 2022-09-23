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
using System.Threading;
using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;
using ScriptEngine.HostedScript.Library;
using ScriptEngine.HostedScript.Library.Json;
using ScriptEngine.HostedScript.Library.Binary;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace oscriptcomponent
{
    /// <summary>
    /// Предоставляет методы для извлечения данных из JSON по запросу JSON-path
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
        /// <param name="encoding">КодировкаТекста. кодировка файла.</param>
        [ContextMethod("ОткрытьФайл", "OpenFile")]
        public void OpenFile(string JSONFileName, IValue encoding = null)
        {

            StreamReader _fileReader;

            try
            {
                if (encoding == null)
                    _fileReader = ScriptEngine.Environment.FileOpener.OpenReader(JSONFileName, Encoding.Default);
                else
                    _fileReader = ScriptEngine.Environment.FileOpener.OpenReader(JSONFileName, TextEncodingEnum.GetEncoding(encoding));
            }
            catch (Exception e)
            {
                throw new RuntimeException(e.Message, e);
            }

            _jsonData = JToken.Parse(_fileReader.ReadToEnd());

            _fileReader.Close();

        }

        /// <summary>
        /// Читает данные из потока JSON для последующей обработки
        /// </summary>
        /// <param name="JSONStream">Поток. поток с данными JSON.</param>
        /// <param name="encoding">КодировкаТекста. кодировка файла.</param>
        [ContextMethod("ОткрытьПоток", "OpenStream")]
        public void OpenStream(IValue JSONStream, IValue encoding = null)
        {

            string _JSONString = "{}";
            Encoding _encoding;

            if (encoding == null)
                _encoding = Encoding.Default;
            else
                _encoding = TextEncodingEnum.GetEncoding(encoding);

            using (Stream _underlyingStream = ((IStreamWrapper)JSONStream).GetUnderlyingStream())
            {
                byte[] buffer = new byte[1000];
                StringBuilder builder = new StringBuilder();
                int read = -1;

                while (true)
                {
                    AutoResetEvent gotInput = new AutoResetEvent(false);
                    Thread inputThread = new Thread(() =>
                    {
                        try
                        {
                            read = _underlyingStream.Read(buffer, 0, buffer.Length);
                            gotInput.Set();
                        }
                        catch (ThreadAbortException)
                        {
                            Thread.ResetAbort();
                        }
                    })
                    {
                        IsBackground = true
                    };

                    inputThread.Start();

                    // Timeout expired?
                    if (!gotInput.WaitOne(100))
                    {
                        inputThread.Abort();
                        break;
                    }

                    // End of stream?
                    if (read == 0)
                    {
                        _JSONString = builder.ToString();
                        break;
                    }

                    // Got data
                    builder.Append(_encoding.GetString(buffer, 0, read));
                }
            }

            string _BOMMarkUTF8 = Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble());

            if (_JSONString.StartsWith(_BOMMarkUTF8, StringComparison.Ordinal))
                _JSONString = _JSONString.Remove(0, _BOMMarkUTF8.Length);

            _jsonData = JToken.Parse(_JSONString.Trim());

        }

        /// <summary>
        /// Выполняет выборку из JSON по указанному JSON-path
        /// </summary>
        /// <param name="path">Строка. JSON-path.</param>
        /// <param name="getObjectAsJSON">Булево. Истина - объекты будут возвращены в виде строки JSON;
        /// Ложь - Объекты будут возвращены в виде соответствия.</param>
        /// <returns>Строка - Выбранные данные</returns>
        [ContextMethod("Выбрать", "Select")]
        public IValue Select(string path, bool getObjectAsJSON = true)
        {

            IValue result;

            List<JToken> parseResult = _jsonData.SelectTokens(path).ToList();

            if (parseResult.Count() == 0)
            {
                result = ValueFactory.Create();
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
                else if (parseResult[0].Type == JTokenType.Date)
                {
                    result = ValueFactory.Create(Convert.ToDateTime(((JValue)parseResult[0]).Value));
                }
                else if (parseResult[0].Type == JTokenType.Object || parseResult[0].Type == JTokenType.Array)
                {
                    if (getObjectAsJSON)
                    {
                        result = ValueFactory.Create(parseResult[0].ToString());
                    }
                    else
                    {
                        result = JSONToMap(parseResult[0].ToString());
                    }
                }
                else
                {
                    result = ValueFactory.Create();
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
                if (getObjectAsJSON)
                {
                    result = ValueFactory.Create(sb.ToString());
                }
                else
                {
                    result = JSONToMap(sb.ToString());

                }
            }

            return result;
            
        }

        /// <summary>
        /// Преобразует строку JSON в соответствие
        /// </summary>
        /// <param name="JSONstring">Строка. Строка JSON.</param>
        /// <returns>Соответствие - Соответствие, полученное из строки JSON</returns>
        private IValue JSONToMap(string JSONstring)
        {
            JSONReader Reader = new JSONReader();
            Reader.SetString(JSONstring);

            return ((GlobalJsonFunctions)GlobalJsonFunctions.CreateInstance()).ReadJSONInMap(Reader);
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