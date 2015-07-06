/**
 * @author jaco
 */
package it.pixeldump.utils.geom {

	import flash.geom.Point;

	public class BezierUtil {

		//public function BezierUtil() {}

		public static function getPointOnQuadraticBezier(p1:Point, p2:Point, p3:Point, t:Number):Point {

			var p:Point = new Point();
			var ti:Number = 1 - t;

        	p.x = ti * ti * p1.x + 2 * ti * t * p2.x + t * t * p3.x;
			p.y = ti * ti * p1.y + 2 * ti * t * p2.y + t * t * p3.y;

        	return p;
		}

		/**
		 *
		 */
		public static function bezierSplit (p0:Point, p1:Point, p2:Point, p3:Point):Array {

			var p01:Point = LineUtil.midLine(p0, p1);
			var p12:Point = LineUtil.midLine(p1, p2);
			var p23:Point = LineUtil.midLine(p2, p3);
			var p02:Point = LineUtil.midLine(p01, p12);
			var p13:Point = LineUtil.midLine(p12, p23);
			var p03:Point = LineUtil.midLine(p02, p13);

			var b:Array = new Array();

			b.b0 = new Array(p0, p01, p02, p03);
			b.b1 = new Array(p03, p13, p23, p3);

			return b;
		}

		/**
		 * recursive
		 */
		public static function cBez(a:Point, b:Point, c:Point, d:Point, mcp:Array = null, k:Number = 2):Array {

			// find intersection between bezier arms
			if(!mcp) mcp = new Array();
			var coords:Array;

			if((a.x == b.x && b.x == c.x && c.x == d.x) || (a.y == b.y && b.y == c.y && c.y == d.y)){
				coords = new Array(c.x, c.y, d.x, d.y);
				mcp.push(coords);

				return mcp;
			}

			var s:Point = LineUtil.intersect2Lines (a, b, c, d);

			if(!s) s = new Point();

			// find distance between the midpoints
			var dx:Number = (a.x + d.x + s.x * 4 - (b.x + c.x) * 3) * .125;
			var dy:Number = (a.y + d.y + s.y * 4 - (b.y + c.y) * 3) * .125;

			var ap:Number = dx * dx + dy * dy;

			// split curve if the quadratic isn't close enough
			if (ap > k) {

				var halves:Array = BezierUtil.bezierSplit (a, b, c, d);
				var b0:Array = halves.b0;
				var b1:Array = halves.b1;

				// recursive call to subdivide curve
				BezierUtil.cBez(a, b0[1], b0[2], b0[3], mcp, k);
				BezierUtil.cBez(b1[0], b1[1], b1[2], d, mcp, k);
			}
			else {

				// end recursion by drawing quadratic bezier
				coords = new Array(s.x, s.y, d.x, d.y);

				mcp.push(coords);
			}

			return mcp;
		}


		public static function getBezierCurves (p1:Point, p2:Point, p3:Point, p4:Point, tolerance:Number = 2):Array {

			return BezierUtil.cBez(p1, p2, p3, p4, null, (tolerance * tolerance));
		}

	} // class
} // pkg