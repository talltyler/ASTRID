package framework.net
{
	import asunit.framework.TestCase;
	import framework.net.AssetsGroup;
		
	public class AssetsGroupTest extends TestCase 
	{
		private var instance:AssetsGroup;

		public function AssetsGroupTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new AssetsGroup();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("AssetsGroup instantiated", instance is AssetsGroup);
		}
	}
}