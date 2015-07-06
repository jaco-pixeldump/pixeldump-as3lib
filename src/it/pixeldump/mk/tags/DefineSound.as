

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.media.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineSound extends Tag {


		public function get CLASS_NAME():String { return "DefineSound"; }
		public function get CLASS_ID():uint { return Constants.tagList["DefineSound"]; }

		public var soundFormat:uint;			// UB[4] Format of SoundData
		public var soundRate:uint;				// UB[2]  The sampling rate. This is
												// ignored for Nellymoser and
        										// Speex codecs.
        										// 5.5kHz is not allowed for MP3.
												// 0 = 5.5 kHz
        										// 1 = 11 kHz
        										// 2 = 22 kHz
        										// 3 = 44 kHz
		public var soundSize:uint;				// UB[1] Size of each sample. This
        										// parameter only pertains to
        										// uncompressed formats. This is
        										// ignored for compressed
        										// formats which always decode
        										// to 16 bits internally.
        										// 0 = snd8Bit
        										// 1 = snd16Bit
		public var soundType:uint;				// UB[1] Mono or stereo sound
        										// This is ignored for Nellymoser
        										// and Speex.
        										// 0 = sndMono
        										// 1 = sndStereo
		public var soundSampleCount:uint		// UI32 Number of samples. Not
        										// affected by mono/stereo
        										// setting; for stereo sounds this is
        										// the number of sample pairs.
		public var soundData:ByteArray;			// UI8[size of sound data] The sound data;
												// varies by format.


		// the constructor
		function DefineSound(){
		}


		//
		public override function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			tagSL = true;
			tagID = Constants.SOUND;
			ba = super.toByteArray();

			ba.writeShort(itemID);

			trace("soundFormat", soundFormat);
			trace("soundRate", soundRate);
			trace("soundSize", soundSize);
			trace("soundType", soundType);


			var chStr:String = SwfUtils.value2bin(soundFormat, 4);
			chStr += SwfUtils.value2bin(soundRate, 2);
			chStr += soundSize ? "1" : "0";
			chStr += soundType ? "1" : "0";

			ba.writeByte(parseInt(chStr, 2));
			ba.writeUnsignedInt(soundSampleCount);

			soundData.position = 0;
			ba.writeShort(0); // no frame to skip
			ba.writeBytes(soundData);
			ba.position = 2;
			ba.writeUnsignedInt(ba.length - 6);

			trace(StringUtils.hex_dump(ba, 0, 16));

			return ba;
		}


		public override function fromByteArray(ba:ByteArray):void{

			ba.position = 0;
			super.fromByteArray(ba);
			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;

			itemID = ba.readUnsignedShort();
			offset += 2;

			var ch:uint = ba.readUnsignedByte();
			offset++;
			var chStr:String = SwfUtils.value2bin(ch, 8);

			soundFormat = parseInt(chStr.substring(0, 4), 2);
			soundRate = parseInt(chStr.substring(4, 6), 2);
			soundSize = parseInt(chStr.charAt(6), 2);
			soundType = parseInt(chStr.charAt(7), 2);
			soundSampleCount = ba.readUnsignedInt();

			offset += 4;
			soundData = new ByteArray();
			soundData.writeBytes(ba, offset);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += "format=\"" +Constants.soundFormat[soundFormat] +"\" ";
			xmlStr += "rate=\"" +Constants.soundRate[soundRate] +"\" ";
			xmlStr += "size=\"" +Constants.soundSize[soundSize] +"\" ";
			xmlStr += "type=\"" +Constants.soundType[soundType] +"\" ";
			xmlStr += "sampleCount=\"" +soundSampleCount +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" />";

			return xmlStr;
		}
	}
}