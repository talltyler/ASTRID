package framework.components
{
	import asunit.framework.TestCase;
	import framework.components.Stepper;
		
	public class StepperTest extends TestCase 
	{
		private var instance:Stepper;

		public function StepperTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Stepper();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Stepper instantiated", instance is Stepper);
		}
	}
}