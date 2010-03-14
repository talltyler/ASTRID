package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.TextNode;
		
	public class TextNodeTest extends TestCase 
	{
		private var instance:TextNode;

		public function TextNodeTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new TextNode();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("TextNode instantiated", instance is TextNode);
		}
	}
}