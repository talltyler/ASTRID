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

public class ModelUtils
{
	public var _data:Data;
	public var _name:String;
	public var _class:Class;
	
	public function ModelUtils( data:Data, name:String, clazz:Class )
	{
		super();
		_data = data;
		_name = name;
		_class = clazz;
	}
	
	/** Create a new model object
	 */
	public function create( params:Object=null ) : * {
		return _data.create( _name, params );
	}

	/** Export all items as a String formated relative to the models adapter
	 */
	public function export( params:Object=null ) : String {
		return _data.export( _name, params );
	}

	/** Load data and convert to native objects, your adapter should define the datas format
	 */
	public function load( path:String ) : void {
		_data.load( _name, path );
	}

	/** Convert a string of the adapters type to native objects
	 */
	public function parse( source:String ) : void {
		_data.parse( _name, source );
	}

	/** Find model objects of this models type
	 */
	public function find( ...args ) : * {
		return _data.find( _name, args );
	}

	/** Return an Array of all of the models of this models type that meet all of the parameters conditions
	 */
	public function all( conditions:Object=null, limit:int=0, offset:int=0, sortOnFields:Object=null, sortOptions:Object=null ) : Array {	
		return _data.all( _name, conditions, limit, offset, sortOnFields, sortOptions );
	}

	/** Return the first model of this models type that meet all of the parameters conditions
	 */
	public function first( conditions:Object=null, limit:int=0, offset:int=0, sortOnFields:Object=null, sortOptions:Object=null ) : * {	
		return _data.first( _name, conditions, limit, offset, sortOnFields, sortOptions );
	}

	/** Return the last model of this models type that meet all of the parameters conditions
	 */
	public function last( conditions:Object=null, limit:int=0, offset:int=0, sortOnFields:Object=null, sortOptions:Object=null ) : * {
		return _data.last( _name, conditions, limit, offset, sortOnFields, sortOptions );
	}

	/** Return the model of this models type that has this id
	 */
	public function findById( id:int ) : * {
		return _data.findById( _name, id );
	}
	
}

}