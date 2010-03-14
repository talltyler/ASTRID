package framework.utils
{
	import asunit.framework.TestCase;
	import framework.utils.Validate;
		
	public class ValidateTest extends TestCase 
	{
		private var instance:Validate;

		public function ValidateTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Validate();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Validate instantiated", instance is Validate);
		}
	}
}