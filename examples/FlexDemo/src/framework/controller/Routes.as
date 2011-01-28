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
import framework.cache.Cache;

/**
 * Routes is like a mapping to all of the locations that your applications
 * can goto. Normally a application will map to contexts and actions
 * but you can add any keyword into a route to pass variables through.
 * For instance: /users/edit/1 can be mapped with :context/:action/:id
 * In this case the users controller must be added to your application 
 * and it must contain a method called edit. This method will be called 
 * on this controller and passed a params object with id equal to 1.
 * You can add any other paramiters on that you like but keeping your 
 * routes readable is the key so don't make it to complicated. 
 */
public class Routes
{
	public var hasViewContect:Boolean = true;
	
	private var _cache:Cache;
	
	/**
	 * @constructor
	 * @param cache Cache A instance of Cache that your routes will be 
	 * saved in should be passed in. Routes should have the same cache 
	 * as the controller.
	 */
	public function Routes( cache:Cache = null )
	{
		super();
		
		if( cache != null ) {
			_cache = cache;
			if( cache.routes == null ) {
				_cache.routes = [];
			}
		}else{
			_cache = new Cache();
			_cache.routes = [];
		}
	}
	
	public function get cache():Object
	{
		return _cache.routes;
	}
	
	/**
	 * Add a route 
	 * @param name String The route mapping
	 * @param options Object Any options that you would like to set
	 */
	public function add( name:String, options:Object=null ):void
	{
		var route:Object = {"name":name, options:options };
		if( hasViewContect == false ) {
			route.content = "";
		}
		_cache.routes.push( route );
		
	}
}

}