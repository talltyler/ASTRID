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
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedSuperclassName;
import flash.utils.getQualifiedClassName;
import framework.debug.Log;

public class ClassUtils extends Object
{
	
	public function ClassUtils()
	{
		super();
	}
	
	/**
	 *	Returns the name of the class you pass in.
	 *	
	 *	@param klass The class that you want to know the name of.
	 *	@tiptext
	 */
	public static function className( obj:* ) : String
	{
		return getQualifiedClassName( obj ).split("::")[1];
	}
	
	public static function superClassName( obj:* ) : String
	{
		return getQualifiedSuperclassName( obj ).split("::")[1];
	}
	
	public static function getClass( name:String ):Class
	{
		return ApplicationDomain.currentDomain.getDefinition( name ) as Class;
	}
	
	public static function getInstance( name:String, ...args ) : *
	{
		return instantiateWithArgs( getClass( name ), args );
	}
	
	public static function instantiateWithArgs( clazz:Class, args:Array ):*
	{
		try {
			switch(args.length){
				case 0: return new clazz(); break;
				case 1: return new clazz(args[0]); break;
				case 2: return new clazz(args[0], args[1]); break;
				case 3: return new clazz(args[0], args[1], args[2]); break;
				case 4: return new clazz(args[0], args[1], args[2], args[3]); break;
				case 5: return new clazz(args[0], args[1], args[2], args[3], args[4]); break;
				case 6: return new clazz(args[0], args[1], args[2], args[3], args[4], args[5]); break;
				case 7: return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
				case 8: return new clazz(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]); break;
				default : return new clazz(); break;
			}
		}catch( error:Error ) {
			// Log.error( "Error: Class was not able to be instantiated successfully.", clazz, error ); 
		}
	} 
}

}