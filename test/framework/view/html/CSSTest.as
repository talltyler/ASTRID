package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.CSS;
		
	public class CSSTest extends TestCase 
	{
		private var instance:CSS;

		public function CSSTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new CSS();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("CSS instantiated", instance is CSS);
		}
	}
}