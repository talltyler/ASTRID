package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.Tracking;
		
	public class TrackingTest extends TestCase 
	{
		private var instance:Tracking;

		public function TrackingTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Tracking();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Tracking instantiated", instance is Tracking);
		}
	}
}