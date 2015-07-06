
package it.pixeldump.mk.struct {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class LineStyleArray {

		private var _tagID:uint;
		private var _lengthFromByteArray:uint = 0;

		public var lineStyles:Array; // line styles

		public function set tagID(value:uint):void {

			if(_tagID == value) return;

			_tagID = value;

			for each(var lineStyle:LineStyle in lineStyles)
				lineStyle.tagID = _tagID;
		}

		public function get tagID():uint {
			return _tagID;
		}

		public function get lineStylesCount():uint {
			return lineStyles.length;
		}

		public function length():uint {
			var lsLength:uint = 1;

			if(lineStyles.length >= 256) lsLength += 2;

			for each(var lStyle:LineStyle in lineStyles) lsLength += lStyle.length;

			return lsLength;
		}

		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}


		// the constructor
		function LineStyleArray(tagID:uint = Constants.SHAPE_ID){

			_tagID = tagID;
			lineStyles = new Array();
		}


		//
		public function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint {

			/* TODO test */

			trace("lineStyleArray");

			lineStyles = new Array();
			var initialOffset:uint = offset;
			ba.position = offset;

			var lsCount:uint = ba.readUnsignedByte();
			offset++;

			trace("lsCount:", lsCount);

			if(!lsCount) return 1;

			if(lsCount == 0xFF) {
				lsCount = ba.readUnsignedShort();
				offset += 2;
			}

			for(var i:int = 0; i < lsCount; i++){

				if(_tagID == Constants.SHAPE_ID4){
					var lStyle2:LineStyle2 = new LineStyle2();
					offset += lStyle2.fromByteArray(ba, offset);
					lineStyles.push(lStyle2);

				} else {
					var lStyle:LineStyle = new LineStyle(_tagID);
					offset += lStyle.fromByteArray(ba, offset);
					lineStyles.push(lStyle);
				}
			}

			_lengthFromByteArray = offset - initialOffset;

			return _lengthFromByteArray;
		}

		//
		private function find_duplicated_lineStyle(lineWidth:uint, color:Color):uint{

			var lsDup:uint = 0;

			var lsCount:uint = lineStyles.length;

			for(var i:uint = 0; i < lsCount; i++){

				var lineStyle:LineStyle = lineStyles[i];

				if(lineStyle.width == lineWidth && lineStyle.color.equals(color)){
					lsDup = i + 1;
					break;
				}
			}

			return lsDup;
		}

		// return lineStyle object at given index
		// note that lsIndex must be referenced from 1
		// as intended by swf specification
		public function get_lineStyleAt(lsIndex:uint):LineStyle {
			return lineStyles[lsIndex];
		}

		//
		public function add_lineStyle(lineWidth:Number, color:Color):uint{

			var lCount:uint = lineStyles.length;

			if(color.alpha != 0xFF) _tagID = Constants.SHAPE_ID3;

			var lw:uint = SwfUtils.toTwip(lineWidth);
			var lsDup:uint = find_duplicated_lineStyle(lw, color);

			if(lsDup) return lsDup; // avoid to add a lineStyle duplicate

			lineStyles[lCount] = new LineStyle(_tagID, lineWidth);
			lineStyles[lCount].color = color;
			lineStyles[lCount].lineWidth = lw;
			lCount++;

			return lCount; // lineStyle added, return its index starting from 1
		}

		// returns LINESTYLEARRAY bytes length
		public function get_length():uint {

			var length:uint = 1;

			if(!lineStyles.length) return length;
			if(lineStyles.length >= 0xFF) length += 2;

			length += lineStyles.length * lineStyles[0].get_length();

			return length;
		}
	}
}