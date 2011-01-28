package framework.data.adapters {

	import asunit.framework.TestCase;

	public class JSONAdapterTest extends TestCase {
		private var instance:JSONAdapter;

		public function JSONAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new JSONAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is JSONAdapter", instance is JSONAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}