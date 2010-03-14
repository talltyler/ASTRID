package framework.helpers
{
	import asunit.framework.TestCase;
	import framework.display.HTMLHelper;
		
	public class HTMLHelperTest extends TestCase 
	{
		private var instance:HTMLHelper;

		public function HTMLHelperTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new HTMLHelper();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("HTMLHelper instantiated", instance is HTMLHelper);
		}
	}
}