package it.pixeldump.mk {

	import flash.utils.*;

	import it.pixeldump.mk.struct.*;

	public class SwfUtils {


		public static const TWIP:uint = 20;


		public static function get_xml_indent_row(tabLevel:uint = 0):String{

			var xir:String = "\n";

			for(var i:uint = 0; i < tabLevel; i++) xir += "\t";

			return xir;
		}

		public static function get_color_array(col:String = "#000000", alpha:uint = 0xff, useAlpha:Boolean = false):Color {

			var c:Color = new Color();
			c.fromString(col, alpha, useAlpha);

			return c;
		}

		/**
		 * find the minimum bits needed to express a value
		 */
		public static function find_minBits(val1:int, val2:int, ... rest):uint {

			var val1Length:int = Math.abs(val1).toString(2).length + 1;
			var val2Length:int = Math.abs(val2).toString(2).length + 1;

			var minBits:int = Math.max(val1Length, val2Length);

			if(!rest.length) return minBits;

			// continue to compare rest parameters
			for each(var i:int in rest){
				minBits = Math.max(minBits, (Math.abs(i).toString(2).length + 1));
			}

			return minBits;
		}


		/**
		 * convert int to binary String
		 */
		public static function int_to_bitFieldString(value:int):String {

			if(value == 0) return "0";

			var valueStr:String = value.toString(2);

			if(value > 0) return "0" +valueStr;

			valueStr = (~value).toString(2);
			var negStr:String = "1";

			for(var i:int = 0; i < valueStr.length; i++)
				negStr += valueStr.charAt(i) == "1" ? "0" : "1";

			return negStr;
		}


		/**
		 *
		 */
		public static function isNegative(binStr:String):Boolean {
			return binStr.charAt(0) == "1" ? true : false;
		}

		/**
		 * convert an integer to binary string with fixed length
		 * be careful: no error check is done
		 */
		public static function value2bin(value:int, numBits:int):String {

			var valueStr:String = SwfUtils.int_to_bitFieldString(value);
			var vLength:int = valueStr.length;

			if(vLength == numBits) {
				return valueStr;
			}

			if(vLength > numBits) {
				return valueStr.substring(valueStr.length - numBits);
			}

			var diffLength:int = numBits - vLength;
			var ch:String = valueStr.charAt(0);
			var padStr:String = "";

			for(var i:int = 0; i < diffLength; i++) padStr += ch;

			return padStr + valueStr;
		}

		/**
		 * converts a Number to 16.16 fixed point binary string
		 */
		public static function fpValue2bin(fv:Number, minBits:uint = 32):String{

			var fvL:int = Math.floor(fv);
			var fvR:Number = fv - fvL;

			var fvLBinStr:String = SwfUtils.value2bin(fvL, 16);
			var fvRBinStr:String = "";
			var d:Number = fvR;

			for(var i:uint = 0;  i < 16; i++){

				d *= 2;

				if(d >= 1){
					fvRBinStr += "1";
					d -= 1;
				}
				else fvRBinStr += "0";
			}

			var fp32BinStr:String = fvLBinStr + fvRBinStr;

		 	return fp32BinStr.substring(-minBits);
		}


		/**
		 * find minBits in an array of fixed 16.16 values
		 */
		public static function fpFindMinBits(fpAr:Array):uint{

			var fpMinBits:uint = 17; // 1.16 minimum bits

			var fpStrAr:Array = new Array();

			for each(var fpVal:Number in fpAr){

				var fpStr:String = SwfUtils.fpValue2bin(fpVal);

				var fc:String = fpStr.charAt(0) == "1" ? "0" : "1";
				var fpL:String = fpStr.substring(fpStr.indexOf(fc));

				fpStrAr.push(fpL.length);
			}

			for each(var i:uint in fpStrAr)
				fpMinBits = Math.max(i, fpMinBits);

			fpMinBits++;

			if(fpMinBits < 16) fpMinBits = 16;

			return fpMinBits;
		}

		/**
		 * converts a binString to signed integer
		 */
		public static function binStrToInt(binStr:String):int {

			if(!SwfUtils.isNegative(binStr)) return parseInt(binStr, 2);

			var str:String = "";

			for(var i:int = 0; i < binStr.length; i++){
				str += binStr.charAt(i) == "1" ? "0" : "1";
			}


			return -(parseInt(str, 2) + 1);
		}

		/* TODO test */
		/**
		 *
		 */
		public static function fpBinStrToFloat(fpStr:String, precision:uint = 4, fp:uint = 16):Number {

			var fvL:int = 0;
			var fvR:Number = 0;

			if(!fpStr.length) fpStr = "0";

			var ch:String = fpStr.charAt(0);
			var fps32:String = "";

			for(var i:uint = 0; i < (fp * 2); i++) fps32 += ch;

			fps32 = fps32.substring(0, fp * 2 - fpStr.length) + fpStr;

			var fvLBinStr:String = fps32.substring(0, fp);
			var fvRBinStr:String = fps32.substring(fp);

			for(var j:uint = 0; j < fp; j++) {

				if(fvRBinStr.charAt(j) == "1")
					fvR += Math.pow(2, -(j + 1));
			}

			fvL = parseInt(fvLBinStr, 2);

			if(SwfUtils.isNegative(fvLBinStr)) fvL -= 0xFFFF + 1;

			var mul:int = Math.pow(10, precision);
			fvR = Math.round(fvR * mul) / mul;

			return fvL + fvR;
		}


		/**
		 * byte array to binary string
		 */
		public static function toBinString(ba:ByteArray, offset:uint = 0, byteLength:int = 0):String {

			ba.position = offset;
			var binStr:String = "";

			var baLength:uint = byteLength ? byteLength : ba.length - offset;


			for(var i:int = 0; i < baLength; i++){
				var ch:int = ba.readUnsignedByte();
				binStr += SwfUtils.value2bin(ch, 8);
			}

			return binStr;
		}

		/**
		 * returns a binary string starting from bitOffset and given bit length
		 */
		public static function toBitOffsetBinString(ba:ByteArray, offset:uint = 0, bitOffset:uint = 0, bitLength:uint = 8):String {

			bitOffset = Math.min(8, bitOffset); // bitOffset can't be > 8

			var bytesRequired:uint = Math.ceil((bitOffset + bitLength) / 8);
			var binStr:String = SwfUtils.toBinString(ba, offset, bytesRequired);

			return binStr.substr(bitOffset, bitLength);
		}

		public static function get_byteArray_from_string(binStr:String):ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var bLength:int = Math.floor(binStr.length / 8);

			for(var i:int = 0, k:int = 0; i < bLength; i++, k += 8){
				ba.writeByte(parseInt(binStr.substr(k, 8), 2));
			}

			return ba;
		}

		public static function toTwip(value:Number):int {
			return Math.round(value * SwfUtils.TWIP);
		}

		public static function fromTwip(value:Number):Number {
			return value / SwfUtils.TWIP;
		}

		public static function read_swfString(ba:ByteArray):String {
			ba.position = 0;
			var str:String = "";
			var i:int = ba.position;

			while(ba[i++] != 0) { /* nop */ };

			ba.position = 0;

			str = ba.readUTFBytes(i - 1);

			return str;
		}

		//
		public static function read_recordHeader(ba:ByteArray):RecordHeader {
			ba.position = 0;
			var b:uint = ba.readUnsignedShort();
			var bStr:String = SwfUtils.value2bin(b, 16);

			var tagID:uint = parseInt(bStr.substr(0, 10), 2);
			var tagLength:uint = parseInt(bStr.substr(10, 6), 2);

			var tagSL:Boolean = false;

			if(tagLength >= 63) {
				tagSL = true;
				tagLength = ba.readUnsignedInt();
			}

			return new RecordHeader(tagID, tagLength, tagSL);
		}

		//
		public static function write_tagHeader(tagID:uint, tagLength:uint, forceLongTag:Boolean = false):ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		//
		public static function isEdgeRecord(value:uint, bitOffset:uint = 0):Boolean {
			var binStr:String = SwfUtils.value2bin(value, 8);
			return binStr.charAt(bitOffset) == "1" ? true : false;
		}

		//
		public static function isStraightEdgeRecord(value:uint, bitOffset:uint = 0):Boolean {
			var binStr:String = SwfUtils.value2bin(value, 8);

			if(binStr.charAt(bitOffset) == "0") return false; // not an
			return binStr.charAt(bitOffset + 1) == "1" ? true : false;
		}

		//
		public static function isEndShapeRecord(sr:String):Boolean {
			return sr.substring(0, 6) == "000000" ? true : false;
		}

		//
		public static function fixJpeg(ba:ByteArray):ByteArray {

				var i:uint = 0;
				var jpegData:ByteArray = new ByteArray
				var EOI:uint = 0xffd9;

				ba.position = 0;
				var bCount:uint = ba.length -2;
				var tableMarker:int = -1;

				for(i = 0; i < bCount; i += 2){

					var cmp:uint = ba.readUnsignedShort();

					if(cmp == EOI) {
						ba.position = 0;
						tableMarker = i;
						break;
					}
				}

				ba.position = 0;

				if(tableMarker > -1){ // jpegTableMisc + jpegImage

					jpegData.writeBytes(ba, 0, tableMarker);
					jpegData.writeBytes(ba, tableMarker + 4);
					jpegData.position = 0;

					return jpegData;
				}
			else return ba;		// regular jpegData
		}
	}
}