package framework.data {

	import asunit.framework.TestCase;

	public class DataTest extends TestCase {
		private var data:Data;

		public function DataTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			data = new Data();
		}

		override protected function tearDown():void {
			super.tearDown();
			data = null;
		}

		public function testInstantiated():void {
			assertTrue("data is Data", data is Data);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}