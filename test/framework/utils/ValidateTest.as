package framework.utils {

	import asunit.framework.TestCase;

	public class ValidateTest extends TestCase {
		private var validate:Validate;

		public function ValidateTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			validate = new Validate();
		}

		override protected function tearDown():void {
			super.tearDown();
			validate = null;
		}

		public function testInstantiated():void {
			assertTrue("validate is Validate", validate is Validate);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}