package framework.plugins
{
	import asunit.framework.TestCase;
	import framework.plugins.Plugins;
		
	public class PluginsTest extends TestCase 
	{
		private var instance:Plugins;

		public function PluginsTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Plugins();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Plugins instantiated", instance is Plugins);
		}
	}
}