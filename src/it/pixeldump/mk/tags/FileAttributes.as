
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class FileAttributes extends Tag {

		public function get CLASS_NAME():String{ return "FileAttributes"; }

		public function get CLASS_ID():uint { return Constants.tagList.FileAttributes; }

		public var useDirectBlit:Boolean;
		public var useGPU:Boolean;
		public var containsMetaData:Boolean;
		public var containsAS3:Boolean;
		public var useNetwork:Boolean;

		// the constructor
		function FileAttributes(useDirectBlit:Boolean = false,
								useGPU:Boolean = false,
								containsMetaData:Boolean = false,
								containsAS3:Boolean = false,
								useNetwork:Boolean = false){

			this.useDirectBlit = useDirectBlit;
			this.useGPU = useGPU;
			this.containsMetaData = containsMetaData;
			this.containsAS3 = containsAS3;
			this.useNetwork = useNetwork;
		}

		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			tagID = CLASS_ID;
			tagSL = false;
			tagLength = 4;

			var flags:String = "0";
			flags += useDirectBlit ? "1": "0";
			flags += useGPU ? "1": "0";
			flags += containsMetaData ? "1": "0";
			flags += containsAS3 ? "1": "0";
			flags += "00";
			flags += useNetwork ? "1": "0";

			ba = super.toByteArray();
			ba.writeByte(parseInt(flags, 2));
			ba.writeByte(0x0);
			ba.writeShort(0x0);

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			/* TODO */
			super.fromByteArray(ba);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			if(useDirectBlit) xmlStr += " useDirectBlit=\"" +useDirectBlit +"\" ";
			if(useGPU) xmlStr += " useGPU=\"" +useGPU +"\" ";
			if(containsMetaData) xmlStr += " containsMetaData=\"" +containsMetaData +"\" ";
			if(containsAS3) xmlStr += " containsAS3=\"" +containsAS3 +"\" ";
			if(useNetwork) xmlStr += " useNetwork=\"" +useNetwork +"\" ";

			xmlStr += " tagLength=\"" +_tagLength +"\" >";

			return xmlStr;
		}
	}
}
