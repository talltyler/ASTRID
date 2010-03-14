package framework.view.miniHTML
{
	import asunit.framework.TestCase;
	import framework.view.miniHTML.MiniHTML;
		
	public class MiniHTMLTest extends TestCase 
	{
		private var instance:MiniHTML;

		public function MiniHTMLTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new MiniHTML();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("MiniHTML instantiated", instance is MiniHTML);
		}
	}
}