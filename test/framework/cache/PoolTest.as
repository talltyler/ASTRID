package framework.cache
{
	import asunit.framework.TestCase;
	import framework.cache.Pool;
	
	public class PoolTest extends TestCase 
	{
		private var instance:Pool;

		public function PoolTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Pool();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Pool instantiated", instance is Pool);
			var pool1:* = instance.getPool( Mock );
			assertTrue("Pool size equals 1", pool1.size == 1 );
			assertTrue("Pool usageCount equals 1", pool1.usageCount == 1 );
			assertTrue("Pool wasteCount equals 0", pool1.wasteCount == 0 );
			var mock1:* = pool1.retrieve("test", 1);
			assertTrue("Pool::retrieve returns an instance of our class", mock1 is Mock );
			assertTrue("Pool mock object has arguments", ( mock1.arg1 is String && mock1.arg2 is Number && mock1.arg2 == 1 ) );
			pool1.destroy(mock1);
			assertTrue("Pool after mock destroyed wasteCount ok", pool1.wasteCount == 1 );
			assertTrue("Pool after mock destroyed usageCount ok", pool1.usageCount == 0 );
		}
	}
}
class Mock 
{
	public var arg1:String;
	public var arg2:Number;
	public function Mock( arg1:String=null, arg2:Number=null )
	{
		this.arg1 = arg1;
		this.arg2 = arg2;
	}
}