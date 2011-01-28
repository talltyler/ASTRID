package framework.components
{
import flash.events.Event;
import flash.text.TextField;
import flash.filters.BitmapFilter;
import flash.text.TextFormat;
import flash.filters.DropShadowFilter;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.display.Sprite;

import framework.display.Base;
import framework.display.Position;
import framework.display.ElementBase;
import framework.view.html.Document;
import framework.view.html.Element;
import framework.view.html.Form;

public class Stepper extends TextInput
{	
	private var _up:Sprite;
	private var _down:Sprite;
	private var _size:int = 0;
	
	public function Stepper( document:Document=null, target:Element=null, xml:XML=null )
	{	
		super( document, target, xml );
		_up = new Sprite();
		_down = new Sprite();
	}
	
	override public function draw( style:Object ):void
	{
		if( _size == 0 ) {
			_size = style.width = style.width - 17;
		}else{
			style.width = _size;
		}
		
		super.draw( style );
		
		_up.graphics.clear();
		_up.graphics.beginFill(0,0.4);
		_up.graphics.drawRoundRectComplex(0,0,17,height/2-1,0,5,0,0);
		_up.graphics.beginFill(0xFFFFFF,0.5);
		_up.graphics.drawRoundRectComplex(1,1,15,height/2-2,0,5,0,0);
		_up.graphics.beginFill(0,0.5);
		_up.graphics.moveTo(3,8);
		_up.graphics.lineTo(8,4);
		_up.graphics.lineTo(13,8);
		_up.graphics.lineTo(3,8);
		_up.graphics.endFill();
		_up.x = style.width;
		_up.buttonMode = true;
		_up.focusRect = false;
		_up.tabEnabled = false;
		_up.addEventListener( MouseEvent.CLICK, onUp );
		appendChild( _up );
		
		_down.graphics.clear();
		_down.graphics.beginFill(0,0.4);
		_down.graphics.drawRoundRectComplex(0,0,17,height/2-1,0,0,0,5);
		_down.graphics.beginFill(0xFFFFFF,0.5);
		_down.graphics.drawRoundRectComplex(1,1,15,height/2-3,0,0,0,5);
		_down.graphics.beginFill(0,0.5);
		_down.graphics.moveTo(3,3);
		_down.graphics.lineTo(8,7);
		_down.graphics.lineTo(13,3);
		_down.graphics.lineTo(3,3);
		_down.graphics.endFill();
		_down.x = style.width;
		_down.y = height/2 - 1;
		_down.buttonMode = true;
		_down.focusRect = false;
		_down.tabEnabled = false;
		_down.addEventListener( MouseEvent.CLICK, onDown );
		appendChild( _down );
		
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}
	
	override protected function onKeyDown(event:KeyboardEvent):void
	{
		super.onKeyDown( event );
		if( event.keyCode == 38 ) {
			onUp();
		}
		if( event.keyCode == 40 ) {
			onDown();
		}
	}
	
	private function onUp(event:Event=null):void
	{
		textField.text = String( parseFloat( textField.text ) + 1 );
	}
	
	private function onDown(event:Event=null):void
	{
		textField.text = String( parseFloat( textField.text ) - 1 );
	}
}

}