package
{
	import framework.config.PreloaderBase;

	public class Preloader extends PreloaderBase
	{	
		override protected function progress( percent:Number ):void
		{
			if( stage ) {
				graphics.clear();
				graphics.beginFill( 0x808080, 0.5 );
				graphics.drawRect( 0, stage.stageHeight/2, stage.stageWidth*percent, 1 );
			}
		}
	}
}