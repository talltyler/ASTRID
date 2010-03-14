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
	import framework.debug.Log;
	
	public class Fill 
	{
		public function Fill()
		{
			super();
		}
		
		public static function none( element:Sprite, style:Object ):void {// Log.info("none")}
		
		public static function solid( element:Sprite, style:Object ) :void 
		{
			if( style.fill == null ) style.fill = { color:uint(Math.random()*0xFFFFFF), alpha:1 }
			if( style.fill.color == null ) style.fill.color = uint(Math.random()*0xFFFFFF)
			element.graphics.beginFill( style.fill.color, style.fill.alpha||1 );
		}
		
		/* The width and height of the gradients matrix are based on percentages not pixels */
		public static function gradient( element:Sprite, style:Object ) :void 
		{
			var matrix:Matrix = new Matrix(); 
			if(!style.fill) style.fill = { h:100, w:100, tx:0, ty:0, r:0, spread:"pad", rpolation:"rgb", focalpoint:0 }
			if(!style.fill.kind) style.fill.kind = "linear"
			if(!style.fill.w) style.fill.w = 100
			if(!style.fill.h) style.fill.h = 100
			if(!style.fill.tx) style.fill.tx = 0
			if(!style.fill.ty) style.fill.ty = 0
			if(!style.fill.r) style.fill.r = 90
			if(!style.fill.spread) style.fill.spread = "pad"
			if(!style.fill.interpolation) style.fill.interpolation = "rgb"
			if(!style.fill.focalpoint) style.fill.focalpoint = 0
			if(!style.fill.alphas) {
				style.fill.alphas = []
				for( var item:String in style.fill.colors ) style.fill.alphas.push(1)
			}
			if(!style.fill.ratios){
				style.fill.ratios = []
				for( var i:String in style.fill.colors ) {
					style.fill.ratios.push((255/(style.fill.colors.length-1))*int(i))
				}
			}
			matrix.createGradientBox( ( style.width*.01 ) * style.fill.w, ( style.height*.01 ) * style.fill.h, ( style.fill.r/180 )*Math.PI, style.fill.tx, style.fill.ty );
			element.graphics.beginGradientFill( style.fill.kind, style.fill.colors, style.fill.alphas, style.fill.ratios, matrix, style.fill.spread, style.fill.interpolation, style.fill.focalpoint );
		}
	
	}

}