/** 
 * Methods star, polygon and wedge are partially based on http://www.3gcomm.fr/Flex/PrimitiveExplorer/srcview/index.html
 * This orginial class has a few other objects that you might want that I didn't include
 *
 * DrawUtils is a static class that provides a number of functions
 * to draw shapes that are not part of the standard ActionScript Drawing
 * API.
 * 
 * based on source code found at:
 * http://www.macromedia.com/devnet/mx/flash/articles/adv_draw_methods.html
 * 
 * @author Ric Ewing - version 1.4 - 4.7.2002
 * @author Kevin Williams - version 2.0 - 4.7.2005
 * @author Jason Hawryluk - version 3.0 - 22.02.2007 
 *         -Modified for Flex 2.01
 */
package framework.display.graphics 
{
	import flash.display.Sprite;
	import framework.debug.Log;
	
	public class Shapes 
	{
		/**
		*	These methods define the different shapes available box, ellipse, rounded, roundedComplex, star, polygon, wedge, or none. 
		*	Custom shapes should be added below
		*	TODO: Might want to look into FXG or SVG for more complex shapes but I haven't needed yet. Feel free to help out
		*/
		public function Shapes()
		{
			super();
		}
		
		public static function none( element:Sprite, style:Object ) :void 
		{
			box( element, style )
		}
		
		public static function box( element:Sprite, style:Object ) :void 
		{	// // Log.debug("box", style.width, style.height)
			element.graphics.drawRect( 0, 0, style.width, style.height);
		}
		
		public static function ellipse( element:Sprite, style:Object ) :void 
		{
			element.graphics.drawEllipse( 0, 0, style.width, style.height);
		}
		
		public static function rounded( element:Sprite, style:Object ) :void 
		{
			element.graphics.drawRoundRect( 0, 0, style.width, style.height, style.shape.width, style.shape.height);
		}
		
		public static function roundedComplex( element:Sprite, style:Object ) :void 
		{
			element.graphics.drawRoundRectComplex( 0, 0, style.width, style.height, style.shape.tl, style.shape.tr, style.shape.br, style.shape.bl );
		}
		
		// to draw shape you need these in style:  x, y, angle, points, innerRadius, outerRadius
		public static function star(element:Sprite, style:Object ):void 
		{

			var count:int = Math.abs(style.shape.points);
			if (count>=2) {
				
				var _x:int = style.x + ( style.shape.outerRadius / 2 );
				var _y:int = style.y + ( style.shape.outerRadius / 2 );
				
				// calculate distance between points
				var step:Number = (Math.PI*2)/style.shape.points;
	            var halfStep:Number = step/2;

	            // calculate starting angle in radians
				var start:Number;
                if( style.shape.angle == undefined ) start = 0;
                else start = (style.shape.angle/180)*Math.PI;

	            element.graphics.moveTo(_x+(Math.cos(start)*style.shape.outerRadius), _y-(Math.sin(start)*style.shape.outerRadius));
                
	            // draw lines
	            for (var i:int=1; i<=count; i++) {
	                element.graphics.lineTo(_x+Math.cos(start+(step*i)-halfStep)*style.shape.innerRadius, _y-Math.sin(start+(step*i)-halfStep)*style.shape.innerRadius);
	                element.graphics.lineTo(_x+Math.cos(start+(step*i))*style.shape.outerRadius, _y-Math.sin(start+(step*i))*style.shape.outerRadius);
				}
	
			}
			element.graphics.endFill();
	
		}
		
		// to draw shape you need these in style:  x, y, points, angle, radius
		public static function polygon(element:Sprite, style:Object ) :void 
		{      
         	// convert sides to positive value
	         var count:int = Math.abs(style.shape.points);
	         if (count>=2) {
				var _x:int = style.x + ( style.shape.outerRadius / 2 );
				var _y:int = style.y + ( style.shape.outerRadius / 2 );
		
		        // calculate span of sides
		        var step:Number = (Math.PI*2)/style.shape.points;
                
		        // calculate starting angle in radians
		        var start:Number;
		        if( style.shape.angle == undefined ) start = 0;
		        else start = (style.shape.angle/180)*Math.PI;
                
		        element.graphics.moveTo(_x+(Math.cos(start)*style.shape.radius), _y-(Math.sin(start)*style.shape.radius));
                
		        for (var i:int=1; i<=count; i++)
		        	element.graphics.lineTo(_x+Math.cos(start+(step*i))*style.shape.radius, _y-Math.sin(start+(step*i))*style.shape.radius);  
	        }
			element.graphics.endFill();
      	}
		
		// to draw shape you need these in style:  x, y, startAngle, arc, radius, yRadius
		public static function wedge(element:Sprite, style:Object ) :void 
		{
    		
			var _x:int = style.x + ( style.shape.outerRadius / 2 );
			var _y:int = style.y + ( style.shape.outerRadius / 2 );
			
         	element.graphics.moveTo(_x, _y);

	        if (Math.abs(style.shape.arc)>360)
	            style.shape.arc = 360;
            
	        var segs:Number = Math.ceil(Math.abs(style.shape.arc)/45);
	        var segAngle:Number = style.shape.arc/segs;
	        var theta:Number =-(segAngle/180)*Math.PI;
	        var angle:Number =-(style.shape.startAngle/180)*Math.PI;
            
	        if (segs>0) {
	            element.graphics.lineTo(_x+Math.cos(style.shape.startAngle/180*Math.PI)*style.shape.radius, _y+Math.sin(-style.shape.startAngle/180*Math.PI)*style.shape.yRadius);
            
	            for (var i:int = 0; i<segs; i++) {
	                angle += theta;
	                var angleMid:Number = angle-(theta/2);
	                element.graphics.curveTo(_x+Math.cos(angleMid)*(style.shape.radius/Math.cos(theta/2)), 
	                _y+Math.sin(angleMid)*(style.shape.yRadius/Math.cos(theta/2)), 
	                _x+Math.cos(angle)*style.shape.radius, _y+Math.sin(angle)*style.shape.yRadius);
	            }
	            element.graphics.lineTo(_x, _y);
	        }
			element.graphics.endFill();
      	}

		public static function freeForm(element:Sprite, style:Object ) :void 
		{
			element.graphics.moveTo(style.shape.points[0][0],style.shape.points[0][1])
			for each(var points:Array in style.shape.points){
				element.graphics.lineTo(points[0],points[1])
			}
			element.graphics.lineTo(style.shape.points[0][0],style.shape.points[0][1])
			element.graphics.endFill();
      	}
	
	}

}