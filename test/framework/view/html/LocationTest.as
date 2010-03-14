package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Location;
		
	public class LocationTest extends TestCase 
	{
		private var instance:Location;

		public function LocationTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Location();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Location instantiated", instance is Location);
		}
	}
}