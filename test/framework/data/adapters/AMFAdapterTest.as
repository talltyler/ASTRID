package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.AMFAdapter;
		
	public class AMFAdapterTest extends TestCase 
	{
		private var instance:AMFAdapter;

		public function AMFAdapterTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new AMFAdapter();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("AMFAdapter instantiated", instance is AMFAdapter);
		}
	}
}