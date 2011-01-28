package framework.net {

	import asunit.framework.TestCase;

	public class URITest extends TestCase {
		private var uRI:URI;

		public function URITest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			uRI = new URI();
		}

		override protected function tearDown():void {
			super.tearDown();
			uRI = null;
		}

		public function testInstantiated():void {
			assertTrue("uRI is URI", uRI is URI);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}