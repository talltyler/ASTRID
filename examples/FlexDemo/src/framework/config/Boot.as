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
package framework.config
{
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import framework.display.Base;
	import framework.cache.Cache;
	import framework.data.Data;
	import framework.controller.Controller;
	import framework.controller.Routes;
	//import framework.plugins.Plugins;
	//import framework.tasks.Tasks;
	import framework.net.Assets;
	import framework.net.Asset;
	import framework.net.AssetsGroup;
	import framework.net.Job;
	
	// TODO:
	// cookies/ shared objects model adapter
	// state machine with animation
	// binding
	// process progress / bind to process
	// zoom/pan integrated with gestures and mouse wheel
	// lazy loading data sets
	// amf and rtmp data connections
	// prefs with defaults, and overrides
	
	/**
	 * Boot is a base class that should your application should extend, the applications part
	 */
	public class Boot extends Base
	{
		public static const SETUP:String = "setup";
		public static const READY:String = "ready";
		
		public var parameters:Object;
		public var cache:Cache;
		public var assets:Assets;
		public var data:Data;
		public var controller:Controller;
		public var routes:Routes;
		//public var tasks:Tasks;
		//public var plugins:Plugins;
		
		private var _ready:Boolean;
		
		public function Boot()
		{
			super();
			addEventListener( Event.ENTER_FRAME, initialize );
		}
	
		//Setup stage and application
		protected function configure():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		
			parameters = this.root.loaderInfo.parameters;
		
			// The Cache is where your applications data will be saved
			cache = new Cache();

			// Create a model manager.
			data = new Data( cache ); 
			
			// Routes is like a map of url locations to parts of your application.
			routes = new Routes( cache );
			
			// Assets is a simplified way to load anything.
			assets = new Assets( cache ); 
			
			// Create a controller manager.
			controller = new Controller( this, routes, assets ); 
		
			// Task are for objects that can modify other objects.
			//tasks = new Tasks( cache );
			
			// Create a Plugin Manager
			//plugins = new Plugins( assets );

			// Look for preload xml files defined in flashVars
			if( parameters.preloads != null ) {
				var preloads:AssetsGroup = new AssetsGroup( assets ); // AssetsGroup loads a list of files defined in XML
				preloads.addEventListener( Event.COMPLETE, loaded );
				preloads.add( parameters.preloads );
				preloads.load();
			}else{
				_ready = true;
			}
		
			// TODO: Environment setup things differently relative to environment
			// browser, OS, player type, system default language, screen type,
			// var ip = '<!--#echo var="REMOTE_ADDR"-->'; // get IP address
		
			// Handle all uncaught Errors, Flash 10.1 feature
			if( this.root.loaderInfo.hasOwnProperty("uncaughtErrorEvents") ) {
				this.root.loaderInfo["uncaughtErrorEvents"].addEventListener( "uncaughtError", onUncaughtError );
			}
		}
		
		/**
		 * Override this method if you want to config anything before your application starts
		 * @param event Event 
		 */
		public function start( event:Event=null ):void
		{
			controller.start();
		}
		
		protected function setup():void
		{
			dispatchEvent(new Event( SETUP, true ));
		}
		
		protected function ready():void
		{
			dispatchEvent(new Event( READY, true ));
			start();
		}
	
		/**
		 * Initialize stub, no need to change anything below this.
		 */
		private function initialize(event:Event):void
		{
			removeEventListener( Event.ENTER_FRAME, initialize );

			if( parent == null ) {
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}else{
				configure();
				setup();
				if( _ready ) {
					var job:Job = assets.load();
					job.addEventListener( Event.COMPLETE, loaded );
					if( job.length == 0 ) {
						loaded();
					}
				}
			}
		}
	
		/**
		 * Call setup after the application has been added to the stage.
		 */
		private function onAddedToStage( event:Event=null ):void
		{
			configure();
			setup();
			if( _ready ) {
				var job:Job = assets.load();
				job.addEventListener( Event.COMPLETE, loaded );
				if( job.length == 0 ) {
					loaded();
				}
			}
		}
		
		/**
		 * Application is ready and will start whenever you are ready
		 * @param event Event
		 * @private
		 */
		private function loaded(event:Event=null):void
		{
			if( event && event.target.hasEventListener( Event.COMPLETE ) ) {
				event.target.removeEventListener( Event.COMPLETE, loaded ); 
			}
			ready();
		}
	
		/**
		 * This is global uncaught error handler/listener
		 * @param event UncaughtErrorEvent 
		 */
		private function onUncaughtError( event:Event ) : void 
		{
			if( event["error"] is Error) {
				var error:Error = event["error"] as Error;
				// Log.debug(error.errorID, error.name, error.message);
			}else {
				var errorEvent:ErrorEvent = event["error"] as ErrorEvent;
				// Log.error(errorEvent["errorID"]);
			}
		}
	}
}