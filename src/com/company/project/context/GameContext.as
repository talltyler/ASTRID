package com.company.project.context
{
	import framework.controller.ContextBase;
	import com.company.project.renderers.GameRenderer;
	
	public class GameContext extends ContextBase
	{		
		public function game( params:Object ):void
		{
			render( GameRenderer );
		}
	}
}