package framework.config
{
	import flash.display.Shape;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;

	public class PreloaderBase extends Shape
	{
		private var _preloads:Dictionary = new Dictionary();
		private var _loaded:int;
		private var _total:int;
		
		public function PreloaderBase()
		{
			super();
		}
		
		public function add( scope:Object ):void
		{
			if( scope is EventDispatcher ) {
				scope.addEventListener(ProgressEvent.PROGRESS, onProgress );
			}
			_preloads[scope] = {};
		}
		
		public function update( scope:Object, bytesLoaded:int, bytesTotal:int ):void
		{
			var obj:Object = _preloads[ scope ];
			obj.bytesLoaded = bytesLoaded;
			obj.bytesTotal = bytesTotal;
			_loaded = 0;
			_total = 0;
			for each( var loadee:Object in _preloads ){
				_loaded += loadee.bytesLoaded;
				_total += loadee.bytesTotal;
			}
			var percent:Number = ( 100 / _total ) / ( 100 / _loaded );
			if( percent == 1 || isNaN( percent ) ) {
				graphics.clear();
			}else{
				progress( percent );
			}
		}
		
		protected function progress( percent:Number ):void
		{
			graphics.clear();
			graphics.beginFill( 0x808080, 0.5 );
			graphics.drawRect( 0, 0, stage.stageWidth*percent, stage.stageHeight );
		}
		
		protected function destroy():void
		{
			for( var scope:Object in _preloads ){
				if( scope is EventDispatcher ){
					scope.removeEventListener(ProgressEvent.PROGRESS, onProgress );
				}
			}
		}
		
		private function onProgress( event:ProgressEvent ):void
		{
			update( event.target, event.bytesLoaded, event.bytesTotal );
		}
	}
}