
package it.pixeldump.mk.struct {

	import it.pixeldump.mk.*;

	public class Asset {

		public function get CLASS_NAME():String{
			return "Asset";
		}

		public var itemID:uint;
		public var name:String;

		function Asset(itemID:uint = 0, name:String = ""){
			this.itemID = itemID;
			this.name = name;
		}

		public function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;
			xmlStr += " id=\"" +itemID +"\" ";
			xmlStr += "name=\"" +name +"\" />";

			return xmlStr;
		}

	}
}