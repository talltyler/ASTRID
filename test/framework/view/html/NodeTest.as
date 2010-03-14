package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Node;
		
	public class NodeTest extends TestCase 
	{
		private var instance:Node;

		public function NodeTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Node();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Node instantiated", instance is Node);
		}
	}
}