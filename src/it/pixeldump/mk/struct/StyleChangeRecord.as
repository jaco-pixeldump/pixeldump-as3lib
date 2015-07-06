
package it.pixeldump.mk.struct {

	import flash.utils.*;

	import it.pixeldump.mk.*;

	public class StyleChangeRecord {

		public static const TYPE_FLAG:uint = 0; // non-egde record
		public static const RECORD_TYPE:String = "styleChangeRecord";

		private var _bitLengthFromByteArray:uint = 0;
		private var _tagID:uint;

		private var _stateNewStyles:Boolean = false;
		private var _stateLineStyle:Boolean = false;
		private var _stateFillStyle1:Boolean = false;
		private var _stateFillStyle0:Boolean = false;
		private var _stateMoveTo:Boolean = false;

		//public var nBitsMoveTo:uint = 0;
		private var _moveX:int = 0;						// moveto X in twips
		private var _moveY:int = 0;						// moveto Y in twips

		public var fillStyle0:uint;
		public var fillStyle1:uint;
		public var lineStyle:uint;

		//public var fsBits:uint; // fill Index bits
		//public var lsBits:uint; // line Index bits

		// this is in case of new fill/line style array
		public var fsArray:FillStyleArray;
		public var lsArray:LineStyleArray;

		public var fsBits:uint = 0;
		public var lsBits:uint = 0;

		// update tagID fsaData, lsaData, if present
		public function set tagID(value:uint):void {

			if(_tagID == value) return;

			_tagID = value;

			if(_stateNewStyles && fsArray && lsArray) {

				fsArray.tagID = _tagID;
				lsArray.tagID = _tagID;
			}
		}

		public function set moveX(value:int):void{

			//stateMoveTo = true;
			_moveX = value;
			//nBitsMoveTo = SwfUtils.find_minBits(moveX, moveY);
		}

		public function set moveY(value:int):void{
			_moveY = value;
			_stateMoveTo = true;
			//nBitsMoveTo = SwfUtils.find_minBits(moveX, moveY);
		}

		public function set stateMoveTo(value:Boolean):void {
			_stateMoveTo = value;
		}

		/*
		public function set stateNewStyles(value:Boolean):void {

			if(flagNewStyles == Constants.NO_STYLE){

				_stateNewStyles = false;
				_stateLineStyle = false;
				_stateFillStyle1 = false;
				_stateFillStyle1 = false;

				return;
			}

			if(flagNewStyles & Constants.HAS_NEW_STYLE) stateNewStyles = true;
			if(flagNewStyles & Constants.RIGHT_FILL) stateFillStyle1 =  true;
			if(flagNewStyles & Constants.LEFT_FILL) stateFillStyle0 =  true;
			if(flagNewStyles & Constants.LINE_STYLE) stateLineStyle =  true;
		}
		*/

		public function get bitLengthFromByteArray():uint {
			return _bitLengthFromByteArray;
		}


		// the constructor
		function StyleChangeRecord(tagID:uint = Constants.SHAPE_ID){
			_tagID = tagID;
		}


		public function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		// NOTE: if there is stateNewStyles, it must be provided fillBits and lineBits
		//       for correct reading
		public function fromByteArray(ba:ByteArray, offset:uint = 0, bitOffset:uint = 0, fillBits:uint = 0, lineBits:uint = 0):uint{

			/* TODO */

			var maxBitLengthBeforePad:uint = bitOffset + 73 + fillBits *  2+ lineBits;
			var baLength:uint = Math.min(ba.length - offset, Math.ceil(maxBitLengthBeforePad / 8));

			// trace("baLength:", baLength);
			// trace("Style change record, from byteArray, bitOffset", bitOffset);

			var binStr:String = SwfUtils.toBinString(ba, offset, baLength).substring(bitOffset);

			//trace("binStr:", binStr);

			_stateNewStyles = binStr.charAt(1) == "1" ? true : false;
			_stateLineStyle = binStr.charAt(2) == "1" ? true : false;
			_stateFillStyle1 = binStr.charAt(3) == "1" ? true : false;
			_stateFillStyle0 = binStr.charAt(4) == "1" ? true : false;
			_stateMoveTo = binStr.charAt(5) == "1" ? true : false;

			var ofst:uint = 6;

			if(_stateMoveTo){

				var nMoveBits:uint = parseInt(binStr.substr(ofst, 5), 2);
				ofst += 5;

				_moveX = SwfUtils.binStrToInt(binStr.substr(ofst, nMoveBits));
				ofst += nMoveBits;

				_moveY = SwfUtils.binStrToInt(binStr.substr(ofst, nMoveBits));
				ofst += nMoveBits;

				trace("moveTo, nMoveBits, moveX, moveY", nMoveBits, _moveX, _moveY);
			}

			if(_stateFillStyle0){
				fillStyle0 = parseInt(binStr.substr(ofst, fillBits), 2);
				ofst += fillBits;
				trace("fillStyle0:", fillStyle0);
			}

			if(_stateFillStyle1){
				fillStyle1 = parseInt(binStr.substr(ofst, fillBits), 2);
				ofst += fillBits;
				trace("fillStyle1:", fillStyle1);
			}

			if(_stateLineStyle){
				lineStyle = parseInt(binStr.substr(ofst, lineBits), 2);
				ofst += lineBits;
				trace("lineStyle:", lineStyle);
			}

			if(_stateNewStyles){
				trace("new styles");
				offset += Math.ceil((bitOffset + ofst) / 8);
				ofst += ofst % 8; // pad

				fsArray = new FillStyleArray(_tagID);
				var fsLength:uint = fsArray.fromByteArray(ba, offset);
				ofst += fsLength * 8;
				offset += fsLength;

				lsArray = new LineStyleArray(_tagID);
				var lsLength:uint = lsArray.fromByteArray(ba, offset);
				ofst += lsLength * 8;
				offset += lsLength;

				var chStr:String = SwfUtils.toBinString(ba, offset, 1);
				offset++;
				ofst += 8;

				fsBits = parseInt(chStr.substring(0, 4), 2);
				lsBits = parseInt(chStr.substring(4, 8), 2);

				trace("new fsBits:", fsBits);
				trace("new lsBits:", lsBits);
			}

			_bitLengthFromByteArray = ofst;

			trace("_bitLengthFromByteArray:", _bitLengthFromByteArray);

			return _bitLengthFromByteArray;
		}

		// returns a "first part" of stylechange record
		// even if contains statenewStyles
		// does not include padding bits nor fill or line style array
		public function get_binStr_before_pad():String{

			var binStr:String = "";

			/* TODO */

			return binStr;
		}

		// set moveTo options
		public function update_moveTo(mX:int, mY:int, inTwips:Boolean = true):void{
			_stateMoveTo = true;
			_moveX = inTwips ? mX : SwfUtils.toTwip(mX);
			_moveY = inTwips ? mY : SwfUtils.toTwip(mY);
			//nBitsMoveTo = SwfUtils.find_minBits(moveX, moveY);
		}

		// set "leftFill" options
		private function update_leftFill(lfsIndex:uint, fsLength:uint = 0):void{
			_stateFillStyle0 = true;
			//fsBits = SwfUtils.boundBits(fsLength);
			fillStyle0 = lfsIndex;
		}

		// set "rightFill" options
		private function update_rightFill(rfsIndex:uint, fsLength:uint = 0):void {
			_stateFillStyle1 = true;
			//fsBits = SwfUtils.boundBits(fsLength);
			fillStyle1 = rfsIndex;
		}

		// set "line" options
		private function update_lineStyle(lsIndex:uint, lsLength:uint = 0):void {
			//*-
			//trace_var("updating linestyle");
			//-*
			_stateLineStyle = true;
			//lsBits = 0;

			//if(lsLength) lsBits = SwfUtils.boundBits(lsLength);

			lineStyle = lsIndex;
		}

		// update binStr from a given bit offset
		// it may be useful when refreshing data
		// from preceeding shape record and when stylechange
		// has stateNewStyle
		public function update_binStr_from_offset(offset:uint):String{
			var binStr:String = "";

			/* TODO */
			return binStr;
		}

	}
}