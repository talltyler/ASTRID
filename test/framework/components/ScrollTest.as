package framework.components {

	import asunit.framework.TestCase;

	public class ScrollTest extends TestCase {
		private var scroll:Scroll;

		public function ScrollTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			scroll = new Scroll();
		}

		override protected function tearDown():void {
			super.tearDown();
			scroll = null;
		}

		public function testInstantiated():void {
			assertTrue("scroll is Scroll", scroll is Scroll);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}