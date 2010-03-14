package framework.controller
{
	import asunit.framework.TestCase;
	import framework.controller.Controller;
		
	public class ControllerTest extends TestCase 
	{
		private var instance:Controller;

		public function ControllerTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Controller();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Controller instantiated", instance is Controller);
		}
	}
}