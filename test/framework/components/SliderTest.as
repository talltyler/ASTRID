package framework.components {

	import asunit.framework.TestCase;

	public class SliderTest extends TestCase {
		private var slider:Slider;

		public function SliderTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			slider = new Slider();
		}

		override protected function tearDown():void {
			super.tearDown();
			slider = null;
		}

		public function testInstantiated():void {
			assertTrue("slider is Slider", slider is Slider);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}