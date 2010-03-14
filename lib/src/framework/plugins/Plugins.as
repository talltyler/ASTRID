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
package framework.plugins
{
import flash.events.Event;

import framework.net.Assets;
import framework.net.Asset;
import framework.utils.ArrayUtils;
import framework.utils.ClassUtils;

public class Plugins
{
	public var assets:Assets;
	public static var classes:Object = {};
	
	public function Plugins( assets:Assets )
	{
		super();
		
		this.assets = assets;
	}
	
	internal function add( path:String, ...packages ):void
	{
		var asset:Asset = assets.add( path );
		if( packages.length ) {
			asset.userData = packages;
			asset.addEventListener( Event.COMPLETE, onPluginLoaded );
		}
		assets.load();
	}
	
	public static function getClass( clazz:String ):Class
	{
		if( classes[ clazz ] != null ) {
			return classes[ clazz ];
		}
		return resolveClassName( clazz );
	}
	
	private function onPluginLoaded( event:Event ):void
	{
		for each( var clazz:String in event.target.userData ) {
			resolveClassName( clazz );
		}
	}
	
	private static function resolveClassName( name:String ):Class
	{
		return classes[ ArrayUtils.last( name.split("::").join(".").split(".") ) ] = ClassUtils.getClass( name );
	}
	
}

}