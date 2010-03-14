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
package framework.display
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ContentElement;
	import flash.text.engine.DigitCase;
	import flash.text.engine.DigitWidth;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontMetrics;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.Kerning;
	import flash.text.engine.LigatureLevel;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;
	import flash.text.engine.TextRotation;
	import flash.text.engine.TypographicCase;
	import flash.text.StyleSheet;
	import flash.ui.Mouse;
	
	import framework.utils.TypeUtils;
	import framework.debug.Log;

    public class Text extends Base 
	{
        
		public var style:Object; 
		public var totalLines:int;

		private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		private var _textBlock:TextBlock; 
		private var _groupElement:GroupElement
		private var _textElement:TextElement; 
        private var _elementFormat:ElementFormat; 
		private var _styleSheet:StyleSheet;
		private var _leading:Number = 1.25;
        private var _textWidth:int;
		private var _text:String; 
		
		/**
		 *	@return	Returns the text applied to the Text object
		 */
		public function get text():String
		{ 
			return _text; 
		}
		
		/**
		 *	@param	value	Sets the text value of the Text object
		 */
		public function set text( value:String ):void
		{
			if( value !== _text && style != null ) {
				_text = value;
				// rebreakLines();
			}
		}
		
		/**
		 *	@constructor
		 *	@param	txt	 	A String of text that is going to be rendered
		 *	@param	style	The style that this text is going to be rendered
		 */
        public function Text( txt:String=null, style:Object=null, styleSheet:StyleSheet=null ) 
        { 
			super();
			
			_styleSheet = styleSheet;
			if( style == null )	style = {};
			this.style = style;
			
			_text = txt;
			//if( _text != null ) create();
        }
		
        public function create( params:Object=null ):void 
		{
			var width:Object;
			if( params == null || params.style == null ) {
				style.margin = {top:0, right:0, bottom:0, left:0 };
				style.padding = {top:0, right:0, bottom:0, left:0 };
				width = "100%";
			}else{
				style.margin = params.style.margin;
				style.padding = params.style.padding;
				
				if( params.style.margin == null ) 
					style.margin = {top:0, right:0, bottom:0, left:0 };
				if( params.style.padding == null ) 
					style.padding = {top:0, right:0, bottom:0, left:0 };
				
				width = params.style.width;
			}

			if( width is String ){
				_textWidth = int(TypeUtils.percentToNumber( width as String, parent.parent.width ));
			}else{
				_textWidth = int(width);
			}

 			_textBlock = new TextBlock( createContent() );
            createLines();
        }

		private function createContent():GroupElement
		{
			var groupVector:Vector.<ContentElement> = new Vector.<ContentElement>;
			
			_elementFormat = getFormat();
			
			// ------------------------------------------------------------------------------------------------------
			var currentFormat:ElementFormat = _elementFormat; //_elementFormat;
			function parse( node:XML, underline:Boolean=false, lineThrough:Boolean=false ):void{
				for each ( var xml:XML in node.children() ) {
					currentFormat = currentFormat.clone();
					if( xml.nodeKind() == "element" ) {
						var name:String = String(xml.name()).toLowerCase();
						var s:Object = {};
						if( _styleSheet != null ) {
							s = _styleSheet.getStyle( name )||{};
							var classes:String = xml.@["class"].toString();
							if( classes ){
								for each( var c:String in classes.split(" ") ){
									s = mergeObj( s, _styleSheet.getStyle( "."+c ) );
								}
							}
							s = mergeObj( s||{}, _styleSheet.getStyle( "#"+xml.@id.toString() ) );
							
							for( var prop:String in s ){
								if( prop == "fontFamily" || prop == "fontWeight" || prop == "fontPosture" ){
									currentFormat.fontDescription[prop] = s[prop];
								}else if( prop == "fontSize" || prop == "color" || prop == "alpha" ){
									currentFormat[prop] = s[prop];
								}
							}
						}
						
						//var fontMetrics:FontMetrics = currentFormat.getFontMetrics();
						
						if( name == "font" ){
							if( xml.@face.toString() ){
								currentFormat.fontDescription.fontName = xml.@face.toString();
							}else if( xml.@size.toString() ){
								currentFormat.fontSize = xml.@size.toString();
							}else if( xml.@color.toString() ){
								currentFormat.color = parseInt( xml.@color.toString(), 16 );
							}
							parse( xml, underline, lineThrough );
						}else if( name == "b" || name == "strong" ){
							currentFormat.fontDescription.fontWeight = FontWeight.BOLD; 
							parse( xml, underline, lineThrough );
						}else if( name == "i" || name == "em" ){
							currentFormat.fontDescription.fontPosture = FontPosture.ITALIC; 
							parse( xml, underline, lineThrough );
						}else if( name == "u" ){
							parse( xml, true, false );
						}else if( name == "s" || name == "strike" || name == "del" ){
							parse( xml, false, true );
						}else if( name == "img" ){
							var loader:Loader = new Loader();
							var element:GraphicElement = new GraphicElement( loader, 
									parseInt(xml.@width.toString()||s.width), 
									parseInt(xml.@height.toString()||s.height), 
									currentFormat );
							groupVector.push( element );
							loader.load( new URLRequest( xml.@src.toString() ) );
						}else{
							if( style ){
								// haven't implimented "overline" or "blink" 
								if( s.textDecoration == "line-through" ){
									parse( xml, underline, true );
								}else if( s.textDecoration == "underline" ){
									parse( xml, true, lineThrough );
								}else{
									parse( xml, underline, lineThrough );
								}
							}
						}
					}else{
						var textElement:TextElement = new TextElement( xml.toXMLString(), currentFormat );
						textElement.userData = {underline:underline, lineThrough:lineThrough};
						textElement.eventMirror = _dispatcher;
						_dispatcher.addEventListener(Event.ADDED_TO_STAGE, onTextLineAdded );
						groupVector.push( textElement );
					}
				}
			}
			
			parse( XML( "<xml>" + _text + "</xml>" ), false, false );
			
			
			// ------------------------------------------------------------------------------------------------------
			
			
			_groupElement = new GroupElement(groupVector);
			return _groupElement;
		}
    	
		/**
		 *	@private
		 *	After this TextLine has been added to the displaylist then you can add the other stuff
		 *	like underlines, strick-throughs, and so on.
		 */
		private function onTextLineAdded( event:Event ) : void
		{
			var textLine:TextLine = event.target as TextLine;
			textLine.removeEventListener( Event.ADDED_TO_STAGE, onTextLineAdded );
			var region:TextLineMirrorRegion = textLine.getMirrorRegion(_dispatcher);
			var userData:Object = region.element.userData;
			if( userData != null && ( userData.underline || userData.strikeThrough ) ) {
				// Log.debug( userData.underline, userData.strikeThrough)
				// , fontMetrics.strikethroughThickness, elementFormat.color, elementFormat.alpha, fontMetrics.strikethroughOffset, textLine.textWidth
				var elementFormat:ElementFormat = region.element.elementFormat;
				var fontMetrics:FontMetrics = elementFormat.getFontMetrics();
				var shape:Shape = new Shape();
                var g:Graphics = shape.graphics;
				
                if( userData.strikeThrough ) {
                    g.lineStyle(fontMetrics.strikethroughThickness, 
                                elementFormat.color, elementFormat.alpha);
                    g.moveTo(0, fontMetrics.strikethroughOffset);
                    g.lineTo(textLine.textWidth, fontMetrics.strikethroughOffset);
                }
                if( userData.underline ) {
                    g.lineStyle(fontMetrics.underlineThickness, 
                                elementFormat.color, elementFormat.alpha);
                    g.moveTo(0, fontMetrics.underlineOffset);
                    g.lineTo(textLine.textWidth, fontMetrics.underlineOffset);
                }
                textLine.addChild(shape);
			}
		}
		
        private function clickHandler(event:MouseEvent):void
        {
            var redFormat:ElementFormat = new ElementFormat();
            redFormat.color = 0xCC0000;
            redFormat.fontSize = 18;
            var line:TextLine = event.target as TextLine;
            var region:TextLineMirrorRegion = line.getMirrorRegion(_dispatcher);
            region.element.elementFormat = redFormat;
            createLines();
        }
        
        private function mouseOverHandler(event:MouseEvent):void
        {
            Mouse.cursor = "button";
        }
        
        private function mouseOutHandler(event:MouseEvent):void
        {
            Mouse.cursor = "arrow";
        }
            
        private function createLines():void 
        {
            clear();
                
            var x:Number = 15.0;
            var y:Number = 0;
            var textLine:TextLine = null;
			var firstLine:Boolean = true;
                
            while( textLine = _textBlock.createTextLine( textLine, _textWidth, 0, true ) )
            {
				textLine.x = x;	
				
				if( style.textAlign )
					style.align = style.textAlign;
				
				if( style.align == "center" ) {
					textLine.x = ( _textWidth - style.margin.left - style.padding.left )/2 - textLine.width/2;
				}else if( style.align == "right" ){
					textLine.x = _textWidth - textLine.width - style.margin.right - style.padding.right; 
				}else{
					textLine.x = style.margin.left + style.padding.left; 
				}
				
				y += (_leading * textLine.height ); 
				
				if( firstLine ){
					textLine.y = textLine.ascent + style.margin.top + style.padding.top + 5;
					firstLine = false;
				}else{
	                textLine.y = y; 
				}
				
                addChild (textLine);
            }
			
        }
		
		
		/** 
         * 	Reads a set of style properties for a named style and then creates 
         * 	a TextFormat object that uses the same properties. 
         *	@private
         */ 
        private function getFormat():ElementFormat 
        {
            if( style.color is String ) {
                style.color = parseInt(style.color.split("#").join("").split("0x").join(""), 16);
            }
            var fd:FontDescription = new FontDescription( 
                                style.fontFamily||"_sans", 
                                style.fontWeight||FontWeight.NORMAL, 
								style.fontPosture||style.fontStyle||FontPosture.NORMAL,
                                FontLookup.DEVICE, 
                                RenderingMode.NORMAL, 
                                CFFHinting.NONE); 
            var format:ElementFormat = new ElementFormat( fd, 
								style.fontSize||12, 
                                style.color||0, 
                                style.alpha||1, 
                                style.textRotation||TextRotation.AUTO, 
                                style.textBaseline||TextBaseline.ROMAN, 
                                TextBaseline.USE_DOMINANT_BASELINE, 
                                0.0, // baselineShift
                                style.kerning||Kerning.ON, // "on" || "off"
                                0.0, // trackingRight
                                0.0, // trackingLeft
                                "en", // local
                                style.breakOpportunity||BreakOpportunity.AUTO, 
                                style.digitCase||DigitCase.DEFAULT, 
                                style.digitWidth||DigitWidth.DEFAULT, 
                                style.ligatureLevel||LigatureLevel.NONE, 
                                style.textTransform||style.fontVariant||style.typographicCase||TypographicCase.DEFAULT); 
            
			if( style.lineHeight != null ) {
				_leading = (style.lineHeight - (style.fontSize||12));
			}
			
            if (style.hasOwnProperty("letterSpacing")) {
                format.trackingRight = style.letterSpacing; 
            } 
            return format; 
        }

		/**
		 *	Takes to Objects and combines them together, the newer properties have presidence.
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
		 *	deletes all of the children, in this case should only the TextLines
		 *	@private
		 */
		private function clear() :void
        { 
            while(numChildren) {     
                removeChildAt(0); 
            } 
        }
    }
}