package framework.components 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.filters.BevelFilter;
	import flash.display.Shape;
	
	public class Scroll extends Sprite 
	{
		private var par:ScrollBar;
		private var style:Object;		
		private var btnUp:MovieClip;
		private var btnDown:MovieClip;
		private var bar:MovieClip; 
		private var track:MovieClip;
		private var trackSize:int;
		private var barMinSize:int = 6; 
		private var scrollScale:Number;
		private var barPressed:Boolean = false;
		private var orientation:String;
		
		private var topShift:int;					// top bar position
		private var bottomShift:int;				// bottom bar position calculated from the bottom
		
		private var windowSize:int;
		private var contentSize:int;
		private var btnMoveAmount:int = 4;
		private var initTimer:Timer;
		private var btnTimer:Timer;
		private var delta:int = 0;
		private var ease:int = 0;

		public var position:int = 0;
		
		
		public function Scroll(orientation:String, par:ScrollBar, wSize:int, cSize:int, style:Object) : void
		{
			super();
			this.par = par;
			windowSize = wSize;
			contentSize = cSize;
			this.style = style;
			this.orientation = orientation;
			
			par.addChild(this);
			
			// for non-standard layout:
			// set internal variables depending on passed style
			topShift = (style.track.topShift != undefined)? style.track.topShift : style.size;
			bottomShift = (style.track.bottomShift != undefined)? style.track.bottomShift : style.size;

			// create TRACK
			trackSize = windowSize - topShift - bottomShift;  
			track = createTrack(style, "Track");
			this.addChild(track);
			
			// create button UP. For layout with buttons on the bottom style.buttonUp.BottomShift should be defined
			btnUp = createButton(style, "ButtonUp");
			if(style.buttonUp.BottomShift != undefined)		
				btnUp.y = track.height - style.buttonUp.BottomShift;	// in case when buttonUP at the bottom
			else
				btnUp.y = 0;											// standard layout
			this.addChild(btnUp);
	
			// create button DOWN. Assume that button DOWN always the lowest.
			btnDown = createButton(style, "ButtonDown");
			btnDown.y = windowSize - btnDown.height;
			this.addChild(btnDown);
		
			// create BAR
			bar = createBar(style, "Bar");
			bar.y = topShift;
			this.addChild(bar);

			scrollScale = (contentSize - windowSize) / (trackSize - bar.height);
			setListeners();
		}
		
		public function init(wSize:int, cSize:int, style:Object) : void
		{
			windowSize = wSize;
			contentSize = cSize;
			var yTemp:int = bar.y;
			var size:int = Math.round(trackSize * (trackSize/contentSize));
			if(style.styleMovie)
				combineThreeParts(bar, size);
			scrollScale = (contentSize - windowSize) / (trackSize - bar.height);
			setPosition((yTemp - topShift) * scrollScale);
			
		}
		
		private function createTrack(style:Object, skin:String=null) : MovieClip
		{
			var track:MovieClip;
			if(style.styleMovie && skin)
			{
				var Track:Class = style.styleMovie.loaderInfo.applicationDomain.getDefinition(skin) as Class;
				track = new Track();
								
				combineThreeParts(track, windowSize);
				track.x = 0;
				track.y = 0;
				
				if(track.hit_area != undefined)
				{
					combineThreeParts(track.hit_area, trackSize);
					track.hit_area.y = topShift;
					track.hitArea = track.hit_area;
					track.hit_area.visible = false;
					track.mouseChildren = false; 
				}
			}else{ 
				track = new MovieClip();
				track.graphics.beginFill(style.trackColor.color, 1); // style.trackColor.color, style.buttonsColor.alpha
				track.graphics.drawRect(0, 0, style.size, windowSize);
				var innerTrack:Shape = new Shape();
				innerTrack.graphics.beginFill(0xFFFFFF, 0.5);
				innerTrack.graphics.drawRoundRect( 0, 1, style.size, windowSize-(style.size*2)-4, style.size );
				innerTrack.filters = [new BevelFilter(style.size/2,225,0xFFFFFF,1,0,0.3,style.size/2,style.size/2)]
				track.addChild(innerTrack);
			}
			return track;
		}
		private function createButton(style:Object, skin:String=null) : MovieClip
		{			
			var button:MovieClip;
			if(style.styleMovie && skin)
			{
				var ScrollButton:Class = style.styleMovie.loaderInfo.applicationDomain.getDefinition(skin) as Class;
				button = new ScrollButton();
								
				button.gotoAndStop("_up");
				button.x = 0;
				button.y = 0;
				// If you include frames labeled _up, _over, and _down, Flash Player provides automatic state changes
				button.buttonMode = true;
				button.mouseChildren = false;
				
				// hitArea is useful when button is not rectangle (hit_area MovieClip should be defined in styleMovie)
				if(button.hit_area != undefined)
				{
					button.hitArea = button.hit_area;
					button.hit_area.visible = false;
				}
			}
			else
			{
				button = new MovieClip(); 
				button.graphics.beginFill(style.buttonsColor.color, style.buttonsColor.alpha);
				button.graphics.drawRect(0, 0, style.size, style.size);
				button.graphics.beginFill(0, 0.5);
				if( skin == "ButtonUp" ) {
					button.graphics.moveTo( style.size/2, 5 );
					button.graphics.lineTo( style.size - 5, style.size - 5 );
					button.graphics.lineTo( 5, style.size - 5 );
					button.graphics.endFill();
				}else{
					button.graphics.moveTo( 5, 5 );
					button.graphics.lineTo( style.size - 5, 5 );
					button.graphics.lineTo( style.size/2, style.size - 5 );
					button.graphics.endFill();
				}
			}
			return button;
		}
				
		private function createBar(style:Object, skin:String=null) : MovieClip
		{
			var size:int = Math.round(trackSize * (trackSize/contentSize));
			var bar:MovieClip;
			if(style.styleMovie && skin)
			{
				var Bar:Class = style.styleMovie.loaderInfo.applicationDomain.getDefinition(skin) as Class;
				bar = new Bar();
								
				//barMinSize = bar.top.height + bar.middle.height + bar.bottom.height; 
				if(size < barMinSize)
					size = barMinSize;

				combineThreeParts(bar, size);
				
				/* this doesn't work so far
				combineThreeParts(bar, size, "_up");
				combineThreeParts(bar, size, "_over");
				combineThreeParts(bar, size, "_down");
				*/
				
				bar.gotoAndStop("_up");

				// If you include frames labeled _up, _over, and _down, Flash Player provides automatic state changes
				bar.mouseChildren = false; 
//				bar.buttonMode = true;

			}
			else
			{
				if(size < barMinSize)
					size = barMinSize;

				bar = new MovieClip();
				bar.graphics.lineStyle(1, 0, 0.5);
				bar.graphics.beginFill(0x808080, 0.5); // style.faceColor.color, style.buttonsColor.alpha
				bar.graphics.drawRoundRect( 0, style.track.topShift, style.size, size-style.track.topShift, style.size );
				bar.filters = [new BevelFilter(style.size/2,45,0xFFFFFF,1,0,1,style.size/2,style.size/2)]
				// distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false)
			}
			return bar;
		}
		
		// combines any three MovieClips with names "top", "middle" and "bottom"
		private function combineThreeParts(art:MovieClip, size:int, frame:String=null) : void
		{
			if(frame)
				art.gotoAndStop(frame);
			art.x = 0;
			art.y = 0;
			art.top.y = 0;
			art.middle.y = art.top.y + art.top.height;
			art.middle.height = size - art.top.height - art.bottom.height;
			
			if(art.middle.height < 1)
				art.middle.height = 1;
			art.bottom.y = art.middle.y + art.middle.height;
		}
		
		private function setListeners() : void
		{
			// works only inside window
			if(orientation == "y" ) // && this.parent && this.parent.parent && this.parent.parent.parent
				this.parent.parent.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);

			if( bar && stage && btnUp && btnDown && track) {
				bar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_bar);
				bar.addEventListener(MouseEvent.MOUSE_UP, mouseUp_bar);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp_bar);

				btnUp.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_btn);
				btnUp.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				btnUp.addEventListener(MouseEvent.MOUSE_OUT, mouseUp);

				btnDown.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_btn);
				btnDown.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				btnDown.addEventListener(MouseEvent.MOUSE_OUT, mouseUp);

				track.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_track);
			}
			
		}
		
		// scroll wheel
		private function mouseWheelListener(ev:MouseEvent) : void
		{
			delta = -ev.delta * btnMoveAmount;
			moveBar();
		}
	
		// scroll track
		private function mouseDown_track(ev:MouseEvent) : void 
		{
			var yMouse:int = ev.localY*ev.target.scaleY;
			if(yMouse < bar.y)
				delta = -bar.height;
			else if(yMouse > bar.y + bar.height)
				delta = bar.height;
				
			moveBar();
		}
		
		// buttons UP and DOWN
		private function mouseDown_btn(ev:MouseEvent) : void 
		{
			if(ev.target == btnUp)
				delta = -btnMoveAmount;
			if(ev.target == btnDown)
				delta = btnMoveAmount;
			
			if(delta != 0)
			{
				moveBar();
							
				initTimer = new Timer(200,1);	// run initial timer once
				initTimer.addEventListener(TimerEvent.TIMER, setTimer);
				initTimer.start();
			}
		}
		private function setTimer(ev:TimerEvent) : void
		{
			initTimer.removeEventListener(TimerEvent.TIMER, setTimer);
			initTimer = null;
			
			btnTimer = new Timer(80);
			btnTimer.addEventListener(TimerEvent.TIMER, moveBar);
			btnTimer.start();
		}
		private function moveBar(ev:TimerEvent=null) : void 
		{
			bar.y += delta;
			if(delta < 0)
			{
				if(bar.y < topShift)
					bar.y = topShift;
			}
			else
			{
				if(bar.y > trackSize - bar.height + topShift)
					bar.y = trackSize - bar.height + topShift;
			}
			moveScrollee();
		}
		private function mouseUp(ev:MouseEvent) : void 
		{
			if(initTimer) 
			{
				initTimer.removeEventListener(TimerEvent.TIMER, setTimer);
				initTimer = null;
			}			
			if(btnTimer) 
			{
				btnTimer.removeEventListener(TimerEvent.TIMER, moveBar);
				btnTimer = null;
			}
			delta = 0;
		}
		
		// bar control
		private function mouseDown_bar(ev:MouseEvent) : void
		{
			barPressed = true;
		    this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_bar);
			bar.startDrag(false, new Rectangle(track.x, topShift, 0, trackSize - bar.height));
		}
		private function mouseMove_bar(ev:MouseEvent = null) : void
		{
			moveScrollee();
			ev.updateAfterEvent();
		}
		private function mouseUp_bar(ev:MouseEvent) : void 
		{
			if(barPressed) 
			{
                barPressed = false;
		    	this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove_bar);
			    bar.stopDrag();
			    moveScrollee();
		   }
		}
		
		private function moveScrollee() : void 
		{
			position = Math.round((bar.y - topShift) * scrollScale);
			
			/*
			var dist:Number = position - windowRect.y;
	        var e:int=(ease <= 0) ? 1 : Math.ceil(ease);
	        var moveAmount:Number = dist / e;
	        windowRect.y += moveAmount;
	        if (Math.abs(windowRect.y - position) < .5) 
				windowRect.y = Math.round(position);
	        */
			
			par.updateScrollee();
		}
		
		// move content to specified position.
		// first move bar, then call moveScrollee();
		public function setPosition(pos:int) : void
		{
			bar.y = Math.round(pos/scrollScale + topShift);
			if(bar.y < topShift)
				bar.y = topShift;
			if(bar.y > trackSize - bar.height + topShift)
				bar.y = trackSize - bar.height + topShift; 	
		
			moveScrollee();
		}
	}
}