package framework.net
{
	import asunit.framework.TestCase;
	import framework.net.URI;
		
	public class URITest extends TestCase 
	{
		private var instance:URI;

		public function URITest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new URI();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("URI instantiated", instance is URI);
		}
	}
}