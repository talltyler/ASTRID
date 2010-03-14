package framework.events
{
	import asunit.framework.TestCase;
	import framework.display.ModelEvent;
		
	public class ModelEventTest extends TestCase 
	{
		private var instance:ModelEvent;

		public function ModelEventTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ModelEvent();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ModelEvent instantiated", instance is ModelEvent);
		}
	}
}