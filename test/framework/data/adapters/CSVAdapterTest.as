package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.CSVAdapter;
		
	public class CSVAdapterTest extends TestCase 
	{
		private var instance:CSVAdapter;

		public function CSVAdapterTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new CSVAdapter();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("CSVAdapter instantiated", instance is CSVAdapter);
		}
	}
}