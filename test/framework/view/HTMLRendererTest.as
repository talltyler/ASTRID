package framework.view
{
	import asunit.framework.TestCase;
	import framework.view.HTMLRenderer;
		
	public class HTMLRendererTest extends TestCase 
	{
		private var instance:HTMLRenderer;

		public function HTMLRendererTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new HTMLRenderer();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("HTMLRenderer instantiated", instance is HTMLRenderer);
		}
	}
}