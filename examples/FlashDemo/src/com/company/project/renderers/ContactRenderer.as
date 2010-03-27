package com.company.project.renderers
{
	import framework.view.RendererBase;
	import framework.controller.Controller;
	import framework.view.html.Navigator;
	import framework.view.html.Window;
	import flash.text.TextField;

	public class ContactRenderer extends RendererBase
	{	
		public var menu_mc:Menu;
		public var thanks_txt:TextField;
		public var navigator:Navigator;
		public var window:Window;
		
		public function ContactRenderer( controller:Controller, width:int, height:int )
		{
			super( controller, width, height );
			navigator = new Navigator( controller );
			window = new Window( navigator, 350, 200 );
			thanks_txt.visible = false;
		}
		
		override public function render( source:String ):void
		{
			var form:String = 
			 '<div style="width:350; height:500;">'+
			 '	<form action="site/contact" method="post">'+
			 '		<input type="text" name="name" restrict="A-Z,a-z" maxlength="12" placeholder="Name">'+
			 '		<input type="email" name="email" placeholder="Email">'+
			 '		<input type="text" name="subject" placeholder="Subject" min="10">'+
			 '		<textarea name="message" placeholder="message"></textarea>'+
			 '		<input type="submit" label="Submit">'+
			 '	</form>'+
			 '</div>';

			window.render( form );
			window.x = 40;
			window.y = 130;
			// window.rotationY = 34; // Try a little 3d rotation!
			// window.rotationZ = -4;
			addChild( window );
		}
	}
}