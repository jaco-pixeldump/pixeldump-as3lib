/**
 * @package wav reader/writer library
 * @author jaco_at_pixeldump
 * @description part of lib
 *
 * NOTE: this is a draft stage, much work has to be done
 * If you plan to use this stuff, don't strip this header!
 * released under gpl v.2 - http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */
package it.pixeldump.sound.wav {

	import flash.utils.ByteArray;

	import it.pixeldump.sound.wav.Float;

	public class Sample {

		public var l:Float;
		public var r:Float;

		/**
		 * the constructor
		 */
		function Sample(l:Float = null, r:Float = null) {
			this.l = l ? l : new Float();
			this.r = r ? r : new Float();
		}

		public function getRawSample():ByteArray {
			return null;  // TODO
		}
	}
}