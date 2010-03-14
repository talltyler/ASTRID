package framework.net
{
	import asunit.framework.TestCase;
	import framework.net.Job;
		
	public class JobTest extends TestCase 
	{
		private var instance:Job;

		public function JobTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Job();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Job instantiated", instance is Job);
		}
	}
}