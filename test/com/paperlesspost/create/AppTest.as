package com.paperlesspost.create {

	import asunit.framework.TestCase;

	public class AppTest extends TestCase {
		private var app:App;

		public function AppTest(methodName:String=null) {
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