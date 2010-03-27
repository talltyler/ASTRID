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
package framework.view.miniHTML 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;
	import flash.text.StyleSheet;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	/**
	 *  A mini HTML and CSS parser
	 *    
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Tyler Larson
	 *  @since  24.10.2009
	 */
	public class MiniHTML extends Sprite
	{
		private var _parsedXML:XML;
		private var _styleSheet:StyleSheet;
		
		/**
		 *	@constructor
		 *	@param	width	 The width of the document
		 *	@param	height	 The height of the document
		 */
		public function MiniHTML( width:int, height:int )
		{
			super();
			
			update( width, height );
		}
		
		/**
		 *	A CSS Stylesheet can be set here and used to style your HTML nodes
		 *	@param	styles	 String of CSS styles
		 */
		public function set styleSheet( styles:String ) : void
		{
			_styleSheet = new StyleSheet();
			_styleSheet.parseCSS( styles );
		}
		
		/**
		 *	Set the HTML for your document with innerHTML.
		 *	To keep this library simple you must structure your HTML string to be valid XML.
		 *	Your HTML will be parsed as soon as you have set this property.
		 *	@param	html	 String of HTML to be parsed
		 */
		public function set innerHTML( html:String ) : void
		{
			_parsedXML = XML( html.replace(/<img([^>]*)\s*>/gi,'<img$1 />') );
			parse( this, _parsedXML );
		}
		
		/**
		 *	To get a instance of an Element you can pass in the id of that node.
		 *	An Element is a subclass of Sprite, you can add events to them or change any of there properties.
		 *	Note: If you call update the instance that you had will be deleted and a new one created.
		 *	@param	name	 The ID of a node that you are looking for as a String
		 *	@return		Returns the instance of the Element with the name passed in or Null
		 */
		public function getElementById( name:String ) : Element
		{
			var result:DisplayObject;
			function loop( target:DisplayObjectContainer, id:String ) : void {
				for(var i:uint=0; i < target.numChildren; i++) {
					if( target.getChildAt(i) is DisplayObjectContainer ) {
						if( DisplayObjectContainer(target.getChildAt(i)).getChildByName( id ) ) {
							result = DisplayObjectContainer(target.getChildAt(i)).getChildByName( id ); 
							break;
						}else{
							loop( target.getChildAt(i) as DisplayObjectContainer, id );
						}
			        }
			    }
			}
			
			if( getChildByName( name ) ) {
				result = getChildByName( name );
			}else{
				loop( this, name );
			}
				
			return result as Element;
		}
		
		/**
		 *	To update the size of your document you can call this method,
		 *	this is useful when resizing your browser window
		 *	This method will recreate the document from scratch
		 *	Note: Make sure to recreate any listeners that you need after this has been called
		 *	@param	width	 An intager of the width of your document
		 *	@param	height	 An intager of the height of your document
		 */
		public function update( width:int, height:int ) : void
		{
			clear();
			graphics.clear();
			graphics.beginFill( 0xFFFFFF, 1 );
			graphics.drawRect( 0, 0, width, height );
			if( _parsedXML != null ) {
				parse( this, _parsedXML );
			}
		}
		
		/**
		 *	This method parses XML and renders the contents of the node's children
		 *	It is a recursive method that loops over all of the children of the given XML
		 *	Each node calls a method with the same name as the node, if the node cannot be found
		 *	the or the node is not an element, the node is assumed to be text or character data.
		 *	If you would like to create other nodes you might want to put these rendering 
		 *	methods in another class for clarity. All rendering methods must accept the same arguments.
		 *	@param	target	 The DisplayObjectContiner that the node is going to be drawn into
		 *	@param	node	 A XML node that contains children to be rendered
		 */
		private function parse( target:DisplayObjectContainer, node:XML ) : void 
		{
			for each ( var xml:XML in node.children() ) {
				var name:String = String(xml.name());
				if( xml.nodeKind() == "element" && hasOwnProperty( name ) ) {
					var result:Object = this[ name ]( target, xml );
					if( result != null ) { 
						if( result is DisplayObjectContainer ){
							parse( result as DisplayObjectContainer, xml );
							target.addChild( result as DisplayObjectContainer );
						}else{
							parse( target, xml );
						}
					}
				}else{
					target.addChild( cdata( target, xml ) );
				}
			}
		}
		
		/**
		 *	A div tag is sent to this method to be rendered. A basic Element is created and
		 *	all of the attributes from the node are combined with the styles from the style sheet
		 *	to style and then render this element. After the Element is added to the display list 
		 *	the element is positioned based on its styles. Only the most basic properties can be 
		 *	used within the style sheet to style these elements.
		 *	@param	target	 The DisplayObjectContainer that the created Element will be added to.
		 *	@param	xml	 	The XML node that this Element will be rendered from
		 *	@return		Returns the DisplayObjectContainer that was created 
		 */
		public function div( target:DisplayObjectContainer, xml:XML ) : DisplayObjectContainer
		{
			var result:Element = new Element();
			getStyle( result, xml, target.width, target.height );
			result.graphics.beginFill( result.style.background, 1 );
			result.graphics.drawRect( 0, 0, result.style.width, result.style.height );
			return result;
		}
		
		/**
		 *	A text node or unknown tag is sent to this method to be rendered. A Text node is just
		 *	a extened TextField, anything that can be set inside of a ActionScript TextField object
		 *	can be defined in your CSS style sheet to modify this object. The width and height 
		 *	are base of of the parent.
		 *	@param	target	 The DisplayObjectContainer that the created Element will be added to.
		 *	@param	xml	 	The XML node that this Element will be rendered from
		 *	@return		Returns the DisplayObjectContainer that was created 
		 */
		public function cdata( target:DisplayObjectContainer, xml:XML ) : Text
		{
			var result:Text = new Text();
			result.width = target.width;
			result.multiline = true;
			result.wordWrap = true;
			result.autoSize = "left";
			result.styleSheet = _styleSheet;
			result.htmlText = xml.toXMLString();
			return result;
		}
		
		/**
		 *	Other html tag examples:
		 *	Many other tags would be very simple to add to this, here are a few examples.
		 *	Title is able to simply change the title of you HTML window and img can load images
		 *	Technically loading images of any kind including pngs or loading swfs is the same
		 *	but in HTML they also have embed and object tags for this functionality. 
		 *	You might also want to add something to cache the loaded images or something to scale 
		 *	the image after it is loaded. Other tags like span, li and even the new HTML 5 tags like 
		 *	video and audio would be very easy to add here but there are many different ways this 
		 *	could be created and I wanted to keep this class simple. But feel free to try it out yourself.
		 */
		/* 
		public function title( target:DisplayObjectContainer, xml:XML ) : void
		{
			ExternalInterface.call( "document.title=" + xml.text() );
		}
		
		public function img( target:DisplayObjectContainer, xml:XML ) : DisplayObjectContainer
		{
			var result:Element = new Element();
			getStyle( result, xml, target.width, target.height );
			result.graphics.beginFill( result.style.background, 0 );
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaded );
			loader.load( new URLRequest( xml.@src.toString() ) );
			function onLoaded( event:Event ):void {
				result.addChild( loader );
				result.graphics.drawRect( 0, 0, loader.width, loader.height );
			}
			return result;
		}
		*/
		
		/**
		 *	This method retrives all of the classes, id and node styles that might be defined in the 
		 *	style sheet and also anything else that might be defined on the node itself and combines
		 *	all of the styles together in the right order and assigns the style object to the target.
		 *	It can handle basic cleaning of properties from colors to percentages and booleans or strings.
		 *	It can't handle ems,pt or other point sizes, it only handles pixels.
		 *	@param	target	 The scope that the styles are going to be applied to.
		 *	@param	xml	 The XML object that the styles are defined
		 *	@param	parentWidth	 The size of the parent element.
		 *	@param	parentHeight	 The size of the parent element.
		 */
		private function getStyle( target:Object, xml:XML, parentWidth:Number, parentHeight:Number ) : void
		{
			var style:Object;
			
			if( _styleSheet != null ) {
				
				style = _styleSheet.getStyle( xml.name() )||{};
				
				var classes:String = xml.@["class"].toString();
				if( classes ){
					for each( var c:String in classes.split(" ") ){
						style = mergeObj( style, _styleSheet.getStyle( "."+c ) );
					}
				}
				
				style = style||{};
				
				target.name = xml.@id.toString();
				style = mergeObj( style, _styleSheet.getStyle( "#"+target.name ) );
			}

			style = style||{};
			
			for each( var att:XML in xml.@* ) {
				style[ String(att.name()) ] = att.toXMLString();
			}
			
			for( var prop:String in style ) {
				if( prop == "width" ) {
					style.width = cleanString( style.width||"100%", parentWidth );
				}else if( prop == "height" ){
					style.height = cleanString( style.height||"100%", parentHeight );
				}else if( prop == "background" ){
					style.background = cleanString( style.background );
				}else{
					target[prop] = cleanString( style[prop] );
				}
			}
			
			if( style.width == null ) {
				style.width = parentWidth;
			}
			
			if( style.height == null ) {
				style.height = 0;
			}
			
			style.y = style.y||0;
				
			target.style = style;
		}
		
		/**
		 *	This method takes in a String value and converts it to the type that it should be.
		 *	Can handle with hex numbers, percentages, numbers, booleans, and strings.
		 *	@param	vaalue	 A String version of a value to be cleaned
		 *	@param	parentSize	 The size of your parent, this is to figure percentages
		 *	@return		Returns a untypes version of the the cleaned value
		 */
		private function cleanString( value:String, parentSize:int=0 ) : *
		{
			if( value.substr( 0, 1 ) == "#" ){     // || value.substr( 0, 2 ) == "0x"
				value = value.split("#").join(""); // .split("0x").join("");
				if( value.length == 3 ) {
					var result:String = "";
					for(var i:int=0;i<3;i++){
						result += value.charAt(i)+value.charAt(i);
					}
					value = result;
				}
				return parseInt(value, 16);
			}else if( value.search( /\d+/ ) == 0 && value.indexOf("%") == -1 ){
				return parseFloat( value );
			}else if( value.search( /\d+/ ) == 0 && value.indexOf("%") > -1 ){
				return parentSize * ( parseFloat( value ) * 0.01 );
			}else if( value == "true" ){
				return true;
			}else if( value == "false" ){
				return false;
			}
			return value;
		}
		
		/**
		 *	Takes to Objects and combines them together, the newer properties have precedence.
		 *	@param	obj1	 The target object
		 *	@param	obj2	 The object to be merged
		 *	@return		Returns the second object merged into the first object
		 */
		private function mergeObj( obj1:Object, obj2:Object ):Object
		{
			for( var prop:String in obj2 ) { 
				obj1[prop] = obj2[prop];
			}
			return obj1;
		}
		
		/**
		 *	If you want to clear everything visual from the document this is the method to do it.
		 *	You will still have references to the html and stylesheet data.
		 */
		private function clear() : void
		{
			var i:int = numChildren;
			while( i-- ){ 
				removeChildAt( i ); 
			}
		}
	}
}

/**
 *  Both Element and Text are dymamic classes, this is to allow for a little flexibility, you can define 
 *	all of the properties that you are going to use on each if you prefer this but it will compile larger.
 */
import flash.display.*;
import flash.events.*;
import flash.text.*;
dynamic class Element extends Sprite 
{
	/**
	 *	@constructor
	 */
	public function Element()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	/**
	 *	After this Element has been created we position it, unless you set position equal to 
	 *	relative in your styles your element will flow like a inline element or like it is floating left.
	 *	This is very simple positioning but it is the heart of what is often missing in ActionScript.
	 */
	private function onAdded(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		if( this.position != "relative" ){
			var index:int = parent.getChildIndex(this);
			if( index > 0 ) {
				var last:Element = parent.getChildAt(index-1) as Element;
				if( last && last.x + last.width + width + x <= parent.width ){
					x += last.width + last.x;
					y += last.y - last.style.y;
				}else if( last ){
					y += last.y + last.height;
				}
			}	
		}
	}
}

dynamic class Text extends TextField {}