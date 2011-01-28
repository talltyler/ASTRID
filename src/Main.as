package
{
	import flash.events.Event;
	import framework.config.Preloader;
	import com.paperlesspost.create.App;
	/**
	 * Document class for ASTRID application
	 * @playerversion Flash 10.0.0
	 * @author Tyler Larson, talltyler@me.com, @talltyler
	 */
	public class Main extends Preloader
	{
		/**
		 * @constructor
		 */
		public function Main()
		{
			super( "com.company.project.App" );
			new App();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onEnterFrame(event:Event):void
		{
			// Update the preloader with the loading progress
			preloader.graphics.clear();

			// Draw the outline of a progress bar
			preloader.graphics.lineStyle(3, 0x333333, 1, true);
			preloader.graphics.drawRoundRect(100, 290, stage.stageWidth-200, 20, 10, 10);

			// Fill the progress bar based on how many of our bytes have been loaded
			preloader.graphics.beginFill(0x555555);
			preloader.graphics.drawRoundRect(100, 290, (stage.stageWidth-200) * 
				stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal, 20, 10, 10);

			super.onEnterFrame( event );
		}
	}
}