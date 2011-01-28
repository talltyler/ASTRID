package com.company.project.context
{
	import framework.controller.ContextBase;
	import framework.helpers.Paginator;
	import framework.view.MiniHTMLRenderer;
	import framework.view.HTMLRenderer;
	
	import com.company.project.data.Image;
	
	public class SiteContext extends ContextBase
	{
		public function index( params:Object ):void
		{
			template = "basic-template";
			data.title = "Hello World!";
			data.images = new Paginator( Image.data.all(), params.page||1, params.per||6 );
			render( MiniHTMLRenderer );
		}
		
		public function test( params:Object ):void
		{
			template = "default-template";
			data.title = "Hello World!";
			data.images = new Paginator( Image.data.all(), params.page||1, params.per||6 );
			render( HTMLRenderer );
		}
		
		public function contact( params:Object ):void
		{
			template = "default-template";
			data.title = "Contact";
			data.name = "Tyler";
			render( HTMLRenderer );
		}
		
		public function send_email( params:Object ):void
		{
			trace("send_email", params)
		}
	}
}

