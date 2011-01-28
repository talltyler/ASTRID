package com.paperlesspost.create.renderers {

	import asunit.framework.TestCase;

	public class EditorTest extends TestCase {
		private var editor:Editor;

		public function EditorTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			editor = new Editor();
		}

		override protected function tearDown():void {
			super.tearDown();
			editor = null;
		}

		public function testInstantiated():void {
			assertTrue("editor is Editor", editor is Editor);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}