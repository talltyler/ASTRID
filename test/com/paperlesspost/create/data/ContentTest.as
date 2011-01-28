package com.paperlesspost.create.data {

	import asunit.framework.TestCase;

	public class ContentTest extends TestCase {
		private var content:Content;

		public function ContentTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			content = new Content();
		}

		override protected function tearDown():void {
			super.tearDown();
			content = null;
		}

		public function testInstantiated():void {
			assertTrue("content is Content", content is Content);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}