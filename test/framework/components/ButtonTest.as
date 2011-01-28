package framework.components {

	import asunit.framework.TestCase;

	public class ButtonTest extends TestCase {
		private var button:Button;

		public function ButtonTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			button = new Button();
		}

		override protected function tearDown():void {
			super.tearDown();
			button = null;
		}

		public function testInstantiated():void {
			assertTrue("button is Button", button is Button);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}