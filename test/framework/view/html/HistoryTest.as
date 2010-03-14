package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.History;
		
	public class HistoryTest extends TestCase 
	{
		private var instance:History;

		public function HistoryTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new History();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("History instantiated", instance is History);
		}
	}
}