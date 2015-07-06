/**
 * @author jaco
 */

package it.pixeldump.mk {

	import flash.utils.*;

	public class StringUtils {

		public static const PAD_LEFT:String = "padLeft";
		public static const PAD_RIGHT:String = "padRight";

		function StringUtils() {}

		// hex dump
		public static function hex_dump(ba:ByteArray, lowerLimit:int = 0, byteLength:int = 1024):String {

			ba.position = 0;
			if(lowerLimit > ba.length) return "";

			if(byteLength)
				byteLength = Math.min(ba.length - lowerLimit, byteLength);
			else
				byteLength = ba.length - lowerLimit;

			var hexBA:ByteArray = new ByteArray();
			hexBA.writeBytes(ba, lowerLimit, byteLength);
			hexBA.position = 0;

			var hexStr:String = "";
			var ch:int;



			for(var i:int = 0; i < hexBA.length; i++){
				ch = hexBA.readUnsignedByte();
				hexStr += StringUtils.toHex(ch) +" ";

				if(i && !(i % 16)) hexStr += "\n";
			}

			return hexStr;
		}


		public static function toHex(val:int, numDigits:uint = 2, includeMarker:Boolean = false):String {

			var hexStr:String = str_pad(val.toString(16), "0", numDigits).toUpperCase();

			return includeMarker ? "0x" + hexStr : hexStr;
		}

		//
		public static function str_pad(str:String, padChar:String, padTotal:uint, padType:String = StringUtils.PAD_LEFT):String {

			var padStr:String = "";

			if(padTotal < str.length) return str;

			var numPad:int = padTotal - str.length;

			for(var i:int = 0; i < numPad; i++) padStr += padChar;

			if(padType == StringUtils.PAD_RIGHT) return str + padStr;

			return padStr +str;
		}
	}
}