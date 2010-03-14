package framework.helpers
{
	import asunit.framework.TestCase;
	import framework.display.Paginator;
		
	public class PaginatorTest extends TestCase 
	{
		private var instance:Paginator;

		public function PaginatorTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Paginator();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Paginator instantiated", instance is Paginator);
		}
	}
}