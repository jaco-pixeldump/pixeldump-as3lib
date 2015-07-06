/**
 * @author jaco
 */
package it.pixeldump.mk.writers {

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;

	public class ShapeWriter {

		private shapeBounds:Rect;
		private var shapes:Array;

		private var x:Number = 0;
		private var y:Number = 0;

		//
		function ShapeWriter() {

			shapeBounds = new Rect();
			shapes = new Array();
			addShape();
		}

		public function addShape():void {
			var shapeItem:ShapeItem = new ShapeItem();
			shapes.push(shapeItem);
		}

		public function setFillColor(color:uint):void {
			shapes[shapes.length - 1].fillColor = color;
		}

		public function setFillBitmap(bitmapID, bitmapFillType):void {

		}


		// from absolute to local coord, x and y must be updated
		private function get_local_coord(xy:Number, xory:Boolean = true):Number{

			var tmpCoord:Number = xory ? x : y;
			var coord:Number = xy + tmpCoord * -1;

			if(xy < tmpCoord) coord = -(Math.abs(tmpCoord + xy * -1));

			if(xory)  x = xy;
			else y = xy;

			return coord;
		}


		public function moveTo(x:Number, y:Number):void {

		}

		public function relativeLineTo(x:Number, y:Number):void {
		}

		public function relativeCurveTo(ax:Number, ay:Number, cx:Number, cy:Number):void {

		}

		public function absoluteLineTo(x:Number, y:Number):void {

		}

		public function absoluteCurveTo(ax:Number, ay:Number, cx:Number, cy:Number):void {

		}

		public function addCircle(centerX:Number, centerY:Number, radius:Number):void {

		}

		public function addRect(x:Number, y:Number, width:Number, heigth:Number):void {

		}

		public function addFreeForm(coords:Array):void {

		}
	}
}