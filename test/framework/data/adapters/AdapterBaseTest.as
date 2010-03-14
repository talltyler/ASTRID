package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.AdapterBase;
		
	public class AdapterBaseTest extends TestCase 
	{
		private var instance:AdapterBase;

		public function AdapterBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new AdapterBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("AdapterBase instantiated", instance is AdapterBase);
		}
	}
}