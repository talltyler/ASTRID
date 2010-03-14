package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.ArrayUtils;
		
	public class ArrayUtilsTest extends TestCase 
	{
		private var instance:ArrayUtils;

		public function ArrayUtilsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ArrayUtils();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ArrayUtils instantiated", instance is ArrayUtils);
		}
	}
}