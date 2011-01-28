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
package framework.data 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import framework.cache.Cache;
	import framework.events.ListenerManager;
	import framework.events.ModelEvent;
	import framework.data.adapters.AdapterBase;
	import framework.utils.ClassUtils;
	import framework.utils.StringUtils;
	import framework.debug.Log;
	
	[Event(name='destroyed', type='flash.event.Event')]
	[Event(name='change', type='flash.event.Event')]
	[Event(name='complete', type='flash.event.Event')]
	[Event(name='error', type='flash.framework.ModelEvent')]
	
	dynamic public class ModelBase extends Proxy implements IEventDispatcher
	{     
		public static const DESTROYED:String = "destroyed";
		public static var data:Data;
		
		public var className:String;		
		public var errors:Array = [];

		private var _adapter:AdapterBase;
		private var _data:Object = {};
		private var _dispatcher:EventDispatcher;
		private var _cache:Cache;
		private var _listenerManager:ListenerManager;
		private var _beforeTasks:Object = {};
		private var _afterTasks:Object = {};
		
		/**
		 *	@constructor
		 *	@param	name	 The name of the model object, this is normally the name of the class
		 */
		public function ModelBase( params:Object=null )
		{	
			super();
			className = ClassUtils.className( this );
			_cache = data.cache;
			_dispatcher = new EventDispatcher();
			_listenerManager = new ListenerManager( _dispatcher );
			if( params != null ) {
				create( params );
			}
		}
		
		/**
		 *	Setter for the models data conversion class, an adapter allows different data formats to interface commonly
		 *	@param	value	 A adapter Class
		 */
		public function setAdapter(value:Class):void
		{
			_adapter = new value( this, _cache||new Cache(), data );
			_adapter.addEventListener( Event.COMPLETE, onLoad );
		}
		
		/**
		 *	Getter for the models data conversion class, an adapter allows different data formats to interface commonly
		 *	@return		Returns an instance of the models adapter 
		 */
		public function getAdapter():AdapterBase
		{ 
			return _adapter; 
		}
		
		/**
		 *	Export data within this objects instance as a 
		 *	@return		Returns String formated relative to the models adapter
		 */
		public function export( params:Object = null ):String
		{
			return _adapter.export(this.id , params );
		}
		
		/**
		 *	Destroy this object, clear any listener added to it and take it out of the cache
		 *	When finished it will dispatch a ModelBase.DESTROYED event
		 */
		public function destroy( event:Event=null ):void 
		{
			_listenerManager.destroy();
			data.destroy( className, this );
			_dispatcher.dispatchEvent( new Event( DESTROYED ) );
		}
		
		/**
		 *	Add a before task to a column, these methods will be called in order before the change 
		 *	of the value of this column is made. These methods have a specific signature, 
		 *	see framework.utils.Validate for examples on how this works.
		 *	@param	column	 Name of the column as a String
		 *	@param	method	 The Function object that will be used to process this changed value
		 *	@param	params	 A Object filled with any items that might need to be used for processing
		 */
		public function beforeTask( column:String, method:Function, params:Object=null ):void
		{
			if( !_beforeTasks.hasOwnProperty(column) ){
				_beforeTasks[column] = [];
			}
			_beforeTasks[column].push({ method:method, params:params });
		}
		
		/**
		 *	Add a after task to a column, these methods will be called in order after the change 
		 *	of the value of this column is made. These methods have a specific signature, 
		 *	see framework.utils.Validate for examples on how this works.
		 *	@param	column	 Name of the column as a String
		 *	@param	method	 The Function object that will be used to process this changed value
		 *	@param	params	 A Object filled with any items that might need to be used for processing
		 */
		public function afterTask( column:String, method:Function, params:Object=null ):void
		{
			if( !_afterTasks.hasOwnProperty(column) ){
				_afterTasks[column] = [];
			}
			_afterTasks[column].push({ method:method, params:params });
		}
		
		//---------------------------------------
		//	EventDispature methods
		//---------------------------------------
		/**
		 *	@see	flash.events.EventDispatcher|#addEventListener Same as EventDispatcher
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 *	@see	flash.events.EventDispatcher|#removeEventListener Same as EventDispatcher
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
			_listenerManager.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @see	flash.events.EventDispatcher|#dispatchEvent Same as EventDispatcher
		 * @param event Event 
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
		 *	@see	flash.events.EventDispatcher|#hasEventListener Same as EventDispatcher
		 */
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		/**
		 *	@see	flash.events.EventDispatcher|#willTrigger Same as EventDispatcher
		 */
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
		/**
		 *	@private 
		 *	  TODO: impliment save to external source
		 */
		public function save():void
		{	
			if( errors.length == 0 ){}
		}
		
		//---------------------------------------
		// MODEL ASSOCIATIONS
		//---------------------------------------
		/**
		 *	This method gives you the ability to say that the model that you are working with 
		 *	belongs to another model. This relationship is facilitated with the use of id columns.
		 *	The foreign key should be on the model with the belongsTo association defined.
		 *	If you would like a better understanding of these associations try looking here
		 *	http://guides.rubyonrails.org/association_basics.html
		 */
		protected function belongsTo( clazz:Class ) : void
		{
			var name:String = ( ClassUtils.className( clazz ) + "_id" as String).toLowerCase();
			addAssociation( name, "belongsTo", clazz );
		}
		
		/**
		 *	This method gives you the ability to say that the model that you are working is  
		 *	associated with many models of another type. This relationship is facilitated with 
		 *	the use of foreign key columns placed on the associated model.
		 *	If you would like a better understanding of these associations try looking here
		 *	http://guides.rubyonrails.org/association_basics.html
		 */
		protected function hasMany( clazz:Class ) : void
		{
			var name:String = StringUtils.pluralize( ClassUtils.className( clazz ) ).toLowerCase();
			addAssociation( name, "hasMany", clazz );
		}
		
		/**
		 *	This method gives you the ability to say that the model that you are working is  
		 *	associated with one model of another type. This relationship is facilitated with 
		 *	the use of foreign key columns placed on the associated model.
		 *	If you would like a better understanding of these associations try looking here
		 *	http://guides.rubyonrails.org/association_basics.html
		 */
		protected function hasOne( clazz:Class ) : void
		{
			var name:String = StringUtils.singularize( ClassUtils.className( clazz ) ).toLowerCase();
			addAssociation( name, "hasOne", clazz );
		}
		
		/* // We dont have scope to whatever this join table would be so I dont think this is possible, 
			// will have to find a different way
		protected function hasManyAndBelongsTo( clazz:Class ) : void
		{
			var name:String = StringUtils.singularize( ClassUtils.className( clazz ) ).toLowerCase();
			addAssociation( name, "hasManyAndBelongsTo", clazz );
		}
		*/
		
		// TODO: hasMany through relationships
		
		/**
		 *	@private
		 *	If params are sent into the constructor of this object create it and pass the instance to models
		 */
		private function create( params:Object ):void
		{
			var result:* = this;
			var index:int = data.push( className, result );
			var columns:Array = data.columns( className );
			for(var prop:String in params ){
				if( params[prop] is Array ) {
					var associatedObjects:Array = [];
					if( data.isAssociatedProperty( className, prop ) ) {
						for each(var item:Object in params[prop]){
							item[ className.toLowerCase() + "_id" ] = index;
							if( item is ModelBase ) {
								associatedObjects.push( item );
							}else{
								associatedObjects.push( data.getAssociationForProperty( className, prop ).create( item ) );
							}
						}
						result[prop] = associatedObjects;
					}else{
						// Log.warning( className, "is not associated with", prop );
					}
				}else{
					if( params[prop] is ModelBase ) {
						if( columns.indexOf( prop + "_id" ) != -1 ) {
							result[prop] = params[prop];
							result[prop + "_id"] = params[prop].index;
							result[prop][className.toLowerCase()] = result;
							result[prop][className.toLowerCase() + "_id"] = index;
						}else{
							// Log.warning( className, "is not associated with", prop );
						}
					}else if( typeof( params[prop] ) == "object" ){
						result[prop] = data.getClass(prop)[create]( params[prop] );
					}else{
						result[prop] = params[prop];
					}
				}
			}
			result.index = index;
			if( columns.indexOf("id") != -1 ){
				result.id = index;
			}
		}
		
		/**
		 *	@private
		 *	After an adapter as loaded it's data it will dispatch an event that calls this method, 
		 *	this event is passed on and dispatched from this model
		 */
		private function onLoad(event:Event):void
		{
			dispatchEvent( event );
		}
		
		/**
		 *	@private
		 *	This is just a method to simplify the creation of the other associations above,
		 *	belongsTo, hasOne, and hasMany all call this method
		 */
		private function addAssociation( name:String, type:String, clazz:Class ) : void
		{
			var columns:Array = data.columns( className );
			if( columns.indexOf( name ) == -1 && data.columnsLocked( className ) != true ) {
				columns.push( name );
			}
			data.addAssociation( className, type, name, clazz )
		}
		
		/**
		 *	@private
		 *	Any method that isn't defined on the model will be sent here.
		 */
		private function methodMissing( method:*, args:Array ) : Object
		{
			if( method.substring(0,6) == "findBy" ){
				return data.findBy( className, method.split("findBy")[1], args );
			}
			// Log.warning("methodMissing", method, args)
			return null;
		}
		
		/**
		 *	@private
		 *	After a setProperty is finished it calls this method to set the property and call the after tasks 
		 */
		private function setPropertyComplete( name:String, value:*, result:Object, errors:Array):void
		{
			if( errors.length == 0 ) {
				if( flash_proxy::isAttribute(name) ){
					this[name] = value;
				}else{
					_data[name] = value;
				}
				if( _afterTasks.hasOwnProperty(name) ){
					for each( var task:Object in _afterTasks[name] ){
						task.method( this, name, value, task.params );
					}
				}
				_dispatcher.dispatchEvent( new Event( Event.CHANGE ) );
			}else{
				this.errors.apply(null,errors); // apply the errors to the models errors array
				_dispatcher.dispatchEvent( new ModelEvent( ModelEvent.ERROR, errors ) );
			}
		}
		
		/**
		 *	@private
		 */
		private function onTaskFinished( event:ModelEvent ):void 
		{
			setPropertyComplete( event.message.name, event.message.value, event.message.result, event.message.errors);
		}
		
		//---------------------------------------
		// flash_proxy methods
		//---------------------------------------
		/**
		 *	Call before tasks set property and then call after tasks
		 *	@inheritDoc
		 *	
		 */
		override flash_proxy function setProperty(name:*, value:*):void 
		{	
			var errors:Array = [];
			var task:Object;
			var result:Object;
			var hasDispatcher:Boolean;
			if( _beforeTasks.hasOwnProperty(name) ){
				for each( task in _beforeTasks[name] ){
					result = task.method( this, name, value, task.params );
					if( result != null ){
						if( result.dispatcher != null ) {
							result.dispatcher.addEventListener( Event.COMPLETE, onTaskFinished );
							hasDispatcher = true;
						}else{
							if( result.errors != null ) {
								errors.push(result.errors);
							}
							if( result.value != null ) {
								value = result.value;
							}
						}
					}
				}
				if( !hasDispatcher ) {
					setPropertyComplete( name, value, result, errors);
				}
			}else{
				setPropertyComplete( name, value, result, errors);
			}
        }
		
		/**
		 *	@inheritDoc
		 */
        override flash_proxy function getProperty(name:*):* 
		{	
			if( flash_proxy::isAttribute(name) ){
				return this[name];
			}else if( _data.hasOwnProperty(name) ){
				return _data[name];
			}
			// Log.warning( name, "could not be found on", className );
            return null;
        }
		
		/**
		 *	@inheritDoc
		 */
        override flash_proxy function hasProperty(name:*):Boolean 
		{
            return _data.hasOwnProperty(name);
        }
		
		/**
		 *	@inheritDoc
		 */
		override flash_proxy function deleteProperty(name:*):Boolean 
		{
			_dispatcher.dispatchEvent( new Event( Event.CHANGE ) );
            return delete _data[name];
        }	
		
		/**
		 *	@inheritDoc
		 */
		override flash_proxy function callProperty(method:*, ...args) : * 
		{
			try { 		 
				var clazz : Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
				return clazz.prototype[method].apply(method, args);
		   	}catch (e : Error) {
				return methodMissing(method, args);
		   	}
		}
		
		/**
		 * @inheritDoc
		 */
        override flash_proxy function nextNameIndex (index:int):int 
		{
			var l:int = 0;
			for(var prop:String in _data){ //TODO: strip this loop out of this method
				l++
			}
            if (index < l) {
                return index + 1;
            } else {
                return 0;
            }
        }
        
		/**
		 * @inheritDoc
		 */
        override flash_proxy function nextName(index:int):String {
			var l:int = 0;
			for(var prop:String in _data){ //TODO: strip this loop out of this method
				if(l>index) return prop;
				l++
			}
            return ""
        }
        
		/**
		 * @inheritDoc
		 */
        override flash_proxy function nextValue(index:int):* {
            // var prop:String = props[index - 1];
			// return _data[prop]; //TODO: fix this
			var length:int = 0;
			for(var prop:String in _data){ 
				if(length > index) return _data[prop];
				length++
			}
        }		
	}
}