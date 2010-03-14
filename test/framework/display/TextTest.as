package framework.display
{
	import asunit.framework.TestCase;
	import framework.display.Text;
		
	public class TextTest extends TestCase 
	{
		private var instance:Text;

		public function TextTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Text();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Text instantiated", instance is Text);
		}
	}
}