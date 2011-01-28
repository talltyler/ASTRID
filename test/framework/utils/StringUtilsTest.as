package framework.utils {

	import asunit.framework.TestCase;

	public class StringUtilsTest extends TestCase {
		private var instance:StringUtils;

		public function StringUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new StringUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is StringUtils", instance is StringUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}