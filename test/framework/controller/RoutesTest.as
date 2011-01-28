package framework.controller {

	import asunit.framework.TestCase;

	public class RoutesTest extends TestCase {
		private var routes:Routes;

		public function RoutesTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			routes = new Routes();
		}

		override protected function tearDown():void {
			super.tearDown();
			routes = null;
		}

		public function testInstantiated():void {
			assertTrue("routes is Routes", routes is Routes);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}