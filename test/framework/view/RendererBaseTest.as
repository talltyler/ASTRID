package framework.view {

	import asunit.framework.TestCase;

	public class RendererBaseTest extends TestCase {
		private var instance:RendererBase;

		public function RendererBaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new RendererBase();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is RendererBase", instance is RendererBase);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}