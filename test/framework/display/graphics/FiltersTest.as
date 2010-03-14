package framework.display.graphics
{
	import asunit.framework.TestCase;
	import framework.display.Filters;
		
	public class FiltersTest extends TestCase 
	{
		private var instance:Filters;

		public function FiltersTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Filters();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Filters instantiated", instance is Filters);
		}
	}
}