package framework.net
{
	import asunit.framework.TestCase;
	import framework.net.Asset;
		
	public class AssetTest extends TestCase 
	{
		private var instance:Asset;

		public function AssetTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Asset();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Asset instantiated", instance is Asset);
		}
	}
}