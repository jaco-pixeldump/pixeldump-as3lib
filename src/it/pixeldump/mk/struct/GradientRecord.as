/**
 * @author jaco
 */
package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class GradientRecord {

		public var tagID:uint = Constants.SHAPE_ID;

		public var ratio:uint;		// UI8 Ratio value
		public var color:Color;		// RGB (Shape1 or Shape2) Color of gradient
		      						// RGBA (Shape3)


		public function get length():uint {

			if(tagID >= Constants.SHAPE_ID3) return 5;

			return 4;
		}

		function GradientRecord(tagID:uint = Constants.SHAPE_ID) {
			this.tagID = tagID;
		}

		public function toByteArray():ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeByte(ratio)

			var cBA:ByteArray = new ByteArray();

			if(tagID >= Constants.SHAPE_ID3){
				cBA = color.toRGBAByteArray();
			}
			else cBA = color.toRGBByteArray();

			cBA.position = 0;
			ba.writeBytes(cBA);
			ba.position = 0;

			return ba;
		}


		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint {

			ba.position = offset;
			ratio = ba.readUnsignedByte();

			var rgbLimit:Boolean = tagID >= Constants.SHAPE_ID3 ? false : true;

			color = new Color();
			color.tagID = tagID;
			color.fromByteArray(ba, offset + 1, rgbLimit);

			return tagID >= Constants.SHAPE_ID3 ? 4 : 3;
		}
	}
}