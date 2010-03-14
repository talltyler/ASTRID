package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.Button;
		
	public class ButtonTest extends TestCase 
	{
		private var instance:Button;

		public function ButtonTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Button();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("App instantiated", instance is Button);
		}
	}
}