package framework.events {

	import asunit.framework.TestCase;

	public class ModelEventTest extends TestCase {
		private var modelEvent:ModelEvent;

		public function ModelEventTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			modelEvent = new ModelEvent();
		}

		override protected function tearDown():void {
			super.tearDown();
			modelEvent = null;
		}

		public function testInstantiated():void {
			assertTrue("modelEvent is ModelEvent", modelEvent is ModelEvent);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}