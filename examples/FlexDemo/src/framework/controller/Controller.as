/*                                   ,----,                                 
 *                                 ,/   .`|                                 
 *      ,---,       .--.--.      ,`   .'  :,-.----.      ,---,    ,---,     
 *     '  .' \     /  /    '.  ;    ;     /\    /  \  ,`--.' |  .'  .' `\   
 *    /  ;    '.  |  :  /`. /.'___,/    ,' ;   :    \ |   :  :,---.'     \  
 *   :  :       \ ;  |  |--` |    :     |  |   | .\ : :   |  '|   |  .`\  | 
 *   :  |   /\   \|  :  ;_   ;    |.';  ;  .   : |: | |   :  |:   : |  '  | 
 *   |  :  ' ;.   :\  \    `.`----'  |  |  |   |  \ : '   '  ;|   ' '  ;  : 
 *   |  |  ;/  \   \`----.   \   '   :  ;  |   : .  / |   |  |'   | ;  .  | 
 *   '  :  | \  \ ,'__ \  \  |   |   |  '  ;   | |  \ '   :  ;|   | :  |  ' 
 *   |  |  '  '--' /  /`--'  /   '   :  |  |   | ;\  \|   |  ''   : | /  ;  
 *   |  :  :      '--'.     /    ;   |.'   :   ' | \.''   :  ||   | '` ,/   
 *   |  | ,'        `--'---'     '---'     :   : :-'  ;   |.' ;   :  .'     
 *   `--''                                 |   |.'    '---'   |   ,.' Tyler      
 * ActionScript tested rapid iterative dev `---' Copyright2010'---'  Larson
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * http://www.gnu.org/licenses
 */
package framework.controller 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;

	import framework.cache.Cache;
	import framework.config.Boot;
	import framework.events.ControllerEvent;
	import framework.events.ViewEvent;
	import framework.net.Assets;
	import framework.net.Asset;
	import framework.view.RendererBase;
	import framework.data.UndoRedo;
	import framework.controller.SWFAddress;
	import framework.controller.SWFAddressEvent;
	
	[Event(name='contextNotFound', type='flash.events.Event')]
	[Event(name='methodNotFound', type='flash.events.Event')]
	
	/**
	 * Your applications trafic cop, the controller will manage calling 
	 * the applications contexts that are mapped though Routes.
	 */
	public class Controller extends EventDispatcher
	{	

		public static const TEMP_DISABLE:String = "tempDisable";
		public static const DEEPLINKING_ON:String = "deeplinkingOn";
		public static const DEEPLINKING_OFF:String = "deeplinkingOff";
		
		private var _assets:Assets;
		private var _container:DisplayObject;
		private var _deeplinking:String = DEEPLINKING_OFF;
		private var _tracking:Function;
	
		/**
		 * @param routes Routes 
		 * @param container Sprite 
		 * @param deeplinking String 
		 * @param tracking Function 
		 */
		public function Controller(container:DisplayObject):void
		{ 
			super();
			_container = container;
			_assets = new Assets();
		}
		
		public function get assets():Assets
		{
			return _assets;
		}
		
		public function get container():DisplayObject
		{
			return _container;
		}
		
		public function set deeplinking(value:String):void
		{
			_deeplinking = value;
		}
		
		public function get deeplinking():String
		{
			return _deeplinking;
		}
		
		public function set tracking(value:Function):void
		{
			_tracking = value;
		}
		
		public function get tracking():Function
		{
			return _tracking;
		}

		/**
		 * @param path String 
		 * @param params Object 
		 */
		public function redirectTo(path:String, params:Object=null):void
		{
			trace("redirectTo", path );
		}
		
		public function back():void
		{
			trace('back');
		}
		
		public function forward():void
		{
			trace('forward');
		}
		
	}
}