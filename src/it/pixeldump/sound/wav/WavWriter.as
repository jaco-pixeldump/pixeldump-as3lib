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

	public class WavWriter extends WavBase {

		function WavWriter(wavFileName:String = "", sampleRate:Number = 44100, numChannels:int = 2){
			this._wavFileName = wavFileName;

			var ba:ByteArray = new ByteArray();

			riff = new Riff(ba);
			fmt = new Fmt(ba);
			fmt.chunkSize = 16;
			fmt.audioFormat = 1;
			fmt.numChannels = numChannels;
			fmt.sampleRate = sampleRate;
			fmt.bitsPerSample = 16;
			fmt.byteRate = fmt.sampleRate * fmt.numChannels * fmt.bitsPerSample / 8;
			fmt.blockAlign = fmt.numChannels * fmt.bitsPerSample / 8;

			data = new SoundData(ba, numChannels);
		}


		public function buildWavData(samples:Vector.<PCM16Sample>):ByteArray {

			riff.chunkSize = Riff.RIFF_LENGTH + Fmt.FMT_LENGTH + samples.length * 4;

			//trace("riff.chunkSize:", riff.chunkSize);

			var ba:ByteArray = new ByteArray();

			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeBytes(riff.buildRiffData());
			ba.writeBytes(fmt.buildFmtData());

			data.samples = samples;
			data.chunkSize = samples.length * fmt.numChannels * (fmt.bitsPerSample / 8);

			ba.writeBytes(data.buildData());

			return ba;
		}

		public function buildFloatWavData(samples:Vector.<PCM16FloatSample>):ByteArray {

			riff.chunkSize = Riff.RIFF_LENGTH + Fmt.FMT_LENGTH + samples.length * 4;

			//trace("riff.chunkSize:", riff.chunkSize);

			var ba:ByteArray = new ByteArray();

			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeBytes(riff.buildRiffData());
			ba.writeBytes(fmt.buildFmtData());

			data.floatSamples = samples;
			data.chunkSize = samples.length * fmt.numChannels * (fmt.bitsPerSample / 8);

			ba.writeBytes(data.buildFloatData());

			return ba;
		}
	}
}