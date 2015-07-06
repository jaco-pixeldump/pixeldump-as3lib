
package it.pixeldump.mk.struct {

	import flash.utils.*;

	import it.pixeldump.mk.*;

	public class StraightEdgeRecord {

		public static const TYPE_FLAG:uint = 1;		// UB[1]
		public static const STRAIGHT_FLAG:uint = 1;	// UB[1]
		public static const RECORD_TYPE:String = "straightEdgeRecord";

		private var _bitLengthFromByteArray:uint = 0;

		//public var nBits:uint = 0;					// UB[4] + 2
		public var generalLineFlag:Boolean;		// UB[1]
		public var deltaX:int;
		public var deltaY:int;
		public var verticalFlag:Boolean;			// UB[1] vert/hor line

		public function get nBits():uint {
			return SwfUtils.find_minBits(deltaX, deltaY) - 2;
		}

		public function get bitLengthFromByteArray():uint {
			return _bitLengthFromByteArray;
		}

		// the constructor
		function StraightEdgeRecord(dx:int = 0, dy:int = 0){
			update_coords(dx, dy);
		}

		// set flags
		// general line or orthogonal
		// vertical/horizontal line
		private function update_flags():void {

			generalLineFlag = false;
			verticalFlag = false;

			if(deltaX && deltaY) generalLineFlag = true;
			else if(deltaY) verticalFlag = true;
		}

		// update deltaX and nBits
		public function update_deltaX(x:int, inTwips:Boolean = false):void{
			deltaX = inTwips ? x : SwfUtils.toTwip(x);
		}

		// update deltaY and nBits
		public function update_deltaY(y:int, inTwips:Boolean = false):void{

			deltaY = inTwips ? y : SwfUtils.toTwip(y);
		}

		public function update_coords(x:int, y:int, inTwips:Boolean = false):void{
			deltaX = inTwips ? x : SwfUtils.toTwip(x);
			deltaY = inTwips ? y : SwfUtils.toTwip(y);
		}

		public function toByteArray():ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			/* TODO */

			return ba;
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0, bitOffset:uint = 0):uint{

			trace("StraightEdgeRecord from byte array");

			var maxBitLength:uint = bitOffset + 41;
			ba.position = offset;

			deltaX = 0;
			deltaY = 0;
			generalLineFlag = false;
			verticalFlag = false;

			var baLength:uint = Math.min(ba.length - offset, Math.ceil(maxBitLength / 8));
			trace("maxBitLength:", maxBitLength);
			var binStr:String = SwfUtils.toBinString(ba, offset, baLength).substring(bitOffset);

			var localNBits:uint = parseInt(binStr.substr(2, 4), 2) + 2;
			var ofst:uint = 6;

			generalLineFlag = (binStr.charAt(ofst) == "1") ? true : false;
			ofst++;

			if(generalLineFlag){

				deltaX = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
				ofst += localNBits;

				deltaY = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
				ofst += localNBits;

				trace("general line, dx, dy:", deltaX, deltaY);
			}
			else {

				verticalFlag = (binStr.charAt(++ofst) == "1") ? true : false;

				if(verticalFlag){
					deltaY = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
					trace("vertical line, dy:", deltaY);
				}
				else {
					deltaX = SwfUtils.binStrToInt(binStr.substr(ofst, localNBits));
					trace("horizontal line, dx:", deltaX);
				}

				ofst += localNBits;
			}

			_bitLengthFromByteArray = ofst;

			return _bitLengthFromByteArray;
		}
	}
}