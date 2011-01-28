package framework.components {

	import asunit.framework.TestCase;

	public class RadioButtonTest extends TestCase {
		private var instance:RadioButton;

		public function RadioButtonTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new RadioButton();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is RadioButton", instance is RadioButton);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}