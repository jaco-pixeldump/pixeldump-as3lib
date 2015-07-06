

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class SetBackgroundColor extends Tag {

		public function get CLASS_NAME():String{ return "SetBackgroundColor"; }

		public var color:Color;

		// the constructor
		function SetBackgroundColor(){
		}

		public function fromString(colorStr:String):void {
			color = new Color();
			color.fromString(colorStr);
		}

		//
		public override function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeByte(0x43);
			ba.writeByte(0x02);
			ba.writeByte(color.red);
			ba.writeByte(color.green);
			ba.writeByte(color.blue);

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void{

			ba.position = 0;
			super.fromByteArray(ba);

			ba.position = 2;
			color = new Color();
			color.red = ba.readUnsignedByte();
			color.green = ba.readUnsignedByte();
			color.blue = ba.readUnsignedByte();

			trace("red:", color.red);
			trace("green:", color.green);
			trace("blue:", color.blue);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " color=\"" +color.toHtmlString() +"\" />";

			return xmlStr;
		}
	}
}