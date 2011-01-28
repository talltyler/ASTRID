package framework.components {

	import asunit.framework.TestCase;

	public class CheckBoxTest extends TestCase {
		private var checkBox:CheckBox;

		public function CheckBoxTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			checkBox = new CheckBox();
		}

		override protected function tearDown():void {
			super.tearDown();
			checkBox = null;
		}

		public function testInstantiated():void {
			assertTrue("checkBox is CheckBox", checkBox is CheckBox);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}