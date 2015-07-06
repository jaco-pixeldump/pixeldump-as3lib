
package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;

	public class Rect {

		private var _lengthFromByteArray:uint = 0;
		// members are always expressed in twips
		public var xmin:Number;
		public var ymin:Number;
		public var xmax:Number;
		public var ymax:Number;

		public function get length():uint {
			var minBits:uint = SwfUtils.find_minBits(xmin, xmax, ymin, ymax);
			var bitLength:int = 5 + minBits * 4;
			return Math.ceil(bitLength / 8);
		}

		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}

		public function get rectangle():Rectangle {
			var x:Number = SwfUtils.fromTwip(xmin);
			var y:Number = SwfUtils.fromTwip(ymin);
			var width:Number = SwfUtils.fromTwip(xmax - xmin);
			var height:Number = SwfUtils.fromTwip(ymax - ymin);

			return new Rectangle(x, y, width, height);
		}

		function Rect(xmin:Number = 0, xmax:Number = 0, ymin:Number = 0, ymax:Number = 0, requireTwip:Boolean = true){

			if(requireTwip){
				this.xmin = SwfUtils.toTwip(xmin);
				this.xmax = SwfUtils.toTwip(xmax);
				this.ymin = SwfUtils.toTwip(ymin);
				this.ymax = SwfUtils.toTwip(ymax);
			}
			else {
				this.xmin = xmin;
				this.xmax = xmax;
				this.ymin = ymin;
				this.ymax = ymax;
			}
		}

		public function toByteArray():ByteArray {

			var binStr:String = "";

			var minBits:uint = SwfUtils.find_minBits(xmin, xmax, ymin, ymax);

			binStr = SwfUtils.value2bin(minBits, 5);
			binStr += SwfUtils.value2bin(xmin, minBits);
			binStr += SwfUtils.value2bin(xmax, minBits);
			binStr += SwfUtils.value2bin(ymin, minBits);
			binStr += SwfUtils.value2bin(ymax, minBits);

			var rectBitLength:int = Math.ceil((5 + minBits * 4) / 8) * 8;
			var padLength:int = rectBitLength - binStr.length;
			var padStr:String = "";

			for(var i:int = 0; i < padLength; i++) padStr += "0";

			binStr += padStr;

			return SwfUtils.get_byteArray_from_string(binStr);
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint {

			var initialOffset:uint = offset;
			ba.position = offset;
			var binStr:String = SwfUtils.toBinString(ba, offset, Constants.MAX_RECT_LENGTH);

			var offset:uint = 0;
			var nBits:uint = parseInt(binStr.substr(offset, 5), 2);
			offset += 5;

			xmin = SwfUtils.binStrToInt(binStr.substr(offset, nBits));
			offset += nBits;

			xmax = SwfUtils.binStrToInt(binStr.substr(offset, nBits));
			offset += nBits;

			ymin = SwfUtils.binStrToInt(binStr.substr(offset, nBits));
			offset += nBits;

			ymax = SwfUtils.binStrToInt(binStr.substr(offset, nBits));
			offset += nBits;

			_lengthFromByteArray = Math.ceil((5 + nBits * 4) / 8);

			return _lengthFromByteArray;
		}
	}
}