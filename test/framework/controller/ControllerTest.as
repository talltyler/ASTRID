package framework.controller {

	import asunit.framework.TestCase;

	public class ControllerTest extends TestCase {
		private var controller:Controller;

		public function ControllerTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			controller = new Controller();
		}

		override protected function tearDown():void {
			super.tearDown();
			controller = null;
		}

		public function testInstantiated():void {
			assertTrue("controller is Controller", controller is Controller);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}