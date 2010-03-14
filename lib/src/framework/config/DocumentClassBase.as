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
package framework.config
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import framework.utils.ClassUtils;
	

	public class DocumentClassBase extends MovieClip
	{
		public var top:Sprite;
		public var bottom:Sprite;
		
		public var preloader:PreloaderBase;
		
		protected var packageName:String = "Main";
	
		private var _firstFrame : Boolean = true;
	
		public function DocumentClassBase( preloaderClass:Class=null )
		{
			super();
			
			bottom = new Sprite();
			bottom.name = "ROOT";
			addChild( bottom );
			
			if( preloaderClass != null ) {
				top = new Sprite();
				addChild( top );
				
				preloader = new preloaderClass();
				top.addChild( preloader );	
			}

			addEventListener( Event.ENTER_FRAME, checkFrame );
		}
	
		private function checkFrame(event:Event):void
		{
			if( currentFrame == totalFrames ) {
				removeEventListener( Event.ENTER_FRAME, checkFrame );
				init();
				return;
			}
		
			if( _firstFrame ) {
				init();
				_firstFrame = false;
				if( preloader != null ) {
					preloader.add( this );
				}
				return;
			}
			
			if( preloader != null ) {
				preloader.update( this, root.loaderInfo.bytesLoaded, root.loaderInfo.bytesTotal );
			}
		}
	
		private function init():void
		{
			stop();
			
			/* if( !_firstFrame && preloader != null ) {
				preloader.destroy();
			} */
			
			var main:* = ClassUtils.getInstance( packageName );
			if( preloader != null ){
				main.preloader = preloader;
			}
			bottom.addChild( main as DisplayObject );
		}
	}	
}