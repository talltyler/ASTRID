package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.XMLAdapter;
		
	public class XMLAdapterTest extends TestCase 
	{
		private var instance:XMLAdapter;

		public function XMLAdapterTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new XMLAdapter();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("XMLAdapter instantiated", instance is XMLAdapter);
		}
	}
}