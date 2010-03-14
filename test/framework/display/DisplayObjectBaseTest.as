package framework.display
{
	import asunit.framework.TestCase;
	import framework.display.DisplayObjectBase;
		
	public class DisplayObjectBaseTest extends TestCase 
	{
		private var instance:DisplayObjectBase;

		public function DisplayObjectBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new DisplayObjectBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("DisplayObjectBase instantiated", instance is DisplayObjectBase);
		}
	}
}