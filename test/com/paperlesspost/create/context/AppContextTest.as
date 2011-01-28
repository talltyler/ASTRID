package com.paperlesspost.create.context {

	import asunit.framework.TestCase;

	public class AppContextTest extends TestCase {
		private var app:App;

		public function AppContextTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			app = new App();
		}

		override protected function tearDown():void {
			super.tearDown();
			app = null;
		}

		public function testInstantiated():void {
			assertTrue("app is App", app is App);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}