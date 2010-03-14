package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.TypeUtils;
		
	public class TypeUtilsTest extends TestCase 
	{
		private var instance:TypeUtils;

		public function TypeUtilsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TypeUtils();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TypeUtils instantiated", instance is TypeUtils);
		}
	}
}