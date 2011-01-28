package framework.display {

	import asunit.framework.TestCase;

	public class ElementBaseTest extends TestCase {
		private var instance:ElementBase;

		public function ElementBaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ElementBase();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ElementBase", instance is ElementBase);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}