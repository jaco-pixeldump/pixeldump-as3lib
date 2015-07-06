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

	public class Riff {

		private var riffData:ByteArray;

		public static const CHUNK_ID:String = "RIFF"; // (0x52494646 big-endian form).
		public static const RIFF_LENGTH:int = 12;

		public var chunkSize:uint; 			// 36 + SubChunk2Size, or more precisely:
											// 4 + (8 + SubChunk1Size) + (8 + SubChunk2Size)
        									// This is the size of the rest of the chunk
        									// following this number.  This is the size of the
        									// entire file in bytes minus 8 bytes for the
        									// two fields not included in this count:
											// ChunkID and ChunkSize.
		public static const FORMAT:String = "WAVE";	// Format Contains the letters "WAVE"
        											// (0x57415645 big-endian form).


		function Riff(riffData:ByteArray){

			this.riffData = riffData;
			if(riffData.length) readRiffData();
		}

		public function readRiffData():void {

			riffData.position = 0;

			var chunkID:String = riffData.readUTFBytes(4);

			if(chunkID != CHUNK_ID){
				throw new Error("data is not valid riff (no RIFF)");
			}

			chunkSize = riffData.readUnsignedInt(); // whole file length - 8

			var format:String = riffData.readUTFBytes(4);

			if(format != FORMAT){
				throw new Error("data is not valid riff (no WAVE)");
			}
		}

		public function buildRiffData():ByteArray {
			riffData = new ByteArray();
			riffData.endian = Endian.LITTLE_ENDIAN;
			riffData.writeUTFBytes(CHUNK_ID);
			riffData.writeInt(chunkSize);
			riffData.writeUTFBytes(FORMAT);

			return riffData;
		}
	}
}