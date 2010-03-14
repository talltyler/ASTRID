package framework.view
{
	import asunit.framework.TestCase;
	import framework.view.TextRenderer;
		
	public class TextRendererTest extends TestCase 
	{
		private var instance:TextRenderer;

		public function TextRendererTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TextRenderer();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TextRenderer instantiated", instance is TextRenderer);
		}
	}
}