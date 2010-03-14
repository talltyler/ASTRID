package framework.data
{
	import asunit.framework.TestCase;
	import framework.data.ModelUtils;
		
	public class ModelUtilsTest extends TestCase 
	{
		private var instance:ModelUtils;

		public function ModelUtilsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ModelUtils();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ModelUtils instantiated", instance is ModelUtils);
		}
	}
}