/*                                   ,----,                                 
 *                                 ,/   .`|                                 
 *      ,---,       .--.--.      ,`   .'  :,-.----.      ,---,    ,---,     
 *     '  .' \     /  /    '.  ;    ;     /\    /  \  ,`--.' |  .'  .' `\   
 *    /  ;    '.  |  :  /`. /.'___,/    ,' ;   :    \ |   :  :,---.'     \  
 *   :  :       \ ;  |  |--` |    :     |  |   | .\ : :   |  '|   |  .`\  | 
 *   :  |   /\   \|  :  ;_   ;    |.';  ;  .   : |: | |   :  |:   : |  '  | 
 *   |  :  ' ;.   :\  \    `.`----'  |  |  |   |  \ : '   '  ;|   ' '  ;  : 
 *   |  |  ;/  \   \`----.   \   '   :  ;  |   : .  / |   |  |'   | ;  .  | 
 *   '  :  | \  \ ,'__ \  \  |   |   |  '  ;   | |  \ '   :  ;|   | :  |  ' 
 *   |  |  '  '--' /  /`--'  /   '   :  |  |   | ;\  \|   |  ''   : | /  ;  
 *   |  :  :      '--'.     /    ;   |.'   :   ' | \.''   :  ||   | '` ,/   
 *   |  | ,'        `--'---'     '---'     :   : :-'  ;   |.' ;   :  .'     
 *   `--''                                 |   |.'    '---'   |   ,.' Tyler      
 * ActionScript tested rapid iterative dev `---' Copyright2010'---'  Larson
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * http://www.gnu.org/licenses
 */
package framework.view.html 
{
	import flash.external.ExternalInterface;
	import framework.cache.Cache;
	import framework.net.Assets;
	import framework.display.Base;
	
	public class Document extends Base
	{
		public var anchors:Array = [ {name:"name", offsetLeft:0, offsetParent:"parent", offsetTop:0, x:0, y:0} ];
		public var cookie:Object = {};
		public var images:Array = [{border:false, complete:true, width:0, height:0, lowsrc:"", name:"", src:""}];
		public var embeds:Array = [{ name:"", width:0, height:0, hidden:false, pluginspage:"", src:"", type:"", units:"" }];
		public var forms:Array = [];
		public var layers:Array = [];
		public var links:Array = [{hash:"", host:"", hostname:"", href:"", innerText:"", offsetLeft:0, offsetParent:0, offsetTop:0, pathname:"", port:0, protocol:"", search:"", target:"", text:"", x:0, y:0 }];
		public var styleSheets:Array = []
		public var lastModified:Date;
		public var parser:Parser;
		public var referrer:String;
		public var window:Window;
		public var cache:Cache;
		public var assets:Assets;
		
		// 
		public var selectedForm:Form;
		
		private var _documentElement:Node;
		private var _fgColor:Object;
		private var _title:String;
		
		public function get documentElement():Object
		{ 
			return _documentElement; 
		}
		
		public function get domain():String
		{ 
			return window.location.toString(); 
		}
		
		public function get fgColor():Object
		{ 
			return _fgColor; 
		}

		public function set fgColor(value:Object):void
		{
			if (value !== _fgColor)
			{
				_fgColor = value;
				window.location.refresh()
			}
		}
		
		public function get title():String
		{ 
			return _title; 
		}

		public function set title(value:String):void
		{
			if (value !== _title)
			{
				_title = value;
				ExternalInterface.call("document.title="+_title)
			}
		}
		
		public function get url():Object
		{ 
			return window.location.href; 
		}
		
		public function Document( window:Window )
		{
			this.window = window;
			parser = new Parser( window.navigator.tags );
			cache = new Cache( this );
			assets = new Assets( cache );
			//super( this, this, null);
			//style.background.alpha = 0.01;
			//style.width = "100%";
			//style.height = "100%";
			// draw( style );
			super()
			graphics.clear();
		}
		
		public function close():void
		{ 
			window.close()
		}
		
		public function getElementById( id:String ):Element
		{ 
			var result:Element
			return result
		}
		
		public function getElementsByClassName( id:String ):Element
		{ 
			var result:Element
			return result
		}
		
		public function getElementsByTagName( name:String ):void
		{
			
		}
		
		public function hasFeature( feature:String, domVersion:String=null ) : Boolean
		{
			return this.hasOwnProperty(feature)
		}
		
		//createDocumentFragment()
		
		public function createElement( name:String ) : Node
		{ 
			return null
		}
		/*
		public function createTextNode( name:String ) : TextNode
		{ 
			return null
		}
		*/
		public function write( content:String ):void
		{ 
			
		}
		
		public function writeln( content:String ):void
		{ 
			write( content )
		}
	}
}