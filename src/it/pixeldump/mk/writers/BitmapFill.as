/**
 * @author jaco
 */

package it.pixeldump.mk.writers {

	import it.pixeldump.mk.*;

	/**
	 * bitmap fill
	 * NOTE: to be valid it must provided at least the ID
	 */
	public class BitmapFill {

		public var id:uint = 0;
		public var type:uint = Constants.CLIPPED_BITMAP_FILL;

		// matrix data
		public var x:Number = 0;
		public var y:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;

		function BitmapFill() {

		}
	}

}