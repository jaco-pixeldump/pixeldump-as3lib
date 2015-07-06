

package it.pixeldump.mk.struct {

	import flash.utils.*;

	import it.pixeldump.mk.*;

	public class CurvedEdgeRecord {

		public static const TYPE_FLAG:uint = 1;		// UB[1]
		public static const STRAIGHT_FLAG:uint = 0;	// UB[1]
		public static const RECORD_TYPE:String = "curvedEdgeRecord";

		private var _bitLengthFromByteArray:uint = 0;

		//public var nBits:uint = 0;			// UB[4] + 2
		public var cx:int;					// control Delta X
		public var cy:int;					// control Delta Y
		public var ax:int;					// anchor Delta X
		public var ay:int;					// anchor Delta Y

		public function get nBits():uint {
			return SwfUtils.find_minBits(cx, cy, ax, ay) - 2;
		}

		public function get bitLengthFromByteArray():uint {
			return _bitLengthFromByteArray;
		}

		// the constructor
		function CurvedEdgeRecord(cx:uint = 0, cy:uint = 0, ax:uint = 0, ay:uint = 0, requireTwips:Boolean = true){
			update_coords(cx, cy, ax, ay, requireTwips);
		}

		public function toByteArray():ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			/* TODO */

			return ba;
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0, bitOffset:uint = 0):uint{

			trace("CurvedEdgeRecord from byte array");

			ba.position = offset;

			var baLength:uint = Math.ceil((bitOffset + Constants.MAX_CURVEDEDGE_BIT_LENGTH) / 8);
			baLength = Math.min(baLength, ba.length - offset);

			trace("baLength, bitOffset", baLength, bitOffset);
			var binStr:String = SwfUtils.toBinString(ba, offset, baLength).substring(bitOffset);

			var localNBits:uint = parseInt(binStr.substr(2, 4), 2) + 2;
			var ofst:uint = 6;

			cx = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
			ofst += localNBits;

			cy = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
			ofst += localNBits;

			ax = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
			ofst += localNBits;

			ay = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
			ofst += localNBits;

			trace("ax, ay, cx, cy:", ax, ay, cx, cy);

			_bitLengthFromByteArray = ofst;

			return _bitLengthFromByteArray;
		}

		// update class members
		public function update_coords(cX:Number, cY:Number, aX:Number, aY:Number, inTwips:Boolean = false):void{

			if(!inTwips){
				cx = SwfUtils.toTwip(cX);
				cy = SwfUtils.toTwip(cY);
				ax = SwfUtils.toTwip(aX);
				ay = SwfUtils.toTwip(aY);
			}
			else {
				cx = cX;
				cy = cY;
				ax = aX;
				ay = aY;
			}
		}

		// return CURVEDEDGERECORD bit Length
		public function get_bitLength():uint{
			return 6 + (nBits + 2) * 4;
		}
	}
}


