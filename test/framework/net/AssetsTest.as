package framework.net
{
	import asunit.framework.TestCase;
	import framework.net.Assets;
		
	public class AssetsTest extends TestCase 
	{
		private var instance:Assets;

		public function AssetsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Assets();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Assets instantiated", instance is Assets);
		}
	}
}