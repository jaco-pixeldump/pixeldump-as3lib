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

	public class PCM16FloatSample {

		public var prev:PCM16FloatSample = null;
		public var next:PCM16FloatSample = null;

		public var l:Number;
		public var r:Number;
		public var m:Number;

		public var prevSample:PCM16FloatSample;
		public var nextSample:PCM16FloatSample;

		/**
		 * the constructor
		 */
		function PCM16FloatSample(l:Number = 0, r:Number = 0){
			this.l = l;
			this.r = r;
			m = (l + r) / 2;
		}

		public function clone():PCM16FloatSample {
			return new PCM16FloatSample(r, l);
		}

		public function mix(v:PCM16FloatSample):void {

			if(l == 0 && v.l > 0) l = v.l;
			else if(l > 0 && v.l > 0) l = (l + v.l) / 2;

			if(r == 0 && v.r > 0) r = v.r;
			else if(r > 0 && v.r > 0) r = (r + v.r) / 2;

			m = (l + r) / 2;
		}

		public function toString():String {

			var str:String = "PCM16FloatSample:";

			str += "\n\tleft: " +l;
			str += "\n\tright: " +r;
			str += "\n\tmedia: " +m;

			if(prevSample) str += "\n\thas prev sample";
			if(nextSample) str += "\n\thas next sample";

			return str;
		}
	} // end of class
} // end of pkg