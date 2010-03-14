package framework.data.adapters
{
	import asunit.framework.TestCase;
	import framework.data.adapters.SQLiteAdapter;
		
	public class SQLiteAdapterTest extends TestCase 
	{
		private var instance:SQLiteAdapter;

		public function SQLiteAdapterTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new SQLiteAdapter();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("SQLiteAdapter instantiated", instance is SQLiteAdapter);
		}
	}
}