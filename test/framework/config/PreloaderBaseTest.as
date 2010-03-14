package framework.config
{
	import asunit.framework.TestCase;
	import framework.config.PreloaderBase;
		
	public class PreloaderBaseTest extends TestCase 
	{
		private var instance:PreloaderBase;

		public function PreloaderBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new PreloaderBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("PreloaderBase instantiated", instance is PreloaderBase);
		}
	}
}