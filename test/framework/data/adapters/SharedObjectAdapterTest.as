package framework.data.adapters {

	import asunit.framework.TestCase;

	public class SharedObjectAdapterTest extends TestCase {
		private var instance:SharedObjectAdapter;

		public function SharedObjectAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new SharedObjectAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is SharedObjectAdapter", instance is SharedObjectAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}