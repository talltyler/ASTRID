package framework.config
{
	import asunit.framework.TestCase;
	import framework.config.Boot;
		
	public class BootTest extends TestCase 
	{
		private var instance:Boot;

		public function BootTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Boot();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Boot instantiated", instance is Boot);
		}
	}
}