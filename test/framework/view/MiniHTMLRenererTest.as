package framework.view
{
	import asunit.framework.TestCase;
	import framework.view.MiniHTMLRenerer;
		
	public class MiniHTMLRenererTest extends TestCase 
	{
		private var instance:MiniHTMLRenerer;

		public function MiniHTMLRenererTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new MiniHTMLRenerer();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("MiniHTMLRenerer instantiated", instance is MiniHTMLRenerer);
		}
	}
}