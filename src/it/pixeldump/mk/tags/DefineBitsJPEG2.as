
package it.pixeldump.mk.tags {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;

	public class DefineBitsJPEG2 extends Tag {

		public function get CLASS_NAME():String{
			return "DefineBitsJPEG2";
		}

		public var jpegData:ByteArray;

		function DefineBitsJPEG2(){

		}

		public function getImageAsJPEG():ByteArray {
			jpegData.position = 0;
			return jpegData;
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
			offset += 2;

			var tmpJpegData:ByteArray = new ByteArray();

			jpegData = new ByteArray();
			tmpJpegData.writeBytes(ba, offset);
			tmpJpegData.position = 0;

			trace("fixing JPEG2");
			jpegData = SwfUtils.fixJpeg(tmpJpegData);
			jpegData.position = 0;
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;
			xmlStr += " tagID=\"" +_tagID +"\" ";
			xmlStr += "itemID=\"" +itemID +"\" ";

			xmlStr += "tagLength=\"" +_tagLength +"\" />";

			return xmlStr;
		}
	}
}