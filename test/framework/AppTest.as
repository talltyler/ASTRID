package wrapper
{
	import asunit.framework.TestCase;
	import App;
	import flash.display.DisplayObject;
	import framework.data.Data;
	import framework.controller.Controller;
	import framework.cache.Cache;
	import framework.net.Assets;
	import framework.controller.Routes;
	import framework.tasks.Tasks;
	import framework.plugins.Plugins;
	import framework.debug.Log;
		
	public class AppTest extends TestCase 
	{
		private var instance:App;

		public function AppTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new App();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("App instantiated", instance is App);
			assertTrue("App is DisplayObject", instance is DisplayObject);
			assertTrue("App has model", instance.data is Data);
			assertTrue("App has controller", instance.controller is Controller);
			assertTrue("App has parameters", instance.parameters is Object);
			assertTrue("App has cache", instance.cache is Cache);
			assertTrue("App has assets", instance.assets is Assets);
			assertTrue("App has routes", instance.routes is Routes);
			assertTrue("App has tasks", instance.tasks is Tasks);
			assertTrue("App has plugins", instance.plugins is Plugins);
			assertTrue("App has log", instance.log is Log);
		}
	}
}