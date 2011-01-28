package com.paperlesspost.create.renderers {

	import asunit.framework.TestCase;

	public class EnvelopeTest extends TestCase {
		private var envelope:Envelope;

		public function EnvelopeTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			envelope = new Envelope();
		}

		override protected function tearDown():void {
			super.tearDown();
			envelope = null;
		}

		public function testInstantiated():void {
			assertTrue("envelope is Envelope", envelope is Envelope);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}