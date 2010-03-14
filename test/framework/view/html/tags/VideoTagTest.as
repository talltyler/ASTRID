package framework.view.html.tags
{
	import asunit.framework.TestCase;
	import framework.view.html.VideoTag;
		
	public class VideoTagTest extends TestCase 
	{
		private var instance:FormTag;

		public function VideoTagTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new VideoTag();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("VideoTag instantiated", instance is VideoTag);
		}
	}
}