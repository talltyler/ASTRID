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
package framework.helpers
{
	
import flash.events.TimerEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextField;
import flash.utils.Timer;
import framework.display.DisplayObjectBase;

public class CirclePreloader extends DisplayObjectBase
{
	private var timer:Timer;
	private var slices:int;
	private var radius:int;
	private var textfield:TextField;
	
	public function CirclePreloader(slices:int = 12, radius:int = 6)
	{
		super();
		this.slices = slices;
		this.radius = radius;
		draw();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function set percent( value:Number ):void
	{
		textfield.text = Math.round( value * 100 ) + "%";
	}
	
	private function onAddedToStage(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		timer = new Timer(65);
		timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		timer.start();
	}
	
	private function onRemovedFromStage(event:Event):void
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		timer.reset();
		timer.removeEventListener(TimerEvent.TIMER, onTimer);
		timer = null;
	}
	
	private function onTimer(event:TimerEvent):void 
	{
		rotation = (rotation + (360 / slices)) % 360;
	}
	
	private function draw():void
	{
		// preloader.x = stage.stageWidth/2;
		// preloader.y = stage.stageHeight/2;
		var i:int = slices;
		var degrees:int = 360 / slices;
		while (i--)
		{
			var slice:Shape = getSlice();
			slice.alpha = Math.max(0.2, 1 - (0.1 * i));
			var radianAngle:Number = (degrees * i) * Math.PI / 180;
			slice.rotation = -degrees * i;
			slice.x = Math.sin(radianAngle) * radius;
			slice.y = Math.cos(radianAngle) * radius;
			addChild(slice);
		}
		textfield = new TextField();
        addChild( textfield );
        textfield.htmlText = "<font face='Arial'> ";
	}
	
	private function getSlice():Shape
	{
		var slice:Shape = new Shape();
		slice.graphics.beginFill(0x666666);
		slice.graphics.drawRoundRect(-1, 0, 2, 6, 12, 12);
		slice.graphics.endFill();
		return slice;
	}
}
}