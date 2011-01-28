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
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import framework.view.html.Element;
	import framework.utils.TypeUtils;
	import framework.debug.Log;
	
	public final class Position 
	{
		private static const COMPUTED_STYLES:String = "computedStyles";
		private static const MARGIN:String = "margin";
		private static const PADDING:String = "padding";
		
		// private var current:Object = {top:0, bottom:0};
		// private var floatLeft:Object = {left:0, right:0, top:0, bottom:0};
		// private var floatRight:Object = {left:0, right:0, top:0, bottom:0};
		
		public function Position()
		{
			super();
		}
		 
		/**
		 *	This is a very simple implimentation of absolute positioning, floats, margins, padding and so on need to be added back into this. I might want to make these bit of functionality modular so that all of the positioning methods can use them. 
		 *	You can instanciate this from css by saying positioning:absolute;
		 */
		public static function absolute( parentElement:Sprite, element:ElementBase ) : void 
		{
			// TODO: pass in reference to frame, need scope to the highest thing
			//var appContainer:ApplicationContainer = ApplicationContainer.instance;
			//var local:Point = element.localToGlobal( new Point(appContainer.main.x, appContainer.main.y) );
			//element.x = -(local.x - element.style.x);
			//element.y = -(local.y - element.style.y);
		}
		
		/**
		 *	Auto is the default mode of positioning anything, it mirrors the standard way that HTML positions elements.
		 *	Currently this method impliments, margins(numbers, percents, 'auto'), padding(numbers, percents), float(left, right), clear(left, right, both), inline, text-align
		 *	There are still many things that need to be refined but it is pretty close to the way that a browser would handle positioning
		 *	Still TODO: z-index, 
		 */
		public static function auto( parentElement:Sprite, element:ElementBase ) : void 
		{
			// SETTINGS
			const paddingAddsToSize:Boolean = true;
			const marginSubtractsFromSize:Boolean = true;
			// end settings
			
			var parent:*
			var parentStyle:Object;
			var parentWidth:Number;
			var parentHeight:Number;
			var parentPadding:Object
			
			if( parentElement is ElementBase ) {
				parent = parentElement as ElementBase;
				parentStyle = parent.computedStyles;
				parentWidth = parentStyle.width;
				parentHeight = parentStyle.height;
				parentPadding = parentStyle.padding||{top:0, right:0, bottom:0, left:0};
			}else{
				/* //  Dont need to position something that is not an elementBase
				parent = parentElement;
				parentWidth = parentElement.width;
				parentHeight = parentElement.height;
				parentPadding = {top:0, right:0, bottom:0, left:0};
				*/ 
				return
			}

			var style:Object = element.computedStyles;
			var x:Number = style.left;
			var y:Number = style.top;
			var width:Number = style.width;
			var height:Number = style.height;
			
			var center:Number = ( parentWidth - parentPadding.left - parentPadding.right ) / 2;
			var middle:Number = ( parentHeight - parentPadding.top - parentPadding.bottom ) / 2;
			
			var standardItems:Array = [];
			var floatedItems:Array = [];
			var floatedLeft:Array = [];
			var floatRight:Array = [];
			var tableCells:Array = [];
			var tableRows:Array = [];
			
			var lastChildRect:Rectangle
			var lastChildMargin:Object
			
			// table related variables
			var definedWidth:Number = 0;
			var widthPadding:Number = 0;
			var widthMargin:Number = 0;
			var numDefinedWidth:int = 0;
			var definedHeight:Number = 0;
			var heightPadding:Number = 0;
			var heightMargin:Number = 0;
			var numDefinedHeight:int = 0;
			
			// display:none;
			if( style.display == "none" ){
				style.width = 0;
				style.height = 0;
				element.visible = false;
			}
			
			
			// Changes depths of items based on there properties, floats are above. I'm not sure if this is correct.
			for( var h:int = 0; h < element.parent.numChildren; h++ ){
				var currentItem:* = element.parent.getChildAt( h );
				if( currentItem.hasOwnProperty(COMPUTED_STYLES) ){
					if( currentItem.computedStyles.display == "table-cell" ){ 
						tableCells.push( currentItem );
					}else if( currentItem.computedStyles.display == "table-row" ){
						tableRows.push( currentItem );
					}else if( currentItem.computedStyles.hasOwnProperty("float") ) {
						if( currentItem.computedStyles.float == "left"){
							floatedLeft.push( currentItem );
							floatedItems.push( currentItem );
						} 
						else if( currentItem.computedStyles.float == "right") {
							floatRight.push( currentItem );
							floatedItems.push( currentItem );
						}
					}else{
						standardItems.push( currentItem );
					}
				}else{
					standardItems.push( currentItem );
				}
			}
			
			var depthCount:int = 0;
			for each( var depthItem:* in standardItems ){
				element.parent.addChildAt(depthItem, depthCount);
				depthCount++;
			}
			for each( depthItem in floatedItems ){
				element.parent.addChildAt(depthItem, depthCount)
				depthCount++
			}
			
			// get the last child, we need to find out if we are the first element or need to be position relative to others
			if( element.parent.getChildIndex( element ) != 0  ) {
				var lastChildIndex:int = element.parent.getChildIndex( element ) - 1;
				var lastChild:* = element.parent.getChildAt( lastChildIndex );
				//// Log.debug(element.parent.numChildren, lastChildIndex, lastChild.name)
				for each( var child:ElementBase in element.parent ){
					if( child.index == ( element.index - 1 ) ) {
						lastChildIndex = child.index;
						lastChild = child;
					}
				}
				/*
				for( var i:int = element.parent.numChildren-1; i>= 0; i-- ){
					if( lastChild.hasOwnProperty(COMPUTED_STYLES) && !lastChild.computedStyles.hasOwnProperty("float") ){
						lastChild = element.parent.getChildAt( lastChildIndex );
						lastChildIndex--;
						if()
						break;
					}
				}
				*/
				if( lastChild.hasOwnProperty(COMPUTED_STYLES) && !lastChild.computedStyles.hasOwnProperty("float") ){
					lastChildRect = new Rectangle(lastChild.x, lastChild.y, lastChild.computedStyles.width||lastChild.width, lastChild.computedStyles.height||lastChild.height)
					if( lastChild.computedStyles.hasOwnProperty(MARGIN) )
						lastChildMargin = {left:lastChild.computedStyles.margin.left, right:lastChild.computedStyles.margin.right, bottom:lastChild.computedStyles.margin.bottom, top:lastChild.computedStyles.margin.top}
					else
						lastChildMargin = {left:0, right:0, bottom:0, top:0};
				}else{
					lastChildRect = new Rectangle(0, 0, 0, 0);
					lastChildMargin = {left:0, right:0, bottom:0, top:0};
				}	
			}
			
			// implement clear
			var clearLeft:Boolean = false;
			var clearRight:Boolean = false;
			if( style.clear == "left" )	{
				clearLeft = true;
			}else if( style.clear == "both" || style.clear == "right" ) {
				clearRight = true;
			}
			if( element.parent.getChildIndex( element ) != 0  ) {
				var lastClearChild:* = element.parent.getChildAt( element.parent.getChildIndex( element ) - 1 );
				if( lastClearChild.hasOwnProperty(COMPUTED_STYLES) && ( lastClearChild.computedStyles.clear == "right" || lastClearChild.computedStyles.clear == "both" ) && int(lastClearChild.computedStyles.left) >= int(style.left) ){
					clearRight = true;
				}
			}
			
			if( style.hasOwnProperty(MARGIN) == false ) {
				style.margin = {left:0, right:0, bottom:0, top:0};
			}
			if( style.hasOwnProperty(PADDING) == false ) {
				style.padding = {left:0, right:0, bottom:0, top:0};
			}
			if( parent.computedStyles.hasOwnProperty(PADDING) == false ){
				parent.computedStyles.padding = {left:0, right:0, bottom:0, top:0};
			}
			
			if( style.display == "inline" || style.display == "inline-block" ){
				if( style.textAlign == "center" ){
					style.left = center - style.width/2;
					if( element.parent.getChildIndex( element ) == 0 ){
						style.left = parent.computedStyles.padding.top + style.margin.top + style.top;
					}else{
						style.top = lastChildRect.y - lastChildMargin.top + lastChildMargin.bottom + lastChildRect.height + style.margin.top + style.top;
					}
				}else if(style.textAlign == "right"){
					if( element.parent.getChildIndex( element ) == 0 ){
						style.left = parent.computedStyles.width - parent.computedStyles.padding.right - style.width - style.margin.right;
						style.top = parent.computedStyles.padding.top + style.top + style.margin.top;
					}else{
						if( lastChildRect.x - lastChildMargin.left - style.width - style.margin.right > 0 ){
							style.left = lastChildRect.x - lastChildMargin.left - style.width - style.margin.right;
							style.top = lastChildRect.y;
						}else{ // else wrap to next line
							style.left = parent.computedStyles.width - parent.computedStyles.padding.right - style.width - style.margin.right;
							style.top = style.top + style.margin.top + lastChildRect.y + lastChildRect.height + lastChildMargin.bottom;
						}
					}
				}else{ // left
					if( element.parent.getChildIndex( element ) == 0 ){
						style.left = parent.computedStyles.padding.left + style.margin.left + style.left;
						style.top = parent.computedStyles.padding.top + style.top + style.margin.top;
					}else{
						if( lastChildRect.x + lastChildRect.width + lastChildMargin.right + style.width + style.margin.left < parent.computedStyles.width ){
							style.left = lastChildRect.x + lastChildRect.width + lastChildMargin.right + style.margin.left;
							style.top = lastChildRect.y;
						}else{ // else wrap to next line
							style.left = parent.computedStyles.padding.left + style.margin.left + style.left;
							style.top = style.top + style.margin.top + lastChildRect.y + lastChildRect.height + lastChildMargin.bottom;
						}
					}
				}
				
			}else if( style.display == "table-cell" ){  // style.display == "table-row" ||

				for each( var item:Element in tableCells ){
					if( item.style.width ) {
						definedWidth += item.computedStyles.width;
						widthPadding += item.computedStyles.padding.left + item.computedStyles.padding.right;
						widthMargin += item.computedStyles.margin.left + item.computedStyles.margin.right;
						numDefinedHeight++;
					}
					if( item.style.height ){
						definedHeight += item.computedStyles.height;
						heightPadding += item.computedStyles.padding.top + item.computedStyles.padding.bottom;
						heightMargin += item.computedStyles.margin.top + item.computedStyles.margin.bottom;
						numDefinedHeight++;
					} 
				}
				
				var tableWidth:Number = parent.computedStyles.width - parent.computedStyles.padding.left - parent.computedStyles.padding.right;
				var tableHeight:Number = parent.totalHeight;
				
				/*
				if( tableHeight < style.height ) 
					tableHeight = style.height;
				if( tableHeight == 0 )
					tableHeight = 100;
				*/	
				
				/*
				var isColumn:Boolean
				if( parent is ElementBase && parent.computedStyles.display == "table-cell" ) {
					if( parent.parent && parent.parent.parent is ElementBase && parent.parent.parent.computedStyles.display == "table-cell" ) {
						isColumn = false;
					}else{
						isColumn = true;
					}
				}else{
					isColumn = false;
				}
				*/
				style.width = (tableWidth - widthPadding - widthMargin)/( tableCells.length - numDefinedWidth );
				//style.height = (tableHeight)/( tableCells.length - numDefinedHeight );
				//  - heightPadding - heightMargin

				if( element.parent.getChildIndex(element) == 0 ) {
					style.left = style.margin.left;
					style.top = style.margin.top;
				}else{
					var lastCell:Element = element.parent.getChildAt(element.parent.getChildIndex(element) - 1) as Element;
					style.left = lastCell.x + lastCell.computedStyles.width + lastCell.computedStyles.margin.right + style.margin.left;
					style.top = lastCell.y;
				}
				
				/*
				if( isColumn ) {
					
				}else{
					if( element.parent.getChildIndex( element ) == 0 ){
						style.left = parent.computedStyles.padding.left + style.margin.left + style.left;
						style.top = parent.computedStyles.padding.top + style.top + style.margin.top;
					}else{
						style.left = parent.computedStyles.padding.left + style.margin.left + style.left;
						style.top = style.margin.top + lastChildRect.y + lastChildRect.height + lastChildMargin.bottom;
					}
				}
				*/
				//// Log.debug(style.left, lastCell.x, lastCell.computedStyles.width, lastCell.computedStyles.margin.right, style.margin.left)

			}else{  //  if( style.display == "block" || style.display == "table" ) // I dont know what layout options a table has over a block, for now I'm going to say they are the same

				if( element.parent.getChildIndex( element ) == 0 ){
					style.left = parent.computedStyles.padding.left + style.margin.left + TypeUtils.cleanNumber( element.style.left, parentWidth ); // style.left;
					style.top = parent.computedStyles.padding.top + style.margin.top + TypeUtils.cleanNumber( element.style.top, parentHeight ); 	// style.top;
				}else{
					style.left = parent.computedStyles.padding.left + style.margin.left + TypeUtils.cleanNumber( element.style.left||0, parentWidth ); // style.left;
					style.top = style.margin.top + lastChildRect.y + lastChildRect.height + lastChildMargin.bottom;
				}
				// // Log.debug("lastChildRect", lastChildRect.height, lastChildRect.y)
				
				// margin auto
				if(style.margin.left == "auto" || style.margin.right == "auto"){
					style.left = center - style.width/2;
				}
				if(style.margin.top == "auto" || style.margin.bottom == "auto"){
					style.top = middle - style.height/2;
				}
				
				// vertical-align
				if( style.verticalAlign == "middle" ){
					style.top = middle - style.margin.top;
				}else if( style.verticalAlign == "bottom" ){
					style.top = parent.computedStyles.height - parent.computedStyles.padding.bottom - style.margin.bottom;
				}else{
					if( element.parent.getChildIndex( element ) == 0  )
						style.top = style.margin.top + style.padding.top + style.top;
					else{
						/*
						if( lastChildRect.x + lastChildRect.width + par.parent.clean.padding.left + n.margin.left + lastChild.clean.padding.right + par.parent.clean.padding.right < par.parent.clean.width ){
						}else{		
						}
						*/
					}		
				}
				
				var lastFloatIndex:Number;
				var currentLoopIndex:int;
				var lastFloatRect:Rectangle;
				var lastFloatMargin:Object;
				var lastFloatPadding:Object;
				var largestRightFloatY:Number;
				var lastFloat:*;
				var lastFloat2:*;
				var floatCount:int = 0;
				var floatIndex:int = 0;
				var i:int;
				
				if( style.float == "right" ){ 
					if( element.parent.getChildIndex( element ) == 0  ){
						style.left = parent.computedStyles.width - parent.computedStyles.padding.right - style.width - style.margin.right;
						style.top = parent.computedStyles.padding.top + style.margin.top;
					}else{
						
						// figure out what the last floated element is.
						lastFloatIndex = element.parent.getChildIndex( element );
						floatIndex = floatRight.indexOf(element);
						lastFloat = floatRight[ floatIndex - 1 ];
						
						if( lastFloat.computedStyles.clear == "right" || lastFloat.computedStyles.clear == "both" ){
							clearRight = true;
						}
						
						if(floatIndex != 0){
							lastFloatRect = new Rectangle(lastFloat.x, lastFloat.y , lastFloat.computedStyles.width, lastFloat.computedStyles.height)
							lastFloatMargin = {left:lastFloat.computedStyles.margin.left, right:lastFloat.computedStyles.margin.right, top:lastFloat.computedStyles.margin.top, bottom:lastFloat.computedStyles.margin.bottom}
							lastFloatPadding = {left:lastFloat.computedStyles.padding.left, right:lastFloat.computedStyles.padding.right, top:lastFloat.computedStyles.padding.top, bottom:lastFloat.computedStyles.padding.bottom}
						}else{
							lastFloatRect = new Rectangle(parent.computedStyles.width - parent.computedStyles.padding.right, parent.computedStyles.padding.top, lastFloat.computedStyles.width, lastFloat.computedStyles.height)
							lastFloatMargin = {left:lastFloat.computedStyles.margin.left, right:lastFloat.computedStyles.margin.right, top:lastFloat.computedStyles.margin.top, bottom:lastFloat.computedStyles.margin.bottom}
							lastFloatPadding = {left:lastFloat.computedStyles.padding.left, right:lastFloat.computedStyles.padding.right, top:lastFloat.computedStyles.padding.top, bottom:lastFloat.computedStyles.padding.bottom}
						}
						
						if( !clearLeft && !clearRight && lastFloatRect.x - lastFloatMargin.left - style.width - style.margin.left - style.margin.right >= 0 ){
							style.left = lastFloatRect.x - style.width - style.margin.right - lastFloatMargin.right;
							style.top = (lastFloatRect.y + style.margin.top);
							if(floatIndex != 0) style.top = style.top - lastFloatMargin.top;
						}else{ // wrapp to the next line
							largestRightFloatY = lastFloat.computedStyles.base.y + lastFloat.computedStyles.height + lastFloat.computedStyles.margin.bottom
							for( var j:int = element.parent.numChildren-1; j >= 0; j-- ){
								var q:* = element.parent.getChildAt( j );
								if( q.hasOwnProperty(COMPUTED_STYLES) && q.computedStyles.float == "right" && largestRightFloatY < q.computedStyles.top + q.computedStyles.height + q.computedStyles.margin.bottom ){
									largestRightFloatY = q.computedStyles.top + q.computedStyles.height + q.computedStyles.margin.bottom;
								}
							}
							style.left = parent.computedStyles.width - parent.computedStyles.padding.right - style.width - style.margin.right;
							style.top = largestRightFloatY; // - n.base.height
						}
					}
					
				}else if( style.float == "left" ){ 
					if( element.parent.getChildIndex( element ) == 0  ){ //  if this is the first element
						style.left = parent.computedStyles.padding.left + style.margin.left;
						style.top = parent.computedStyles.padding.top + style.margin.top;
					}else{ // else we have to find the other elements that have relation to this one
						
						// figure out what the last floated element is.
						lastFloatIndex = element.parent.getChildIndex( element );
						floatIndex = floatedLeft.indexOf(element);
						lastFloat = floatedLeft[ floatIndex - 1 ];
						if( lastFloat == null ) return
						
						if( lastFloat.computedStyles.clear == "right" || lastFloat.computedStyles.clear == "both" ){
							clearRight = true;
						}
						
						// if this is the first floated item just place it, else position relative to last floated item
						if(floatIndex != 0){
							lastFloatRect = new Rectangle(lastFloat.x, lastFloat.y, lastFloat.computedStyles.width, lastFloat.computedStyles.height )
							lastFloatMargin = {left:lastFloat.computedStyles.margin.left, right:lastFloat.computedStyles.margin.right, top:lastFloat.computedStyles.margin.top, bottom:lastFloat.computedStyles.margin.bottom}
							lastFloatPadding = {left:lastFloat.computedStyles.padding.left, right:lastFloat.computedStyles.padding.right, top:lastFloat.computedStyles.padding.top, bottom:lastFloat.computedStyles.padding.bottom}
						}else{
							lastFloatRect = new Rectangle(0,0,0,0)
							lastFloatMargin = {left:0, right:0, top:0, bottom:0}
							lastFloatPadding = {left:0, right:0, top:0, bottom:0}
						}
						
						if( !clearLeft && !clearRight && lastFloatRect.x + lastFloatMargin.left + style.width + style.margin.left + style.margin.right + lastFloatRect.width <= parent.computedStyles.width ){
							style.left = lastFloatRect.x + lastFloatRect.width + style.margin.left + lastFloatMargin.right// + n.base.x
							style.top = (lastFloatRect.y + style.margin.top);
							if(floatIndex != 0) style.top = style.top - lastFloatMargin.top;
						}else{ // wrapp to the next line
							largestRightFloatY = lastFloat.computedStyles.top + lastFloat.computedStyles.height + lastFloat.computedStyles.margin.bottom // - par.parent.clean.padding.top
							style.left = parent.computedStyles.padding.left + style.margin.left;
							style.top = largestRightFloatY;
						}	
					}
				}
			}
		}
		
		public static function relative( parentElement:Sprite, element:ElementBase ) : void
		{
			// Flash uses relative positioning by default, this method doesn't need to do anything
			element.x = element.style.x + element.style.margin.left + element.style.padding.left;
			element.y = element.style.y + element.style.margin.top + element.style.padding.top;
		}
	}
}