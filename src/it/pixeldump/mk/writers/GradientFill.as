/**
 * @author jaco
 */

package it.pixeldump.mk.writers {

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.*;

	/**
	 * gradients
	 * up to 15 colors
	 */
	public class GradientFill {

		public var spread:uint = 0;
		public var interpolation:uint = 0;
		public var gradientColors:Array;
		public var ratios:Array;

		// matrix data
		public var x:Number = 0;
		public var y:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;

		function GradientFill() {

			gradientColors = new Array();
			ratios = new Array();
		}
	}

}