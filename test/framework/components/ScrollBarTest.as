package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.ScrollBar;
		
	public class ScrollBarTest extends TestCase 
	{
		private var instance:ScrollBar;

		public function ScrollBarTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ScrollBar();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ScrollBar instantiated", instance is ScrollBar);
		}
	}
}