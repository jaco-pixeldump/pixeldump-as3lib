

package it.pixeldump.mk.struct {

	import flash.utils.*;

	import it.pixeldump.mk.*;

	public class Color {

		public var tagID:uint = Constants.SHAPE_ID;
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public var alpha:uint;

		function Color(red:uint = 0, green:uint = 0, blue:uint = 0, alpha:uint = 0xFF){

			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;

			if(this.alpha < 0xFF) tagID = Constants.SHAPE_ID3;
		}

		public function fromString(col:String = "#000000", cAlpha:uint = 0xff, useAlpha:Boolean = false):void {

			if(col.charAt(0) == "#") col = col.substring(1);

			var c:uint = parseInt(col);

			red = c >> 0x10;
			green = (c >> 0x08) & 0xFF;
			blue = c & 0xFF;

			if(useAlpha || cAlpha <= 0xff){
				alpha = cAlpha;
				tagID = Constants.SHAPE_ID3;
			}
		}

		public function toString(includeAlpha:Boolean = true):String{

			var colorStr:String = "#";

			colorStr += StringUtils.str_pad(red.toString(16), "0", 2);
			colorStr += StringUtils.str_pad(green.toString(16), "0", 2);
			colorStr += StringUtils.str_pad(blue.toString(16), "0", 2);
			colorStr += StringUtils.str_pad(alpha.toString(16), "0", 2);

			return colorStr;
		}

		public function equals(color:Color):Boolean {

			var result:Boolean = false;

			if(red == color.red &&
			   green == color.green &&
			   blue == color.blue &&
			   alpha == color.alpha) result = true;

			return result;
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0, rgbLimit:Boolean = false):void {

			ba.position = offset;
			red = ba.readUnsignedByte();
			green = ba.readUnsignedByte();
			blue = ba.readUnsignedByte();

			if(!rgbLimit && ba.length + offset > 3) {
				alpha = ba.readUnsignedByte();
				tagID = Math.max(Constants.SHAPE_ID3, tagID);
			}

			trace("color, red:", red, "green:", green, "blue:", blue);
		}

		public function toHtmlString(useAlpha:Boolean = false):String {
			var htmlColor:String = "#";
			htmlColor += StringUtils.str_pad(red.toString(16).toUpperCase(), "0", 2);
			htmlColor += StringUtils.str_pad(green.toString(16).toUpperCase(), "0", 2);
			htmlColor += StringUtils.str_pad(blue.toString(16).toUpperCase(), "0", 2);

			if(useAlpha)
				htmlColor += StringUtils.str_pad(alpha.toString(16).toUpperCase(), "0", 2);

			return htmlColor;
		}

		public function toRGBByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();

			ba.writeByte(red);
			ba.writeByte(green);
			ba.writeByte(blue);

			ba.position = 0;

			return ba;
		}

		public function toARGBByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			ba.writeByte(alpha);
			ba.writeByte(red);
			ba.writeByte(green);
			ba.writeByte(blue);

			ba.position = 0;

			return ba;
		}

		public function toRGBAByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			ba.writeByte(red);
			ba.writeByte(green);
			ba.writeByte(blue);
			ba.writeByte(alpha);

			ba.position = 0;

			return ba;
		}
	}
}

