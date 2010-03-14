package framework.controller
{
	import asunit.framework.TestCase;
	import framework.controller.Routes;
		
	public class RoutesTest extends TestCase 
	{
		private var instance:Routes;

		public function RoutesTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Routes();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Routes instantiated", instance is Routes);
		}
	}
}