package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Parser;
		
	public class ParserTest extends TestCase 
	{
		private var instance:Parser;

		public function ParserTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Parser();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Parser instantiated", instance is Parser);
		}
	}
}