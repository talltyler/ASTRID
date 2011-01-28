package framework.net {

	import asunit.framework.TestCase;

	public class AssetsGroupTest extends TestCase {
		private var instance:AssetsGroup;

		public function AssetsGroupTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new AssetsGroup();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is AssetsGroup", instance is AssetsGroup);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}