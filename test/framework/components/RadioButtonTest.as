package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.RadioButton;
		
	public class RadioButtonTest extends TestCase 
	{
		private var instance:RadioButton;

		public function RadioButtonTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new RadioButton();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("RadioButton instantiated", instance is RadioButton);
		}
	}
}