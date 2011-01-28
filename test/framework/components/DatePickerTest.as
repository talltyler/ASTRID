package framework.components {

	import asunit.framework.TestCase;

	public class DatePickerTest extends TestCase {
		private var datePicker:DatePicker;

		public function DatePickerTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			datePicker = new DatePicker();
		}

		override protected function tearDown():void {
			super.tearDown();
			datePicker = null;
		}

		public function testInstantiated():void {
			assertTrue("datePicker is DatePicker", datePicker is DatePicker);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}