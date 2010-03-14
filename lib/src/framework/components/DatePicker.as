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
import flash.geom.Point;
import flash.display.Shape;

public class DatePicker extends TextInput
{	
	private const months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	private const days:Array = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
	private const daysInMonth:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	
	private var _calendar:Sprite;
	private var _currentDate:Date;
	private var _currentMonth:int;
	private var _currentYear:String;
	
	public function DatePicker( document:Document=null, target:Element=null, xml:XML=null )
	{	
		super( document, target, xml );
	}
	
	/*
	override public function draw( style:Object ):void
	{
		super.draw( style );
		
		//addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}*/
	
	override protected function onFocus(event:Event):void
	{
		super.onFocus( event );
		if( _calendar && _calendar.parent ) {
			return // If open, don't make another calendar.
		}
		if( textField.text == "" ) {
			_currentDate = new Date();
		}else{
			var parts:Array = textField.text.split("-").join(" ").split(" ");
			var year:int;
			var month:int;
			var day:int;
			for each( var part:String in parts ) {
				if( part.search( /\d+/ ) == 0 ) { // is number
					if( part.length == 4 ) {
						year = parseInt( part );
					}else{
						day = parseInt( part );
					}
				}else{
					var monthIndex:int = months.indexOf( part );
					if( monthIndex != -1 ) {
						month = monthIndex;
					}
				}
			}
			_currentDate = new Date( year, month, day );
		}
		_calendar = drawCalendar( _currentDate );
		var local:Point = this.localToGlobal(new Point(this.root.x, this.root.y));
		_calendar.x = local.x;
		_calendar.y = local.y + computedStyles.height;
		Sprite(this.root).addChild( _calendar );
	}
	
	override protected function onBlur(event:Event):void
	{
		super.onBlur( event );
	}
	
	private function drawCalendar( date:Date ):Sprite
	{
		var margin:int = 2;
		var width:int = computedStyles.width;
		var height:int = 160;
		var dayWidth:int = ( ( width ) / 7 ) - margin;
		var dayHeight:int = ( ( height - 30 ) / 6 ) - margin;
		var firstDay:int = getFirstDay( date );
		var currentX:int = ( firstDay + 1 )* ( dayWidth + margin ) + margin;
		var currentY:int = 30;
		var color:uint;
		var num:int = 1;
		var today:Date = new Date();
		
		var calendar:Sprite = new Sprite();
		calendar.graphics.beginFill( 0xAAAAAA, 1 );
		calendar.graphics.drawRoundRect( 0, 0, width, height, 5 );
		var monthName:TextField = new TextField();
		_currentDate = date;
		_currentMonth = date.month;
		_currentYear = date.fullYear.toString();
		monthName.htmlText = "<font face='Arial' size='12'><b>" + months[_currentMonth] + " " + _currentYear + "</b>";
		calendar.addChild( monthName );
		
		var count:int = 0;
		for each( var dayName:String in days ) {
			var dName:Sprite = new Sprite();
			dName.graphics.beginFill( 0xFFFFFF, 0.3 );
			dName.graphics.drawRect( 0, 0, dayWidth, 12 );
			dName.x = ((dayWidth+margin)*count)+margin;
			dName.y = 16;
			var t:TextField = new TextField();
			t.width = dayWidth;
			t.y = -1;
			t.htmlText = "<p align='center'><font face='Arial' size='10'>"+dayName+"</font></p>"
			dName.addChild(t);
			calendar.addChild( dName );
			count++;
		}
		
		for( var i:int = firstDay; i < getDaysInMonth( date ) + firstDay; i++ ) {
			if( today.fullYear == date.fullYear && today.month == date.month && today.date == num ) {
				color = 0xCCFFCC;
			}else{
				color = 0xFFFFFF;
			}
			var day:Sprite = drawDay( num, dayWidth, dayHeight, color );
			if( ( i + 1 ) % 7 == 0 ) {
				currentX = margin;
				currentY += dayHeight + margin;
			}
			day.x = currentX;
			day.y = currentY;
			calendar.addChild( day );
			day.addEventListener( MouseEvent.MOUSE_OVER, onOverDay );
			day.addEventListener( MouseEvent.MOUSE_OUT, onOutDay );
			day.addEventListener( MouseEvent.CLICK, onClickDay );
			currentX += dayWidth + margin;
			num++;
		}
		
		var prev:Sprite = new Sprite();
		prev.graphics.beginFill( 0x777777, 0.8 );
		prev.graphics.drawRoundRect( 0, 0, 20, 14, 5 );
		prev.graphics.beginFill( 0xFFFFFF, 0.6 );
		prev.graphics.drawRoundRect( 1, 1, 18, 12, 5 );
		prev.graphics.beginFill( 0, 0.6 );
		prev.graphics.moveTo( 14, 4 );
		prev.graphics.lineTo( 7, 7 );
		prev.graphics.lineTo( 14, 10 );
		prev.graphics.endFill();
		prev.x = calendar.width - 44;
		prev.addEventListener( MouseEvent.CLICK, onClickPrev );
		calendar.addChild(prev);
		
		var next:Sprite = new Sprite();
		next.graphics.beginFill( 0x777777, 0.8 );
		next.graphics.drawRoundRect( 0, 0, 20, 14, 5 );
		next.graphics.beginFill( 0xFFFFFF, 0.6 );
		next.graphics.drawRoundRect( 1, 1, 18, 12, 5 );
		next.graphics.beginFill( 0, 0.6 );
		next.graphics.moveTo( 7, 4 );
		next.graphics.lineTo( 14, 7 );
		next.graphics.lineTo( 7, 10 );
		next.graphics.endFill();
		next.x = calendar.width - 22;
		next.addEventListener( MouseEvent.CLICK, onClickNext );
		calendar.addChild(next);
		
		return calendar;
	}
	
	/*
	override protected function onKeyDown(event:KeyboardEvent):void
	{
		super.onKeyDown( event );
		if( event.keyCode == 38 ) {
			onUp();
		}
		if( event.keyCode == 40 ) {
			onDown();
		}
	}*/
	
	private function onClickPrev( event:Event ):void
	{
		closeCalendar();
		_currentDate.setMonth( _currentDate.month - 1 );
		_calendar = drawCalendar( _currentDate );
		var local:Point = this.localToGlobal(new Point(this.root.x, this.root.y));
		_calendar.x = local.x;
		_calendar.y = local.y + computedStyles.height;
		Sprite(this.root).addChild( _calendar );
	}
	
	private function onClickNext( event:Event ):void
	{
		closeCalendar();
		_currentDate.setMonth( _currentDate.month + 1 );
		_calendar = drawCalendar( _currentDate );
		var local:Point = this.localToGlobal(new Point(this.root.x, this.root.y));
		_calendar.x = local.x;
		_calendar.y = local.y + computedStyles.height;
		Sprite(this.root).addChild( _calendar );
	}
	
	private function onClickDay( event:Event ):void
	{
		var t:TextField = event.target.getChildAt(0);
		textField.text = months[_currentMonth] + " " + t.text +", "+ _currentYear;
		closeCalendar();
	}
	
	private function onOverDay( event:Event ):void
	{
		event.target.alpha = 0.5;
		// var t:TextField = event.target.getChildAt(0);
		// textField.text = months[_currentMonth] + " " + t.text +", "+ _currentYear;
	}
	
	private function onOutDay( event:Event ):void
	{
		event.target.alpha = 1;
	}
	
	private function closeCalendar():void
	{
		var i:int = _calendar.numChildren;
		while( i-- ){ 
			_calendar.removeChildAt( i ); 
		}
		_calendar.parent.removeChild( _calendar );
	}
	
	private function drawDay( num:int, width:int, height:int, color:uint ) : Sprite 
	{
		var day:Sprite = new Sprite();
		day.graphics.beginFill( color, 0.5 );
		day.graphics.drawRect( 0, 0, width, height );
		day.mouseChildren = false;
		var t:TextField = new TextField();
		t.width = width;
		t.htmlText = "<p align='center'><font face='Arial'>"+num+"</font></p>"
		day.addChild(t);
		return day;
	}
	
	private function getFirstDay( date:Date ):uint
	{
		date.setDate(1);
		return date.getDay();
	}
	
	private function getDaysInMonth( date:Date ):uint 
	{
		var result:uint = ( date.month == 1 && isLeapYear( date ) ) ? 1 : 0; 
		return result += daysInMonth[date.month];
	}
	
	private function isLeapYear( date:Date ):Boolean 
	{
		return (date.fullYear % 4 == 0) ? true : false;
	}

}

}