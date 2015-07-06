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

	public class SoundData {

		private static const STEP:Number = 1 / 32768;
		private var dataChunk:ByteArray;

		public static const CHUNK_ID:String = "data";	// Subchunk2ID Contains the letters "data"
        												// (0x64617461 big-endian form).
		public var chunkSize:int;						// Subchunk2Size == NumSamples * NumChannels * BitsPerSample/8
        												// This is the number of bytes in the data.
        												// You can also think of this as the size
        												// of the read of the subchunk following this
        												// number.
		public var samples:Vector.<PCM16Sample>;		//The actual sound data
		public var floatSamples:Vector.<PCM16FloatSample>;		//The actual sound data

		public var numChannels:int;
		public var bitsPerSample:int;


		/**
		 * the constructor
		 */
		function SoundData(dataChunk:ByteArray, numChannels:int = 2, bitsPerSample:int = 16) {
			this.dataChunk = dataChunk;
			this.numChannels = numChannels;
			this.bitsPerSample = bitsPerSample;

			if(dataChunk.length) readDataChunk();
		}

		public function readDataChunk():void {
			dataChunk.position = 0;

			var subChunkID:String = dataChunk.readUTFBytes(4);

			//trace("sound data subChunkID:" +subChunkID);

			if(subChunkID != CHUNK_ID){
				throw new Error("not a valid data subchunk (no data)");
			}

			chunkSize = dataChunk.readUnsignedInt();

			var numSamples:int = chunkSize / (bitsPerSample / 8) / numChannels;

			samples = new Vector.<PCM16Sample>(numSamples);

			for(var i:int = 0; i < numSamples; i++){

				var s:PCM16Sample = new PCM16Sample();

				s.l = dataChunk.readShort();
				s.r = numChannels > 1 ? dataChunk.readShort() : s.l;

				samples[i] = s;
			}
		}

		public function buildData():ByteArray {
			dataChunk = new ByteArray();
			dataChunk.endian = Endian.LITTLE_ENDIAN;
			dataChunk.writeUTFBytes("data");
			dataChunk.writeUnsignedInt(chunkSize);

			for each(var i:PCM16Sample in samples){

				dataChunk.writeShort(i.l);

				if(numChannels == 2) dataChunk.writeShort(i.r);
			}

			return dataChunk;
		}


		/**
		 * uses floatSamples instead of samples
		 */
		public function buildFloatData():ByteArray {
			dataChunk = new ByteArray();
			dataChunk.endian = Endian.LITTLE_ENDIAN;
			dataChunk.writeUTFBytes("data");
			dataChunk.writeUnsignedInt(chunkSize);

			for each(var i:PCM16FloatSample in floatSamples){
				dataChunk.writeShort(i.l);

				if(numChannels == 2) dataChunk.writeShort(i.r);
			}

			return dataChunk;
		}

		public function getRawSamples(littleEndian:Boolean = false):ByteArray {

			var rawSamples:ByteArray = new ByteArray();
			var nmin:int = 0;
			var nmax:int = 0;

			if(littleEndian) rawSamples.endian = Endian.LITTLE_ENDIAN;

			for each(var i:PCM16Sample in samples){

				nmin = Math.min(nmin, i.l);
				nmax = Math.max(nmax, i.l);

				rawSamples.writeShort(i.l);

				if(numChannels == 2) rawSamples.writeShort(i.r);
			}

			//trace("nmin, nmax", nmin, nmax);

			rawSamples.position = 0;

			return rawSamples;
		}

		public function getRawFloatSamples(littleEndian:Boolean = false):ByteArray {

			var rawSamples:ByteArray = new ByteArray();

			if(littleEndian) rawSamples.endian = Endian.LITTLE_ENDIAN;

			for each(var i:PCM16Sample in samples){
				rawSamples.writeFloat(Number(i.l * STEP));

				if(numChannels == 2) rawSamples.writeFloat(Number(i.r * STEP));
			}

			rawSamples.position = 0;

			return rawSamples;
		}

		public function getFloatSamples():Vector.<PCM16FloatSample> {

			floatSamples = new Vector.<PCM16FloatSample>(samples.length);

			for(var i:int = 0; i < samples.length; i++){

				var p:PCM16FloatSample = new PCM16FloatSample();
				p.l = samples[i].l * STEP;
				p.r = samples[i].r * STEP;

				floatSamples[i] = p;

				if(i) p.prev = floatSamples[i - 1];
			}

			for(i = 0; i < samples.length - 1; i++){
				floatSamples[i].next = floatSamples[i + 1];
			}

			// loop
			floatSamples[0].prev = floatSamples[floatSamples.length - 1];
			floatSamples[floatSamples.length - 1].next = floatSamples[0];

			//trace("floatSamples length: ", floatSamples.length);

			return floatSamples;
		}
	} // end of class
} // end of pkg