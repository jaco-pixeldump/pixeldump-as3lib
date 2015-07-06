/**
 * @author jaco
 */
package it.pixeldump.mk.writers {

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;

	public class ShapeItem {

		private var fillColor:uint = 0x0;
		private var lineColor:uint = 0x0;
		private var lineWidth:Number = 0;

		private var bitmapFill:BitmapFill;
		private var gradientFill:GradientFill;

		public function get bitmapFillID():uint {
			return bitmapFill.id;
		}
		public function set bitmapFillID(value:uint):void {
			bitmapFill.id = value;
		}

		function ShapeItem() {
			bitmapFill = new BitmapFill();
			gradientFill = new GradientFill();
		}
	}

}