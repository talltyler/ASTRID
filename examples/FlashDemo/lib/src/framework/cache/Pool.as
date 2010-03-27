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
package framework.cache 
{
	import framework.utils.ClassUtils;
	
	/**
	 *  The Pool is a collection of object pools, or a way to keep track of 
	 *	the objects that are created and destroyed often. It is much faster 
	 *	to reuse instances of objects than to create new ones all of the time
	 */
	public class Pool
	{
		private var _data:Object = {};
		
		/**
		 *	Creates an instance of a Pool
		 *	@constructor
		 */
		public function Pool()
		{
			super();
		}
		
		/**
		 *	This method returns an instance of the class that you send in.
		 *	@param	class	 The class that you would like to retrive an instance of.
		 *	@param	...params	 a rest argument of any of arguments that you want to send into your instance.
		 *	@return		Returns an instance of the Class that you pass in.
		 */
		public function retrieve( clazz:Class, ...params ) : *
		{
			var obj:Obj = getPool( clazz );
			return obj.retrieve.apply( null, params );
		}
		
		/**
		 *	This method returns a reference to the pool related to a Class object.
		 *	@param	class	 A Class object of the pool that you are interested in the object pool for.
		 *	@return		Returns an Obj object for managing this Classes pool.
		 */
		public function getPool( clazz:Class ) : Obj
		{
			var name:String = ClassUtils.className( clazz );

			if( _data[name] == null ){
				_data[name] = new Obj( true );
				_data[name].allocate( clazz, 1 );
			}
			
			return _data[name];
		}
	}
}

import flash.events.Event;
import flash.events.EventDispatcher;
import framework.utils.ClassUtils;

internal class Obj
{
	private var _obj:Class;
	
	private var _initSize:int;
	private var _currSize:int;
	private var _usageCount:int;
	
	private var _grow:Boolean = true;
	
	private var _head:ObjNode;
	private var _tail:ObjNode;
	
	private var _emptyNode:ObjNode;
	private var _allocNode:ObjNode;
	
	/**
	 * Creates a new object pool.
	 * 
	 * @param grow If true, the pool grows the first time it becomes empty.
	 */
	public function Obj( grow:Boolean = false)
	{
		super();
		_grow = grow;
	}
	
	/**
	 * Unlock all ressources for the garbage collector.
	 */
	public function deconstruct():void
	{
		var node:ObjNode = _head;
		var t:ObjNode;
		while (node)
		{
			t = node.next;
			node.next = null;
			node.data = null;
			node = t;
		}
		
		_head = _tail = _emptyNode = _allocNode = null;
	}
	
	/**
	 * The pool size.
	 */
	public function get size():int
	{
		return _currSize;
	}
	
	/**
	 * The total number of 'checked out' objects currently in use.
	 */
	public function get usageCount():int
	{
		return _usageCount;
	}
	
	/**
	 * The total number of unused thus wasted objects. Use the purge()
	 * method to compact the pool.
	 * 
	 * @see #purge
	 */
	public function get wasteCount():int
	{
		return _currSize - _usageCount;	
	}
	
	/**
	 *	Retrieves and instace of an object from the pool
	 */
	public function retrieve( ...parameters ):*
	{
		if (_usageCount == _currSize)
		{
			if (_grow)
			{
				_currSize += _initSize;
				
				var n:ObjNode = _tail;
				var t:ObjNode = _tail;
				
				var node:ObjNode;
				for (var i:int = 0; i < _initSize; i++)
				{
					node = new ObjNode();
					
					node.data = initObject( parameters );
					
					t.next = node;
					t = node; 
				}
				
				_tail = t;
				
				_tail.next = _emptyNode = _head;
				_allocNode = n.next;
				return retrieve();
			}
				else
				throw new Error("object pool exhausted");
		}
		else
		{
			var o:* = _allocNode.data;
			_allocNode.data = null;
			_allocNode = _allocNode.next;
			_usageCount++;
			return o;
		}
	}
	
	/**
	 *	Destroys an instance giving it back to the pool
	 *	@param	instance	 An instance that is contained within the pool
	 */
	public function destroy(o:*):void
	{
		if (_usageCount > 0)
		{
			_usageCount--;
			_emptyNode.data = o;
			_emptyNode = _emptyNode.next;
		}
	}
	
	/**
	 * Allocate the pool by creating all objects from the given class.
	 * 
	 * @param C    The class to instantiate for each object in the pool.
	 * @param size The number of objects to create.
	 */
	public function allocate(C:Class, size:uint, ...parameters ):void
	{
		deconstruct();
		
		_obj = C;
		_initSize = _currSize = size;
		
		_head = _tail = new ObjNode();
		
		_head.data = initObject( parameters );
		
		var n:ObjNode;
		
		for (var i:int = 1; i < _initSize; i++)
		{
			n = new ObjNode();
			
			n.data = initObject( parameters );
			
			n.next = _head;
			_head = n;
		}
		
		_emptyNode = _allocNode = _head;
		_tail.next = _head;
	}
	
	/**
	 * Helper method for applying a function to all objects in the pool.
	 * 
	 * @param func The function's name.
	 * @param args The function's arguments.
	 */
	/*
	public function initialze(func:String, args:Array):void
	{
		var n:ObjNode = _head;
		while (n)
		{
			n.data[func].apply(n.data, args);
			if (n == _tail) break;
			n = n.next;	
		}
	}*/
	
	/**
	 * Remove all unused objects from the pool. If the number of remaining
	 * used objects is smaller than the initial capacity defined by the
	 * allocate() method, new objects are created to refill the pool. 
	 */
	/*
	public function purge():void
	{
		var i:int;
		var node:ObjNode;
		
		if (_usageCount == 0)
		{
			if (_currSize == _initSize)
				return;
				
			if (_currSize > _initSize)
			{
				i = 0; 
				node = _head;
				while (++i < _initSize)
					node = node.next;	
				
				_tail = node;
				_allocNode = _emptyNode = _head;
				
				_currSize = _initSize;
				return;	
			}
		}
		else
		{
			var a:Array = [];
			node =_head;
			while (node)
			{
				if (!node.data) a[int(i++)] = node;
				if (node == _tail) break;
				node = node.next;	
			}
			
			_currSize = a.length;
			_usageCount = _currSize;
			
			_head = _tail = a[0];
			for (i = 1; i < _currSize; i++)
			{
				node = a[i];
				node.next = _head;
				_head = node;
			}
			
			_emptyNode = _allocNode = _head;
			_tail.next = _head;
			
			if (_usageCount < _initSize)
			{
				_currSize = _initSize;
				
				var n:ObjNode = _tail;
				var t:ObjNode = _tail;
				var k:int = _initSize - _usageCount;
				for (i = 0; i < k; i++)
				{
					node = new ObjNode();
					node.data = initObject();
					
					t.next = node;
					t = node; 
				}
				
				_tail = t;
				
				_tail.next = _emptyNode = _head;
				_allocNode = n.next;
				
			}
		}
	}
	*/
	/**
	 *	@private
	 */
	private function initObject( params:Array=null ) : *
	{ 
		var result:* = ClassUtils.instantiateWithArgs( _obj, params||[] );
		if( result is EventDispatcher ) {
			result.addEventListener( "destroyed", destroyed );
		}	
		return result;
	}
	
	/**
	 *	@private
	 */
	private function destroyed( event:Event ):void
	{
		destroy( event.target );
	}
}


internal class ObjNode
{
	public var next:ObjNode;
	
	public var data:*;
	
	public function ObjNode(){
		super()
	}
}