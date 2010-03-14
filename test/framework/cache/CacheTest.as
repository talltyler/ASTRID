package framework.cache
{
	import asunit.framework.TestCase;
	import framework.cache.Cache;
	
	public class CacheTest extends TestCase 
	{
		private var instance:Cache;

		public function CacheTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Cache(this);
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Cache instantiated", instance is Cache);
			
			instance.name = "Tyler";
			assertTrue("Cache can get and set dynamic variables", instance.name == "Tyler");
			
			assertTrue("Cache has context", instance.context == this);
		}
	}
}