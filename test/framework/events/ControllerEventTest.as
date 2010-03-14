package framework.events
{
	import asunit.framework.TestCase;
	import framework.display.ControllerEvent;
		
	public class ControllerEventTest extends TestCase 
	{
		private var instance:ControllerEvent;

		public function ControllerEventTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ControllerEvent();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ControllerEvent instantiated", instance is ControllerEvent);
		}
	}
}