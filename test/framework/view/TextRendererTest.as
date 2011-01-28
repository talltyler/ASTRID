package framework.view {

	import asunit.framework.TestCase;

	public class TextRendererTest extends TestCase {
		private var instance:TextRenderer;

		public function TextRendererTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new TextRenderer();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is TextRenderer", instance is TextRenderer);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}