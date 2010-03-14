package
{
	import flash.events.Event;
	import framework.config.Boot;
	import framework.helpers.HTMLHelper;
	import framework.tasks.LoadingTasks;
	import com.company.project.data.*;
	import com.company.project.context.*;
	
	public class Main extends Boot
	{
		override protected function setup():void
		{
			// Models store your applications data.
			data.add( Image ); 
			
			// The controller is like a trafic cops for the different parts of 
			// your app. Context classes define these different parts.
			controller.add( SiteContext, GameContext ); 
		
			// Routes map the places you can navigate to within your application.
			routes.add( "", { context:"site", method:"index" } ); // root route
			routes.add( "game/game",{context:"game", method:"game", content:""});
			routes.add( ":context/:method/:id" ); // default routes
			
			tasks.add( LoadingTasks );
		}

		override protected function start( event:Event=null ):void
		{
			var tags:Array = HTMLHelper.getImgTags( assets.fetch("feed") );
			for each( var tag:String in tags ) {
				new Image( { tag:tag } );
			}
			super.start();
		}
	}
}