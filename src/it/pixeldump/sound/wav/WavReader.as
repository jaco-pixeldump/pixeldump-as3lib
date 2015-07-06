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
	import flash.utils.Endian;

	public class WavReader extends WavBase {

		public function get numChannels():int {
			return fmt.numChannels;
		}

		public function get bitsPerSample():int {
			return fmt.bitsPerSample;
		}

		public function get numSamples():int {
			return data.chunkSize / fmt.numChannels / (fmt.bitsPerSample / 8);
		}

		public function get duration():Number {
			var stepRate:Number = 1 / fmt.sampleRate;
			return (this.numSamples * stepRate);
		}

		//public function get numSamples():uint {
		//	return data.samples.length;
		//}

		public function get samples():Vector.<PCM16Sample> {
			return data.samples;
		}

		/**
		 * the constructor
		 */
		function WavReader(wavData:ByteArray, wavFileName:String = ""){
			super(wavFileName);

			wavData.position = 0;
			_rawData = wavData;

			if(wavData.length) readWavData(wavData);
		}

		public function readWavData(wavData:ByteArray):void{
			_rawData = wavData;

			var ofst:int = 0;

			wavData.endian = Endian.LITTLE_ENDIAN;
			wavData.position = 0;

			var riffData:ByteArray = new ByteArray();

			riffData.endian = Endian.LITTLE_ENDIAN;
			riffData.writeBytes(wavData, ofst, Riff.RIFF_LENGTH);
			riff = new Riff(riffData);
			ofst += Riff.RIFF_LENGTH;
			riff = new Riff(riffData);

			var fmtData:ByteArray = new ByteArray();

			fmtData.endian = Endian.LITTLE_ENDIAN;
			fmtData.writeBytes(wavData, ofst, Fmt.FMT_LENGTH);
			fmt = new Fmt(fmtData);
			ofst += Fmt.FMT_LENGTH;

			var soundData:ByteArray = new ByteArray();

			soundData.endian = Endian.LITTLE_ENDIAN;
			soundData.writeBytes(wavData, ofst, wavData.length - ofst);
			data = new SoundData(soundData, fmt.numChannels, fmt.bitsPerSample);

			// trace("wav duration:", this.duration);
		}

		public function getRawSamples(littleEndian:Boolean = false):ByteArray {
			return data.getRawSamples(littleEndian);
		}

		public function getRawFloatSamples(littleEndian:Boolean = false):ByteArray {
			return data.getRawFloatSamples();
		}

		public function getFloatSamples():Vector.<PCM16FloatSample> {
			return data.getFloatSamples();
		}

		public function getSamples():Vector.<PCM16Sample> {
			return data.samples;
		}

		public function getFmtInfo():String {
			return fmt.toString();
		}
	}
}