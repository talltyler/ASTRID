package com.company.project.renderers
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import framework.controller.SWFAddress;

	public class Menu extends MovieClip
	{
		public var home_btn:SimpleButton;
		public var gallery_btn:SimpleButton;
		public var contact_btn:SimpleButton;
		
		public function Menu()
		{
			home_btn.addEventListener(MouseEvent.CLICK, onClickMenuItem);
			gallery_btn.addEventListener(MouseEvent.CLICK, onClickMenuItem);
			contact_btn.addEventListener(MouseEvent.CLICK, onClickMenuItem);
		}
	
		public function clear():void
		{
			home_btn.removeEventListener(MouseEvent.CLICK, onClickMenuItem);
			gallery_btn.removeEventListener(MouseEvent.CLICK, onClickMenuItem);
			contact_btn.removeEventListener(MouseEvent.CLICK, onClickMenuItem);
		}
	
		public function onClickMenuItem(event:Event):void
		{
			var pageName:String = event.target.name.split("_btn").join("");
			SWFAddress.setValue( "site/"+pageName );
		}
	}
}