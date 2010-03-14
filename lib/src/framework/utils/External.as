package framework.utils
{
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	/**
	 *  IE has a "feature" that prevents ExternalInterface from being called consecutively, 
	 * 	every call must be at least 500 milliseconds appart.
	 *  @example External.call('alert','hello world');
	 */
	public class External 
	{
		private static var _timer:Timer
		private static var _que:Array = [];
		
		public static function call(...args):void
		{
			if( _timer != null ){
				_que.push(args);
			}else{
				fire( args );
			}
		}

		private static function fire( args:Array ):void
		{
			ExternalInterface.call.apply( null, args );
			_timer = new Timer(550); 
			_timer.addEventListener( TimerEvent.TIMER, onFinished );
			_timer.start();
		}
		
		private static function onFinished( event:Event ):void
		{
			_timer.removeEventListener( TimerEvent.TIMER, onFinished );
			if( _que.length != 0 ) {
				fire( _que.shift() );
			}
		}
	}
}