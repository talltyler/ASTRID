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
package framework.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import framework.cache.Cache;
	
	public class AssetsGroup extends EventDispatcher
	{
		private var _cache:Cache;
		private var _assets:Assets;
		private var _loading:Array = [];
		
		public function AssetsGroup( assets:Assets )
		{
			super();
			
			_assets = assets;
			_cache = _assets.cache;
		}
		
		public function add( path:String, options:Object=null ):void
		{
			_loading.push( path );
			_assets.add( path, options );
		}
		
		public function load():void
		{
			_assets.load().addEventListener( Event.COMPLETE, onLoaded );
		}
		
		private function onLoaded( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, onLoaded );
			
			for each( var preloads:String in _loading ){
				var data:XML = XML( _cache.assets[preloads].data );
				for each( var file:XML in data.elements() ){
					var options:Object = {};
					options.name = file.@name.toString()||null;
					options.method = file.@method.toString()||null;
					options.type = file.@type.toString()||null;
					_assets.add( file.@src.toString()||file.@href.toString()||file.text(), options );
				}
			}
			_assets.load().addEventListener( Event.COMPLETE, onComplete );
		}
		
		private function onComplete( event:Event ):void
		{
			event.target.removeEventListener( Event.COMPLETE, onComplete );
			dispatchEvent( event );
		}
	}
}