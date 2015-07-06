package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class FillStyle {


		private var _tagID:uint = Constants.SHAPE_ID;
		private var _lengthFromByteArray:uint = 0;

		private var _color:Color;

		public var type:uint = Constants.SOLID_FILL;
		public var gradientMatrix:MKMatrix;
		public var gradient:Gradient;
		public var bitmapID:uint;
		public var bitmapMatrix:MKMatrix;

		public function set tagID(value:uint):void {

			if(_tagID == value) return;

			_tagID = value;

			if(_color) _color.tagID = _tagID;
		}

		public function get tagID():uint {
			return _tagID;
		}

		//
		public function set color(value:Color):void {

			if(value.alpha != 0xFF) _tagID = Constants.SHAPE_ID3;

			_color = value;
		}

		public function get color():Color { return _color; }


		// returns FILLSTYLE byte length
		public function get length():uint{

			var fsLength:uint = 1;

			if(type == Constants.SOLID_FILL) {
				fsLength += 3;

				if(tagID == Constants.SHAPE_ID3) fsLength++;
			}
			else if(type == Constants.LINEAR_GRADIENT_FILL ||
					type == Constants.RADIAL_GRADIENT_FILL) {

				fsLength += gradientMatrix.length;
				fsLength += gradient.length;
			}
			else if(type == Constants.REPEATING_BITMAP_FILL ||
					type == Constants.CLIPPED_BITMAP_FILL ||
					type == Constants.NS_BITMAP_FILL ||
					type == Constants.NS_CLIPPED_BITMAP_FILL) {

				fsLength += 2;
				fsLength += bitmapMatrix.length;
			}

			return fsLength;
		}


		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}

		// the constructor
		function FillStyle(tagID:uint = Constants.SHAPE_ID){
			_tagID = tagID;
		}

		// drawFromCenter flag set to move default gradient
		// using center origin instead left,top coord
		public function build_gradientMatrix(gm:Rectangle, drawFromCenter:Boolean = false, rotation:Number = 0):void {

				var mTwips:uint = 32768;
				gradientMatrix = new MKMatrix();

				var px:Number = gm.x;
				var py:Number = gm.y;

				if(type == Constants.LINEAR_GRADIENT_FILL){

					px = gm.x;
					py = gm.y;

					if(!drawFromCenter) {
						px += gm.width / 2;
						py += gm.height / 2;
					}
				}

				//gradientMatrix.set_position(px, py);
				var twipWidth:int = SwfUtils.toTwip(gm.width);
				var twipHeight:int = SwfUtils.toTwip(gm.height);

				var scalex:Number = 1;
				var scaley:Number = 1;

				if(twipWidth)  scalex = 100 / Math.round(mTwips / twipWidth);
				if(twipHeight) scaley = 100 / Math.round(mTwips / twipHeight);

				//gradientMatrix.set_scale(scalex, scaley);

				//if(rotation) gradientMatrix.set_rotation(rotation);
		}

		//
		public function set_bitmapMatrix(bitmapMatrix:Object, bitmapID:uint = 0):void {

			if(bitmapID) this.bitmapID = bitmapID;

			bitmapMatrix = new MKMatrix();

			// x and y field must be set
			var x:Number = (bitmapMatrix.x) ? bitmapMatrix.x : 0;
			var y:Number = (bitmapMatrix.y) ? bitmapMatrix.y : 0;

			if(x || y ) {
				bitmapMatrix.set_position(bitmapMatrix.x, bitmapMatrix.y);
			}

			var sx:Number = 1;
			var sy:Number = 1;

			sx = (bitmapMatrix.scaleX) ? bitmapMatrix.scaleX : 1;
			sy = (bitmapMatrix.scaleY) ? bitmapMatrix.scaleY : 1;

			bitmapMatrix.set_scale(sx * 2000, sy * 2000, true);

			//if(bitmapMatrix.rotation) this.bitmapMatrix.set_rotation(bitmapMatrix.rotation);
		}

		//
		public function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		// NOTE: be care to provide correct tagID FIRST
		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint{

			var initialOffset:uint = offset;
			ba.position = offset;

			type = ba.readUnsignedByte();
			offset++;

			trace("FillStyle, type:", type);

			if(type >= Constants.REPEATING_BITMAP_FILL){

				trace("evaluating bitmap fill");

				bitmapID = ba.readUnsignedShort();
				offset += 2;

				trace("bitmapID:", bitmapID);

				bitmapMatrix = new MKMatrix();

				offset += bitmapMatrix.fromByteArray(ba, offset);
			}
			else if(type >= Constants.LINEAR_GRADIENT_FILL){

				trace("evaluating gradient fill");

				gradientMatrix = new MKMatrix();
				offset += gradientMatrix.fromByteArray(ba, offset);

				gradient = new Gradient(type, _tagID);
				offset += gradient.fromByteArray(ba, offset);
			}
			else {

				trace("evaluating fill color");

				_color = new Color();
				_color.tagID = _tagID;

				var rgbLimit:Boolean = true;

				if(_tagID > Constants.SHAPE_ID2) rgbLimit = false;

				_color.fromByteArray(ba, offset, rgbLimit);

				offset += 3 + (rgbLimit ? 0 : 1);
			}

			_lengthFromByteArray = offset - initialOffset;

			return _lengthFromByteArray;
		}
	}
}