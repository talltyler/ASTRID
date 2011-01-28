package framework.helpers
{

public class PrintHelper
{
	public var pagesToPrint:uint = 0;
	private var job:PrintJob;
	private var options:PrintJobOptions;
	private static const STUPID_MARGIN:Number = 0.942226891;
	
	public function PrintHelper()
	{
		super();
		init();
	}
	
	private function init():void
	{
		job = new PrintJob();
		options = new PrintJobOptions(true);
	}
	
	public function print( ...pages ):void
	{
		if(job.start()) {
			var magnifier:Number = Math.max(1, 4095 / Math.max(job.pageWidth, job.pageHeight));
			var window:Sprite = new Sprite();
			window.x = window.y = 5000;
			target.stage.addChild(window);
			for each( var page:Sprite in pages ) {
				page.width = job.pageWidth * magnifier;
				page.height = job.pageHeight * magnifier;
				page.scaleX = page.scaleY = magnifier;
				var bmp:Bitmap = makeBitmap(page);
				bmp.smoothing = true;
				bmp.scaleX = bmp.scaleY = 1 / magnifier * STUPID_MARGIN;
				window.addChild(bmp);
				try {
		            job.addPage(window, null, options);
		            pagesToPrint++;
		        } catch(e:Error) { /* do nothing */ }
		        
			}
			target.stage.removeChild(window);
			if(pagesToPrint > 0) job.send();
		}
	}
	
	private function makeBitmap(subject:DisplayObject):Bitmap {
		var rect:Rectangle = subject.getBounds(subject);
		if (rect.width > 4095 || rect.height > 4095) {
			rect.width  = Math.min(4095, rect.width);
			rect.height = Math.min(4095, rect.height);
		}
        var matrix:Matrix = new Matrix(1, 0, 0, 1, -rect.x, -rect.y);
        var bitmapData:BitmapData = new BitmapData(rect.width, rect.height);
		bitmapData.draw(subject, matrix);
		return new Bitmap(bitmapData);
	}
	
}

}