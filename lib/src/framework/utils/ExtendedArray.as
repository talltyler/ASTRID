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
package framework.utils 
{
import flash.events.*;
import framework.events.*;

/**
 * This class is a sub class of Array, does all of the same stuff but also 
 * dispatches Event.CHANGE events any time the Array is modified.
 * In addition to this all events that are listened to are added to a ListenerManager
 * This gives us the functionality to delete these listeners when this object is destroyed.
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 */
public dynamic class ExtendedArray extends Array implements IEventDispatcher 
{		
	private var _dispatcher:EventDispatcher;
	private var _listenerManager:ListenerManager;
	
	/**
	 * @constructor
	 */
	public function ExtendedArray(... args)
	{
		_dispatcher = new EventDispatcher(this);
		_listenerManager = new ListenerManager( _dispatcher );
		
		if (args.length > 0) {
			super(args);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	AS3 override function slice(startIndex:Number = 0, endIndex:Number = 0xFFFFFF):Array
	{
		if (endIndex >= this.length){
			endIndex = this.length;
		}

		var results:ExtendedArray = new ExtendedArray();
		for (var i:int = startIndex; i < endIndex; i++)
		{
			results.push(this[i]);
		}
		return results;
	}
	
	/**
	 * @inheritDoc
	 */
	AS3 override function push(... args):uint
	{
		var results:uint = super.push.apply(this, args);
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}
	
	/**
	 * @inheritDoc
	 */
	AS3 override function pop():*
	{
		var results:* = super.pop();
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}
	
	/**
	 * @inheritDoc
	 */
	AS3 override function reverse():Array
	{
		var results:Array = super.reverse();
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}

	/*AS3 override function splice(startIndex:int, deleteCount:uint, ... args):Array {
		var results = super.splice(args);
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}*/
		
	/**
	 * @inheritDoc
	 */
	AS3 override function shift():*
	{
		var results:* = super.shift();
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}
	
	/**
	 * @inheritDoc
	 */
	AS3 override function unshift(... args):uint
	{
		var results:uint = super.unshift.apply(this, args);
		dispatchEvent(new Event(Event.CHANGE));
		return results;
	}
	
	/**
	 * Destory this object, delete the items from within the array.
	 * The items themselves are not deleted but if there are no other references to them 
	 * they should be garbage collected. This method also deletes all event listeners that 
	 * have been added and dispatches an Event named "destroyed"
	 * @param event Optional Event 
	 */
	public function destroy( event:Event=null ):void
	{
		splice(0,length);
		_listenerManager.destroy();
		_dispatcher.dispatchEvent( new Event( "destroyed" ) );
	}
	
	/**
	 * Standard implimentation of addEventListener but adds a listener manager so that we can delete events if needed.
	 * @param type String 
	 * @param listener Function 
	 * @param useCapture Boolean 
	 * @param priority int 
	 * @param useWeakReference Boolean 
	 */
	public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	{
		_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		_listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * Standard implimentation of dispatchEvent
	 * @param evt Event 
	 * @return Boolean 
	 */
	public function dispatchEvent(event:Event):Boolean
	{
		if( hasEventListener(event.type) ) {
			return _dispatcher.dispatchEvent(event);
		}else{
			return false;
		}
	}

	/**
	 * Standard implimentation of hasEventListener
	 * @param type String 
	 * @return Boolean 
	 */
	public function hasEventListener(type:String):Boolean
	{
		return _dispatcher.hasEventListener(type);
	}
	
	/**
	 * Standard implimentation of removeEventListener, but added call to remove listener from ListenerManager
	 * @param type String 
	 * @param listener Function 
	 * @param useCapture Boolean 
	 */
	public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
	{
		_dispatcher.removeEventListener(type, listener, useCapture);
		_listenerManager.removeEventListener(type, listener, useCapture);
	}
	
	/**
	 * Standard implimentation of willTrigger
	 * @param type String 
	 * @return Boolean 
	 */
	public function willTrigger(type:String):Boolean
	{
		return _dispatcher.willTrigger(type);
	}
}

}
