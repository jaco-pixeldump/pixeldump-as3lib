/**
 * @author jaco
 */

package it.pixeldump.sound.vos {

	public class MP3FrameHeaderVO {

		public var version:uint;
		public var layer:uint;
		public var protectionBit:int;
		public var bitRate:uint;
		public var rate:uint;

		public var padding:int;
		public var frameSize:uint;
		public var privateBit:int;
		public var channelMode:uint;
		public var modeExtension:uint;
		public var copyright:int;
		public var original:int;
		public var emphasis:uint;
		public var numSamples:uint;


		/**
		 * the constructor
		 */
		public function MP3FrameHeaderVO() {}

		/**
		 *
		 */
		public function toString():String {

			var str:String = "MP3FrameHeader:";
			str += "\nversion:\t" 		+version;
			str += "\nlayer:\t" 		+layer;
			str += "\nprotectionBit:\t" +protectionBit;
			str += "\nbitRate:\t" 		+bitRate;
			str += "\nrate:\t" 			+rate;

			str += "\npadding:\t"		+padding;
			str += "\nframeSize:\t" 	+frameSize;
			str += "\nprivateBit:\t" 	+privateBit;
			str += "\nchannelMode:\t"   +channelMode;
			str += "\nmodeExtension:\t" +modeExtension;
			str += "\ncopyright:\t" 	+copyright;
			str += "\noriginal:\t" 		+original;
			str += "\nemphasis:\t" 		+emphasis;
			str += "\nnumSamples:\t" 	+numSamples;

			return str;
		}
	}
}