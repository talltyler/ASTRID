package framework.components
{
import flash.events.Event;
import flash.text.TextField;
import flash.filters.BitmapFilter;
import flash.text.TextFormat;
import flash.filters.DropShadowFilter;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import framework.display.Base;
import framework.display.Position;
import framework.display.ElementBase;
import framework.view.html.Document;
import framework.view.html.Element;
import framework.view.html.Form;
import flash.events.KeyboardEvent;

public class Button extends ElementBase
{	
	public var form:Form;
	private var _format:TextFormat = new TextFormat();
	private var _filter:BitmapFilter;
	private var _textFild:TextField;
	private var _document:Document;

	public function Button( document:Document=null, target:Element=null, xml:XML=null )
	{	
		super( document.window.css.getElementStyles( xml, target ).style );
		_document = document;
	}

	public function get label():String
	{ 
		return _textFild.text; 
	}

	public function set label( value:String ):void
	{
		if( _textFild == null ) {
			init();
		}
		if( value !== _textFild.text ) {
			_textFild.text = value;
			redraw();
		}
	}
	
	override protected function init():void
	{
		if( _textFild == null ) {
			_textFild = new TextField();
			addChild( _textFild );
		}
		
		_format.font = computedStyles.fontFamily||"Arial";
		
		if( computedStyles.kerning == true ) {
			_format.kerning = true;
		} 
		if( computedStyles.lineHeight ) {
			_format.leading = computedStyles.lineHeight;
		}
		if( computedStyles.letterSpacing ) {
			_format.letterSpacing = computedStyles.letterSpacing;
		}
		if( computedStyles.color ) {
			_format.color = Number("0x"+computedStyles.color.split("#").join(""));
		}
		if( computedStyles.fontSize) {
			_format.size = computedStyles.fontSize;
		}
		if( computedStyles.embedFonts ) {
			_textFild.embedFonts = computedStyles.embedFonts;
		}
		
		focusRect = false;
		mouseChildren = false;
		buttonMode = true;
		_format.align = "center";
		_textFild.autoSize = "left";
		_textFild.selectable = false;
		_textFild.defaultTextFormat = _format;
		
		_filter = new DropShadowFilter(2,45,computedStyles.focusColor||0x00FF00,0.5);
		
		_textFild.addEventListener(FocusEvent.FOCUS_IN, onFocus);
		_textFild.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
		addEventListener(FocusEvent.FOCUS_IN, onFocus);
		addEventListener(FocusEvent.FOCUS_OUT, onBlur);
		addEventListener(MouseEvent.MOUSE_OVER, onOver);
		addEventListener(MouseEvent.MOUSE_OUT, onOut);
		
		super.init();
	}
	
	override public function draw( style:Object ):void
	{
		
		if( _textFild == null ) {
			init()
		}
		
		if( style.size && style.width == null ) {
			style.width = style.size * 11;
		}
		
		style.width = _textFild.width + 6;
		style.height = _textFild.height + 4;
		_textFild.x = 2;
		_textFild.y = 2;
		
		style.margin = { top:5, right:0, bottom:0, left:5 };
		style.border = { top:1, right:1, bottom:1, left:1 };
		style.border.color = style.border.color||0;
		style.border.alpha = 0.4;
		style.background.type = "solid";
		style.background.color = 0xFFFFFF; 
		style.background.alpha = 0.5;
		style.border.shape = "RoundRect";
		style.border.radius = 5;
		filters = [];
		
		super.draw( style );
	}
	
	private function onFocus(event:Event):void
	{
		dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OVER, true, false ) );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}
	
	private function onBlur(event:Event):void
	{
		dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OUT, true, false ) );
		removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}
	
	private function onOver(event:Event):void
	{
		if( _textFild.text == computedStyles.placeholder ) {
			_textFild.text = "";
		}else if( _textFild.text == "" ){
			_textFild.text = computedStyles.placeholder||"";
		}
		filters = [_filter];
		_document.selectedForm = form;
	}
	
	private function onOut(event:Event):void
	{
		filters = [];
	}
	
	private function onKeyDown(event:KeyboardEvent):void
	{
		if( event.keyCode == 13 ) {
			dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, false ) );
		}
	}
}

}