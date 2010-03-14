package framework.display.graphics
{
	import asunit.framework.TestCase;
	import framework.display.Fill;
		
	public class FillTest extends TestCase 
	{
		private var instance:Fill;

		public function FillTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Fill();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Fill instantiated", instance is Fill);
		}
	}
}