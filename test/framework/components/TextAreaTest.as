package framework.components {

	import asunit.framework.TestCase;

	public class TextAreaTest extends TestCase {
		private var textArea:TextArea;

		public function TextAreaTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			textArea = new TextArea();
		}

		override protected function tearDown():void {
			super.tearDown();
			textArea = null;
		}

		public function testInstantiated():void {
			assertTrue("textArea is TextArea", textArea is TextArea);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}