package framework.components
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.filters.BitmapFilter;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import framework.display.Base;
	import framework.display.Position;
	import framework.display.ElementBase;
	import framework.view.html.Document;
	import framework.view.html.Element;
	import framework.view.html.Form;

	public class CheckBox extends ElementBase
	{	
		public var form:Form;
		private var _format:TextFormat = new TextFormat();
		private var _filter:BitmapFilter;
		private var _textFild:TextField;
		private var _document:Document;
		private var _value:Boolean;
		
		public function CheckBox( document:Document=null, target:Element=null, xml:XML=null )
		{	
			super( document.window.css.getElementStyles( xml, target ).style );
			_document = document;
		}
		
		public function get value():String
		{ 
			if( _value ) return "true";
			return "false";
		}
		
		public function get checked():Boolean
		{ 
			return _value; 
		}

		public function set checked( value:Boolean ):void
		{
			if( value !== _value ) {
				_value = value;
				redraw();
			}
		}
		
		override protected function init():void
		{
			focusRect = false;
			mouseChildren = false;
			buttonMode = true;
			
			_filter = new GlowFilter(computedStyles.focusColor||0x1283FF,0.8,4,4);

			addEventListener(FocusEvent.FOCUS_IN, onFocus);
			addEventListener(FocusEvent.FOCUS_OUT, onBlur);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
		
			super.init();
		}
	
		override public function draw( style:Object ):void
		{
			style.width = 12;
			style.height = 12;
			style.margin = { top:5, right:0, bottom:0, left:5 };
			style.border = { top:1, right:1, bottom:1, left:1 };
			style.border.color = style.border.color||0x777777;
			style.border.alpha = 0.4;
			style.background.type = "solid";
			style.background.color = 0xFFFFFF; 
			style.background.alpha = 0.5;
			style.border.shape = "RoundRect";
			style.border.radius = 5;
			filters = [];
		
			super.draw( style );
			
			if( _value == true ) {
				graphics.lineStyle(2,0,0.5);
				graphics.moveTo(4,5);
				graphics.lineTo(5,9);
				graphics.lineTo(9,4);
			}
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
			filters = [_filter];
			_document.selectedForm = form;
		}
	
		private function onOut(event:Event):void
		{
			filters = [];
		}
		
		private function onClick(event:Event):void
		{
			if( _value == true ) {
				checked = false;
			}else{
				checked = true;
			}
		}
	
		private function onKeyDown(event:KeyboardEvent):void
		{
			if( event.keyCode == 13 ) {
				dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, false ) );
			}
		}
	}
}