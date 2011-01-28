package framework.data {

	import asunit.framework.TestCase;

	public class ModelUtilsTest extends TestCase {
		private var modelUtils:ModelUtils;

		public function ModelUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			modelUtils = new ModelUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			modelUtils = null;
		}

		public function testInstantiated():void {
			assertTrue("modelUtils is ModelUtils", modelUtils is ModelUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}