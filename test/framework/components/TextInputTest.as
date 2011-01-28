package framework.components {

	import asunit.framework.TestCase;

	public class TextInputTest extends TestCase {
		private var textInput:TextInput;

		public function TextInputTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			textInput = new TextInput();
		}

		override protected function tearDown():void {
			super.tearDown();
			textInput = null;
		}

		public function testInstantiated():void {
			assertTrue("textInput is TextInput", textInput is TextInput);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}