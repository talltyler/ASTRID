package framework.events
{
	import asunit.framework.TestCase;
	import framework.display.ListenerManager;
		
	public class ListenerManagerTest extends TestCase 
	{
		private var instance:ListenerManager;

		public function ListenerManagerTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ListenerManager();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ListenerManager instantiated", instance is ListenerManager);
		}
	}
}