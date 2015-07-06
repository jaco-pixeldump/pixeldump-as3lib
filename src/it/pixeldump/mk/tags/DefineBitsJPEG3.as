
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;


	public class DefineBitsJPEG3 extends DefineBitsJPEG2 {

		public override function get CLASS_NAME():String{
			return "DefineBitsJPEG3";
		}

		private var ld:Loader;

		public var rawImage:ByteArray;
		public var alphaDataOffset:uint;
		public var bitmapAlphaData:ByteArray;
		public var width:int;
		public var height:int;

		function DefineBitsJPEG3(){

		}

		public function getBaseImageAsJPEG():ByteArray {
			return jpegData;
		}

		public override function getImageAsJPEG():ByteArray {

			rawImage.position = 0;
			//var png:PNGEncoder = new PNGEncoder();
			//return png.encodeByteArray(rawImage, width, height, true);
			return null;
		}

		public function getAlphaPNG():ByteArray {
			return new ByteArray(); /* TODO: implement */
		}

		//
		//public override function toByteArray():ByteArray{

		//	var ba:ByteArray = new ByteArray();
		//	ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

		//	return ba;
		//}

		public override function fromByteArray(ba:ByteArray):void {

			super.fromByteArray(ba);

			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			alphaDataOffset = ba.readUnsignedInt();

			offset += 6;

			jpegData = new ByteArray();
			bitmapAlphaData = new ByteArray();
			var tmpJpegData:ByteArray = new ByteArray();

			tmpJpegData.writeBytes(ba, offset, alphaDataOffset);
			tmpJpegData.position = 0;
			jpegData = SwfUtils.fixJpeg(tmpJpegData);
			jpegData.position = 0;

			bitmapAlphaData.writeBytes(ba, offset+ alphaDataOffset);
			bitmapAlphaData.uncompress();

			ld = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete);
			ld.loadBytes(jpegData);
		}

		private function onImageComplete(evt:Event):void {

			bitmapAlphaData.position = 0;
			rawImage = new ByteArray();
			var bmp:Bitmap = Bitmap(ld.content);
			width = ld.contentLoaderInfo.width;
			height = ld.contentLoaderInfo.height;

			for(var y:uint = 0; y < height; y++){

				for(var x:uint = 0; x < width; x++){

					var alpha:uint = bitmapAlphaData.readUnsignedByte();
					var diff:uint = 0xFF - alpha;

					rawImage.writeByte(alpha);

					var pixel:uint = bmp.bitmapData.getPixel(x, y);
					var red:uint = (pixel >> 0x10) + diff;
					var green:uint = ((pixel >> 0x08) & 0xFF) + diff;
					var blue:uint = (pixel & 0xFF) + diff;

					rawImage.writeByte(Math.min(red, 0xFF));
					rawImage.writeByte(Math.min(green, 0xFF));
					rawImage.writeByte(Math.min(blue, 0xFF));
				}
			}

			rawImage.position = 0;
		}
	}
}