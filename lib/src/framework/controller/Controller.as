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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	
	import framework.cache.Cache;
	import framework.config.Boot;
	import framework.debug.Log;
	import framework.events.ControllerEvent;
	import framework.events.ViewEvent;
	import framework.net.Assets;
	import framework.net.Asset;
	import framework.view.RendererBase;
	
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
		public static const CONTEXT_NOT_FOUND:String = "contextNotFound";
		public static const METHOD_NOT_FOUND:String = "methodNotFound";
		public static const DEFAULT_METHOD:String = "index";
		
		public var contexts:Object = {};
		
		public var viewBase:String = "assets/context/";
		public var viewExtension:String = ".html";
		
		public var currentRoute:Object;
		public var currentContext:String;
		public var currentMethod:String;
		public var currentParams:Object;
		public var currentViewData:Object;
		public var currentView:RendererBase;
		public var started:Boolean;
		
		// separators
		private static const PATH_SEPARATOR:String = "|";
		private static const SLASH:String = "/";
		private static const DOT:String = ".";
		private static const QUESTION:String = "?";
		private static const AND:String = "&";
		private static const EQUALS:String = "=";
		private static const COLON:String = ":";
		
		private var _assets:Assets;
		private var _routes:Routes;
		private var _container:Boot; // Container must be class that extends Sprite
		private var _deeplinking:String = DEEPLINKING_ON;
		private var _tracking:Function;
		private var _pathParts:Array;
		private var _pathPartIndex:int;
		private var _currentPathPart:int;
		private var _history:UndoRedo;
	
		/**
		 * @param routes Routes 
		 * @param container Sprite 
		 * @param deeplinking String 
		 * @param tracking Function 
		 */
		public function Controller( container:Boot, routes:Routes, assets:Assets, deeplinking:String=DEEPLINKING_ON, tracking:Function=null ):void
		{ 
			super();
			
			_container = container;
			_routes = routes;
			_deeplinking = deeplinking;
			_tracking = tracking;
			_assets = assets;
			_history = new UndoRedo();
			addEventListener( ControllerEvent.REDIRECT, redirectEvent );
			if( _container.parent == null ) {
				_container.addEventListener( Event.ADDED_TO_STAGE, start );
			}
		}
		
		public function get assets():Assets
		{
			return _assets;
		}
		
		public function get container():Boot
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
		
		public function add( ...classes ):void
		{
			for each( var clazz:Class in classes ) {
				var instance:ContextBase = new clazz();
				instance.setup( this );
				contexts[ instance.name ] = instance;
			}
		}
		
		/**
		 * Start your application when everything is loaded
		 * @param event Event, optional
		 */
		public function start(event:Event=null):void
		{
			if( _deeplinking == DEEPLINKING_ON ){
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
			}else{
				redirectTo("");
			}
		}
		
		/**
		 * @param path String 
		 * @param params Object 
		 */
		public function redirectTo(path:String, params:Object=null):void
		{
			if( path.indexOf(PATH_SEPARATOR) != -1 ){
				_pathParts = path.split(PATH_SEPARATOR);
				_pathPartIndex = 0;
				currentParams = params;
				nextPart();
			}else{
				redirectToPart(path,params);
			}
			_history.add( { path:path, params:params } );
		}
		
		/**
		 * @private
		 * @param path String 
		 * @param params Object 
		 */
		private function redirectToPart( path:String, params:Object=null ):void
		{
			currentContext = null;
			currentParams = params||{};
			
			if( path.charAt(0) == SLASH ) { // strip out leading slash
				path = path.substr(1);
			}

			var pathParts:Array = breakPathUp( path );

			var isMatch:Boolean;
			
			var chosenRoute:Object;
			var chosenContext:String;
			var chosenMethod:String;

			routesLoop : for each( var route:Object in _routes.cache ){
				
				var matchingParts:Array = [];
				var routeParts:Array = breakPathUp( route.name, true );
				var matchingContexts:Array = [];
				if( routeParts.toString() == "" && pathParts.toString() == "" ) {
					chosenRoute = route;
					chosenContext = route.options.context;
					chosenMethod = route.options.method;
					isMatch = true;
					break routesLoop;
				}else if( pathParts.toString() == "" ){
					continue;
				}
				pathPartLoop : for each( var pathPart:String in pathParts ){
					var partsCount:int = 0;
					routePartLoop: for each( var routePart:String in routeParts ){
						
						if( partsCount > pathParts.length ) {
							if( chosenContext != null ) {
								isMatch = true;
								break pathPartLoop;
							}
							
						}
						partsCount++
						var contextName:String;
						if( routePart.charAt(0) == COLON ){
							if( (routePart == ":context" || routePart == ":controller" ) && contexts.hasOwnProperty( pathPart ) != -1 ) {
								contextName = pathPart;
								matchingContexts.push( contextName );
								chosenContext = contextName;
								chosenRoute = route;
							}else if( routePart == ":method" || routePart == ":action" ){
								for each( contextName in matchingContexts ){
									if( contexts[contextName] && contexts[contextName].hasOwnProperty( pathPart.split(COLON).join("") ) ){
										chosenContext = contextName;
										chosenMethod = pathPart.split(COLON).join("");
										chosenRoute = route;
										isMatch = true;
										break routePartLoop; 
									}
								}
							}else{
								currentParams[routePart.split(COLON).join("")] = pathPart;
							}

						}else if( pathPart == routePart ){
							
							matchingParts.push( pathPart );
							
							if( matchingParts.length == routeParts.length ) {
								contextName = route.options.context;
								chosenContext = contextName;
								chosenMethod = route.options.method;
								chosenRoute = route;
								isMatch = true;
								break routePartLoop; 
							}
							
						}else{// Should be continue routesLoop; but this doesn't work in some version of the flash player
							isMatch = false;
							break routePartLoop; 
						}
					}
				}
				if( isMatch ){
					break routesLoop;
				}
			}
			
			if( chosenRoute ) {
				for( var prop:String in chosenRoute.options ) {
					if( currentParams[prop] == null ){
						currentParams[prop] = chosenRoute.options[prop];
					}
				}
			}
			
			if( chosenContext == null ){
				contextName = "missing";
				chosenContext = contexts[contextName];
				
				// Debug.log( "MissingContext:", path );
				dispatchEvent( new Event( CONTEXT_NOT_FOUND ) );
			}
			
			currentContext = chosenContext;
			currentParams.context = currentContext;
			
			if( chosenMethod == null ){
				chosenMethod = DEFAULT_METHOD;
				
				// Debug.log( "MissingMethod:", path );
				dispatchEvent( new Event( METHOD_NOT_FOUND ) );
			}
			
			currentMethod = chosenMethod;
			currentParams.method = currentMethod;
			
			if( currentParams.content != null ) {
				currentViewData = {data:currentParams.content};
				contexts[currentContext][currentMethod]( currentParams );	// call method on context
				started = true;
			}else{
				currentViewData = _assets.add( viewBase + currentContext + SLASH + currentMethod + viewExtension );
				currentViewData.addEventListener( Event.COMPLETE, onViewLoaded );
				currentViewData.addEventListener( IOErrorEvent.IO_ERROR, onViewNoFound );
				_assets.load();
			}
			
			currentRoute = chosenRoute;
			
			trace( "redirect", path, contextName, currentMethod, currentParams ); 

		}
		
		public function back():void
		{
			var result:Object = _history.undo();
			if( result != null ) {
				redirectTo( result.path, result.params );
			}
		}
		
		public function forward():void
		{
			var result:Object = _history.redo();
			if( result != null ) {
				redirectTo( result.path, result.params );
			}
		}
		
		/**
		 * @private
		 * @param event Event 
		 */
		private function nextPart(event:Event=null):void
		{
			if( hasEventListener(ViewEvent.RENDERED) ){
				removeEventListener( ViewEvent.RENDERED, nextPart );
				_currentPathPart++;
			}
			if( _pathParts.length > _pathPartIndex && _pathParts[_pathPartIndex] != "" ) {
				redirectToPart( _pathParts[_pathPartIndex], currentParams );
				addEventListener( ViewEvent.RENDERED, nextPart );
			}
		}
		
		/**
		 * @private
		 * @param event Event 
		 */
		private function onAddressChange(event:Event):void
		{
			if( _deeplinking == DEEPLINKING_ON ) {
				redirectTo( SWFAddress.getValue() || "" );
			}else if( _deeplinking == TEMP_DISABLE ) {
				_deeplinking == DEEPLINKING_ON;
			}
		}
		
		/**
		 * @private
		 * @param event ControllerEvent 
		 */
		private function redirectEvent(event:ControllerEvent):void
		{
			redirectTo( event.path, event.params );
		}
		
		/**
		 * @private
		 * @param event Event 
		 */
		private function onViewLoaded( event:Event ):void
		{	
			event.target.removeEventListener( "removed", onViewNoFound );
			event.target.removeEventListener( Event.COMPLETE, onViewLoaded );
			currentParams.content = event.target.data;
			if( contexts[currentContext] != null && contexts[currentContext][currentMethod] != null ) {
				contexts[currentContext][currentMethod]( currentParams );	// call method on context
			}else{
				trace("missing context", currentContext, currentMethod );
			}
			started = true;
		}
		
		/**
		 * @private
		 * @param event Event 
		 */
		private function onViewNoFound( event:Event ):void
		{
			event.target.removeEventListener( IOErrorEvent.IO_ERROR, onViewNoFound );
			event.target.removeEventListener( Event.COMPLETE, onViewLoaded );
			contexts[currentContext][currentMethod]( currentParams );	// call method on context
		}
		
		/**
		 * @private
		 * @param path String 
		 * @param temp Boolean 
		 * @return Array 
		 */
		private function breakPathUp( path:String, temp:Boolean=false ):Array
		{
			var parts:Array = path.split("?");
			var locationString:String = parts[0];
			var paramsString:String = parts[1];
			var result:Array = locationString.split( SLASH );
			var lastItem:String = result[ result.length - 1 ];
			if( lastItem == "" ) {
				result.pop();
			}
			var formatIndex:int = lastItem.indexOf( DOT );
			if( formatIndex != -1 ) {
				result[ result.length - 1 ] = lastItem.substr(0,formatIndex);
				result.push( DOT + lastItem.substr(formatIndex) );
			}
			if( paramsString != null && !temp ){
				var params:Array = paramsString.split(AND);
				for each( var param:String in params ) {
					var paramsParts:Array = param.split(EQUALS)
					currentParams[paramsParts[0]] = paramsParts[1];
				}
			}
			if(result.length == 0) {
				result.push("")
			}
			return result;
		}
	}
}