package framework.components {

	import asunit.framework.TestCase;

	public class FileUploadTest extends TestCase {
		private var fileUpload:FileUpload;

		public function FileUploadTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			fileUpload = new FileUpload();
		}

		override protected function tearDown():void {
			super.tearDown();
			fileUpload = null;
		}

		public function testInstantiated():void {
			assertTrue("fileUpload is FileUpload", fileUpload is FileUpload);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}