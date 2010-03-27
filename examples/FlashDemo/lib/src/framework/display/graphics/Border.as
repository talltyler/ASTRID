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
	import flash.geom.Matrix;
	import flash.display.Sprite;
	
	public class Border 
	{
		public function Border()
		{
			super();
		}
		
		public static function none( element:Sprite, style:Object ) :void {}
		
		// TODO: look into drawing these on a different layer above within shape rather then on the line
		// TODO: also look in drawing boders on just one side
		public function solid( element:Sprite, style:Object ) :void 
		{
			element.graphics.lineStyle( style.border.weight||1, style.border.color||0, style.border.alpha||1, true );
		}
		
		// the width and height of the gradients matrix are based on percentages not pixels
		public static function gradient( element:Sprite, style:Object ) :void
		{
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox( ( style.width*.01 ) * style.border.width, ( style.height*.01 ) * style.border.height, ( style.border.r/180 )*Math.PI, style.border.tx, style.border.ty );
			element.graphics.lineGradientStyle( style.border.kind, style.border.colors, style.border.alphas, style.border.ratios, matrix, style.border.spread, style.border.interpolation, style.border.focalpoint );
		}
	
	}

}

