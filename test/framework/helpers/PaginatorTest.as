package framework.helpers {

	import asunit.framework.TestCase;

	public class PaginatorTest extends TestCase {
		private var paginator:Paginator;

		public function PaginatorTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			paginator = new Paginator();
		}

		override protected function tearDown():void {
			super.tearDown();
			paginator = null;
		}

		public function testInstantiated():void {
			assertTrue("paginator is Paginator", paginator is Paginator);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}