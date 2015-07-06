
/**
 * @author jaco
 *
 * created on 3/2/2010 9:06:56 PM
 */
package it.pixeldump.utils.geom {

	import flash.geom.Point;

	/**
	 *
	 */
	public class BezierCubic {


		private var _a:Point = new Point();
		private var _b:Point = new Point();
		private var _c:Point = new Point();
		private var _d:Point = new Point();

		/**
		 *
		 */
		public function get a():Point {
			return _a;
		}
		public function set a(v:Point):void {
			_a = v.clone();
		}

		/**
		 *
		 */
		public function get b():Point {
			return _b;
		}
		public function set b(v:Point):void {
			_b = v.clone();
		}

		/**
		 *
		 */
		public function get c():Point {
			return _c;
		}
		public function set c(v:Point):void {
			_c = v.clone();
		}

		/**
		 *
		 */
		public function get d():Point {
			return _d;
		}
		public function set d(v:Point):void {
			_d = v.clone();
		}


		/**
		 * the constructor
		 */
		public function BezierCubic(a:Point = null, b:Point = null, c:Point = null, d:Point = null) {

			if(a) this.a = a.clone();
			if(b) this.b = b.clone();
			if(c) this.c = c.clone();
			if(d) this.d = d.clone();
		}

		/**
		 * point by t factor
		 */
		public function getPointAt(t:Number):Point {

			// polynomial coefficients
			var cx:Number = 3.0 * (b.x - a.x);
			var bx:Number = 3.0 * (c.x - b.x) - cx;
			var ax:Number = d.x - a.x - cx - bx;

			var cy:Number = 3.0 * (b.y - a.y);
			var by:Number = 3.0 * (c.y - b.y) - cy;
			var ay:Number = d.y - a.y - cy - by;

			// point t-related on curve */
			var tSquared:Number = t * t;
			var tCubed:Number = t * t * t;

			var p:Point = new Point();

			p.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + a.x;
			p.y = (ay * tCubed) + (by * tSquared) + (cy * t) + a.y;

 			return p;
		}

		public function getSlope(t:Number):Number {

			if(!t) return LineUtil.lineSlope(a, b);
			if(t == 1) return LineUtil.lineSlope(d, c);

			var pt:Point = getPointAt(t);
			var pt1:Point = BezierUtil.getPointOnQuadraticBezier(a, b, c, t);

			return LineUtil.lineSlope(pt1, pt);
		}

		public function getBezierLength(steps:uint = 200):Number {

			var t:Number = 0;
		    var bezierLength:Number = 0;

		    var pt:Point = a.clone();
		    var pt1:Point;

		    for(var i:int = 0; i <= steps; i++) {
		        t = i / steps;
		        pt1 = pt.clone();
		        pt = getPointAt(t);

		        if(i) bezierLength += Point.distance(pt1, pt);
			}

			return bezierLength;
		}

		/**
		 *
		 */
		public function getDataAtCubicBezierLength(l:Number, steps:uint = 200):Object {

			var t:Number = 0;
			var tOld:Number = 0;
		    var bezierLength:Number = 0;

		    var pt:Point = a.clone();
		    var pt1:Point;
			var result:Object = new Object();
			result.point = d.clone();
			result.t = 1;

		    for(var i:int = 0; i <= steps; i++) {
		        t = i / steps;
		        pt1 = pt.clone();
		        pt = getPointAt(t);

		        if(i) {

		        	bezierLength += Point.distance(pt1, pt);

		        	if(bezierLength >= l) {

		        		result.t = tOld;
		        		result.p = pt1;
		        		return result;
		        	}
		        }

		        tOld = t;
			}

			return result;
		}

		/**
		 *
		 */
		public function toString():String {

			var str:String = "BezierCubic: \n";
			str += "a: " +a.toString() +"\n";
			str += "b: " +b.toString() +"\n";
			str += "c: " +c.toString() +"\n";
			str += "d: " +d.toString() +"\n";

			return str;
		}

	} // class

} // pkg
