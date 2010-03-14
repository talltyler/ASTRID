package framework.components 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class ScrollBar extends Sprite 
	{
		private var scrollee:DisplayObjectContainer;
		private var target:DisplayObjectContainer;
		private var scrollX:Scroll;
		private var scrollY:*;
		private var xFlag:int = 0;
		private var yFlag:int = 0;
		private var windowRect:Rectangle;
		private var contentRect:Rectangle;
		private var overflow:String;
		private var maskSquare:Sprite;
		
		private var goalX:Number, goalY:Number;
		private var speed:Number; 
		
		private var style:Object;		
		public var baseStyle:Object;
		private var scrollDefault:Object = 
		{		
			arrowColor:{type:"solid", color:0xFFFFFF}, 
			faceColor:{type:"solid", color:0x333333, alpha:0.5}, 
			faceShape:{type:"none"}, 
			baseColor:{type:"solid", color:0xFFFFFF, alpha:0.5}, 
			baseShape:{type:"none"}, 
			trackColor:{type:"solid", color:0xFF0000 }, //  color:0xFFFFFF }, //    type:"solid", color:0xFFFFFF
			trackShape:{type:"box"}, //none 
			buttonsColor:{type:"solid", color:0x0000FF,  alpha:0.5}, 
			buttonsShape:{type:"none"}, 
			//styleMovie:MovieClip,
			margin:0, 
			size:20, 
			ease:0 
		}
		
		// TODO: load this style 
		private var scrollBottomStyle:Object = 
		{		
			arrowColor:{type:"solid", color:0xFFFFFF}, 
			faceColor:{type:"solid", color:0x333333, alpha:0.5}, 
			faceShape:{type:"none"}, 
			baseColor:{type:"solid", color:0xFFFFFF, alpha:0.5}, 
			baseShape:{type:"none"}, 
			trackColor:{type:"solid", color:0xAAAAAA }, //  color:0xFFFFFF }, //    type:"solid", color:0xFFFFFF
			trackShape:{type:"box"}, //none 
			buttonsColor:{type:"solid", color:0x999999,  alpha:0.5}, 
			buttonsShape:{type:"none"}, 
			//styleMovie:MovieClip,
			margin:0, 
			size:16, 
			ease:0,
			track:{topShift:"0", bottomShift:"34", color:0xCCCCCC},
			buttonUp:{BottomShift:"33"}
		}
		
		// scrollbar = new ScrollBox( components, rawChildren, clean );
		public function ScrollBar( targ:DisplayObjectContainer, scrollItem:DisplayObjectContainer, style:Object, overflow:String="both") 
		{
			super();
			target = targ;        //components
			scrollee = scrollItem;
			this.overflow = overflow;
			
			// something like this should be done for text:
			//scrollee = targ;

			baseStyle = style;
						
			//if(!style.scrollbar){
			  this.style = scrollDefault;
	        //}else{
		      //this.style = style.scrollbar;
		    //
	        //}
			
			scrollee.addEventListener(Event.CHANGE, updateScroller);
			target.addEventListener(Event.CHANGE, updateScroller);
			target.addEventListener("parsed", updateScroller);	// listen for finished container rendering
		}
		
		public function updateScroller(ev:Event=null) : void 
		{
			trace("updateScroller")
			if(windowRect == null)
				windowRect = new Rectangle(baseStyle.x, baseStyle.y, baseStyle.width, baseStyle.height);

			if(maskSquare == null)
			{
				maskSquare = new Sprite();
				maskSquare.graphics.beginFill(0xFF0000);
				maskSquare.graphics.drawRect(0, 0, windowRect.width, windowRect.height);
				maskSquare.visible = false;
				addChild(maskSquare);
				scrollee.mask = maskSquare;
			}

			contentRect = scrollee.getBounds(this); // content 
			var contentWidth:int = contentRect.width;
			var contentHeight:int = contentRect.height;
			/* TODO: text
			if(ev && ev.target is Text)
			{
				contentHeight = ev.target.field.textHeight;
			}*/

			xFlag = (contentWidth > windowRect.width)? 1 : 0;
			yFlag = (contentHeight > windowRect.height && windowRect.height > 45 )? 1 : 0;
			
			/*
			if(overflow == "scrollY")
			{
				xFlag = 0;
				yFlag = 1;
			}
			else if(overflow == "scrollX")
			{
				xFlag = 1;
				yFlag = 0;
			}
			*/

			if(xFlag == 1 || yFlag == 1) {
				style = scrollBottomStyle;
				
				// style.styleMovie = Application.app.assets.files["scroll"].content;
			}
			
			var scrollSize:Number;
			if(yFlag == 1)	// Y
			{ 
				if(scrollY) 
					scrollY.init(windowRect.height - xFlag*style.size, contentHeight, style);
				else if( overflow != "scrollX")
				{	
					scrollSize = windowRect.height - xFlag*style.size;
					if( overflow == "scrollY" ) {
						scrollSize += style.size;
					}
					
					scrollY = new Scroll("y", this, scrollSize, contentHeight, style);
					scrollY.x = windowRect.width - style.size;
					scrollY.y = 0;
					
					if(xFlag == 1 && overflow != "scrollY" ) 	// create deadZone
					{
						var deadZone:Sprite = new Sprite();
						deadZone.graphics.beginFill(style.track.color, 1);
						deadZone.graphics.lineStyle();
						deadZone.graphics.drawRect(scrollY.x, scrollY.height, style.size, style.size);
						this.addChild(deadZone);
					}
				}
			}
			if(xFlag == 1)	// X
			{ 
				if(scrollX) 
					scrollX.init(windowRect.width - yFlag*style.size, contentWidth, style);
				else if( overflow != "scrollY"){
					scrollSize = windowRect.width - yFlag*style.size
					if( overflow == "scrollX" ) {
						scrollSize += style.size;
					}
					scrollX = new Scroll("x", this, scrollSize, contentWidth, style);
					scrollX.x = 0; 
					scrollX.y = windowRect.height;
					scrollX.rotation = -90;
				}
			}
			updateScrollee();
		}
		
		public function updateScrollee() : void
		{
			if(xFlag == 1 || yFlag == 1)
			{
				if(xFlag == 1 && scrollX)	
					scrollee.x = -scrollX.position;
				if(yFlag == 1 && scrollY)	
					scrollee.y = -scrollY.position;
				target.dispatchEvent(new Event("scroll"))
			}
			else
			{
				if(xFlag == 0 && scrollX)
				{
					this.removeChild(scrollX); 
					scrollee.x = 0;
					scrollX = null;
				}
				if(yFlag == 0 && scrollY)
				{
					this.removeChild(scrollY); 
					scrollee.y = 0;
					scrollY = null;
				}
			}
		}
		public function setPosition(x:int=0, y:int=0) : void
		{
			positionX = x;
			positionY = y;
		}
		
		public function setTimedPosition(x:int=0, y:int=0, scrollSpeed:Number = 10) : void
		{
			goalX = x, goalY = y;
			speed = Math.max(1, scrollSpeed);
			addEventListener(Event.ENTER_FRAME, updatePosition);
		}
		
		public function updatePosition(event:Event = null) : void
		{
			var xDone:Boolean = false, yDone:Boolean = false;
			var oldX:Number = positionX, oldY:Number = positionY;
			
			if (!scrollX || Math.abs(positionX - goalX) < speed) {
				xDone = true;
				positionX = goalX;
			} else if (positionX < goalX) {
				positionX += speed;
			} else {
				positionX -= speed;
			}
			if (positionX == oldX) {
				xDone = true;
			}
			
			if (!scrollY || Math.abs(positionY - goalY) < speed) {
				yDone = true;
				positionY = goalY;
			} else if (positionY < goalY) {
				positionY += speed;
			} else {
				positionY -= speed;
			}
			if (positionY == oldY) {
				yDone = true;
			}
			
			if (xDone && yDone) {
				removeEventListener(Event.ENTER_FRAME, updatePosition);
			}
		}
		
		public function get positionX():int {
			if(scrollX)
				return scrollX.position;
			return -1;
		}
		
		public function set positionX(value:int):void {
			if(scrollX)
				scrollX.setPosition(value);
		}
		
		public function get positionY():int {
			if(scrollY)
				return scrollY.position;
			return -1;
		}
		
		public function set positionY(value:int):void {
			if(scrollY)
				scrollY.setPosition(value);
		}
	}
}
