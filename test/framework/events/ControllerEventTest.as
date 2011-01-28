package framework.events {

	import asunit.framework.TestCase;

	public class ControllerEventTest extends TestCase {
		private var instance:ControllerEvent;

		public function ControllerEventTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ControllerEvent();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ControllerEvent", instance is ControllerEvent);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}