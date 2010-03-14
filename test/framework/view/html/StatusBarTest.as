package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.StatusBar;
		
	public class StatusBarTest extends TestCase 
	{
		private var instance:StatusBar;

		public function StatusBarTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new StatusBar();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("StatusBar instantiated", instance is StatusBar);
		}
	}
}