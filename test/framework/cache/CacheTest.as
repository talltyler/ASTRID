package framework.cache {

	import asunit.framework.TestCase;

	public class CacheTest extends TestCase {
		private var cache:Cache;

		public function CacheTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			cache = new Cache();
		}

		override protected function tearDown():void {
			super.tearDown();
			cache = null;
		}

		public function testInstantiated():void {
			assertTrue("cache is Cache", cache is Cache);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}