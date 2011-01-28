package framework.helpers
{
import framework.controller.Controller;
import framework.config.Boot;

public class TimerHelper
{
	private var _controller:Controller;
	private var _timer:Timer;
	
	public function TimerHelper( controller:Controller )
	{
		super();
		init(controller);
	}
	
	public function get timer():Timer
	{ 
		return _timer; 
	}
	
	public function start( name:String, delay:int=30000, repeatCount:int=0 ):void
	{
		_timer = _controller.container.cache[name] = new Timer( delay, repeatCount );
		_timer.start();
	}	
	
	public function stop( name:String=null ):void
	{
		setTimer( name );
		_timer.stop();
	}
	
	public function reset( name:String=null ):void
	{
		setTimer( name );
		_timer.reset();
	}
	
	private function setTimer( name:String=null ):void
	{
		if( name ) {
			_timer = _controller.container.cache[name];
		}
	}
	
	private function init( controller:Controller ):void
	{
		_controller = controller;
	}
	
}

}