package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class LineStyle {

		private var _tagID:uint;
		protected var _lengthFromByteArray:uint = 0;

		public var width:int; // value is stored in twips
		public var color:Color;

		//
		public function set tagID(value:uint):void{

			if(_tagID == value) return;

			_tagID = value;

			if(color) color.tagID = _tagID;
		}

		// returns LINESTYLE bytes length
		public function get length():uint{
			return (_tagID == Constants.SHAPE_ID3) ? 6 : 5;
		}

		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}


		// the constructor
		function LineStyle(tagID:uint = Constants.SHAPE_ID, width:int = 0){
			_tagID = tagID;
			this.width = width;
			color = new Color();
		}

		//
		public function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;


			/* TODO */

			return ba;
		}

		// NOTE: provide correct tagID first
		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint{

			/* TODO test */
			var initialOffset:uint = offset;
			ba.position = offset;

			width = ba.readUnsignedShort();
			offset += 2;

			color = new Color();
			color.tagID = _tagID;

			var rgbLimit:Boolean = true;

			if(_tagID > Constants.SHAPE_ID2) rgbLimit = false;

			color.fromByteArray(ba, offset, rgbLimit);

			offset += 3 + (rgbLimit ? 0 : 1);

			_lengthFromByteArray = offset - initialOffset;

			return _lengthFromByteArray;
		}

	}
}