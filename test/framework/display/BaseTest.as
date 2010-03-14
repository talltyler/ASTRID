package framework.display
{
	import asunit.framework.TestCase;
	import framework.display.Base;
		
	public class BaseTest extends TestCase 
	{
		private var instance:Base;

		public function BaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Base();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Base instantiated", instance is Base);
		}
	}
}