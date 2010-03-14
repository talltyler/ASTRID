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
package framework.display 
{
	import flash.display.Sprite
	import flash.events.Event;
	
	import framework.events.ListenerManager;
	import framework.cache.Cache;
	
	/**
	 *  If you are using display objects for anything, I would highly recomend usnig this as a base class.
	 *	This class extends Sprite and manages any event listeners that are applied to it, has an init
	 *	method for when it has been added to stage and cleans everything up when it is removed from the 
	 *	display list or when you call destroy();
	 */
	public class Base extends DisplayObjectBase
	{
		public var state:String = "";
		public var type:String;
		
		private var _listenerManager:ListenerManager;
		
		/**
		 *	@constructor
		 */
		public function Base()
		{
			super();
			
			_listenerManager = new ListenerManager( this );
			
			if( stage == null ) 
				addEventListener( Event.ADDED_TO_STAGE, onAdded );
			else 
				init();
			
			addEventListener( Event.REMOVED_FROM_STAGE, destroy );
		}
		
		/**
		 *	This method is called after the instance has been added to the display list.
		 */
		protected function init():void
		{
			// You should override this. 
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			_listenerManager.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 *	To destroy this instance and all of the children of it call this method. 
		 *	It will also clean up all of there listeners.
		 */
		public function destroy( event:Event=null ):void 
		{
			graphics.clear();
			dispatchEvent( new Event( "destroyed", true ) );
			_listenerManager.destroy(); // can't destroy listeners before dispatch of event
			if (parent != null){
				parent.removeChild(this);
			}
		}
		
		/**
		 *	@private
		 */
		private function onAdded( event:Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			init();
		}
	}
}