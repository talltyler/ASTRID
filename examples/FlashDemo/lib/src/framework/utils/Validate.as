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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import framework.events.ModelEvent;
	import framework.net.Assets;
	import framework.net.Asset;
		
	/**
	 *  Data validation methods
	 */
	public class Validate extends EventDispatcher 
	{
		private static var dispatcher:EventDispatcher
		private static var assets:Assets
		
		/* ErrorId's 
			1. Not valid format
			2. Value legth is either to long or short
		*/

		public function Validate()
		{
			super();
		}
		
		/**
		 *	Validate emails addresses
		 */
		public static function email( obj:*, name:String, value:*, params:Object=null ):Object
		{
			var pattern:RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
			
			var emails:Array = value.toLowerCase().split(/[\,\s]+/); // commas and/or whitespace separate emails 
			var result:Object;
			for each (var email:String in emails) {
	 			if(!pattern.test(email)) {
	 				if( result == null ){ result = {}; }
					if( result.errors == null ){ result.errors = []; }
					result.errors.push( { errorId:1, obj:obj, name:name, value:value, part:email, message:email + " is not a valid email address."})
				}
			}
			return result;
		}
		
		/**
		 *	Validate the length of a given value
		 */
		public static function length( obj:*, name:String, value:*, params:Object=null ):Object
		{
			var result:Object;
			if( params.min >= 0 && value.length < params.min) {
				if( result == null ){ result = {}; }
				if( result.errors == null ){ result.errors = []; }
				result.errors.push( { errorId:2, obj:obj, name:name, value:value, part:value, message:name+" must be between "+ params.min +" and " + params.max + "characters long."})
			} else if( params.max >= 0 && params.max >= params.min && value.length > params.max) {
				if( result == null ){ result = {}; }
				if( result.errors == null ){ result.errors = []; }
				result.errors.push( { errorId:2, obj:obj, name:name, value:value, part:value, message:name+" must be between "+ params.min +" and " + params.max + "characters long."})
			}
			
			return null
		}
		
		/**
		 *	Validate the data on the server
		 */
		public static function server( obj:*, name:String, value:*, params:Object=null ):Object
		{
			if( assets == null ) {
				assets = new Assets();
			}
			var asset:Asset = assets.add( params.path );
			asset.addVariable( name, value );
			asset.userData = {obj:obj, name:name, value:value, params:params};
			asset.addEventListener(Event.COMPLETE, Validate.onLoad );
			assets.load();
			if( dispatcher == null ) {
				dispatcher = new EventDispatcher();
			}
			return { dispatcher:dispatcher };
		}
		 
		private static function onLoad( event:Event ):void
		{
			var asset:Asset = event.target as Asset;
			if( asset.data == "" || asset.data.toLowerCase() == "true" || asset.data.toLowerCase() == "success" ) {
				dispatcher.dispatchEvent( new ModelEvent( Event.COMPLETE, asset.userData ) )
			}else{
				asset.userData.message = asset.data;
				dispatcher.dispatchEvent( new ModelEvent( Event.COMPLETE, asset.userData ) );
			}
		}
	}
}