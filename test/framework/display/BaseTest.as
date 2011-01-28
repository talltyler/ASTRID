package framework.display {

	import asunit.framework.TestCase;

	public class BaseTest extends TestCase {
		private var base:Base;

		public function BaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			base = new Base();
		}

		override protected function tearDown():void {
			super.tearDown();
			base = null;
		}

		public function testInstantiated():void {
			assertTrue("base is Base", base is Base);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}