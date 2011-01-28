package framework.components
{

public class ColorPicker extends Object
{
	
	public function ColorPicker()
	{
		super();
	}
	
}

}

/*
 * This class tracks a single unsigned integer number, both as an RGB8 value and as an HSB/HSV value.
 * Use it anywhere you need to think about color in terms of hue, saturation, and brightness.
 * ColorMatrixFilter can perform similar operations on image data, and I'd bet you can use it to
 * affect a single value, but ColorValue is much easier to work with when we've got a single numeric input.
 * 
 * You can use or modify this class in any way you'd like, just let me know if you will be using it anywhere
 * the end product will be seen broadly, as I'd love to be able to link to any such usage. Thanks.
 * 
 * @author: Daniel McKay <http://blog.idiosyntactic.com/>
 */

package com.idiosyntactic {
	public class ColorValue {
		// vars - hexColor is virtually the only persistent variable in this class. holdHue should come into use relatively infrequently.
		public 	var hexColor:uint 	= 0x000000;
		private var holdHue:Number;
		
		public function ColorValue(hex:uint = 0x000000){ hexColor=hex; }
		
		
		/////////
		// HEX //
		/////////
		
		// return a CSS/HTML-compatible  version of the color
		public function get hexString():String{ 
			if (hexColor==0x0) { return "#000000"; }
			var str:String = hexColor.toString(16);
			while (str.length<6) { str='0'+str; }
			return '#'+str.toUpperCase();
		}
		
		
		/////////
		// RGB //
		/////////
		
		// RGB color name getter/setters respectively return/set the r, g, b components of the color value individually
		public function get red():uint{ return hexColor >> 16; }
		public function set red(r:uint):void{ greyCheckedSetColor( ( r << 16 ) | ( hexColor & 0x00FFFF ) ); }
		public function get green():uint{ return hexColor >> 8 & 0xFF; }
		public function set green(g:uint):void{ greyCheckedSetColor( ( g << 8 ) | ( hexColor & 0xFF00FF ) ); }
		public function get blue():uint{ return hexColor & 0xFF; }
		public function set blue(b:uint):void{ greyCheckedSetColor( b | ( hexColor & 0xFFFF00 ) ); }
		
		// RGB array getter/setters return/set the color value r, g, and b components of the color value all at once
		public function get asRGB():Array{ return [ red, green, blue ]; }
		public function set asRGB(rgb:Array):void{ 
			greyCheckedSetColor(
				( rgb[0] << 16 & 0xFF0000 ) | 
				( rgb[1] << 8 & 0xFF00 ) | 
				( rgb[2] & 0xFF )
			);
		}
		
		
		/////////////
		// HSB/HSV //
		/////////////
		
		// return a hue value from 0-360 degrees
		public function get hue():Number{
			if ( (red==green) && (green==blue) ){ return holdHue; }
			var opp:Number=Math.sqrt(3)*(green-blue);
			var adj:Number=2*red-(green+blue);
			if (opp==0){
				if (adj>0){ return 0; }
				else if (adj<0){ return 180; }
				else { return 0; }
			} else if (opp>0) {
				if (adj>0) { return Math.round(Math.atan(opp/adj)*180/3.1416); // 1st quadrant
				} else if (adj<0) { return 180+Math.round(Math.atan(opp/adj)*180/3.1416); // 2nd quadrant, atan => -PI/2 to 0
				} else { return 90; } // adj==0
			} else { // (opp<0)
				if (adj>0) { return 360+Math.round(Math.atan(opp/adj)*180/3.1416); // 4th quad, atan => -PI/2 to 0 
				} else if (adj<0) { return 180+Math.round(Math.atan(opp/adj)*180/3.1416); // 3rd quad, atan => PI/2 to 0 
				} else { return 270; } // adj==0
			}
		}
		
		// return the saturation of the current color value from 0 to 1
		public function get saturation():Number{
			if (extrema[0]==extrema[1]) { return 0; } // covers extrema[0]==0 as well
			else{ return (extrema[0]-extrema[1])/extrema[0]; }
		}
		
		// return the brightness of the current color value from 0 to 1
		public function get brightness():Number{ 
			return extrema[0]/255; } // 0-1
			
		// HSB array functions get/set the color value all together in terms of hue[0-360], saturation[0-1], and brightness[0-1]
		public function get asHSB():Array{ return [ hue, saturation, brightness ]; }
		public function set asHSB(hsb:Array):void{
			while (hsb[0]>=360) { hsb[0]-=360; } while (hsb[0]<0) { hsb[0]+=360; }
			if (hsb[1]>1) { hsb[1]=1; holdHue = undefined; } else if (hsb[1]<=0) { hsb[1]=0; holdHue = new Number(hue); }
			if (hsb[2]>1) { hsb[2]=1; holdHue = undefined; } else if (hsb[2]<=0) { hsb[2]=0; holdHue = new Number(hue); }
			hsb[0]=hsb[0]/60;
			var hueInt:Number=Math.floor(hsb[0]);
			var hueDec:Number=hsb[0]-hueInt;
			var min:Number=hsb[2]*(1-hsb[1]);
			var mid1:Number=hsb[2]*(1-(hsb[1]*hueDec)); // subtractive % (off of max angle)
			var mid2:Number=hsb[2]*(1-(hsb[1]*(1-hueDec))); // additive % (onto max angle)
			switch (hueInt) {
				case 0: // max,mid2,min
					red=Math.round(hsb[2]*255);
					green=Math.round(mid2*255);
					blue=Math.round(min*255);
					break;
				case 1: //  mid1,max,min
					red=Math.round(mid1*255);
					green=Math.round(hsb[2]*255);
					blue=Math.round(min*255);
					break;
				case 2: // min,max,mid2
					red=Math.round(min*255);
					green=Math.round(hsb[2]*255);
					blue=Math.round(mid2*255);
					break;
				case 3: // min,mid1,max
					red=Math.round(min*255);
					green=Math.round(mid1*255);
					blue=Math.round(hsb[2]*255);
					break;
				case 4: // mid2,min,max
					red=Math.round(mid2*255);
					green=Math.round(min*255);
					blue=Math.round(hsb[2]*255);
					break;
				case 5: // max,min,mid1
					red=Math.round(hsb[2]*255);
					green=Math.round(min*255);
					blue=Math.round(mid1*255);
					break;
			}
		}
		
		
		///////////
		// OTHER //
		///////////
		
		// set the color, but check if we need to store a hue first
		public function greyCheckedSetColor(color:uint):void{
			if (isGrey(color)){ holdHue = hue; }
			else { holdHue = undefined; }
			hexColor = color;
		}
		// check a color number to see if it is grey.
		public function isGrey(checkedColor:uint):Boolean{
			var extant:uint = hexColor;
			hexColor = checkedColor;
			if ( (red==blue) && (blue==green) ) {
				hexColor = extant;
				return true;
			} else {
				hexColor = extant;
				return false;
			}
		}
		
		// return (without setting) the inverse of the current value of the color
		public function get inverse():uint{ 
			if (hexColor==0) { return 0xFFFFFF; }
			var shift:uint=0;
			while ( hexColor < 0x80000000 ){ // 1st truly 32 bit number. (ex. 0x10000000 would only be 29 bits) 
				hexColor=uint(hexColor<<4);
				shift+=4;
			}
			return uint((~hexColor)>>shift);
		} 
		
		// set the value of the current color to its inverse (ex. 0xFFFFFF => 0x000000)
		public function invert():void{ 
			var inv:uint = inverse;
			hexColor=inv; 
		}
		
		// Find the greatest and least values among red, green, and blue.
		// (doesn't matter if two are more vals are the same, b/c we're just returning the values, 
		// not the colors to which they relate - the extrema could even be te same number [for a grey]).
		public function get extrema():Array{
			var ext:Array=[0,255]; // max, min
			for (var i:Number=0;i<3;i++){
				if(asRGB[i]>ext[0]){ ext[0]=asRGB[i]; }
				if(asRGB[i]<ext[1]){ ext[1]=asRGB[i]; }
			}
			return ext;
		}
	}
}