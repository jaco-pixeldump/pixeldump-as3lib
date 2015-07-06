/**
 * @author jaco
 */

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class CSMTextSettings extends Tag {

		public function get CLASS_NAME():String { return "CSMTextSettings"; }
		public function get CLASS_ID():uint { return Constants.tagList["CSMTextSettings"]; }


		public var useFlashType:uint = 0;	// UB[2] 0 = use normal renderer.
											//       1 = use FlashType renderer

		public var gridFit:uint = 0;		// UB[3] 0 = Do not use grid fitting.
											//           AlignmentZones and LCD
											//           sub-pixel information will not be used.
											//       1 = Pixel grid fit. Only
											//           supported for left-aligned
											//           dynamic text. This setting
											//           provides the ultimate in
											//           FlashType readability, with
											//           crisp letters aligned to pixels.
											//       2 = Sub-pixel grid fit. Align
											//           letters to the 1/3 pixel used
											//           by LCD monitors. Can also
											//           improve quality for CRT output.

		public var gfReserved:uint = 0;		// UB[3] Must be 0.
		public var thickness:Number = 0;	// F32 The thickness attribute for the
											//     associated text field. Set to 0.0
											//     to use the default
											//     (anti-aliasing table) value.
		public var sharpness:Number;		// F32 The sharpness attribute for
											//     the associated text field. Set to 0.0
											//     to use the default
											//     (anti-aliasing table) value.
		public var reserved:uint = 0;		// UI8 Must be 0.

		function CSMTextSettings() {
			tagID = CLASS_ID;
		}

		//
		public override function toByteArray():ByteArray{

			tagSL = true; // always long tag
			tagLength = 12; // fixed length

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba = super.toByteArray();
			ba.position = 6;
			ba.writeShort(itemID);

			var chStr:String = useFlashType ? "01" : "00";
			chStr += SwfUtils.value2bin(gridFit, 3);
			chStr += "000";
			ba.writeByte(parseInt(chStr, 2));

			ba.writeUnsignedInt(Constants.NIL); // default thickness /* TODO */
			ba.writeUnsignedInt(Constants.NIL); // default sharpness /* TODO */

			ba.writeByte(Constants.NIL);
			ba.position = 0;

			return ba;
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " textID=\"" +itemID +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" ";

			if(useFlashType) xmlStr += "useFlashType=\"true\" ";

			xmlStr += "gridFit=\"" +gridFit +"\" />";

			return xmlStr;
		}
	}

}