package com.paperlesspost.create.renderers {

	import asunit.framework.TestCase;

	public class CardTest extends TestCase {
		private var card:Card;

		public function CardTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			card = new Card();
		}

		override protected function tearDown():void {
			super.tearDown();
			card = null;
		}

		public function testInstantiated():void {
			assertTrue("card is Card", card is Card);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}