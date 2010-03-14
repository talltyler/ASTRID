package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.CheckBox;
		
	public class CheckBoxTest extends TestCase 
	{
		private var instance:CheckBox;

		public function CheckBoxTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new CheckBox();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("CheckBox instantiated", instance is CheckBox);
		}
	}
}