package 
{
	import asunit.framework.TestSuite;
	import project.AllTests;
	import wrapper.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new project.AllTests());
			addTest(new framework.AllTests());
		}
	}
}