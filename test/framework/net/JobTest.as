package framework.net {

	import asunit.framework.TestCase;

	public class JobTest extends TestCase {
		private var job:Job;

		public function JobTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			job = new Job();
		}

		override protected function tearDown():void {
			super.tearDown();
			job = null;
		}

		public function testInstantiated():void {
			assertTrue("job is Job", job is Job);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}