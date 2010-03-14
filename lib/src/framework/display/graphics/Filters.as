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
package framework.display.graphics 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.filters.*;
	
	import framework.display.Base;
	
	public class Filters 
	{
		
		public function Filters()
		{ 
			super();
		}
		
		public static function applyFilters( target:Base, filters:Object ) : void
		{
			/*
			var arr:Array = []
			for each( var f:Object in filters ) {
				if( f.type != undefined ){
					if(f.type){
						arr.push( this[ f.type.toLowerCase() ]( f ) );
					}
				}
			}
			target.filters = arr;
			*/
		}
		public static function bevel( f:Object ) : BevelFilter { 
			return new BevelFilter( f.distance||4, f.angle||45, f.highlightColor||0xFFFFFF, f.highlightAlpha||1, f.shadowColor||0, f.shadowAlpha||1, f.blurX||4, f.blurY||4, f.strength||1, f.quality||1, f.fillType||"pad", false);
		}
		public static function blur( f:Object ) : BlurFilter { 
			return new BlurFilter( f.blurX||4, f.blurY||4, f.quality||1 );
		}
		public static function dropshadow( f:Object ) : DropShadowFilter { 
			return new DropShadowFilter( f.distance||4, f.angle||45, f.color||0, f.alpha||.3, f.blurX||4, f.blurY||4, f.strength||1, f.quality||1, f.inner||false, f.knockout||false );
		}
		public static function glow( f:Object ) : GlowFilter { 
			return new GlowFilter( f.color||0, f.alpha||1, f.blurX||8, f.blurY||8, f.strength||1, f.quality||1, f.inner||false, f.knockout||false );
		}
		public static function colormatrix( f:Object ) : ColorMatrixFilter { 
			return new ColorMatrixFilter( f.matrix );
		}
	}	
}