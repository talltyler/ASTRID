package framework.controller
{
	import asunit.framework.TestCase;
	import framework.controller.ControllerBase;
		
	public class ControllerBaseTest extends TestCase 
	{
		private var instance:ControllerBase;

		public function ControllerBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ControllerBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ControllerBase instantiated", instance is ControllerBase);
		}
	}
}