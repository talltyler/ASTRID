package framework.config {

	import asunit.framework.TestCase;

	public class BootTest extends TestCase {
		private var boot:Boot;

		public function BootTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			boot = new Boot();
		}

		override protected function tearDown():void {
			super.tearDown();
			boot = null;
		}

		public function testInstantiated():void {
			assertTrue("boot is Boot", boot is Boot);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}