package com.company.project
{
	import flash.events.Event;
	import framework.config.Boot;
	import framework.config.Preloader;
	import com.paperlesspost.create.data.*;
	import com.paperlesspost.create.context.*;
	
	public class App extends Boot
	{
		override protected function setup( event:Event ):void
		{
			data.add( Content, Products ); 
			controller.add( SiteContext ); 
			routes.add( "", { context:"site" } ); // root route
			routes.add( ":context/:method/:id" ); // default routes
		}

		override protected function ready( event:Event ):void
		{
			dispatchEvent( new Event(Preloader.REMOVE_PRELOADER, true) );
			start();
		}
	}
}