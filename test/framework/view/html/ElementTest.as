package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Element;
		
	public class ElementTest extends TestCase 
	{
		private var instance:Element;

		public function ElementTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Element();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Element instantiated", instance is Element);
		}
	}
}