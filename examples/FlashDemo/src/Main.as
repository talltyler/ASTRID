package
{
	import flash.events.Event;
	import framework.config.Boot;
	import com.company.project.data.*;
	import com.company.project.context.*;
	
	public class Main extends Boot
	{
		override protected function setup():void
		{	
			data.add( Image ); // Data stores your applications model objects.
			
			// The controller is like a trafic cops for the different parts of 
			// your app. Context classes define these different parts.
			controller.add( SiteContext );
		
			// Routes map the places you can navigate to within your application.
			routes.add( "", { context:"site", method:"home", content:"" } );// root route, if nothing is defined
			routes.add( ":context/:method/:id", {content:""} ); 			// default routes
			
			assets.add("assets/data/gallery.csv"); 							// load your image data
		}

		override protected function start( event:Event=null ):void
		{
			Image.data.parse( assets.fetch("assets/data/gallery.csv") ); 	// parse data into Image objects
			for each( var image:Image in Image.data.all() ) { 				// loop over all Image objects
				assets.add( image.url ); 									// add the images defined inside the url column
			} 
			assets.addEventListener(Event.COMPLETE, super.start ); 			// Start the application after everything loads
			assets.load(); 
		}
	}
}