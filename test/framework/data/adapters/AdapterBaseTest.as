package framework.data.adapters {

	import asunit.framework.TestCase;

	public class AdapterBaseTest extends TestCase {
		private var instance:AdapterBase;

		public function AdapterBaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new AdapterBase();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is AdapterBase", instance is AdapterBase);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}