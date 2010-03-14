package framework.utils 
{
	import flash.display.*;
	import flash.events.*;
	
	import asunit.framework.TestCase;
	import framework.utils.*;
	
	public class ObjectUtilsTest extends TestCase 
	{
		private var instance:ObjectUtils;
		
		public function ObjectUtilsTest()
		{
			super();
		}
		
		protected override function setUp():void {
			instance = new ObjectUtils();
		}

		protected override function tearDown():void {
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("ObjectUtils instantiated", instance is ObjectUtils );	
		}
		
		public function testCloneObject():void {
			var obj:Object = ObjectUtils.cloneObject( {name:"value"} );
			assertTrue("ObjectUtils.cloneObject with Class", 
				obj is Object && 
				obj.hasOwnProperty("name") && 
				obj.name == "value" && 
				obj.name is String );
		}
		
		public function testCleanObject():void {
			var cleanedObject1:* = instance.cleanObject( new Sprite, "this.parent" );
			assertTrue("ObjectUtils.cleanObject - this.parent", cleanedObject1 == null );
			var cleanedObject2:Number = instance.cleanObject( new Sprite, "this.alpha" );
			assertTrue("ObjectUtils.cleanObject - this.alpha", cleanedObject2 is Number );
		}

	}
}