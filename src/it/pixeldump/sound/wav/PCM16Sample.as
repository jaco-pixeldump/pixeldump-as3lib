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

	public class PCM16Sample {

		public var l:int;
		public var r:int;
		public var m:int;

		public var prevSample:PCM16Sample;
		public var nextSample:PCM16Sample;

		/**
		 * the constructor
		 */
		function PCM16Sample(l:int = 0, r:int = 0){
			this.l = l;
			this.r = r;
			m = (l + r) / 2;
		}

		public function fromFloat(fl:Number = 0, fr:Number = 0):void {
			l = Math.floor(fl * 32768);
			r = Math.floor(fl * 32768);
			m = (l + r) / 2;
		}

		public function clone():PCM16Sample {
			return new PCM16Sample(l, r);
		}

		public function toString():String {

			var str:String = "PCMSample:";

			str += "\n\tleft: " +l;
			str += "\n\tright: " +r;
			str += "\n\tmedia: " +m;

			if(prevSample) str += "\n\thas prev sample";
			if(nextSample) str += "\n\thas next sample";

			return str;
		}

	} // end of class
} // end of pkg