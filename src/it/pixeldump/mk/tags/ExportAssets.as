
package it.pixeldump.mk.tags {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class ExportAssets extends Tag {

		public function get CLASS_NAME():String{ return "ExportAssets"; }

		public var assets:Array;

		public function get count():uint {
			return assets.length;
		}


		function ExportAssets(){

			assets = new Array();
		}

		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			super.fromByteArray(ba);

			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			var	assetCount:uint = ba.readUnsignedShort();
			offset += 2;

			/*
			for(var i:uint = 0; i < assetCount; i++){

				ba.position = offset;

				var assetID:uint = ba.readUnsignedShort();
				var assetName:String = ba.readUTFBytes();

				var asset:Asset = new Asset(assetID, assetName);
				assets.push(asset);

				offset += 2 + assetName.length;
			}
			*/
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " tagLength=\"" +_tagLength +"\" ";
			xmlStr += "count=\"" +count +"\">";

			for each(var asset:Asset in assets){
				xmlStr += asset.fetch_xml(tabLevel);
			}

			xmlStr += pfx +"</" +CLASS_NAME  +">";

			return xmlStr;
		}
	}
}