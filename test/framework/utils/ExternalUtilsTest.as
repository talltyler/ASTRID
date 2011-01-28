package framework.utils {

	import asunit.framework.TestCase;

	public class ExternalUtilsTest extends TestCase {
		private var instance:ExternalUtils;

		public function ExternalUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ExternalUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ExternalUtils", instance is ExternalUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}