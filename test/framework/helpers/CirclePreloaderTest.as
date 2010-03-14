package framework.helpers
{
	import asunit.framework.TestCase;
	import framework.display.CirclePreloader;
		
	public class CirclePreloaderTest extends TestCase 
	{
		private var instance:CirclePreloader;

		public function CirclePreloaderTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new CirclePreloader();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("CirclePreloader instantiated", instance is CirclePreloader);
		}
	}
}