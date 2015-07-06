
package it.pixeldump.mk.tags {

	import flash.utils.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineSprite extends Tag {

		public function get CLASS_NAME():String{ return "DefineSprite"; }

		public var rawFrameList:Array;

		public function get frameCount():uint {
			return rawFrameList.length;
		}

		//
		function DefineSprite(){
			rawFrameList = new Array();
		}

		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			super.fromByteArray(ba);

			var offset:uint = _tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			//trace("stored frameCount:", ba.readUnsignedShort());

			offset += 4;

			rawFrameList = new Array();
			var frame:Frame = new Frame();
			var tagList:Array = new Array();
			var k:uint = 1;

			//create_fake_references();

			do {

				//trace("offset:", offset);

				ba.position = offset;
				var sba:ByteArray = new ByteArray();
				sba.endian = Endian.LITTLE_ENDIAN;
				var minLength:uint = Math.min(6, ba.length - offset);
				sba.writeBytes(ba, offset, minLength);
				//trace("sba.length:", sba.length);

				var th:TagHeader = new TagHeader();
				th.fromByteArray(sba);

				if(ba.length - offset < th.tagLength){
					throw new Error("swfMovie: not enough data do populate headerInfo, please provide more");
					return;
				}

				var thLength:uint = th.tagLength + (th.tagSL ? 6 : 2);
				sba = new ByteArray();
				sba.endian = Endian.LITTLE_ENDIAN;
				sba.writeBytes(ba, offset, thLength);

				if(th.tagID != Constants.tagList.ShowFrame){

					var tagType:String = Constants.getTagNameFromTagID(th.tagID);
					//trace("new tag:", tagType);

					if(Constants.isSupportedTag(th.tagID)){

						var classPath:String = "it.pixeldump.mk.tags." +tagType;
						//trace("className:", classPath);
						var Clazz:Class = getDefinitionByName(classPath) as Class;
						var customTag:Class = new Clazz();
						customTag.fromByteArray(sba);
						tagList.push(customTag);
					}
					else {
						var tag:Tag = new Tag();
						tag.fromByteArray(sba);
						tagList.push(tag);
					}

				}
				else {
					//trace("new mc frame:", ++k);
					frame.tagList = tagList;
					rawFrameList.push(frame);

					frame = new Frame(k);
					tagList = new Array();
				}

				offset += thLength;

			} while(offset < ba.length);
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;
			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += "";

			xmlStr += "tagLength=\"" +_tagLength +"\" >";

			pfx = SwfUtils.get_xml_indent_row(++tabLevel);
			xmlStr += pfx +"<timeline frames=\"" +frameCount +"\">";

			var k:uint = 1;
			pfx = SwfUtils.get_xml_indent_row(++tabLevel);

			for each(var frame:Frame in rawFrameList){
				xmlStr += pfx +"<frame number=\"" +(k++) +"\>";

				for each(var t:* in frame.tagList){
					xmlStr += t.fetch_xml(tabLevel);
				}

				xmlStr += pfx +"</frame>";
			}


			pfx = SwfUtils.get_xml_indent_row(--tabLevel);
			xmlStr += pfx +"</timeline>";

			pfx = SwfUtils.get_xml_indent_row(--tabLevel);
			xmlStr += pfx +"</" +CLASS_NAME +">";

			return xmlStr;
		}
	}
}