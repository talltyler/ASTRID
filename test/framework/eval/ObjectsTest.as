package framework.eval
{
	import asunit.framework.TestCase;
	import framework.display.Objects;
		
	public class ObjectsTest extends TestCase 
	{
		private var instance:Objects;

		public function ObjectsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Objects();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Objects instantiated", instance is Objects);
		}
	}
}