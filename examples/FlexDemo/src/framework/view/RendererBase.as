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
package framework.view
{
	import framework.display.Base;
	import framework.controller.Controller;
	import flash.events.Event;
	
	public class RendererBase extends Base
	{
		public var data:Object;
		
		public static const RENDERED:String = "rendered";
		
		public var source:String;
		public var controller:Controller;
		
		public function RendererBase( controller:Controller, width:int, height:int )
		{
			super();
			
			this.controller = controller;
			
			graphics.beginFill(0xDDDDDD, 1);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			
			name = "RENDERER";
			controller.container.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		public function setup( target:Base ):void
		{
			
		}
		
		public function render( source:String ):void
		{
			for( var prop:String in data ) {
				if( source.indexOf("#{"+prop+"}") != -1 ) {
					if( data[prop] is String ) {
						source = source.split("#{"+prop+"}").join(data[prop]);
					}else{
						var itemString:String = "";
						for each(var item:Object in data[prop] ) {
							itemString += objectToString(item);
						}
						source = source.split("#{"+prop+"}").join(itemString);
					}
				}
			}
			this.source = source;
		}
		
		public function objectToString(obj:Object):String
		{
			var result:String = "";
			if( obj is String || obj is int ) {
				result = String(obj);
			}else{
				result += "";
				for(var prop:String in obj ) {
					result += prop + ":" + objectToString(obj[prop]) + "\n";
				}
			}
			return result;
		}
		
		public function update( width:int, height:int ):void
		{
			//Log.info("update", width, height)
		}
		
		public function clear():void
		{
			
		}
		
		private function onResize(event:Event):void
		{
			clear();
			var w:int
			var h:int
			if( controller.container.parent == controller.container.root ){
				w = controller.container.stage.stageWidth;
				h = controller.container.stage.stageHeight;
			}else{
				w = controller.container.width;
				h = controller.container.height;
			}
			graphics.clear();
			graphics.beginFill( 0xDDDDDD, 1 );
			
			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();

			update( w, h );
		}
		
		
		/*
		public function updateDisplaylist( event:Event ):void
		{
			
		}
		*/
	}
}