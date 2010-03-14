package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Layer;
		
	public class LayerTest extends TestCase 
	{
		private var instance:Layer;

		public function LayerTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Layer();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Layer instantiated", instance is Layer);
		}
	}
}