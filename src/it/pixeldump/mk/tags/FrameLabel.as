
package it.pixeldump.mk.tags {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class FrameLabel extends Tag {

		public static const CLASS_NAME:String = "FrameLabel";
		public var name:String;

		function FrameLabel(name:String = ""){
			this.name = name;
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

			var offset:uint = _tagSL ? 1 : 5;
			ba.position = offset;
			name = ba.readUTFBytes(ba.length - offset);
			//trace("name length:", name.length);

			//ba.position = _tagLength + offset - 1;
			//var lastByte:uint = read

		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<\"" +CLASS_NAME +"\" ";
			xmlStr += "name=\"" +name +"\" ";
			xmlStr += "tagLength=\"" +_tagLength +"\" />";

			return xmlStr;
		}
	}
}