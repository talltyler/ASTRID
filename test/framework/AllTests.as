package framework 
{
	import asunit.framework.TestSuite;
	import framework.utils.*;
	
	public class AllTests extends TestSuite
	{
	
		public function AllTests()
		{
			super();
			addTest(new framework.AppTest());
			addTest(new framework.cache.CacheTest());
			addTest(new framework.cache.PoolTest());
			// addTest(new framework.components.ButtonTest());
			addTest(new framework.cache.PoolTest());
			// Boot test should be made in AppTest
			// PreloaderBase test should be made in MainTest within your project
			
			addTest(new framework.utils.TraceUtilsTest());
			addTest(new framework.utils.TypeUtilsTest()); 
			addTest(new framework.utils.ObjectUtilsTest());
			addTest(new framework.utils.StringUtilsTest());
		}
	}
}