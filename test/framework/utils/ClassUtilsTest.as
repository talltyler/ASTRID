package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.ClassUtils;
		
	public class ClassUtilsTest extends TestCase 
	{
		private var instance:ClassUtils;

		public function ClassUtilsTest() 
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
			assertTrue("ClassUtils instantiated", instance is ClassUtils);
		}
	}
}