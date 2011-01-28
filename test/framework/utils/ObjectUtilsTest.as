package framework.utils {

	import asunit.framework.TestCase;

	public class ObjectUtilsTest extends TestCase {
		private var instance:ObjectUtils;

		public function ObjectUtilsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ObjectUtils();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ObjectUtils", instance is ObjectUtils);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}