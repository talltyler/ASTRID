package framework.utils {

	import asunit.framework.TestCase;

	public class TypeUtilsTest extends TestCase {
		private var typeUtils:TypeUtils;

		public function TypeUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			typeUtils = new TypeUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			typeUtils = null;
		}

		public function testInstantiated():void {
			assertTrue("typeUtils is TypeUtils", typeUtils is TypeUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}