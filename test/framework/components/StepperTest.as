package framework.components {

	import asunit.framework.TestCase;

	public class StepperTest extends TestCase {
		private var stepper:Stepper;

		public function StepperTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			stepper = new Stepper();
		}

		override protected function tearDown():void {
			super.tearDown();
			stepper = null;
		}

		public function testInstantiated():void {
			assertTrue("stepper is Stepper", stepper is Stepper);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}