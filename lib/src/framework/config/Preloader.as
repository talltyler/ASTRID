package framework.config
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Used as preloader for document classes. 
	 */
	public class Preloader extends MovieClip
	{
		public static const REMOVE_PRELOADER:String = "removePreloader";
		
		protected var preloader:Sprite;
		
		private var _appClassName:String;

		/**
		 * @constructor
		 */
		public function Preloader( appClassName:String )
		{
			super();
			init( appClassName );
		}
		
		/**
		 * @private
		 */
		private function init( appClassName:String ):void
		{
			stop();
			
			_appClassName = appClassName;
			
			addEventListener( Event.ENTER_FRAME, onEnterFrame );

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			preloader = new Sprite();
			addChild(preloader);
		}

		/**
		 * On every frame check how much of the swf is loaded, if everything is loaded 
		 * advance to the next frame and initialize our application.
		 * @param event Event
		 */
		protected function onEnterFrame(event:Event):void
		{
			// check if all of the frames of the SWF have loaded
			if( framesLoaded == totalFrames ) {
				createApplication();
			}
		}

		/**
		 * @private
		 */
		private function createApplication():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			nextFrame();
			
			// we have to start listening for this *before* we create our application
			// because it's constructor may dispatch the "remove preloader" event
			addEventListener( REMOVE_PRELOADER, onRemovePreloader );

			// Create the application by name so we don't have any static linkage to this class
			var appClass:Class = getDefinitionByName( _appClassName ) as Class;
			var app:DisplayObject = new appClass();

			addChildAt(app, 0);
		}

		/**
		 * @param event Event
		 * @private
		 */
		private function onRemovePreloader(event:Event):void
		{
			removeEventListener(REMOVE_PRELOADER, onRemovePreloader);
			removeChild(preloader);
			preloader = null;
		}
	}
}