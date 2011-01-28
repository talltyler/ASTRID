package framework.events {

	import asunit.framework.TestCase;

	public class ViewEventTest extends TestCase {
		private var viewEvent:ViewEvent;

		public function ViewEventTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			viewEvent = new ViewEvent();
		}

		override protected function tearDown():void {
			super.tearDown();
			viewEvent = null;
		}

		public function testInstantiated():void {
			assertTrue("viewEvent is ViewEvent", viewEvent is ViewEvent);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}