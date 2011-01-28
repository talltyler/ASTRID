package framework.utils {

	import asunit.framework.TestCase;

	public class ArrayPlusTest extends TestCase {
		private var arrayPlus:ArrayPlus;

		public function ArrayPlusTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			arrayPlus = new ArrayPlus();
		}

		override protected function tearDown():void {
			super.tearDown();
			arrayPlus = null;
		}

		public function testInstantiated():void {
			assertTrue("arrayPlus is ArrayPlus", arrayPlus is ArrayPlus);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}