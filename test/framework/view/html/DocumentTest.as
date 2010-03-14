package framework.view.html
{
	import asunit.framework.TestCase;
	import framework.view.html.Document;
		
	public class DocumentTest extends TestCase 
	{
		private var instance:Document;

		public function DocumentTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Document();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Document instantiated", instance is Document);
		}
	}
}