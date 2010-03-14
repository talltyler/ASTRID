package framework.controller
{
	import asunit.framework.TestCase;
	import framework.controller.MissingContext;
		
	public class MissingContextTest extends TestCase 
	{
		private var instance:MissingContext;

		public function MissingContextTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new MissingContext();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("MissingContext instantiated", instance is MissingContext);
		}
	}
}