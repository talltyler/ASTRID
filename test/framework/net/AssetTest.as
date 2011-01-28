package framework.net {

	import asunit.framework.TestCase;

	public class AssetTest extends TestCase {
		private var asset:Asset;

		public function AssetTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			asset = new Asset();
		}

		override protected function tearDown():void {
			super.tearDown();
			asset = null;
		}

		public function testInstantiated():void {
			assertTrue("asset is Asset", asset is Asset);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}