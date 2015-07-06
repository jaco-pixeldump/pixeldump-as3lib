



package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class PlaceObject extends Tag {

		public function get CLASS_NAME():String { return "PlaceObject"; }
		public function get CLASS_ID():uint { return Constants.tagList["PlaceObject"]; }

		public var depth:uint = 1;		// UI16   Depth of character
		// public var matrix:Matrix;	//  MATRIX Transform matrix data
		// public var colorTransform:ColorTransform;	// ColorTransform (optional) CXFORM Color transform data

		function PlaceObject(){

		}

		//
		public override function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void{

			ba.position = 0;
			super.fromByteArray(ba);
			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			depth = ba.readUnsignedShort();
			offset += 4;

			/* TODO  */
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += " depth=\"" +depth +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" />";

			return xmlStr;
		}
	}
}








