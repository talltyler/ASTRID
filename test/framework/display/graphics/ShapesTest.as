package framework.display.graphics
{
	import asunit.framework.TestCase;
	import framework.display.Shapes;
		
	public class ShapesTest extends TestCase 
	{
		private var instance:Shapes;

		public function ShapesTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Shapes();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Shapes instantiated", instance is Shapes);
		}
	}
}