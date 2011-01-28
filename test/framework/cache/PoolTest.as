package framework.cache {

	import asunit.framework.TestCase;

	public class PoolTest extends TestCase {
		private var pool:Pool;

		public function PoolTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			pool = new Pool();
		}

		override protected function tearDown():void {
			super.tearDown();
			pool = null;
		}

		public function testInstantiated():void {
			assertTrue("pool is Pool", pool is Pool);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}