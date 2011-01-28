package framework.data.adapters {

	import asunit.framework.TestCase;

	public class SQLiteAdapterTest extends TestCase {
		private var instance:SQLiteAdapter;

		public function SQLiteAdapterTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new SQLiteAdapter();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is SQLiteAdapter", instance is SQLiteAdapter);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}