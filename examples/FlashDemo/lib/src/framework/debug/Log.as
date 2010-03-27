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
package framework.debug
{
import flash.display.Sprite;
import flash.external.ExternalInterface;

import framework.net.Assets;
import framework.net.Asset;

public class Log
{
	/**
	 *  Emergency: system is unusable
	 */		
	public static const EMERGENCY:int   = 0;

	/**
	 * Alert: action must be taken immediately
	 */
	public static const ALERT:int   	= 1;

	/**
	 * Critical: critical conditions
	 */
	public static const CRITICAL:int    = 2;

	/**
	 * Error: error conditions
	 */
	public static const ERROR:int     	= 3;

	/**
	 * Warning: warning conditions
	 */
	public static const WARNING:int    	= 4;

	/**
	 * Notice: normal but significant condition
	 */
	public static const NOTICE:int  	= 5;

	/**
	 * Informational: informational messages
	 */
	public static const INFO:int    	= 6;

	/**
	 * Debugger: debug messages
	 */
	public static const DEBUG:int   	= 7;
	
	/**
	 * Filter messages that contain these strings
	 */
	public static var filters:Array = ["password", "credit"];
	
	/**
	 * The location that errors will be sent to the server in callServer method
	 */
	public static var serverLocation:String;
	
	/**
	 * The lowest level error that will be output, if set to 7, everything is output
	 */
	public static var logLevel:int = 7;
	
	/**
	 * Debug output map, each log level is assigned to an output type, (callServer, jsalert, jsLog, debugger, astrace)
	 */
	public static var outputs:Array = [
		Log.callServer, // emergency
		Log.jsalert,	// alert
		Log.jsalert, 	// critical
		Log.jsalert,	// error
		Log.jsalert,	// warning
		Log.jsalert, 	// notice
		Log.jsLog,		// info
		Log.debugger 	// debug
	]
	
	private static var _saveLog:Boolean;
	private static var _log:Array = [];
	private static var _target:Sprite;
	
	/**
	 * @constructor
	 */
	public function Log( target:Sprite )
	{
		super();
		
		setup( target );
	}

	public function get saveLog():Boolean
	{ 
		return _saveLog; 
	}

	public function set saveLog(value:Boolean):void
	{
		if (value !== _saveLog) {
			_saveLog = value;
		}
	}

	public function get log():Array
	{ 
		return _log; 
	}
	
	public static function openLog():void
	{
		/* // TODO: make logger
		var logger:Sprite = new Sprite();
		logger.graphics.beginFill(0,0.5);
		logger.graphics.drawRect(0,0,_target.stage.stageWidth, _target.stage.stageHeight/3);
		_target.addChild(logger);
		*/
	}
	
	/**
	 * @param logLevel int 
	 * @param ...messages Rest param
	 */
	public static function output( logLevel:int, ...messages ):void
	{
		if( logLevel >= Log.logLevel ) 
		{
			var cleaned:String = filterMessages( messages );

			outputs[ logLevel ]( logLevel, cleaned );
			
			if( _saveLog ) {
				_log.push( cleaned );
			}
		}
	}
	
	/**
	 * Emergency: system is unusable
	 * @param ...messages Rest param
	 */
	public static function emergency(...messages):void
	{
		messages.splice(0,0, Log.EMERGENCY )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Alert: action must be taken immediately
	 * @param ...messages Rest param
	 */
	public static function alert(...messages):void
	{
		messages.splice(0,0, Log.ALERT )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Critical: critical conditions
	 * @param ...messages Rest param
	 */
	public static function critical(...messages):void
	{
		messages.splice(0,0, Log.CRITICAL )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Error: error conditions
	 * @param ...messages Rest param
	 */
	public static function error(...messages):void
	{
		messages.splice(0,0, Log.ERROR )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Warning: warning conditions
	 * @param ...messages Rest param
	 */
	public static function warning(...messages):void
	{
		messages.splice(0,0, Log.WARNING )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Notice: normal but significant condition
	 * @param ...messages Rest param
	 */
	public static function notice(...messages):void
	{
		messages.splice(0,0, Log.NOTICE )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Informational: informational messages
	 * @param ...messages Rest param
	 */
	public static function info(...messages):void
	{
		messages.splice(0,0, Log.INFO )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Debugger: debug messages
	 * @param ...messages Rest param
	 */
	public static function debug(...messages):void
	{
		messages.splice(0,0, Log.DEBUG )
		Log.output.apply( null, messages );
	}
	
	/**
	 * Call the server if one of these errors is thrown.
	 */
	protected static function callServer( logLevel:int, messages:String ):void
	{
		var assets:Assets = new Assets();
		var asset:Asset = assets.add( serverLocation );
		asset.addVariable( "error", messages );
		assets.load();
	}
	
	/**
	 * Output messages to javaScript alerts
	 */
	protected static function jsalert( logLevel:int, messages:String ):void
	{
		ExternalInterface.call( "alert", messages );
	}
	
	/**
	 * Output messages to the javaScript Log, firebug or safari
	 */
	protected static function jsLog( logLevel:int, messages:String ):void
	{
		var method:String;
		switch( logLevel ) {
			case 7 : method = "log"; break;
			case 6 : method = "info"; break;
			case 5 : method = "warn"; break;
			case 4 : method = "warn"; break;
			case 3 : method = "error"; break;
			case 2 : method = "error"; break;
			case 1 : method = "error"; break;
			case 0 : method = "error"; break;
		}
		ExternalInterface.call( "Log." + method, messages );
	}
	
	/**
	 * Output messages with monster debugger
	 */
	protected static function debugger( logLevel:int, messages:String ):void
	{
		// MonsterDebugger.trace( _target, messages );		
	}
	
	/**
	 * Output messages with standard flash trace
	 */
	protected static function astrace( logLevel:int, messages:String ):void
	{
		trace( messages );
	}
	
	private function setup( target:Sprite ):void
	{
		_target = target;
		
		// MonsterDebugger.snapshot( _target );
	}
	
	private static function filterMessages( messages:Array ):String
	{
		var result:String = messages.toString();
		for each( var prop:String in filters ){
			if( result.indexOf( prop ) == -1 ) {
				return ""
			}
		}
		return result
	}
}

}