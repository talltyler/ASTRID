package framework.events
{
	import asunit.framework.TestCase;
	import framework.display.ViewEvent;
		
	public class ViewEventTest extends TestCase 
	{
		private var instance:ViewEvent;

		public function ViewEventTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ViewEvent();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ViewEvent instantiated", instance is ViewEvent);
		}
	}
}