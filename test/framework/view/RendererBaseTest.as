package framework.view
{
	import asunit.framework.TestCase;
	import framework.view.RendererBase;
		
	public class RendererBaseTest extends TestCase 
	{
		private var instance:RendererBase;

		public function RendererBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new RendererBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("RendererBase instantiated", instance is RendererBase);
		}
	}
}