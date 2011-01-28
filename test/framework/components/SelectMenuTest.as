package framework.components {

	import asunit.framework.TestCase;

	public class SelectMenuTest extends TestCase {
		private var selectMenu:SelectMenu;

		public function SelectMenuTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			selectMenu = new SelectMenu();
		}

		override protected function tearDown():void {
			super.tearDown();
			selectMenu = null;
		}

		public function testInstantiated():void {
			assertTrue("selectMenu is SelectMenu", selectMenu is SelectMenu);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}