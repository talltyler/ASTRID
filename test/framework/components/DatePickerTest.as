package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.DatePicker;
		
	public class DatePickerTest extends TestCase 
	{
		private var instance:DatePicker;

		public function DatePickerTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new DatePicker();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("DatePicker instantiated", instance is DatePicker);
		}
	}
}