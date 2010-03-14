package framework.controller
{
	import framework.controller.ContextBase;

	public class CRUDContextBase extends ContextBase
	{
		
		public function index( params:Object ):void
		{
			data.users = new Paginator( User.all(), params.page||1, params.per||3 );
			//// Log.debug(data.users[0].first, "data.users")
			/*
			for(var p:String in data.users.data[0] ) {
				// Log.debug(p, "p")
			}
			*/
			render(HTMLRenderer); 
		}
		
		public function show( params:Object ):void
		{
			data.user = User.findById( params.id );
			render(HTMLRenderer);
		}
	
		public function add( params:Object ):void
		{
			render(HTMLRenderer);
		}

		public function edit( params:Object ):void
		{
			data.user = User.findById( params.id );
			render(HTMLRenderer);
		}
	
		public function create( params:Object ):void
		{
			var user:User = new User( params );
			if( user.save() ){
				flashMessage = "User Saved!";
				controller.redirectTo( "users/" + params.id );
			}else{
				flashMessage += "There was errors while creating a new user.\r" // + Errors( user.errors ).toHTML();
				controller.redirectTo( "users/add", params );
			}
		}
	
		public function update( params:Object ):void
		{
			if( params.id ) {
				var user:User = User.findById( params.id );
				if( user != null && user.update( params ) ) {
					flashMessage = "User was updated.";
					controller.redirectTo( "users/show/" + params.id );
					return
				}
			}
			flashMessage += "User was not updated.\r" // + Errors( user.errors ).toHTML();
			controller.redirectTo( "users/edit/" + params.id, params );
		}
	
		public function clear( params:Object ):void
		{
			if( params.id ) {
				var user:User = User.findById( params.id );
				if( user != null ) {
					user.destroy();
					flashMessage = "User was deleted.";
					controller.redirectTo( "users" );
					return
				}
			}
			flashMessage = "User was not deleted.";
			controller.redirectTo( "users" );
		}	
	}
}