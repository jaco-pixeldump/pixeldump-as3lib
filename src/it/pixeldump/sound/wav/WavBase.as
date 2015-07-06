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

	public class WavBase {

		protected var _wavFileName:String;
		protected var _rawData:ByteArray;

		protected var riff:Riff;
		protected var fmt:Fmt;
		protected var data:SoundData;

		public function get wavFileName():String {
			return _wavFileName;
		}

		public function set wavFileName(value:String):void {
			_wavFileName = value;
		}

		public function get rawData():ByteArray { return _rawData; }

		function WavBase(wavFileName:String = ""){
			_wavFileName = wavFileName;
		}
	}
}