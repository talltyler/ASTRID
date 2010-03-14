package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Frame;
		
	public class FrameTest extends TestCase 
	{
		private var instance:Frame;

		public function FrameTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Frame();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Frame instantiated", instance is Frame);
		}
	}
}