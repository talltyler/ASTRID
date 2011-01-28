package framework.utils {

	import asunit.framework.TestCase;

	public class ClassUtilsTest extends TestCase {
		private var classUtils:ClassUtils;

		public function ClassUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			classUtils = new ClassUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			classUtils = null;
		}

		public function testInstantiated():void {
			assertTrue("classUtils is ClassUtils", classUtils is ClassUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}