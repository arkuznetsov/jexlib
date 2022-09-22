/*----------------------------------------------------------
Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/jexlib/
----------------------------------------------------------*/

using NUnit.Framework;
using oscriptcomponent;
using System.Collections.Generic;
using ScriptEngine.HostedScript.Library;

// Используется NUnit 3.6

namespace NUnitTests
{
	[TestFixture]
	public class MainTestClass
	{

		private EngineHelpWrapper _host;

		public static List<TestCaseData> TestCases
		{
			get
            {
				var testCases = new List<TestCaseData>();
				EngineHelpWrapper _host = new EngineHelpWrapper();
				_host.StartEngine();

				ArrayImpl testMethods =_host.GetTestMethods("NUnitTests.Tests.external.os");

				foreach (var ivTestMethod in testMethods)
				{
					testCases.Add(new TestCaseData(ivTestMethod.ToString()));
                }

				return testCases;
            }
		}
		
		[OneTimeSetUp]
		public void Initialize()
		{
			_host = new EngineHelpWrapper();
			_host.StartEngine();
		}

		[Test]
		[Category("Create data extractor")]
		public void TestAsInternalObjects()
		{
			var item1 = new JSONDataExtractor();
       
//			Assert.AreEqual(item1.ReadonlyProperty, "MyValue"); 
		}

		[TestCaseSource(nameof(TestCases))]
		[Category("Test data extractor")]
		public void TestAsExternalObjects(string testCase)
		{
			_host.RunTestMethod("NUnitTests.Tests.external.os", testCase);
		}
	}
}
