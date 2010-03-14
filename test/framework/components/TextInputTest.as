package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.TextInput;
		
	public class TextInputTest extends TestCase 
	{
		private var instance:TextInput;

		public function TextInputTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TextInput();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TextInput instantiated", instance is TextInput);
		}
	}
}