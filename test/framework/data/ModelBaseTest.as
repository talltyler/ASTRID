package framework.data {

	import asunit.framework.TestCase;

	public class ModelBaseTest extends TestCase {
		private var modelBase:ModelBase;

		public function ModelBaseTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			modelBase = new ModelBase();
		}

		override protected function tearDown():void {
			super.tearDown();
			modelBase = null;
		}

		public function testInstantiated():void {
			assertTrue("modelBase is ModelBase", modelBase is ModelBase);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}