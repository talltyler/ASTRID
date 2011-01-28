package framework.components {

	import asunit.framework.TestCase;

	public class ColorPickerTest extends TestCase {
		private var instance:ColorPicker;

		public function ColorPickerTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ColorPicker();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ColorPicker", instance is ColorPicker);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}