package framework.components {

	import asunit.framework.TestCase;

	public class ScrollBarTest extends TestCase {
		private var scrollBar:ScrollBar;

		public function ScrollBarTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			scrollBar = new ScrollBar();
		}

		override protected function tearDown():void {
			super.tearDown();
			scrollBar = null;
		}

		public function testInstantiated():void {
			assertTrue("scrollBar is ScrollBar", scrollBar is ScrollBar);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}