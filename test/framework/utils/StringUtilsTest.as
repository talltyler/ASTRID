package framework.utils
{
	import flash.display.*;
	import flash.events.*;
	
	import asunit.framework.TestCase;
	
	import framework.utils.*;
	
	public class StringUtilsTest extends TestCase 
	{
		public function StringUtilsTest()
		{
			super();
		}
		
		protected override function setUp():void {
			
		}

		protected override function tearDown():void {
			
		}

		public function testClassName():void {
			assertEquals("StringUtils.className with Class", StringUtils.className( MovieClip ), "MovieClip" );
			assertEquals("StringUtils.className with instance", StringUtils.className( new Sprite ), "Sprite" );
		}
		
		public function testSuperClassName():void {
			assertEquals("StringUtils.superClassName with Class", StringUtils.superClassName( StringUtilsTest ), "TestCase" );
			assertEquals("StringUtils.superClassName with instance", StringUtils.superClassName( (new StringUtilsTest) ), "TestCase" );
		}
		
		public function testPluralize():void {
			assertEquals("StringUtils.pluralize with Model", StringUtils.pluralize( "model" ), "models" );
			assertEquals("StringUtils.pluralize with Try", StringUtils.pluralize( "try" ), "tries" );
			assertEquals("StringUtils.pluralize with Child", StringUtils.pluralize( "child" ), "children" );
		}
		
		public function testSingularize():void {
			assertEquals("StringUtils.singularize with models", StringUtils.singularize( "models" ), "model" );
			assertEquals("StringUtils.singularize with tries", StringUtils.singularize( "tries" ), "try" );
			assertEquals("StringUtils.singularize with children", StringUtils.singularize( "children" ), "child" );
		}
		
		public function testCamelize():void {
			assertEquals("StringUtils.camelize with underscore", StringUtils.camelize( "my_thing" ), "MyThing" );
			assertEquals("StringUtils.camelize with dash", StringUtils.camelize( "my-thing" ), "MyThing" );
		}
		
		public function testUnderscore():void {
			assertEquals("StringUtils.underscore with ThisStuffIsGood", StringUtils.underscore( "ThisStuffIsGood" ), "this_stuff_is_good" );
		}
		
		public function testHumanize():void {
			assertEquals("StringUtils.humanize with ThisStuffIsGood", StringUtils.humanize( "ThisStuffIsGood" ), "this stuff is good" );
			assertEquals("StringUtils.humanize with Title With First Letter Capped", StringUtils.humanize( "TitleWithFirstLetterCapped", true ), "Title With First Letter Capped" );
			assertEquals("StringUtils.humanize with underscore verision Title With First Letter Capped", StringUtils.humanize( "title_with_first_letter_capped", true ), "Title With First Letter Capped" );
		}
		
		public function testUpperWords():void {
			//assertEquals("StringUtils.upperWords with ThisStuffIsGood", StringUtils.upperWords( "ThisStuffIsGood" ), "THIS STUFF IS GOOD" );
			//assertEquals("StringUtils.upperWords with title_with_caps", StringUtils.upperWords( "title_with_caps" ), "TITLE WITH CAPS" );
		}
		
		/// ...
		
	}
}

