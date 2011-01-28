package framework.net {

	import asunit.framework.TestCase;

	public class AssetsTest extends TestCase {
		private var assets:Assets;

		public function AssetsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			assets = new Assets();
		}

		override protected function tearDown():void {
			super.tearDown();
			assets = null;
		}

		public function testInstantiated():void {
			assertTrue("assets is Assets", assets is Assets);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}