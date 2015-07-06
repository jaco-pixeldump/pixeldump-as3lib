/**
 * @author jaco
 */

package it.pixeldump.sound.vos {

	public class MP3DataVO {

		public var format:uint;
		public var mp3FrameCount:uint;
		public var frameSize:uint;
		public var frameCount:uint;
		public var sampleCount:uint;

		// public var channelMode:uint;
		public var size:uint;
		public var type:uint;
		public var duration:Number;

		public var frameHeader:MP3FrameHeaderVO;

		/**
		 * the constructor
		 */
		public function MP3DataVO() {}

		/**
		 *
		 */
		public function toString():String {

			var str:String = "mp3Data:";
			str += "\nformat:\t" +format;
			str += "\nmp3FrameCount:\t" +mp3FrameCount;
			str += "\nframeSize:\t" +frameSize;
			str += "\nframeCount:\t" +frameCount;
			str += "\nsampleCount:\t" +sampleCount;

			return str;
		}
	}
}