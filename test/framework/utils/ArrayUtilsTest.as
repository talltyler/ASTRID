package framework.utils {

	import asunit.framework.TestCase;

	public class ArrayUtilsTest extends TestCase {
		private var arrayUtils:ArrayUtils;

		public function ArrayUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			arrayUtils = new ArrayUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			arrayUtils = null;
		}

		public function testInstantiated():void {
			assertTrue("arrayUtils is ArrayUtils", arrayUtils is ArrayUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}