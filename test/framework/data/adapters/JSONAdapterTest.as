package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.JSONAdapter;
		
	public class JSONAdapterTest extends TestCase 
	{
		private var instance:JSONAdapter;

		public function JSONAdapterTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new JSONAdapter();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("JSONAdapter instantiated", instance is JSONAdapter);
		}
	}
}