package it.pixeldump.mk {

	import flash.utils.*;
	import flash.geom.*;

	public class Tag extends TagHeader {

		public var tagData:ByteArray;

		// the constructor
		function Tag(){

			/*
			var tagHDB:ByteArray = new ByteArray();
			tagHDB.writeBytes(tagData, 0, 10);
			tagData.position = 0;

			super(tagData.readBytes(0, 10));

			this.offset = offset;
			this.tagData = tagData;
			*/
		}

		public override function fromByteArray(tagData:ByteArray):void {

			tagData.position = 0;
			this.tagData = new ByteArray();
			this.tagData.endian = Endian.LITTLE_ENDIAN;
			this.tagData.writeBytes(tagData);
			this.tagData.position = 0;

			var tagHB:ByteArray = new ByteArray();
			tagHB.endian = Endian.LITTLE_ENDIAN
			var minLength:uint = Math.min(tagData.length, 10);
			tagHB.writeBytes(tagData, 0, minLength);
			tagHB.position = 0;

			super.fromByteArray(tagHB);
		}

		public override function toByteArray():ByteArray {

			if(tagData) {

				if(Constants.tagID_hasItemID(tagID)){
					tagData.position = tagSL ? 6 : 2;

					if(itemID) {
						tagData.writeShort(itemID);
					}
					tagData.position = 0;
				}

				return tagData;
			}

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			ba = super.toByteArray();

			/* TODO */

			return ba;
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);
			xmlStr += pfx +"<tag ";

			if(_tagID) {
				xmlStr += "tagID=\"" +_tagID +"\" ";
				xmlStr += "type=\"" +Constants.getTagNameFromTagID(_tagID) +"\" ";
			}
			else {
				xmlStr += "type=\"not_yet_supported\" ";
			}

			xmlStr += "tagLength=\"" +_tagLength +"\" ";

			if(_tagLength <= 63 && _tagSL)
				xmlStr += "tagSL=\"" +_tagSL +"\"";

			xmlStr += " />";

			return xmlStr;
		}


		/*
		public function get_tagBody():ByteArray{
			var tagBody:ByteArray = new ByteArray();
			tagBody.writeBytes(tagData, tagSL, 10);
			tagData.position = 0;

			return tagBody;
		}
		*/
	}
}