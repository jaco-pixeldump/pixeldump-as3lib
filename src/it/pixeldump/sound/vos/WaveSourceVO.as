/**
 * @author jaco
 */

package it.pixeldump.sound.vos {

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import it.pixeldump.sound.wav.WavReader;
	import it.pixeldump.sound.wav.Riff;

	public class WaveSourceVO {

		public var noteInfo:NoteInfoVO;
		public var samples:ByteArray;

		public function get numSamples():uint {
			return samples.length / (noteInfo.numChannels * 2);
		}

		public function get duration():Number{
			return numSamples / noteInfo.soundRate;
		}

		/**
		 * the constructor
		 */
		function WaveSourceVO(noteInfo:NoteInfoVO, ba:ByteArray) {

			this.noteInfo = noteInfo;
			samples = new ByteArray();
			samples.endian = Endian.LITTLE_ENDIAN;
			ba.position = 0;

			var chunkID:String = ba.readUTFBytes(4);

			if(chunkID == Riff.CHUNK_ID){ // file is wav
				var wr:WavReader = new WavReader(ba);
				samples.writeBytes(wr.getRawSamples());
			}
			else {
				samples.writeBytes(ba);
			}
		}
	}

}