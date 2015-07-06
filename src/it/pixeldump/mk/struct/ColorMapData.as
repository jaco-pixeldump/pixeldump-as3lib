
package it.pixeldump.mk.struct {


	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;
	//import it.os.adobe.codec.*;


	public class ColorMapData {

		public var tagID:uint;
		public var width:uint;
		public var height:uint;
		public var colorTableSize:uint;
		public var colorTableRGB:Array;
		public var colorMapPixelData:Array;

		function ColorMapData(tagID:uint, width:uint, height:uint, colorTableSize:uint){

			this.tagID = tagID;
			this.width = width;
			this.height = height;
			this.colorTableSize = colorTableSize;
			colorTableRGB = new Array();
			colorMapPixelData = new Array();

			trace("width:", width);
			trace("height:", height);
			trace("colorTableSize:", colorTableSize);
		}

		public function fromByteArray(ba:ByteArray):void {

			var i:uint;
			var j:uint;
			var ch:uint;
			var color:Color;

			colorTableRGB = new Array();
			colorMapPixelData = new Array();
			ba.position = 0;

			var argbFlag:Boolean = Constants.getTagNameFromTagID(tagID) == Constants.IMAGE_LOSSLESS_ALPHA ? true : false;

			trace("colormap has alpha:", argbFlag);

			for(i = 0; i < colorTableSize; i++){

				var alpha:uint = 0xFF;

				var red:uint = ba.readUnsignedByte();
				var green:uint = ba.readUnsignedByte();
				var blue:uint = ba.readUnsignedByte();

				if(argbFlag) alpha = ba.readUnsignedByte();

				color = new Color(red, green, blue, alpha);

				//trace("color #" +i, red, green, blue, alpha);

				colorTableRGB.push(color);
			}

			var offset:uint = colorTableSize * (argbFlag ? 4 : 3); //
			var imageSize:uint = width * height;

			trace("ba pixels available:", ba.length - offset);
			var paddedWidth:uint = Math.ceil(width / 4) * 4;

			for(i = 0; i < height; i++){

				for(j = 0; j < width; j++){

					ch = ba.readUnsignedByte();

					if(ch > colorTableSize) trace("colorTableSize exceeded:", ch, (i * j));

					colorMapPixelData.push(ch);
				}

				ba.position = offset + i * paddedWidth;
			}
		}

		public function getImageData():ByteArray {

			var argbFlag:Boolean = Constants.getTagNameFromTagID(tagID) == Constants.IMAGE_LOSSLESS_ALPHA ? true : false;

			var i:uint;
			var rgb:Color;
			var argb:Color;
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var imageSize:uint = width * height;
			var colorIndex:uint;

			trace("pixels:", colorMapPixelData.length);

			//if(argbFlag){

				for each(colorIndex in colorMapPixelData){

					argb = colorTableRGB[colorIndex];
					var argbBA:ByteArray = argb.toRGBAByteArray();
					ba.writeBytes(argbBA);
				}
			//}
			//else {

			//	for each(colorIndex in colorMapPixelData){

			//		rgb = colorTableRGB[colorIndex];
			//		var rgbBA:ByteArray = rgb.toRGBByteArray();
			//		ba.writeBytes(rgbBA);
			//	}
			//}

			trace("pixeldata size:", ba.length);

			ba.position = 0;
			return ba;
		}
	}
}
