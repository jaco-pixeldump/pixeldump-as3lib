/**
 * @author jaco
 */
package it.pixeldump.utils.geom {

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GeomUtil {

		public static const DEG2RAD:Number = Math.PI / 180;

		//public function GeomUtil() {}

		/**
		 *
		 */
		public static function rotatePointAroundAnother(p1:Point, p2:Point, rotAngle:Number):Point {

			var radAngle:Number = rotAngle * GeomUtil.DEG2RAD;
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var cosAngle:Number = Math.cos(radAngle);
			var sinAngle:Number = Math.sin(radAngle);

			return new Point(p2.x + dx * cosAngle - dy * sinAngle, p2.y + dy * cosAngle + dx * sinAngle);
		}

		/**
		 *
		 */
	    public static function scaleCoords(drawingCoords:Vector.<Number>, sx:Number, sy:Number = NaN, offsetX:Number = 0, offsetY:Number = NaN):Vector.<Number> {

	    	if(isNaN(sy)) sy = sx;
			if(isNaN(offsetY)) offsetY = offsetX;

	    	var dc:Vector.<Number> = new Vector.<Number>();
	    	var cCount:int = drawingCoords.length;

	    	for(var i:int = 0; i < cCount; i+= 2){
				dc.push(drawingCoords[i] * sx + offsetX);
				dc.push(drawingCoords[i + 1] * sy + offsetY);
	    	}

	    	return dc;
	    }

		/**
		 *
		 */
	    public static function moveCoords(drawingCoords:Vector.<Number>, offsetX:Number = 0, offsetY:Number = NaN):Vector.<Number> {

			if(isNaN(offsetY)) offsetY = offsetX;

	    	var dc:Vector.<Number> = new Vector.<Number>();
	    	var cCount:int = drawingCoords.length;

	    	for(var i:int = 0; i < cCount; i+= 2){
				dc.push(drawingCoords[i] + offsetX);
				dc.push(drawingCoords[i + 1] + offsetY);
	    	}

	    	return dc;
	    }


		/**
		 *
		 */
	    public static function rotateCoords(drawingCoords:Vector.<Number>, p1:Point, angle:Number):Vector.<Number> {

	    	var dc:Vector.<Number> = new Vector.<Number>();
	    	var cCount:int = drawingCoords.length;
	    	var p:Point, p2:Point;

	    	for(var i:int = 0; i < cCount; i+= 2){

				p= new Point(drawingCoords[i], drawingCoords[i + 1]);
	    		p2 = GeomUtil.rotatePointAroundAnother(p, p1, angle);

				dc.push(p2.x);
				dc.push(p2.y);
	    	}

	    	return dc;
	    }

		public static function scaleRect(r:Rectangle, scaleFactor:Number):Rectangle {
			r.x *= scaleFactor;
			r.y *= scaleFactor;
			r.width *= scaleFactor;
			r.height *= scaleFactor;

			return r;
		}
	} // class
} // pkg