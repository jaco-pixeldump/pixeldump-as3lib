

package it.pixeldump.mk {

	import flash.utils.*;

	import it.pixeldump.mk.struct.*;

	public class TagHeader implements ITaggable {

		protected var _tagID:uint;
		public var itemID:uint;	// not sure if to use here

		protected var _tagSL:Boolean; // "short" or long tag
		protected var _tagLength:uint;
		protected var offset:uint;

		public function set tagID(value:uint):void {
			_tagID = value;
		}

		public function get tagID():uint {
			return _tagID;
		}

		public function set tagSL(value:Boolean):void {
			_tagSL = value;
		}

		public function get tagSL():Boolean {
			return _tagSL;
		}

		public function set tagLength(value:uint):void {
			_tagLength = value;
		}

		public function get tagLength():uint {
			return _tagLength;
		}


		function TagHeader(){}

		public function fromByteArray(ba:ByteArray):void {

			var rh:RecordHeader = SwfUtils.read_recordHeader(ba);
			_tagID = rh.tagID;
			_tagLength = rh.tagLength;
			_tagSL = rh.tagSL;
		}

		public function toByteArray():ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var th:uint = 0;

			if(!tagSL){
				th = tagID << 6 | tagLength;
				ba.writeShort(th);
				return ba;
			}

			th = tagID << 6 | 0x3f;
			ba.writeShort(th);
			ba.writeUnsignedInt(tagLength);

			return ba;
		}

		public function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);
			xmlStr += pfx +"<tagHeader ";
			xmlStr += "tagID=\"" +_tagID +"\" ";
			xmlStr += "tagLength=\"" +_tagLength +"\" ";
			xmlStr += "tagSL=\"" +_tagSL +"\" />";

			return xmlStr;
		}
	}
}