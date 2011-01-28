package com.paperlesspost.create.data {

	import asunit.framework.TestCase;

	public class ProductsTest extends TestCase {
		private var products:Products;

		public function ProductsTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			products = new Products();
		}

		override protected function tearDown():void {
			super.tearDown();
			products = null;
		}

		public function testInstantiated():void {
			assertTrue("products is Products", products is Products);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}