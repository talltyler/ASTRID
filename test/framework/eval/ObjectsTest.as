package framework.eval {

	import asunit.framework.TestCase;

	public class ObjectsTest extends TestCase {
		private var objects:Objects;

		public function ObjectsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			objects = new Objects();
		}

		override protected function tearDown():void {
			super.tearDown();
			objects = null;
		}

		public function testInstantiated():void {
			assertTrue("objects is Objects", objects is Objects);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}