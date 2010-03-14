package framework.debug
{
	import asunit.framework.TestCase;
	import framework.debug.Log;
		
	public class LogTest extends TestCase 
	{
		private var instance:Log;

		public function LogTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Log();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Log instantiated", instance is Log);
		}
	}
}