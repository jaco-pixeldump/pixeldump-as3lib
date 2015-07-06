/**
 * @author jaco
 */

package it.pixeldump.sound.utils {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.sound.vos.MP3DataVO;
	import it.pixeldump.sound.vos.MP3FrameHeaderVO;

	public class SoundUtil {

		public static const frequencies:Object = {
										C0:16.351597831,
										C0S:17.323914436,
										D0:18.354047995,
										D0S:19.445436483,
										E0:20.601722307,
										F0:21.826764465,
										F0S:23.124651419,
										G0:24.499714749,
										G0S:25.956543599,
										A0:27.5,
										A0S:29.13523509488062,
										B0:30.867706328507758,
										C1:32.70319566257483,
										C1S:34.64782887210901,
										D1:36.70809598967595,
										D1S:38.890872965260115,
										E1:41.20344461410874,
										F1:43.653528929125486,
										F1S:46.2493028389543,
										G1:48.99942949771866,
										G1S:51.91308719749314,
										A1:55,
										A1S:58.27047018976124,
										B1:61.735412657015516,
										C2:65.40639132514966,
										C2S:69.29565774421802,
										D2:73.4161919793519,
										D2S:77.78174593052023,
										E2:82.40688922821748,
										F2:87.30705785825097,
										F2S:92.4986056779086,
										G2:97.99885899543732,
										G2S:103.82617439498628,
										A2:110,
										A2S:116.54094037952248,
										B2:123.47082531403103,
										C3:130.8127826502993,
										C3S:138.59131548843604,
										D3:146.8323839587038,
										D3S:155.56349186104046,
										E3:164.81377845643496,
										F3:174.61411571650194,
										F3S:184.9972113558172,
										G3:195.99771799087463,
										G3S:207.65234878997256,
										A3:220,
										A3S:233.08188075904496,
										B3:246.94165062806206,
										C4:261.6255653005986,
										C4S:277.1826309768721,
										D4:293.6647679174076,
										D4S:311.1269837220809,
										E4:329.6275569128699,
										F4:349.2282314330039,
										F4S:369.9944227116344,
										G4:391.99543598174927,
										G4S:415.3046975799451,
										A4:440,
										A4S:466.1637615180899,
										B4:493.8833012561241,
										C5:523.2511306011972,
										C5S:554.3652619537442,
										D5:587.3295358348151,
										D5S:622.2539674441618,
										E5:659.2551138257398,
										F5:698.4564628660078,
										F5S:739.9888454232688,
										G5:783.9908719634985,
										G5S:830.6093951598903,
										A5:880,
										A5S:932.3275230361799,
										B5:987.7666025122483,
										C6:1046.5022612023945,
										C6S:1108.7305239074883,
										D6:1174.6590716696303,
										D6S:1244.5079348883237,
										E6:1318.5102276514797,
										F6:1396.9129257320155,
										F6S:1479.9776908465376,
										G6:1567.981743926997,
										G6S:1661.2187903197805,
										A6:1760,
										A6S:1864.6550460723597,
										B6:1975.5332050244965,
										C7:2093.004522404789,
										C7S:2217.4610478149766,
										D7:2349.3181433392606,
										D7S:2489.0158697766474,
										E7:2637.0204553029594,
										F7:2793.825851464031,
										F7S:2959.955381693075,
										G7:3135.963487853994,
										G7S:3322.437580639561,
										A7:3520,
										A7S:3729.3100921447194,
										B7:3951.066410048993,
										C8:4186.009044809578,
										C8S:4434.922095629953,
										D8:4698.636286678521,
										D8S:4978.031739553295,
										E8:5274.040910605919,
										F8:5587.651702928062,
										F8S:5919.91076338615,
										G8:6271.926975707988,
										G8S:6644.875161279122,
										A8:7040,
										A8S:7458.620184289439,
										B8:7902.132820097986,
										C9:8372.018089619156,
										C9S:8869.844191259906,
										D9:9397.272573357042,
										D9S:9956.06347910659,
										E9:10548.081821211837,
										F9:11175.303405856124,
										F9S:11839.8215267723,
										G9:12543.853951415977,
										G9S:13289.750322558244};


		public static const noteInOctave:Array = ["C", "CS", "D", "DS", "E", "F", "FS", "G", "GS", "A", "AS", "B"];

		public static const noteNames:Array = ["C0", "C0S", "D0", "D0S", "E0", "F0", "F0S", "G0", "G0S", "A0", "A0S", "B0",
		                                       "C1", "C1S", "D1", "D1S", "E1", "F1", "F1S", "G1", "G1S", "A1", "A1S", "B1",
		                                       "C2", "C2S", "D2", "D2S", "E2", "F2", "F2S", "G2", "G2S", "A2", "A2S", "B2",
		                                       "C3", "C3S", "D3", "D3S", "E3", "F3", "F3S", "G3", "G3S", "A3", "A3S", "B3",
		                                       "C4", "C4S", "D4", "D4S", "E4", "F4", "F4S", "G4", "G4S", "A4", "A4S", "B4",
		                                       "C5", "C5S", "D5", "D5S", "E5", "F5", "F5S", "G5", "G5S", "A5", "A5S", "B5",
		                                       "C6", "C6S", "D6", "D6S", "E6", "F6", "F6S", "G6", "G6S", "A6", "A6S", "B6",
		                                       "C7", "C7S", "D7", "D7S", "E7", "F7", "F7S", "G7", "G7S", "A7", "A7S", "B7",
		                                       "C8", "C8S", "D8", "D8S", "E8", "F8", "F8S", "G8", "G8S", "A8", "A8S", "B8",
		                                       "C9", "C9S", "D9", "D9S", "E9", "F9", "F9S", "G9", "G9S", "A9", "A9S", "B9"];

		// public function SoundUtil() {}


		/**
		 * get mp3 info, seek for the first framesync to fetch data
		 */
		public static function read_mp3_data(ba:ByteArray, mp3FileSize:int):MP3DataVO{

			var fsTest:ByteArray;
			var mp3d:MP3DataVO = new MP3DataVO();

			ba.position = 0;
			trace("ba length:", ba.length);

			for(var i:int = 0; i < 10; i++){

				fsTest = new ByteArray();
				fsTest.writeBytes(ba, i, 4);

				if(SoundUtil.is_mp3_framesync(fsTest)){

					//trace("seems to have found a frame sync :)");

					mp3d.frameHeader = read_mp3Frame_header(fsTest, false);
					break;
				}
			}

			mp3d.format = Constants.SOUND_MP3;
			mp3d.mp3FrameCount = Math.floor((mp3FileSize - i) / mp3d.frameHeader.frameSize);
			mp3d.sampleCount = mp3d.frameHeader.numSamples * mp3d.mp3FrameCount;

			mp3d.type = Constants.SOUND_MONO;

			if(mp3d.frameHeader.channelMode < 3) {
				mp3d.type = Constants.SOUND_STEREO;
			}

			mp3d.size = Constants.SOUND_16BIT;
			mp3d.duration = mp3FileSize / mp3d.frameHeader.bitRate * 8;

			trace(mp3d.toString());

			return mp3d;
		}

		/**
		 * reads data
		 * fill an associative array with mp3frame fields
		 */
		public static function read_mp3Frame_header(ba:ByteArray, doTest:Boolean = true):MP3FrameHeaderVO{

			if(!ba.length) return null;
			ba.position = 0;

			var testFS:ByteArray = new ByteArray();
			testFS.writeBytes(ba, 0, 2);

			if(doTest && !SoundUtil.is_mp3_framesync(ba)) return null;

			var mFlags:String = SwfUtils.toBinString(ba);

			var frameHeader:MP3FrameHeaderVO = new MP3FrameHeaderVO();

			frameHeader.version		  = parseInt(mFlags.substr(11, 2), 2);
			frameHeader.layer		  = parseInt(mFlags.substr(13, 2), 2);
			frameHeader.protectionBit = parseInt(mFlags.charAt(15));

			trace(frameHeader.toString());

			/*
			trace("frame header");
			trace("version:", frameHeader.version);
			trace("layer:", frameHeader.layer);
			trace("protectionBit:", frameHeader.protectionBit);
			*/

			var storedBitRate:uint = parseInt(mFlags.substr(16, 4), 2);
			var storedRate:uint = parseInt(mFlags.substr(20, 2), 2);

			/*
			trace("storedBitRate:", storedBitRate);
			trace("storedRate:", storedRate);
			*/

			var bitRate:int = SoundUtil.translate_bitRate(storedBitRate, frameHeader.version, frameHeader.layer);
			var rateValue:int = SoundUtil.translate_rate(storedRate, frameHeader.version);

			// trace("rateValue:", rateValue);

			var mCount:int = Constants.mp3Rates.length;
			var rate:uint = 0;

			for(var i:int = 0; i < mCount; i++){

				if(rateValue == Constants.mp3Rates[i]) {
					rate = i;
					break;
				}
			}

			frameHeader.bitRate		  = bitRate;
			frameHeader.rate		  = rate;
			frameHeader.padding		  = parseInt(mFlags.charAt(22));


			/* FIXME use constants values
		 				MPEG 1 	MPEG 2 (LSF) 	MPEG 2.5 (LSF)
		 	Layer I 	384 	384 			384
		 	Layer II 	1152 	1152 			1152
		 	Layer III 	1152 	576 			576
		 	*/

			// each item is in reversed order, their first item is NOT SUPPORTED
			var luSamples:Array = [[0, 1152, 1152, 1152],
			                       [0, 384, 384, 384],
			                       [0, 576, 576, 1152]];

			var luTable:Array = luSamples[frameHeader.layer - 1];

			frameHeader.numSamples = luTable[frameHeader.version];
			frameHeader.frameSize = Math.floor(((frameHeader.numSamples / 8 * bitRate) / rateValue) + frameHeader.padding);

			// "old" formula
			//frameHeader.frameSize	  = Math.floor(144 * bitRate / rateValue) + frameHeader.padding;

			frameHeader.privateBit	  = parseInt(mFlags.charAt(23));
			frameHeader.channelMode	  = parseInt(mFlags.substr(24, 2));
			frameHeader.modeExtension = parseInt(mFlags.substr(26, 2));
			frameHeader.copyright	  = parseInt(mFlags.charAt(28));
			frameHeader.original	  = parseInt(mFlags.charAt(29));
			frameHeader.emphasis	  = parseInt(mFlags.substr(30, 2));

			/*
			trace("bitRate:", frameHeader.bitRate);
			trace("rate:", frameHeader.rate);
			trace("padding:", frameHeader.padding);
			trace("numSamples:", frameHeader.numSamples);
			trace("frameSize:", frameHeader.frameSize);
			trace("privateBit:", frameHeader.privateBit);
			trace("channelMode:", frameHeader.channelMode);
			trace("modeExtension:", frameHeader.modeExtension);
			trace("copyright:", frameHeader.copyright);
			trace("original:", frameHeader.original);
			trace("emphasis:", frameHeader.emphasis);
			*/

			return frameHeader;
		}

		/**
		 * converts mp3frame spec into a more readable (and usable) behavior
		 * e.g.:
		 */
		public static function translate_bitRate(mp3BitRate:uint, mp3Version:uint, mp3Layer:uint):uint{

			var idx:String = Constants.mp3Versions[mp3Version];
			idx += Constants.mp3Layers[mp3Layer];

			return Constants.brLU[idx][mp3BitRate] * 1000;
		}

		/**
		 * converts mp3 sampling rate to flash sampling rate
		 */
		public static function translate_rate(mp3rate:uint, mp3Version:uint):uint{

			// slightly different to Constants.mp3versions
			var mp3Versions:Array = ["V25", "reserved", "V2", "V1"];

			var idx:String = mp3Versions[mp3Version];
			var rateValue:uint = Constants.mp3R[idx][mp3rate];

		   	return  rateValue;
		}

		/**
		 * reads 2 byte data
		 * verify if it's a valid framesync
		 */
		public static function is_mp3_framesync(fsTest:ByteArray):Boolean{


			var headerStr:String = SwfUtils.toBinString(fsTest, 0, 2);

			if(headerStr.substr(0, 11) == Constants.FRAME_SYNC_STRING) return true;

			return false;
		}

		/**
		 * find note range from given lower and upper note
		 */
		public static function getNoteRange(lowerNote:String, upperNote:String):uint {

			if(lowerNote == upperNote) return 0;

			var freqNames:Array = ["A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#"];
			var lowerPos:uint = SoundUtil.getNotePositionInOctave(lowerNote);
			var upperPos:uint = SoundUtil.getNotePositionInOctave(upperNote);

			var octaveDiff:int = parseInt(upperNote.charAt(1)) - parseInt(lowerNote.charAt(1));

			// trace("lowerPos:", lowerPos);
			// trace("upperPos:", upperPos);
			// trace("octaveDiff:", octaveDiff);

			return upperPos - lowerPos + octaveDiff * 12 + 1;
		}

		/**
		 * find the note position in a virtual octave
		 */
		public static function getNotePositionInOctave(note:String):int {

			var freqNames:Array = ["A", "B", "C", "C", "D", "D", "E", "F", "F", "G", "G", "A", "A", "B", "C", "C"];
			var position:int = -3;

			for(var i:int = 2; i < 14; i++){

				if(freqNames[i] == note.charAt(0).toUpperCase()){

					position = i;

					if(note.length > 3){

						var plusDoubleAlteration:String = "##SSss";
						var doubleAlteration:String = note.substr(2, 2);

						if(plusDoubleAlteration.indexOf(doubleAlteration) > -1) position += 2;
						else position -= 2;
					}
					else if(note.length > 2){

						var plusAlteration:String = "#Ss";
						var alteration:String = note.charAt(2);

						if(plusAlteration.indexOf(alteration) > -1) position++;
						else position--;
					}

					position -= 2;
					break;
				}
			}

			if(position == -3) return -1;
			if(position < 0) return 12 - position;
			if(position > 11) return position - 12;

			return position;
		}

		/**
		 * return "absolute" note position
		 */
		public static function getNotePositionByName(note:String):uint {
			return SoundUtil.getNotePositionInOctave(note) + 12 * parseInt(note.charAt(1));
		}

		/**
		 * return the note position in frequency table
		 * NOTE: you must pass  valid note name, e.g. check enharmonic first
		 */
		public static function getNotePositionInFrequencyTable(note:String):int {

			var ftCount:int = SoundUtil.noteNames.length;

			for(var i:int = 0; i < ftCount; i++)
				if(SoundUtil.noteNames[i] == note) return i;

			return -1; // note not found
		}

		/**
		 * return frequency value by note name
		 */
		public static function getFrequencyByNote(note:String):Number {

			if(SoundUtil.frequencies[note]) return SoundUtil.frequencies[note];

			return -1; // frequency not found
		}

		/**
		 * return the note name by offset
		 * NOTE: you must pass  valid note name, e.g. check enharmonic first
		 */
		public static function getNoteByOffset(note:String, offset:int):String {

			var notePosition:int = SoundUtil.getNotePositionInFrequencyTable(note) + offset;

			if(notePosition > -1)
				return SoundUtil.noteNames[notePosition];

			return ""; // note name not found
		}

		/**
		 * find ehnarmonic note
		 */
		public static function find_enharmonic(note:String):String {

			if(!SoundUtil.need_enharmonic(note)) return note;

			var offset:int = 0;

			if(note.toLowerCase().indexOf("ss") > -1) offset =  2;
			else if(note.toLowerCase().indexOf("bb") > -1) offset =  -2;
			else if(note.toLowerCase().indexOf("b") > -1) offset =  -1;

			return SoundUtil.getNoteByOffset(note.substr(0, 2), offset);
		}

		/**
		 * check if a given note is an ehnarmonic to valid note
		 */
		public static function need_enharmonic(note:String):Boolean {

			var result:Boolean = false

			if(note.toLowerCase().indexOf("b") > -1) result =  true;
			else if(note.toLowerCase().indexOf("ss") > -1) result =  true;

			return result;
		}


		/**
		 * interpolate/stretch wave source
		 */
		public static function interpolate(sampleBA:ByteArray, baseFreq:Number, newFreq:Number, stereo:Boolean = false, soundRate:int = 44100):ByteArray {

			var divider:int = stereo ? 4 : 2;
			var i:int = 0;
			var freqRatio:Number = baseFreq / newFreq;
			var newSampleBA:ByteArray = new ByteArray();
			newSampleBA.endian = Endian.LITTLE_ENDIAN;

			if(freqRatio == 1) return sampleBA;

			var sampleCount:int = Math.round(sampleBA.length / divider);
			var newSampleCount:int = Math.round(sampleCount * freqRatio);
			var baseDuration:Number = sampleCount / soundRate;
			var newDuration:Number = newSampleCount / soundRate;
			var newTimeStep:Number = baseDuration / newSampleCount;

			sampleBA.position = 0;

			/*
			trace("freqRatio:", freqRatio);
			trace("sampleCount:", sampleCount);
			trace("newSampleCount:", newSampleCount);
			trace("baseDuration:", baseDuration);
			trace("newTimeStep:", newTimeStep);
			*/

			trace("newDuration:", newDuration);

			if(freqRatio < 1){ // strip some sample

				for(i = 0; i < newSampleCount; i++){

					sampleBA.position = Math.floor(i / freqRatio) * divider;

					newSampleBA.writeShort(sampleBA.readShort());

					if(stereo) newSampleBA.writeShort(sampleBA.readShort());
				}

				newSampleBA.position = 0;
				return newSampleBA;
			}


			// need interpolation

			var prevSampleL:int = 0;
			var prevSampleR:int = 0;

			var nextSampleL:int = 0;
			var nextSampleR:int = 0;

			var newSampleL:int = 0;
			var newSampleR:int = 0;
			var ipSampleCount:Number = freqRatio;
			var stepCount:int = Math.floor(freqRatio);
			var stepSampleL:Number = 0;
			var stepSampleR:Number = 0;
			var signL:int = 0;
			var signR:int = 0;
			var j:int = 0;

			if(stereo){ // stereo interpolation

				for(i = 0; i < newSampleCount - divider; ipSampleCount += freqRatio){

					stepCount = Math.floor(ipSampleCount);
					ipSampleCount -= stepCount;

					sampleBA.position = Math.floor(i / freqRatio) * divider;

					for(j = 0; j < stepCount; j++){

						if(sampleBA.bytesAvailable >= 4){
							newSampleBA.writeShort(sampleBA.readShort());
							newSampleBA.writeShort(sampleBA.readShort());
						}
					}

					i += stepCount;
				}
			}
			else { // mono interpolation

				for(i = 0; i < newSampleCount - divider; ipSampleCount += freqRatio){

					stepCount = Math.floor(ipSampleCount);
					ipSampleCount -= stepCount;

					sampleBA.position = Math.floor(i / freqRatio) * divider;

					//prevSampleL = sampleBA.readShort();


					for(j = 0; j < stepCount; j++)
						newSampleBA.writeShort(sampleBA.readShort());

					i += stepCount;
				}
			}

			newSampleBA.position = 0;
			return newSampleBA;
		}


		public static function fadeSamples(samples:ByteArray, offset:uint, numSampleFade:uint, initialGain:Number, endGain:Number, isStereo:Boolean = false):ByteArray {

			var bytesPerSample:uint = 2 * (isStereo ? 2 : 1);
			var stepFade:Number = (initialGain - endGain) / numSampleFade; // linear fading
			var fadedBA:ByteArray = new ByteArray();
			fadedBA.endian = Endian.LITTLE_ENDIAN;
			samples.position = offset * bytesPerSample;

			var sample:int;

			for(var i:uint = 0; i < numSampleFade; i++){

				samples.position = (offset + i) * bytesPerSample;
				sample = samples.readShort();

				var gain:Number = initialGain - stepFade * i;
				var newSample:int = Math.round(sample * gain);

				//if(i < 10) trace("sample, gain, newSample", sample, gain, newSample);

				fadedBA.writeShort(newSample);

				if(isStereo){
					sample = Math.round(samples.readShort() * (initialGain - stepFade * i));
					fadedBA.writeShort(sample);
				}
			}

			samples.position = 0;
			fadedBA.position = 0;

			return fadedBA;
		}
	}
}