package framework.controller {

	import asunit.framework.TestCase;

	public class ContextBaseTest extends TestCase {
		private var instance:ContextBase;

		public function ContextBaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ContextBase();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ContextBase", instance is ContextBase);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}