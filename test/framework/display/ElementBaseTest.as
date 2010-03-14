package framework.display
{
	import asunit.framework.TestCase;
	import framework.display.ElementBase;
		
	public class ElementBaseTest extends TestCase 
	{
		private var instance:ElementBase;

		public function ElementBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ElementBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ElementBase instantiated", instance is ElementBase);
		}
	}
}