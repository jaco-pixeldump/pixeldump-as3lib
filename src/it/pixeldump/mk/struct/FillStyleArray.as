package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class FillStyleArray {

		private var _tagID:uint;
		private var _lengthFromByteArray:uint = 0;

		public var fillStyles:Array; // fill styles

		public function set tagID(value:uint):void {

			if(_tagID == value) return;

			_tagID = value;

			for each(var fillStyle:FillStyle in fillStyles)
				fillStyle.tagID = _tagID;
		}

		public function get tagID():uint {
			return _tagID;
		}

		public function get fillStylesCount():uint {
			return fillStyles.length;
		}

		// byte length
		public function get length():uint {
			var fsLength:uint = fillStyles.length >= 256 ? 3 : 1;

			for each(var fStyle:FillStyle  in fillStyles) fsLength += fStyle.length;

			return fsLength;
		}

		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}


		// the constructor
		function FillStyleArray(tagID:uint = Constants.SHAPE_ID) {

			_tagID = tagID;

			trace("fillStyleArray, tagid", _tagID);

			fillStyles = new Array();
		}

		//
		public function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}


		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint{

			fillStyles = new Array();

			var initialOffset:uint = offset;
			ba.position = offset;
			var fsCount:uint = ba.readUnsignedByte();
			offset++;

			trace("count of fillStyles:", fsCount);

			if(!fsCount) return 1;

			if(fsCount == 0xFF) {
				fsCount = ba.readUnsignedShort();
				offset += 2;
			}

			for(var i:int = 0; i < fsCount; i++){

				var fStyle:FillStyle = new FillStyle(_tagID);
				offset += fStyle.fromByteArray(ba, offset);
				fillStyles.push(fStyle);
			}

			_lengthFromByteArray = offset - initialOffset;

			trace("FillStyleArray, _lengthFromByteArray:", _lengthFromByteArray);

			return _lengthFromByteArray;
		}

		// return fillStyle object at given index
		// note that fsIndex must be referenced from 1
		// as intended by swf specification
		public function get_fillStyleAt(fsIndex:uint):FillStyle {
			return fillStyles[fsIndex];
		}

		//
		public function add_fillStyle_solid(color:Color):uint{

			var fsi:uint = fillStyles.length;

			if(color.alpha != 0xFF) _tagID = Constants.SHAPE_ID3;

			var fsDup:uint = find_duplicated_fillStyle_solid(color);

			if(fsDup) return fsDup; // avoid to add a lineStyle duplicate

			fillStyles[fsi] = new FillStyle(_tagID);
			fillStyles[fsi].set_fillStyleType(Constants.SOLID_FILL);
			fillStyles[fsi].color = color;

			return ++fsi; // fillStyle added, return its index starting from 1
		}

		//
		public function add_fillStyle(fillStyle:FillStyle):uint{

			var fsi:uint = fillStyles.length;
			fillStyles[fsi] = fillStyle;

			return ++fsi;
		}

		//
		private function find_duplicated_fillStyle_solid(color:Color):uint{

			var fsDup:uint = 0;
			var fsCount:uint = fillStyles.length;

			for(var i:uint = 0; i < fsCount; i++){

				var fillStyle:FillStyle = fillStyles[i];

				if(fillStyle.type != Constants.SOLID_FILL) continue;

				if(fillStyle.color.equals(color)){
					fsDup = i + 1;
					break;
				}
			}

			return fsDup;
		}
	}
}