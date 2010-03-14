package framework.display.graphics
{
	import asunit.framework.TestCase;
	import framework.display.Border;
		
	public class BorderTest extends TestCase 
	{
		private var instance:Border;

		public function BorderTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Border();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Border instantiated", instance is Border);
		}
	}
}