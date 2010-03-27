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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import framework.display.graphics.Border;
	import framework.display.graphics.Fill;
	import framework.display.graphics.Filters;
	import framework.utils.ObjectUtils;
	import framework.utils.TypeUtils;
	import framework.tasks.TasksBase;
	import framework.debug.Log;
	import framework.components.ScrollBar;
	import flash.events.MouseEvent;
	
	public class ElementBase extends Base
	{
		public static const TOP:String = "top";
		public static const MIDDLE:String = "middle";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height";
		private const DEFAULT:String = "default";
		private const BASE_PROPERTIES:Array = [LEFT,TOP,WIDTH,HEIGHT];
		private const BASE_PROPS:Array = [ "alpha","blendMode","buttonMode","cacheAsBitmap","doubleClickEnabled",
									"focusRect","mouseChildren","mouseEnabled","opaqueBackground","rotation",
									"rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ","tabEnabled",
									"tabIndex","useHandCursor","visible","x","y","z" ];
									// ,"height", "width" // it should be draw the width and height so you dont need to define this
		public var index:int;
		public var event:Object;
		public var afterTasks:Array = [];
		public var beforeTasks:Array = [];
		public var _currentState:String = DEFAULT;
		public var _style:Object = {"default":
									{ left:0, top:0, width:"100%", height:0, position:"auto",
									background:{ type:"none", alpha:1 }, 
									border:{ type:"none", shape:"box", left:0, right:0, top:0, bottom:0 }, 
									margin:{ left:0, right:0, top:0, bottom:0 }, 
									padding:{ left:0, right:0, top:0, bottom:0 }}};
		public var style:Object = _style[_currentState];
		
		private var _computedStyles:Object;
		private var _currentAfterTask:uint = 0;
		private var _currentBeforeTask:uint = 0;
		private var _scrollbar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _rawChildren:Sprite;
		private var _components:Sprite;
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState( value:String ):void
		{
			if( _currentState !== value ) {
				_currentState = value;
				//style = _style[_currentState];
			}
		}
		
		public function get computedStyles():Object
		{ 
			if( _computedStyles == null ) {
				_computedStyles = ObjectUtils.cloneObject( _style[_currentState] );
			}
			return _computedStyles;
		}
		
		public function get totalWidth() : Number
		{
			if( _computedStyles == null ) {
				_computedStyles = computedStyles;
			}
			var parentPadding:Number = 0;

			if( parent && parent.parent && parent.parent is ElementBase ) {
				parentPadding = (parent.parent as ElementBase).computedStyles.padding.left + (parent.parent as ElementBase).computedStyles.padding.right;
			}
			return _computedStyles.width + _computedStyles.margin.left + _computedStyles.margin.right + parentPadding;
		}
		
		public function get totalHeight() : Number
		{
			if( _computedStyles == null ) {
				_computedStyles = computedStyles;
			}
			var parentPadding:Number = 0;
			
			if( parent && parent.parent && parent.parent is ElementBase ) {
				parentPadding = (parent.parent as ElementBase).computedStyles.padding.top + (parent.parent as ElementBase).computedStyles.padding.bottom;
			}
			return _computedStyles.height + _computedStyles.margin.top + _computedStyles.margin.bottom + parentPadding;
		}
		
		public function get rawChildren() : Sprite
		{
			if( _rawChildren == null ){
				_rawChildren = new Sprite();
				addChildAt( _rawChildren, 0 );
			}
			return _rawChildren;
		}
		
		public function get scrollbar():ScrollBar
		{
			return _scrollbar;
		}
		
		public function ElementBase( styles:Object=null, events:Object=null )
		{
			super();

			// style = new Style( this, styles );
			event = events;
			// addEventListener(Parser.PARSED, updateDisplayList);
		}
		
		public function create( params:Object=null ) : ElementBase
		{
			if( params.styles ) {
				_style = params.styles;
			}
			event = params.events;
			return this;
		}
		
		public function kill( state:String=null ):void
		{
			this.state = state;
			runAfterTasks();
		}
		
		public function appendChild( child:DisplayObject ):DisplayObject
		{
			return super.addChild( child );
		}

		override public function addChild( child:DisplayObject ):DisplayObject
		{
			rawChildren.addChild( child );
			return child;
		}
		
		override protected function init():void
		{
			draw( style );
			start();
			// stage.addEventListener(Event.RESIZE, resize);
		}
		
		private function start( event:Event=null ):void
		{
			removeEventListener( "content", start );
			runBeforeTasks();
		}
		
		public function draw( style:Object ):void
		{
			graphics.clear();
			
			cleanStyle();
			
			Position[ _computedStyles.position||"auto" ]( parent.parent, this );
			
			// Set all of the base sprite properties
			for each( var prop:String in BASE_PROPS ) {
				if( _computedStyles.hasOwnProperty(prop) ) {
					this[prop] = _computedStyles[prop];
			}	}
			
			x = _computedStyles.left;
			y = _computedStyles.top;
			
			if( _computedStyles.hasOwnProperty( "mask" ) ) {
				mask = parent.getChildByName( _computedStyles.mask );
			}
			if( _computedStyles.hasOwnProperty("hitArea") ) {
				hitArea = parent.getChildByName( _computedStyles.hitArea ) as Sprite;
			}
			// Draw eveything
			drawBorder();
			graphics.endFill()
			
			if( _computedStyles.hasOwnProperty("scrollRect") ){
				var scrollArr:Array = _computedStyles.scrollRect.split(",");
				scrollRect = new Rectangle(parseFloat(scrollArr[0]),parseFloat(scrollArr[1]),
											parseFloat(scrollArr[2]),parseFloat(scrollArr[3]));
			}

			if( _computedStyles.hasOwnProperty("scale9Grid") ){
				var scaleArr:Array = _computedStyles.scale9Grid.split(",");
				scale9Grid = new Rectangle(parseFloat(scaleArr[0]),parseFloat(scaleArr[1]),
											parseFloat(scaleArr[2]),parseFloat(scaleArr[3]));
			}
			
			if( _computedStyles.hasOwnProperty("overflow") && 
				_computedStyles.overflow != "visible" && _computedStyles.overflow != "auto" ) {
				scrollRect = new Rectangle(0,0,_computedStyles.width,_computedStyles.height);
			}
			// TODO: Figure out how to define filters in CSS so that they can be parsed
			// Filters.applyFilters( this, _computedStyles );
			
			setScroll();
			
			dispatchEvent( new Event( "drawn" ) );
			
			// // Log.debug(name, parent.name, _computedStyles.width, _computedStyles.height);

		}
		
		private function drawBorder():void
		{
			// left right top bottom
			var border:Object = _computedStyles.border;
			if( border != null ) {
				// This only supports solid borders for now
				if( border.color == null) {
					border.alpha = 0;
				}
				if( border.color != null && border.color != undefined && border.alpha == undefined ) {
					border.alpha = 1;
				}
				graphics.beginFill( border.color||0, border.alpha );				
				if( border.top && border.right && border.bottom && border.left ) {
					drawShape( 0, 0, _computedStyles.width, _computedStyles.height );
				}
				// shape
				drawBackground();
				drawShape( border.left, border.top,
					_computedStyles.width - border.left - border.right,
					_computedStyles.height - border.top - border.bottom);
			}
		}
		
		private function drawShape( x:Number, y:Number, width:Number, height:Number ):void
		{
			if( _computedStyles.border.shape == null || _computedStyles.border.shape == "box" || _computedStyles.border.shape == "Rect" ) {
				graphics.drawRect( x, y, width, height );
			}else if( _computedStyles.border.shape == "Ellipse" ){
				graphics.drawEllipse( x, y, width, height);
			}else if( _computedStyles.border.shape == "RoundRect" ){
				graphics.drawRoundRect( x, y, width, height, _computedStyles.border.radius, _computedStyles.border.radius);
			}else if( _computedStyles.border.shape == "RoundRectComplex" ){
				graphics.drawRoundRectComplex( x, y, width, height, 
					_computedStyles.border.topLeftRadius, _computedStyles.border.topRightRadius, 
					_computedStyles.border.bottomLeftRadius, _computedStyles.border.bottomRightRadius );
			}
		}
		
		private function drawBackground():void
		{
			if( _computedStyles.background == null )
				_computedStyles.background = {};
			if( _computedStyles.background.type == null || _computedStyles.background.type == "none" ) {
				return;
			}else if( _computedStyles.background.type == "gradient" ) {
				gradient();
			//}else if( _computedStyles.background.type == "bitmap" ) {
			//	image(); // TODO: bitmap
			}else{
				solid();
			}
		}
		
		private function solid() :void 
		{
			if( _computedStyles.background.color == null ) {
				_computedStyles.background.color = uint(Math.random()*0xFFFFFF)
			}
			
			graphics.beginFill( _computedStyles.background.color, _computedStyles.background.alpha||1 );
		}
		
		/* The width and height of the gradients matrix are based on percentages not pixels */
		private function gradient() :void 
		{
			var _gradient:Object = _computedStyles.background.gradient;
			var item:String
			for( item in _gradient.colors ) {
				_gradient.colors[item] = parseInt(_gradient.colors[item].split("#").join(""),16);
			}
			if( _gradient.alphas == null ) {
				_gradient.alphas = [];
				for( item in _gradient.colors ) { _gradient.alphas.push(1); }
			}else{
				for( item in _gradient.alphas ) {
					_gradient.alphas[item] = parseFloat(_gradient.alphas[item]);
				}
			}
			if( _gradient.ratios == null ){
				_gradient.ratios = [];
				for( var i:String in _gradient.colors ) {
					_gradient.ratios.push((255/(_gradient.colors.length-1))*int(i));
				}
			}else{
				for( item in _gradient.ratios ) {
					_gradient.ratios[item] = parseInt(_gradient.ratios[item]);
				}
			}
			var matrix:Matrix = new Matrix();
			var matrixValues:Array = [0,0,90,100,100];
			if( _gradient.matrix == null ){
				_gradient.matrix = matrixValues;
			}else if( _gradient.matrix.length != 5 ){ 
				var matrixProps:Array = ["x","y","rotation","width","height"];
				var count:int = 0;
				for each( var prop:String in matrixProps ){
					if( _gradient.matrix[prop] == null ) {
						_gradient.matrix[prop] = matrixValues[count];
					}
					count++;
				}
			}
			matrix.createGradientBox( 
				( _computedStyles.width*.01 ) * (_gradient.matrix[3]||100), 
				( _computedStyles.height*.01 ) * (_gradient.matrix[4]||100), 
				( ( _gradient.matrix[2]||90 )/180 )*Math.PI, 
				_gradient.matrix[0]||0, _gradient.matrix[1]||0 );
				
			graphics.beginGradientFill( 
				_gradient.kind||"linear", 
				_gradient.colors, 
				_gradient.alphas, 
				_gradient.ratios, 
				matrix, 
				_gradient.spreadMethod||"pad", 
				_gradient.interpolationMethod||"rgb", 
				parseInt(_gradient.focalPointRatio) );
		}
		
		public function redraw():void
		{
			draw( style );
		}
		
		public function updateDisplayList(event:Event=null):void
		{
			var isChanged:Boolean = false;

			var lastChild:ElementBase
			if( totalWidth > _computedStyles.width ) {
				if( getChildAt(parent.getChildIndex(this)-1) is ElementBase ){
					lastChild = getChildAt(parent.getChildIndex(this)-1) as ElementBase
					style.width = width + totalWidth - _computedStyles.width + (parent as ElementBase).computedStyles.padding.right + 
						lastChild.computedStyles.margin.right;
				}else{
					style.width = totalWidth + (parent as ElementBase).computedStyles.padding.right;
				}
				_computedStyles.width = style.width;
				isChanged = true;
			}
			if( totalHeight > _computedStyles.height ) {
				if( getChildAt(parent.getChildIndex(this)-1) is ElementBase ){
					lastChild = getChildAt(parent.getChildIndex(this)-1) as ElementBase;
					style.height = height + totalHeight - _computedStyles.height + (parent as ElementBase).computedStyles.padding.bottom + 
						lastChild.computedStyles.margin.bottom;
				}else{
					style.height = totalHeight + (parent as ElementBase).computedStyles.padding.bottom; 
				}
				_computedStyles.height = style.height;
				isChanged = true;
			}	
			
			//if( isChanged ) redraw();
		}
		
		private function setScroll() : void
		{
			if( _computedStyles.overflow == "auto" || _computedStyles.overflow == "scroll" || _computedStyles.overflow == "scrollX" || _computedStyles.overflow == "scrollY" ) {  
				if( !_scrollbar ){
					_scrollbar = new ScrollBar( this, rawChildren, _computedStyles, _computedStyles.overflow );
					appendChild( _scrollbar );
				}
				if( stage && _scrollbar ) {
					stage.addEventListener(MouseEvent.CLICK, _scrollbar.updateScroller);
				}
			}
		}
		
		public function setProperties() : void 
		{
			const props:Array = ["x", "y", WIDTH, HEIGHT, "alpha","rotation","scaleX","scaleY","visible","cacheAsBitmap","buttonMode",
								"mouseChildren","mouseEnabled","focusRect","blendMode","rotationX","rotationY","rotationZ","scaleZ","z"];
			const propsLength:int = props.length;
			for each(var prop:String in props){
				if( style[ prop ] ) {
					this[ prop ] = style[ prop ]
				}
			}
		}
		
		/* public function resize( event:Event=null ):void
		{
			redraw()
		}*/
		
		private function runBeforeTasks( event:Event=null ):void
		{
			if( beforeTasks.length != 0 && _currentBeforeTask != beforeTasks.length ){
				var task:TasksBase = beforeTasks[_currentBeforeTask];
				task.addEventListener( Event.COMPLETE, runBeforeTasks );
				task.start( this );
				_currentBeforeTask++;
			}else{
				_currentBeforeTask = 0;
				dispatchEvent( new Event( "running" ) );
			}
		}
		
		private function runAfterTasks( event:Event=null ):void
		{
			if( afterTasks.length != 0 && _currentAfterTask != afterTasks.length ){
				var task:TasksBase = afterTasks[_currentAfterTask];
				task.addEventListener( Event.COMPLETE, runAfterTasks );
				task.start( this );
				_currentAfterTask++;
			}else{
				deleted( state );
			}
		}
		
		private function trash( state:String=null ):void
		{
			this.state = state;
			runAfterTasks();
			dispatchEvent(new Event( "trashed" ) );
		}
		
		private function deleted( state:String=null ):void
		{
			destroy();
			dispatchEvent(new Event( "deleted" ) );
		}
		
		private function cleanStyle(state:String="default") : void
		{	
			_computedStyles = ObjectUtils.cloneObject( _style[_currentState] );
			
			for each( var prop:String in BASE_PROPERTIES ){
				if( _computedStyles[prop] is String ){
					var w:*;
					var h:*;
					if( parent.parent is ElementBase ) {
						w = ElementBase(parent.parent).computedStyles.width;
						h = ElementBase(parent.parent).computedStyles.height;
					}else{
						w = parent.parent.width;
						h = parent.parent.height;
					}
					//// Log.debug(w,h, name)
					if( prop == "x" || prop == WIDTH ){
						_computedStyles[prop] = TypeUtils.percentToNumber( _computedStyles[prop], w );
					}else{
						_computedStyles[prop] = TypeUtils.percentToNumber( _computedStyles[prop], h );
					}
				}else if( _computedStyles[prop] == null ){
					_computedStyles[prop] = 0;
					/*
					if( prop == LEFT || prop == TOP ){
						_computedStyles[prop] = 0;
					}else if( prop == WIDTH ){
						_computedStyles[prop] = w;
					}else{
						_computedStyles[prop] = 0;
					}
					*/
				}
			}
		}
	}
}