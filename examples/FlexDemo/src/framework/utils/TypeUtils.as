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
	public class TypeUtils 
	{
		public function TypeUtils()
		{
			super();
		}
		
		public static function cleanNumber( val:*, parentSize:Number ):Number
		{
			if( val is Number)
				return val as Number;
			else if( val is String ) {
				if( isStringPercent( val as String ) )
					return percentToNumber( val as String, parentSize );
				else if( isStringFloat( val as String ) )
					return parseFloat( val as String);
			}
			return Number( cleanString( val as String ) );
		}
		
		public static function cleanString( val:String ) : * 
		{ 
			if( isStringInt( val ) )
				return parseInt( val );
				
			else if( isStringFloat( val ) )
				return parseFloat( val );
				
			else if( isStringHex( val ) ){
				val = val.split("#").join("").split("0x").join("");
				if( val.length == 3 ) { // if 3 characters long handle like a 3 digit color
					var result:String = "";
					for(var i:int=0;i<3;i++){
						result += val.charAt(i)+val.charAt(i)
					}
					val = result;
				}
				return parseInt(val, 16);
			}
				
			else if( isStringBoolean( val ) )
				return val.toLowerCase() == "true" ? true : false;
				
			return val
		}
		
		public static function percentToNumber( val:String, parentSize:Number):Number
		{
			return parentSize * ( parseFloat( val ) * 0.01 )
		}
		
		public static function isStringInt( val:String ) : Boolean { 
			if( val != null && val.search( /\d+/ ) == 0 && val.indexOf(".") == -1 && val.indexOf("%") == -1 )
				return true;
			return false;
		}
		
		public static function isStringFloat( val:String ) : Boolean { 
			if( val != null && val.search( /\d+/ ) == 0 && val.indexOf("%") == -1 )
				return true;
			return false;
		}
		
		public static function isStringPercent( val:String ) : Boolean { 
			if( val != null && val.search( /\d+/ ) == 0 && val.indexOf("%") != -1 )
				return true;
			return false;
		}
		
		public static function isStringHex( val:String ) : Boolean { 
			if( val != null && ( val.substr( 0, 1 ) == "#" || val.substr( 0, 2 ) == "0x" ) )
				return true;
			return false;
		}
		
		public static function isStringBoolean( val:String ) : Boolean { 
			if( val != null && ( val.toLowerCase() == "true" || val.toLowerCase() == "false" ) )
				return true;
			return false;
		}

		public static function cleanBoolean( value:* ) : Boolean
		{
			if( value is String ){
				if( value == "true" ) return true;
				else return false;
			}else return value;
		}
	}
}

