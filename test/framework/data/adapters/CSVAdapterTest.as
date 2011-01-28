package framework.data.adapters {

	import asunit.framework.TestCase;

	public class CSVAdapterTest extends TestCase {
		private var cSVAdapter:CSVAdapter;

		public function CSVAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			cSVAdapter = new CSVAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			cSVAdapter = null;
		}

		public function testInstantiated():void {
			assertTrue("cSVAdapter is CSVAdapter", cSVAdapter is CSVAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}