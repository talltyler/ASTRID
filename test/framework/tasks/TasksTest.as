package framework.task
{
	import asunit.framework.TestCase;
	import framework.task.Tasks;
		
	public class TasksTest extends TestCase 
	{
		private var instance:Tasks;

		public function TasksTest() 
		{
			super();
		}

		protected override function setUp():void 
		{
			instance = new Plugins();
		}

		protected override function tearDown():void 
		{
			instance = null;
		}

		public function testInstantiated():void 
		{
			assertTrue("Tasks instantiated", instance is Tasks);
		}
	}
}