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
	import flash.events.EventDispatcher;
	
	import framework.cache.Cache;
	import framework.display.Base;
	import framework.eval.Objects;
	import framework.events.ListenerManager;
	import framework.net.Assets;
	import framework.net.Asset;
	import framework.utils.ClassUtils;
	import framework.debug.Log;
	import framework.view.RendererBase;
	
	/**
	 *  All contexts within your application should extend this Class, it gives these contexts 
	 *	all of their functionality. 
	 */
	public class ContextBase extends EventDispatcher
	{
		public var controller:Controller;
		public var startChars:String = "<%";
		public var endChars:String = "%>";
		public var template:String;
						
		protected var data:Object = {};
		protected var settings:Object = {};
		protected var layout:Class;
		protected var renderer:Class;
		protected var assets:Assets;
		protected var view:*;
		
		private var _name:String;
		private var _container:Sprite;
		private var _contentPath:String;
		private var _listenerManager:ListenerManager;
		private var _flashMessage:String = "";
		
		/**
		 *	@constructor
		 */
		public function ContextBase()
		{
			super();
		}

		public function get flashMessage():String
		{ 
			var result:String = _flashMessage;
			_flashMessage = "";
			return result; 
		}

		public function set flashMessage(value:String):void
		{
			_flashMessage = value;
		}
				
		/**
		 *	Getter for the contexts name, this name will have the "Controller" part of the class name striped out
		 *	@return		Returns a string of the name of the class to be used by the Routes and application Controller
		 */
		public function get name():String
		{
			if( _name == null )
				_name = ClassUtils.className( this ).split( "Context" ).join("").toLowerCase();
				
			return _name;
		}
		
		/**
		 *	Setter for this contexts name, you can change this name to anything, routes will match your new name
		 *	@param	value	 The name that you would like to call this controller
		 */
		public function set name( value:String ):void
		{
			if( controller.contexts[ _name ] != null )
				controller.contexts[ value ] = controller.contexts[ _name ];
			// We are not deleting the old reference currently, you may want to do this
			// by not deleting the old name you could use both the old names and your new name
			_name = value;
		}
		
		
		/**
		 *	This method will render your contexts content within your views renderer. 
		 *	Most views have something that is loaded into them, we assume that this content is located here
		 *	controller.viewBase + controller.currentContext + "/" + controller.currentMethod
		 *	You can override any of these paths or not load any content at all by passing an empty String to your viewPath
		 *	This will bypass loading anything and tell your view to render. This method also handles the 
		 *	destroy methods that might be on your views elements. By overriding these destroy methods
		 *	you can add closing animations or whatever transition out of each page. 
		 *	This method also is able to handle nested renderers, this is facilitated by the container argument. 
		 *	@param	renderer	 Which class you are using to render your view, you pass null if you want to use the classes layout render
		 *	@param	container	 The parent container of your view, this might be a element within another view, this enables nested views
		 *	@param	viewPath	 If you would like to override the path that is definded by the controller and action you can pass a path in
		 *	@param	seoPath	 	 If you have useSWFAddress set to true and dont want to use your viewPath you can override this here
		 *	@param	trackingPath If you have trackPageViews set to true and dont want to use your seoPath you can override this here
		 */
		public function render( renderer:Class=null, container:Sprite=null, viewPath:String=null, seoPath:String=null, trackingPath:String=null ):*
		{
			if( renderer == null ){
				renderer = layout;}
				
			if( container ){
				_container = container;}
				
			if( _container == null ){
				_container = controller.container;}
				
			if( controller.currentView != null && controller.currentView.parent ){
				if( controller.currentView.hasOwnProperty("destroy") ){
					controller.currentView.addEventListener( "destroyed", onViewReady );
					controller.currentView.destroy();
				}else{
					onViewReady();}
			}else if( container != null ){
				if( container is Base ){ // container must be a subclass of Base to use the destroy functionality
					container.addEventListener( "destroyed", onViewReady );
					(container as Base).destroy();
				}else{
					onViewReady();}
			}else{
				onViewReady();}
			
			function onViewReady( event:Event=null ):void
			{
				// if( controller.currentView != null && controller.currentView.parent != null )
				//	_container.removeChild( controller.currentView );
					
				//if( controller.currentView && controller.currentView.hasEventListener( "destroyed" ) ){
				//	controller.currentView.removeEventListener( "destroyed", onViewReady );
				//}
				//if( container == null && controller.currentView != null && controller.currentView.parent ){
				//	controller.currentView.parent.removeChild( controller.currentView );
				//}
				
				//if( controller.currentView && controller.currentView.parent ) {
				//	controller.currentView.parent.removeChild( controller.currentView );
				//}
				
				if( container == null && _container.parent.name == "ROOT" ){ 
					view = controller.currentView = new renderer( controller, 
												_container.stage.stageWidth, _container.stage.stageHeight );
				}else{
					view = controller.currentView = new renderer( controller, _container.width, _container.height );
				}
				controller.currentView.data = data;

				_container.addChild( controller.currentView );

				if( viewPath == null ){
					viewPath = controller.viewBase + controller.currentContext + "/" + controller.currentMethod; // + "?" + controller.currentParams;
				}
				_contentPath = viewPath;
				
				if( template != null ){
					var templateData:String = controller.assets.fetch(template);
					if( templateData != null ) {
						controller.currentParams.content = templateData.split("<% content %>").join(controller.currentParams.content);
					}
				}
				
				var objects:Objects = new Objects();
				var parsed:String = objects.parse( controller.currentParams.content, data, startChars, endChars );
				//// Log.debug(parsed)
				controller.currentView.render( parsed );
				
				/*
				if( viewPath != "" ) {
					// TODO: might want to dispatch progress events into the renderer
					assets.add( viewPath ).addEventListener(Event.COMPLETE, onComplete);
					assets.load( controller.currentParams.event||null );
				}else{
					controller.currentView.render("");
				}
				*/
				/*
				if( seoPath == null ){
					seoPath = viewPath;
				}
				if( controller.deeplinking == Controller.DEEPLINKING_ON && seoPath != "" ){
					controller.deeplinking = Controller.TEMP_DISABLE;
					SWFAddress.setValue( seoPath );
				}
				
				if( trackingPath == null ){
					trackingPath == seoPath;
				}
				if( controller.tracking != null && trackingPath != "" ){
					controller.currentParams.tracking = trackingPath;
					controller.tracking( controller.currentParams );
				}
				*/
			}
			return controller.currentView;
		}
		
		/**
		 *	This is a wrapper method for the application contexts redirect method.
		 *	You are able to redirect to other locations within your application with this.
		 *	@param	...params	 rest param to send any amount of arguments to the controller
		 *	@see	framework.controller.Controller|#redirect
		 */
		public function redirectTo(...params):void
		{
			controller.redirectTo.apply(null,params);
		}
		
		/**
		 *	This method is called by the application controller to setup this controller
		 *	@private
		 *	@param	controller	 You must pass in a reference to the applications controller
		 */
		public function setup( controller:Controller ):void
		{
			this.controller = controller;
			_container = controller.container;
			assets = controller.assets;
			_listenerManager = new ListenerManager( this );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			_listenerManager.removeEventListener(type, listener, useCapture);
		}
		
		public function destroy( event:Event=null ):void 
		{
			_listenerManager.destroy();			
			dispatchEvent( new Event( "destroyed" ) );
		}
		
		/**
		 *	After your view is loaded this method is called to render your view, your view is passed the loaded content
		 *	@private
		 */
		private function onComplete(event:Event):void
		{
			controller.currentView.render( assets.fetch(_contentPath) );
		}
		
		/*
		Everything below this line is questionable, we need to figure out the best way to do this stuff, 
		This might not be the best way, as soon as we figure it out we will impliment these features
		
		// same as get in other frameworks, get is a keyword
		public function retrieve():void
		{
			
		}
		
		public function post():void
		{
			
		}
		
		public function put():void
		{
			
		}
		
		// same as delete in other frameworks, delete is a keyword
		public function destroy():void
		{
			
		}
		
		public function flash():void
		{
			
		}
		
		//
		public function message():void
		{
			
		}
		*/
		/*
		method_missing
		redirect_to_url
		session
		cookies
		*/
	}
}