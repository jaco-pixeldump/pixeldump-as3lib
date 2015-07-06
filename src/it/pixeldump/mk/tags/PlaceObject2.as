



package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class PlaceObject2 extends PlaceObject {

		public override function get CLASS_NAME():String { return "PlaceObject2"; }
		public override function get CLASS_ID():uint { return Constants.tagList["PlaceObject2"]; }


		public var pfHasClipActions:Boolean;			// UB[1] SWF 5 and later: has
        												// clip actions (sprite characters only)
        												// Otherwise: always 0

		public var pfHasClipDepth:Boolean;				// UB[1] Has clip depth
		public var pfHasName:Boolean;			// UB[1] Has name
		public var pfHasRatio:Boolean;			// UB[1] Has ratio
		public var pfHasColorTransform:Boolean;	// UB[1] Has color transform
		public var pfHasMatrix:Boolean;			// UB[1] Has matrix
		public var pfHasCharacter:Boolean;		// UB[1] Places a character
		public var pfMove:Boolean;				// UB[1] Defines a character to be moved

        //public var depth:uint							// UI16 Depth of character
		private var _characterID:uint						// If PlaceFlagHasCharacter ID of character to place UI16
		private var _ratio:uint;							// If PlaceFlagHasRatio UI16
		private var _name:String;							// If PlaceFlagHasName STRING    Name of character
		private var _clipDepth:uint;						// If PlaceFlagHasClipDepth UI16 Clip depth
		//public var clipActions:ClipActions;				// If PlaceFlagHasClipActions
														// SWF 5 and later: Clip Actions Data


		//public var matrix:MKMatrix;						// If PlaceFlagHasMatrix Transform matrix data
		//public var colorTransform:CxFormWithAlpha		// If PlaceFlagHasColorTransform Color transform data


		public function set characterID(value:uint):void {
			_characterID = value;
			pfHasCharacter = value != 0 ? true : false;
		}

		public function get characterID():uint {
			return _characterID;
		}

		public function set ratio(value:uint):void {
			_ratio = value;
			pfHasCharacter = value != 0 ? true : false;
		}

		public function get ratio():uint {
			return _ratio;
		}

		public function set name(value:String):void {
			_name = value;
			pfHasName = value.length != 0 ? true : false;
		}

		public function get name():String {
			return _name;
		}

		public function set clipDepth(value:uint):void {
			_clipDepth = value;
			pfHasCharacter = value != 0 ? true : false;
		}

		public function get clipDepth():uint {
			return _clipDepth;
		}


		function PlaceObject2(){
			_characterID = 0;
			_name = "";
		}

		/**
		 * provides to build a minimal po2 tag:
		 * depth
		 * characterID
		 * matrix with 0 values (no transformation)
		 */
		public function toMinimalByteArray():ByteArray {

			if(!itemID) itemID = 1;
			if(!characterID) characterID = itemID;

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeByte(0x86);
			ba.writeByte(0x06);
			ba.writeByte(0x06);
			ba.writeShort(depth);
			ba.writeShort(characterID);
			ba.writeByte(0x00);

			return ba;
		}

		//
		public override function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			//return ba;

			return toMinimalByteArray(); // simple and dirty hack to avoid instant headaches :D
		}

		public override function fromByteArray(ba:ByteArray):void{

			ba.position = 0;
			super.fromByteArray(ba);
			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;

			var flags:String = SwfUtils.value2bin(ba.readUnsignedByte(), 8);

			pfHasClipActions    = flags.charAt(0) == "1" ? true : false;
			pfHasClipDepth      = flags.charAt(1) == "1" ? true : false;
			pfHasName           = flags.charAt(2) == "1" ? true : false;
			pfHasRatio          = flags.charAt(3) == "1" ? true : false;
			pfHasColorTransform = flags.charAt(4) == "1" ? true : false;
			pfHasMatrix         = flags.charAt(5) == "1" ? true : false;
			pfHasCharacter      = flags.charAt(6) == "1" ? true : false;
			pfMove              = flags.charAt(7) == "1" ? true : false;

			depth = ba.readUnsignedShort();
			offset += 5;

			if(pfHasCharacter){
				characterID = ba.readUnsignedShort();
				offset += 2;
			}

			/* TODO */

			/*
			if(pfHasMatrix){
				matrix = new MKMatrix();ba.readUnsignedShort();
				offset += 2;
			}
			*/


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








