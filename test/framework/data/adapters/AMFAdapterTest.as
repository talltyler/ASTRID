package framework.data.adapters {

	import asunit.framework.TestCase;

	public class AMFAdapterTest extends TestCase {
		private var aMFAdapter:AMFAdapter;

		public function AMFAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			aMFAdapter = new AMFAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			aMFAdapter = null;
		}

		public function testInstantiated():void {
			assertTrue("aMFAdapter is AMFAdapter", aMFAdapter is AMFAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}