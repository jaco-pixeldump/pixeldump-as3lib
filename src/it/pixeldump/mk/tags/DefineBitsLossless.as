

package it.pixeldump.mk.tags {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	import com.adobe.images.PNGEncoder;

	public class DefineBitsLossless extends Tag {

		public function get CLASS_NAME():String{
			return "DefineBitsLossless";
		}

		public var format:uint;					// UI8 - Format of compressed data
        										// 3 = 8-bit colormapped image
        										// 4 = 15-bit RGB image
        										// 5 = 24-bit RGB image
		public var width:uint					// UI16 Width of bitmap image
		public var height:uint;					// UI16 Height of bitmap image
		public var colorTableSize:uint;				// If BitmapFormat = 3, otherwise absent
		public var zlibBitmapData:ByteArray;	// image data in zlib format
		public var colorMapData:ByteArray;


		function DefineBitsLossless(){

		}

		public function getImageAsPNG():ByteArray {

			trace("getImageAsPNG");
			trace("tagLength:", tagLength)
			trace("format:", format);
			trace("zlibBitmapData length", zlibBitmapData.length);

			if(!zlibBitmapData) return null;

			var ba:ByteArray = new ByteArray();

			if(format > 3) {
				// FIXME
				//return PNGEncoder.encode(zlibBitmapData, width, height, true);
				return null;
			}

			var colorMapData:ColorMapData = new ColorMapData(tagID, width, height, colorTableSize + 1);
			colorMapData.fromByteArray(zlibBitmapData);
			//ba.endian = Endian.LITTLE_ENDIAN;
			ba = colorMapData.getImageData();
			ba.position = 0;

			var hasAlpha:Boolean = Constants.getTagNameFromTagID(tagID) == Constants.IMAGE_LOSSLESS_ALPHA ? true : false;

			// FIXME
			//return PNGEncoder.encode(ba, width, height, hasAlpha);
			return null;
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

			var offset:uint = tagSL ? 13 : 9;
			ba.position = tagSL ? 6 : 2;
			itemID = ba.readUnsignedShort();
			format = ba.readUnsignedByte();
			width = ba.readUnsignedShort();
			height = ba.readUnsignedShort();

			trace("definebitsLossless, width:", width);
			trace("definebitsLossless, height:", height);

			zlibBitmapData = new ByteArray();

			if(format > 3){ // no colorTableSize
				zlibBitmapData.writeBytes(ba, offset);
			}
			else {
				colorTableSize = ba.readUnsignedByte();
				zlibBitmapData.writeBytes(ba, ++offset);
			}

			zlibBitmapData.position = 0;
			zlibBitmapData.uncompress();
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;
			xmlStr += " tagID=\"" +_tagID +"\" ";
			xmlStr += "itemID=\"" +itemID +"\" ";
			xmlStr += "format=\"" +format +"\" ";

			if(colorTableSize){
				xmlStr += "colorTableSize=\"" +colorTableSize +"\" ";
			}
			xmlStr += "width=\"" +width +"\" ";
			xmlStr += "height=\"" +height +"\" ";

			xmlStr += "tagLength=\"" +_tagLength +"\" />";

			return xmlStr;
		}
	}
}
