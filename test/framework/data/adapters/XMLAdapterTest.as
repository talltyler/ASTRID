package framework.data.adapters {

	import asunit.framework.TestCase;

	public class XMLAdapterTest extends TestCase {
		private var xMLAdapter:XMLAdapter;

		public function XMLAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			xMLAdapter = new XMLAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			xMLAdapter = null;
		}

		public function testInstantiated():void {
			assertTrue("xMLAdapter is XMLAdapter", xMLAdapter is XMLAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}