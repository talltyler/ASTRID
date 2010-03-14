package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Window;
		
	public class WindowTest extends TestCase 
	{
		private var instance:Window;

		public function WindowTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Window();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Window instantiated", instance is Window);
		}
	}
}