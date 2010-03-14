package framework.view.html.tags
{
	import asunit.framework.TestCase;
	import framework.view.html.FormTag;
		
	public class FormTagTest extends TestCase 
	{
		private var instance:FormTag;

		public function FormTagTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new FormTag();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("FormTag instantiated", instance is FormTag);
		}
	}
}