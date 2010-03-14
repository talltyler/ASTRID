package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.SelectMenu;
		
	public class SelectMenuTest extends TestCase 
	{
		private var instance:SelectMenu;

		public function SelectMenuTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new SelectMenu();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("SelectMenu instantiated", instance is SelectMenu);
		}
	}
}