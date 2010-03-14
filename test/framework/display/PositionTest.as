package framework.display
{
	import asunit.framework.TestCase;
	import framework.display.Position;
		
	public class PositionTest extends TestCase 
	{
		private var instance:Position;

		public function PositionTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Position();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Position instantiated", instance is Position);
		}
	}
}