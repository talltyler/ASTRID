package framework.data
{
	import asunit.framework.TestCase;
	import framework.data.Data;
		
	public class DataTest extends TestCase 
	{
		private var instance:Data;

		public function DataTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Data();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Data instantiated", instance is Data);
		}
	}
}