/**
 * @author jaco
 */
package it.pixeldump.utils.geom {

	import flash.geom.Point;

	public class LineUtil {

		//public function GeomUtil() {}

		/**
		 * get intersection point beetween segments
		 * return null if they don't intersect
		 */
	    public static function lineIntersection(a1:Point, a2:Point, b1:Point, b2:Point):Point {

			var pi:Point = null;
	        var ut:Number = (b2.y - b1.y) * (a2.x - a1.x) - (b2.x - b1.x) * (a2.y - a1.y);

			if(!ut) return null;

        	var ua:Number = ((b2.x - b1.x) * (a1.y - b1.y) - (b2.y - b1.y) * (a1.x - b1.x)) / ut;
            var ub:Number = ((a2.x - a1.x) * (a1.y - b1.y) - (a2.y - a1.y) * (a1.x - b1.x)) / ut;

            if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1)
                pi = new Point(a1.x + ua * (a2.x - a1.x), a1.y + ua * (a2.y - a1.y));

	        return pi;
	    }

		/**
		 * intersection point beetween two infinite lines
		 */
		public static function intersect2Lines (p1:Point, p2:Point, p3:Point, p4:Point):Point {

			var x1:Number = p1.x; var y1:Number = p1.y;
			var x4:Number = p4.x; var y4:Number = p4.y;

			var dx1:Number = p2.x - x1;
			var dx2:Number = p3.x - x4;

			var m1:Number = dx1 ? (p2.y - y1) / dx1 : Math.log(0);
			var m2:Number = dx2 ? (p3.y - y4) / dx2 : Math.log(0);

			if(!dx1 && !dx2) return null; // no coincident

			if(!dx1) return new Point(x1, m2 * (x1 - x4) + y4);
			if(!dx2) return new Point(x4, m1 * (x4 - x1) + y1);

			var p:Point = new Point();
			p.x = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
			p.y = m1 * (p.x - x1) + y1;

			if(isNaN(p.x) || isNaN(p.y)) return null;

			return p;
		}

		/**
		 *
		 */
		public static function midLine (a:Point, b:Point):Point {
			return new Point((a.x + b.x) / 2, (a.y + b.y) / 2);
		}

		/**
		 *
		 */
		public static function lineSlope(p1:Point, p2:Point):Number {

			var slope:Number = 0;

			var dy:Number = p2.y - p1.y;
			var dx:Number = p2.x - p1.x;

			slope = Math.atan2(dy, dx) / GeomUtil.DEG2RAD;

			if (dx < 0 && dy < 0) slope *= -1;
			if (dx > 0 && dy < 0) slope *= -1;
			if (dx < 0 && dy > 0) slope = 360 - slope;
			if (dx > 0 && dy > 0) slope = 360 - slope;

			return slope;
		}

	} // class
} // pkg