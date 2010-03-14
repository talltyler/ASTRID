package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.TextArea;
		
	public class TextAreaTest extends TestCase 
	{
		private var instance:TextArea;

		public function TextAreaTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TextArea();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TextArea instantiated", instance is TextArea);
		}
	}
}