package framework.events {

	import asunit.framework.TestCase;

	public class ListenerManagerTest extends TestCase {
		private var instance:ListenerManager;

		public function ListenerManagerTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ListenerManager();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ListenerManager", instance is ListenerManager);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}