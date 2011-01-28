package framework.data {

	import asunit.framework.TestCase;

	public class UndoRedoTest extends TestCase {
		private var undoRedo:UndoRedo;

		public function UndoRedoTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			undoRedo = new UndoRedo();
		}

		override protected function tearDown():void {
			super.tearDown();
			undoRedo = null;
		}

		public function testInstantiated():void {
			assertTrue("undoRedo is UndoRedo", undoRedo is UndoRedo);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}