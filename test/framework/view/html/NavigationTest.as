package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Navigation;
		
	public class NavigationTest extends TestCase 
	{
		private var instance:Navigation;

		public function NavigationTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Navigation();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Navigation instantiated", instance is Navigation);
		}
	}
}