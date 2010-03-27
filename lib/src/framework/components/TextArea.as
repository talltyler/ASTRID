package framework.components
{
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.filters.BitmapFilter;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;

import framework.display.Base;
import framework.display.Position;
import framework.display.ElementBase;
import framework.view.html.Document;
import framework.view.html.Element;
import framework.view.html.Form;

public class TextArea extends ElementBase
{	
	public var form:Form;
	public var textField:TextField;
	private var _errors:Array = [];
	private var _format:TextFormat = new TextFormat();
	private var _filter:BitmapFilter;
	private var _document:Document;
	private var _placeholder:String;
	private var _pattern:String;
	private var _required:Boolean;
	private var _min:int = -1;
	private var _max:int = -1;
	private var _orgValue:String;
	private var _cols:Number = 30;
	private var _rows:Number = 6;
	private var _disabled:Boolean;
	private var _readonly:Boolean;
	
	public function TextArea( document:Document=null, target:Element=null, xml:XML=null )
	{	
		super( document.window.css.getElementStyles( xml, target ).style );
		_document = document;
	}
	
	public function get field():TextField
	{ 
		return textField;
	}
	
	public function get min():int
	{ 
		return _min; 
	}

	public function set min(value:int):void
	{
		if( value !== _min ) {
			_min = value;
		}
	}
	
	public function get max():int
	{ 
		return _max; 
	}

	public function set max(value:int):void
	{
		if( value !== _max ) {
			_max = value;
		}
	}
	
	public function get required():Boolean
	{ 
		return _required; 
	}

	public function set required(value:Boolean):void
	{
		if( value !== _required ) {
			_required = value;
		}
	}
	
	public function get pattern():String
	{ 
		return _pattern; 
	}

	public function set pattern(value:String):void
	{
		if (value !== _pattern) {
			_pattern = value;
		}
	}
	
	public function get errors():Array
	{ 
		return _errors;
	}

	public function get value():String
	{ 
		checkValue();
		return textField.text; 
	}

	public function set value(value:String):void
	{
		if( textField == null ) {
			init();
		}
		if( value !== textField.text ) {
			textField.text = value;
			_orgValue = value;
			redraw();
		}
	}
	
	public function get placeholder():String
	{ 
		return _placeholder; 
	}

	public function set placeholder(value:String):void
	{
		if (value !== _placeholder)
		{
			_placeholder = value;
			if( textField != null && (textField.text == "" || textField.text == "undefined") ) {
				textField.text = _placeholder;
				textField.alpha = 0.5;
			}
		}
	}
	
	public function get cols():Number
	{ 
		return _cols; 
	}

	public function set cols(value:Number):void
	{
		if (value !== _cols){
			_cols = value;
			draw(style);
		}
	}
	
	public function get rows():Number
	{ 
		return _rows; 
	}

	public function set rows(value:Number):void
	{
		if (value !== _rows){
			_rows = value;
			draw(style);
		}
	}
	
	public function get disabled():Boolean
	{ 
		return _disabled; 
	}

	public function set disabled(value:Boolean):void
	{
		if (value !== _disabled)
		{
			_disabled = value;
			if( _disabled ) {
				textField.type = "dynamic";
				textField.alpha = 0.7;
			}else{
				textField.type = "input";
				textField.alpha = 1;
			}
		}
	}

	public function get readonly():Boolean
	{ 
		return _readonly; 
	}

	public function set readonly(value:Boolean):void
	{
		if (value !== _readonly)
		{
			_readonly = value;
			if( _readonly ) {
				textField.type = "dynamic";
			}else{
				textField.type = "input";
			}
		}
	}
	
	public function get wrap():String
	{ 
		if( textField.wordWrap == true){
			return "hard";
		}else{
			return "soft"; 
		}
	}

	public function set wrap(value:String):void
	{
		if( value == "hard"){
			textField.wordWrap = true;
		}else{
			textField.wordWrap = false;
		}
	}
	
	override protected function init():void
	{
		if( textField == null ) {
			textField = new TextField();
			addChild( textField );
		}
		
		textField.type = "input";
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
		if( computedStyles.textAlign ) {
			_format.align = computedStyles.textAlign;
		}
		if( computedStyles.embedFonts ) {
			textField.embedFonts = computedStyles.embedFonts;
		}

		if(computedStyles.padding){ 
			_format.leftMargin = computedStyles.padding.left||3;
			_format.rightMargin = computedStyles.padding.right;
		}
		
		textField.defaultTextFormat = _format;
		
		if( (textField.text == "" || textField.text == "undefined") && _placeholder != null ) {
			textField.text = _placeholder;
			textField.alpha = 0.5;
		}
		
		textField.wordWrap = true; // default
		
		_filter = new GlowFilter(computedStyles.focusColor||0x1283FF,0.8,4,4);
		
		textField.addEventListener(FocusEvent.FOCUS_IN, onFocus);
		textField.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
		addEventListener(MouseEvent.CLICK, onOver);
		//addEventListener(MouseEvent.MOUSE_OUT, onOut);
		
		super.init();
	}
	
	override public function draw( style:Object ):void
	{
		if( textField == null ) {
			return
		}
		
		style.width = _cols * ( (style.fontSize||12) - 1 );
		style.height = _rows * ( (style.fontSize||12) + 5 );
		style.overflow = "scroll";
		
		textField.width = style.width - 18; // minus scroll size
		textField.multiline = true;
		textField.y = 3;
		textField.autoSize = "left";
		
		style.margin = { top:5, right:0, bottom:0, left:5 };
		
		style.border = { top:1, right:1, bottom:1, left:1 };
		if( _errors.length == 0 ) {
			style.border.color = style.border.color||0x777777;
		}else{
			style.border.color = style.border.color||0xCC0000;
		}
		style.background.type = "solid"
		style.background.color = 0xFFFFFF; 
		
		filters = [];
		
		super.draw( style );
	}
	
	public function reset():void
	{
		if( _orgValue && _orgValue != "undefined" ) {
			textField.text = _orgValue;
			textField.alpha = 1;
		}else if( _placeholder ) {
			textField.text = _placeholder;
			textField.alpha = 0.5;
		}else{
			textField.text = "";
			textField.alpha = 1;
		}
		_errors = [];
		redraw();
	}
	
	protected function onFocus(event:Event):void
	{
		if( textField.text == _placeholder ) {
			textField.text = "";
			textField.alpha = 1;
		}
		stage.focus = textField;
		textField.setSelection( textField.length, textField.length );
		// dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, false ) );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}
	
	protected function onBlur(event:Event):void
	{
		//dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OUT, true, false ) );
		if( (textField.text == "" || textField.text == "undefined") && _placeholder != null ){
			textField.text = _placeholder;
			textField.alpha = 0.5;
		}
		onOut( event );
		removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}
	
	private function onOver(event:Event):void
	{
		filters = [_filter];
		_document.selectedForm = form;
		// textField.addEventListener(FocusEvent.FOCUS_IN, onFocus);
		textField.dispatchEvent( new FocusEvent( FocusEvent.FOCUS_IN ) );
	}
	
	private function onOut(event:Event):void
	{
		filters = [];
		checkValue();
	}
	
	private function checkValue():void
	{
		if( _pattern ) {
			var regExp:RegExp = new RegExp( _pattern, "gim" );
			var result:Array = textField.text.match( regExp );
			if( result.length != 1 ) {
				_errors.push( { element:this, id:10, message:name + " does not match format." } );
			}else{
				deleteError(10);
			}
		}
		if( _required && (textField.text == "" || textField.text == _placeholder) ) {
			_errors.push( { element:this, id:11, message:name + " is required." } );
		}else{
			deleteError( 11 );
		}
		if( _min != -1 && textField.text.length <= _min ) {
			_errors.push( { element:this, id:12, message:name + " is less than min length." } );
		}else{
			deleteError( 12 );
		}
		if( _max != -1 && textField.text.length >= _max ) {
			_errors.push( { element:this, id:13, message:name + " is greater than max length." } );
		}else{
			deleteError( 13 );
		}
		if( _errors.length != 0 ) {
			dispatchEvent( new Event( "error", true, false ) );
		}
		redraw();
	}
	
	private function deleteError(index:int):void
	{
		var count:int=0;
		for each( var error:Object in _errors ) {
			if( error.id == index ) {
				_errors.splice(count,1);
			}
			count++
		}
	}
	
	protected function onKeyDown(event:KeyboardEvent):void
	{
		var bounds:Rectangle = textField.getBounds(this);
		scrollbar.setPosition(bounds.width, bounds.height);
	}
}

}