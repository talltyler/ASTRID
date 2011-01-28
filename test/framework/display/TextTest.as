package framework.display {

	import asunit.framework.TestCase;

	public class TextTest extends TestCase {
		private var text:Text;

		public function TextTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			text = new Text();
		}

		override protected function tearDown():void {
			super.tearDown();
			text = null;
		}

		public function testInstantiated():void {
			assertTrue("text is Text", text is Text);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}