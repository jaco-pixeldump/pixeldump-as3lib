
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class MetaData extends Tag {

		public function get CLASS_NAME():String{ return "MetaData"; }

		public var metadata:String;

		// the constructor
		function MetaData(metadata:String = ""){

			this.metadata = metadata;
		}

		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			/* TODO */
			super.fromByteArray(ba);

			var offset:uint = _tagSL ? 6 : 2;
			ba.position = offset;
			metadata = ba.readUTFBytes(ba.length - offset - 1);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " tagLength=\"" +_tagLength +"\">";

			pfx = SwfUtils.get_xml_indent_row(++tabLevel);
			xmlStr += pfx +"<[!CDATA[";
			xmlStr += metadata +"]]>";

			pfx = SwfUtils.get_xml_indent_row(--tabLevel);
			xmlStr += pfx +"</" +CLASS_NAME  +">";

			return xmlStr;
		}
	}
}
