
package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;

	public class MKMatrix {

		private var _lenghtFromByteArray:uint = 0;

		// | a b tx |
		// | c d ty |
		// | 0 0 1  |
		public var matrix:Matrix;

		public function get length():uint {

			/* TODO */

			return 0;
		}

		public function get lengthFromByteArray():uint {
			return _lenghtFromByteArray;
		}

		function MKMatrix(){
			matrix = new Matrix();
		}

		public function toByteArray():ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}


		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint {

			/* TODO test */

			ba.position = offset;

			matrix = new Matrix();
			var ch:uint = ba.readUnsignedByte();

			var scaleY:Number;
			var scaleX:Number;

			var rotateSkew0:Number;
			var rotateSkew1:Number;

			var translateX:int;
			var translateY:int;

			if(!ch) { // matrix is empty

				trace("matrix is empty");

				matrix.a = matrix.b = matrix.c = matrix.d = 0;
				matrix.tx = matrix.ty = 0;
				return 1;
			}

			var bLength:uint = Math.min(Constants.MAX_MATRIX_LENGTH, ba.length - offset);
			var binStr:String = SwfUtils.toBinString(ba, offset, bLength);

			// trace("binStr:", binStr);

			var bOffset:uint = 1;

			if(binStr.charAt(0) == "1"){ // scale

				var nScaleBits:uint = parseInt(binStr.substr(bOffset, 5), 2);

				bOffset += 5;
				offset = Math.ceil((6 + nScaleBits * 2) / 8);

				scaleX = SwfUtils.fpBinStrToFloat(binStr.substr(bOffset, nScaleBits));
				bOffset += nScaleBits;

				scaleY = SwfUtils.fpBinStrToFloat(binStr.substr(bOffset, nScaleBits));
				bOffset += nScaleBits;

				trace("has scale, nbits, sx, sy", nScaleBits, scaleX, scaleY);

				matrix.a = scaleX;
				matrix.d = scaleY;
			}

			bOffset++;

			if(binStr.charAt(bOffset - 1) == "1") { // rotate

				var nRotateBits:uint = parseInt(binStr.substr(bOffset, 5), 2);
				bOffset += 5;

				rotateSkew0 = SwfUtils.fpBinStrToFloat(binStr.substr(bOffset, nScaleBits));
				bOffset += nRotateBits;

				rotateSkew1 = SwfUtils.fpBinStrToFloat(binStr.substr(bOffset, nScaleBits));
				bOffset += nRotateBits;

				trace("has rotate, nbits, skew0, skew1", nRotateBits, rotateSkew0, rotateSkew1);

				matrix.b = rotateSkew0;
				matrix.c = rotateSkew1;
			}

			var nTranslateBits:uint = parseInt(binStr.substr(bOffset, 5), 2);
			bOffset += 5;

			translateX = SwfUtils.binStrToInt(binStr.substr(bOffset, nTranslateBits));
			bOffset += nTranslateBits;

			translateY = SwfUtils.binStrToInt(binStr.substr(bOffset, nTranslateBits));
			bOffset += nTranslateBits;

			trace("translate, nbits, tx, ty", nRotateBits, translateX, translateY);

			matrix.tx = translateX;
			matrix.ty = translateY;

			_lenghtFromByteArray = Math.ceil(bOffset / 8);

			trace("matrix length:", _lenghtFromByteArray);

			return _lenghtFromByteArray;
		}
	}
}