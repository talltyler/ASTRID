package framework.view.html.tags
{
	import asunit.framework.TestCase;
	import framework.view.html.BasicTag;
		
	public class BasicTagTest extends TestCase 
	{
		private var instance:BasicTag;

		public function BasicTagTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new BasicTag();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("BasicTag instantiated", instance is BasicTag);
		}
	}
}