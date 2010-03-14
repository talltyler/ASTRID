package framework.helpers
{
	import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
/**
 * Found this free API addthis.com that inables you to post links to any social networking site.
 * See http://www.addthis.com/help/sharing-api for additional information
 * it defaults to my account right now, please make your own account.
 */
public class SocialNetworkingHelper
{
	public var username:String = "talltyler";
	private var _site:String;
	private static const ENDPOINT:String = "http://api.addthis.com/oexchange/0.8/forward";
    private static const DEFAULT_OPTIONS:Object = { title: '', description: '' };
	
	public function SocialNetworkingHelper()
	{
		super();
	}
	
	public function share( url:String, destination:String="", options:Object=null ):void
	{
		options ||= {};
        var params:URLVariables = new URLVariables();
        
        for( var k:String in DEFAULT_OPTIONS) {
            if ( DEFAULT_OPTIONS[k] || options[k] ){
                params[k] = options[k] || DEFAULT_OPTIONS[k];
        	}	
		}
		
        params.url = url;
        
        if( destination == "facebook" ) {
        	params.rel = "canonical";
		}
        if( username ) {
			params.username = username;
		}

        var request:URLRequest = new URLRequest( ENDPOINT + (destination ? '/' + destination : '')  + '/offer?url=' + params.url );
        
        navigateToURL( request, '_blank' );
	}
	
}

}