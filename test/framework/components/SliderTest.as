package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.Slider;
		
	public class SliderTest extends TestCase 
	{
		private var instance:Slider;

		public function SliderTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Slider();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Slider instantiated", instance is Slider);
		}
	}
}