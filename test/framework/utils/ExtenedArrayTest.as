package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.ExtenedArray;
		
	public class ExtenedArrayTest extends TestCase 
	{
		private var instance:ExtenedArray;

		public function ExtenedArrayTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new ExtenedArray();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("ExtenedArray instantiated", instance is ExtenedArray);
		}
	}
}