package com.company.project.renderers
{
	import framework.view.RendererBase;
	import framework.controller.Controller;
	
	import com.company.project.renderers.Pong;
	
	public class GameRenderer extends RendererBase
	{	
		private var game:Pong;
		
		public function GameRenderer( controller:Controller, width:int, height:int )
		{
			super( controller, width, height );
		}
		
		override public function render( source:String ):void
		{
			game = new Pong( width, height );
			addChild( game );
		}
		override public function clear():void
		{
			game.clear();
		}
		override public function update( width:int, height:int ):void
		{
			game.resize( width, height );
		}
	}
}