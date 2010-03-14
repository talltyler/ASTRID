package framework.helpers
{
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.net.FileReference;
import com.adobe.images.JPGEncoder;

public class DownloadHelper
{

	public function DownloadHelper()
	{
		super();
	}
	
	public function download( name:String, data:Object ):void
	{
		var file:FileReference = new FileReference();
		if( data is DisplayObject ) {
			var source:BitmapData = new BitmapData(data.width, data.height);
			source.draw(data);

			var encoder:JPGEncoder = new JPGEncoder(100);
			var stream:ByteArray = encoder.encode(source);

			file.save( stream, name );
			source.dispose();
		}else{ // Else if it is just text we can just save it
			file.save( data, name );
		}
	}
}

}