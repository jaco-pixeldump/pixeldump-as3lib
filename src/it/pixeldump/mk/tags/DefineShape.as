

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineShape extends Tag {

		public static const CLASS_NAME:String =  "DefineShape";
		public static const CLASS_ID:uint = Constants.tagList["DefineShape"];

		//public function get CLASS_NAME():String { return "DefineShape"; }
		//public function get CLASS_ID():uint { return Constants.tagList["DefineShape"]; }

		public var shapeBounds:Rect;
		public var shapeWithStyle:ShapeWithStyle;

		// the constructor
		function DefineShape(){
			shapeBounds = new Rect();
		}

		//
		public override function toByteArray():ByteArray{

			if(tagData) {
				return super.toByteArray();
			}

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba = super.toByteArray();
			//ba.writeShort(itemID);

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void{

			trace(CLASS_NAME + " from bytearray");

			ba.position = 0;
			super.fromByteArray(ba);

			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			offset += 2;

			shapeBounds = new Rect();
			offset += shapeBounds.fromByteArray(ba, offset);

			if(_tagID != CLASS_ID) return;

			shapeWithStyle = new ShapeWithStyle(tagID);

			/* FIXME complete shapeWithStyle reading */
			shapeWithStyle.fromByteArray(ba, offset);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			var nodeName:String = Constants.getTagNameFromTagID(_tagID);

			xmlStr += pfx +"<" +nodeName;

			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" >";

			xmlStr += "</" +nodeName +">";

			return xmlStr;
		}
	}
}