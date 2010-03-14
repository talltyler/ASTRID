package framework.view.html.tags
{
	import asunit.framework.TestCase;
	import framework.view.html.AudioTag;
		
	public class AudioTagTest extends TestCase 
	{
		private var instance:AudioTag;

		public function AudioTagTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new AudioTag();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("AudioTag instantiated", instance is AudioTag);
		}
	}
}