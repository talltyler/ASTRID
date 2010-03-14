package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.FileUpload;
		
	public class FileUploadTest extends TestCase 
	{
		private var instance:FileUpload;

		public function FileUploadTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new FileUpload();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("FileUpload instantiated", instance is FileUpload);
		}
	}
}