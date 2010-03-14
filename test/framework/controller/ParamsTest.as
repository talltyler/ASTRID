package framework.controller
{
	import asunit.framework.TestCase;
	import framework.controller.Params;
		
	public class ParamsTest extends TestCase 
	{
		private var instance:Params;

		public function ParamsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Params();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Params instantiated", instance is Params);
		}
	}
}