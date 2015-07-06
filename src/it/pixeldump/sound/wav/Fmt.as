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

	import flash.utils.*;

	public class Fmt {

		public static const CHUNK_ID:String = "fmt "; // Contains the letters "fmt "
													  // (0x666d7420 big-endian form).
		public static const FMT_LENGTH:int = 24;

		private var fmtData:ByteArray;

		public var chunkSize:int;			// 16 for PCM.  This is the size of the
        									// rest of the Subchunk which follows this number.
		public var audioFormat:int;			// PCM = 1 (i.e. Linear quantization)
        									// Values other than 1 indicate some
        									// form of compression.
		public var numChannels:int;			// Mono = 1, Stereo = 2, etc.
		public var sampleRate:int;			// 8000, 44100, etc.
		public var byteRate:int;			// SampleRate * NumChannels * BitsPerSample/8
		public var blockAlign:int;			// == NumChannels * BitsPerSample/8
        									// The number of bytes for one sample including
        									// all channels. I wonder what happens when
        									// this number isn't an integer?
		public var bitsPerSample:int;		// 8 bits = 8, 16 bits = 16, etc.
		//private var extraParamSize:int;		// if PCM, then doesn't exist
		//private var extraParams:*;			// space for extra parameters

		/**
		 * the constructor
		 */
		function Fmt(fmtData:ByteArray){

			this.fmtData = fmtData;

			if(fmtData.length) readFmtData();
		}

		public function readFmtData():void {
			fmtData.position = 0;

			var subChunkID:String = fmtData.readUTFBytes(4);

			if(subChunkID != CHUNK_ID){
				throw new Error("not a valid fmt subchunk (no fmt )");
			}

			chunkSize = fmtData.readUnsignedInt();
			audioFormat = fmtData.readUnsignedShort();
			numChannels = fmtData.readUnsignedShort();
			sampleRate = fmtData.readUnsignedInt();
			byteRate = fmtData.readUnsignedInt();
			blockAlign = fmtData.readUnsignedShort();
			bitsPerSample = fmtData.readUnsignedShort();

			//trace("read fmtData", toString());
		}

		public function buildFmtData():ByteArray {
			fmtData = new ByteArray();
			fmtData.endian = Endian.LITTLE_ENDIAN;

			fmtData.writeUTFBytes(CHUNK_ID);
			fmtData.writeUnsignedInt(chunkSize);
			fmtData.writeShort(audioFormat);
			fmtData.writeShort(numChannels);
			fmtData.writeUnsignedInt(sampleRate);
			fmtData.writeUnsignedInt(byteRate);
			fmtData.writeShort(blockAlign);
			fmtData.writeShort(bitsPerSample);

			return fmtData;
		}

		public function toString():String {

			var str:String = "fmt:";

			str += "\n\tfmtData length: " +fmtData.length;
			str += "\n\tchunkSize: " +chunkSize;
			str += "\n\taudioFormat: " +audioFormat;
			str += "\n\tnumChannels: " +numChannels;
			str += "\n\tsampleRate: " +sampleRate;
			str += "\n\tbyteRate: " +byteRate;
			str += "\n\tblockAlign: " +blockAlign;
			str += "\n\tbitsPerSample: " +bitsPerSample;

			return str;
		}
	} // end of class
} // end of pkg