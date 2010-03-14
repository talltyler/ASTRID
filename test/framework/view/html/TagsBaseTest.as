package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.TagsBase;
		
	public class TagsBaseTest extends TestCase 
	{
		private var instance:TagsBase;

		public function TagsBaseTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TagsBase();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TagsBase instantiated", instance is TagsBase);
		}
	}
}