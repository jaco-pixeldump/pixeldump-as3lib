

package it.pixeldump.mk {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;

	public class SwfMovie {

		public static const SWF_COMPLETE:String = "swfComplete";

		public var headerInfo:HeaderInfo;
		public var frameList:Array;
		public var workingFrame:uint = 1;

		public var swfData:ByteArray;;
		public var swfDir:String;
		public var rawBody:ByteArray;
		public var rawFrameList:Array;

		private var swfURL:String;
		private var ul:URLLoader;
		private var dispatcher:EventDispatcher;

		public function get frameCount():uint {

			if(!frameList) return 0;

			return frameList.length;
		}

		public function get imageList():Array {

			var imageList:Array = new Array();

			if(rawFrameList.length){

				for each(var f:Frame in rawFrameList){

					for each(var i:Object in f.tagList){

						var d1:DefineBitsLossless2 = i as DefineBitsLossless2;
						if(d1) {
							imageList.push(d1);
							continue;
						}

						var d2:DefineBitsLossless = i as DefineBitsLossless;

						if(d2) {
							imageList.push(d2);
							continue;
						}

						var d3:DefineBitsJPEG2 = i as DefineBitsJPEG2;

						if(d3) {
							imageList.push(d3);
							continue;
						}

						var d4:DefineBitsJPEG3 = i as DefineBitsJPEG3;
						if(d4) imageList.push(d4);
					}
				}
			}

			return imageList;
		}


		public function get shapeList():Array {

			var shapeList:Array = new Array();

			if(rawFrameList.length){

				for each(var f:Frame in rawFrameList){

					for each(var i:Object in f.tagList){

						var d1:DefineShape = i as DefineShape;
						if(d1) {
							shapeList.push(d1);
							continue;
						}

						var d2:DefineShape2 = i as DefineShape2;
						if(d2) {
							shapeList.push(d2);
							continue;
						}

						var d3:DefineShape3 = i as DefineShape3;
						if(d3) {
							shapeList.push(d3);
							continue;
						}

						var d4:DefineShape4 = i as DefineShape4;
						if(d4) shapeList.push(d4);
					}
				}
			}

			return shapeList;
		}


		public function get soundList():Array {

			var soundList:Array = new Array();

			if(rawFrameList.length){

				for each(var f:Frame in rawFrameList){

					for each(var i:Object in f.tagList){

						var d1:DefineSound = i as DefineSound;
						if(d1) soundList.push(d1);
					}
				}
			}

			return soundList;
		}

		public function get fontList():Array {

			var fontList:Array = new Array();

			if(rawFrameList.length){

				for each(var f:Frame in rawFrameList){

					for each(var i:Object in f.tagList){

						var d1:DefineFont2 = i as DefineFont2;

						if(d1) {
							fontList.push(d1);
							continue;
						}

						var d2:DefineFont3 = i as DefineFont3;
						if(d2) fontList.push(d2);
					}
				}
			}

			return fontList;
		}


		function SwfMovie(fileName:String = "untitled.swf",
						  version:uint = 8,
						  stageWidth:uint = 550,
						  stageHeight:uint = 450,
						  fps:uint = 31,
						  bgColor:String = "#FFFFFF") {

			headerInfo = new HeaderInfo(fileName, version, stageWidth, stageHeight, fps, bgColor);

			ul = new URLLoader();
			ul.dataFormat = URLLoaderDataFormat.BINARY;
			ul.addEventListener(Event.COMPLETE, onULComplete);

			dispatcher = new EventDispatcher();

		}

		public function addTag(tag:*, frameNumber:uint = 0):void {

			if(!rawFrameList) {
				rawFrameList = new Array();
			}

			if(frameNumber >= rawFrameList.length){
				var frame:Frame = new Frame();
				frame.add_tag(tag);
				rawFrameList[frameNumber] = frame;
			}
			else rawFrameList[frameNumber].add_tag(tag);
		}

		public function addEventListener(evtName:String, listener:Function):void {
			dispatcher.addEventListener(evtName, listener);

		}

		public function loadMovie(swfURL:String):void {
			this.swfURL = swfURL;
			var rnd:String = escape("" +Math.random());
			var sep:String = swfURL.indexOf("?") > -1 ? "&" : "?";
			swfURL +=  sep +"rnd=" +rnd;

			headerInfo.fileName = swfURL;

			var ur:URLRequest = new URLRequest(swfURL);
			ul.load(ur);
		}


		/**
		 * @description mandatory for reflection compliance
		 * 				each class must be included at compile time
		 *
		 */
		private function create_fake_references():void {
			var d1:DefineBitsLossless = null;
			var d2:DefineBitsLossless2 = null;
			var d3:FrameLabel = null;
			var d4:DefineSprite = null;
			var d5:DefineBitsJPEG2 = null;
			var d6:DefineBitsJPEG3 = null;
			var d7:DefineShape = null;
			var d8:DefineShape2 = null;
			var d9:DefineShape3 = null;
			var d10:DefineShape4 = null;
			var d11:PlaceObject = null;
			var d12:PlaceObject2 = null;
			var d13:ExportAssets = null;
			var d14:DefineSound = null;
			var d15:DefineFont2 = null;
			var d16:DefineFont3 = null;
			var d17:CSMTextSettings = null;
		}

		private function onULComplete(evt:Event):void {
			read_swfData();
		}


		public function read_swfData(data:ByteArray = null, fileName:String = ""):void {

			trace("read data: ", fileName);

			var movieData:ByteArray = data ? data : ul.data;

			if(!movieData){
				throw new Error("no valid data to parse swf!");
				return;
			}

			movieData.position = 0;

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var signature:String = movieData.readUTFBytes(3);
			movieData.position = 0;

			if(signature != "FWS" && signature != "CWS"){

				throw new Error("invalid swf");
			}

			var swfName:String = headerInfo.fileName;

			headerInfo = new HeaderInfo();
			headerInfo.fileName = fileName.length ? fileName : swfName;

			if(signature == "CWS") {

				var cmp:ByteArray = new ByteArray();
				cmp.endian = Endian.LITTLE_ENDIAN;

				cmp.writeBytes(movieData, 8);
				cmp.uncompress();
				cmp.position = 0;

				movieData.position = 0;
				ba.writeBytes(movieData, 0, 8);
				ba.writeBytes(cmp);
			}
			else {
				ba.writeBytes(movieData);
			}

			ba.position = 0;
			var minLength:int = Math.min(ba.length, 34);

			headerInfo.fromByteArray(ba);

			var offset:uint = headerInfo.byteLength;
			rawFrameList = new Array();
			var frame:Frame = new Frame();
			var tagList:Array = new Array();
			var k:uint = 1;

			create_fake_references();

			do {

				ba.position = 0;
				var sba:ByteArray = new ByteArray();
				sba.endian = Endian.LITTLE_ENDIAN;
				minLength = Math.min(6, ba.length - offset);
				sba.writeBytes(ba, offset, minLength);

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

				if(th.tagID == Constants.tagList.End){
					trace("END OF MOVIE");
					break;
				}
				else if(th.tagID != Constants.tagList.ShowFrame){

					if(Constants.isSupportedTag(th.tagID)){

						var tagType:String = Constants.getTagNameFromTagID(th.tagID);
						var classPath:String = "it.pixeldump.mk.tags." +tagType;
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
					frame.tagList = tagList;
					rawFrameList.push(frame);

					frame = new Frame(k);
					tagList = new Array();
				}

				offset += thLength;

			} while(offset < ba.length);

			if(dispatcher.hasEventListener(SWF_COMPLETE)){
				dispatcher.dispatchEvent(new Event(SWF_COMPLETE));
			}
		}

		public function toByteArray():ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var baHI:ByteArray = headerInfo.toByteArray();
			baHI.position = 0;

			ba.writeBytes(baHI);

			for each(var f:Frame in rawFrameList){

				for each(var i:Object in f.tagList) {

					var baTag:ByteArray = i.toByteArray();
					ba.writeBytes(baTag);
				}
				ba.writeShort(0x0040); // ShowFrame
			}

			ba.writeShort(0x0000); // End

			ba.position = 4;
			ba.writeUnsignedInt(ba.length);
			ba.position = 0;

			return ba;
		}

		public function fetch_xml():String{

			var xmlStr:String = Constants.XML_HEADER;
			var tabLevel:uint = 0;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<movie ";
			xmlStr += "fileName=\"" +headerInfo.fileName +"\" ";
			xmlStr += "fileSize=\"" +headerInfo.fileSize +"\" ";
			xmlStr += "version=\"" +headerInfo.version +"\" ";
			xmlStr += "stageWidth=\"" +headerInfo.stageWidth +"\" ";
			xmlStr += "stageHeight=\"" +headerInfo.stageHeight +"\" ";
			xmlStr += "frameRate=\"" +headerInfo.fps +"\" ";
			xmlStr += "compressed=\"" +headerInfo.compressed +"\">";

			for each(var ht:* in headerInfo.headerTags){
				xmlStr += ht.fetch_xml(tabLevel);
			}

			pfx = SwfUtils.get_xml_indent_row(++tabLevel);
			xmlStr += pfx +"<rootTimeline frames=\"" +headerInfo.frameCount +"\" >";
			pfx = SwfUtils.get_xml_indent_row(++tabLevel);
			var frameNumber:uint = 1;

			for each(var frame:Frame in rawFrameList){
				xmlStr += pfx + "<frame number=\"" +(frameNumber++) +"\" >";

				for each(var tag:Tag in frame.tagList){
					xmlStr += tag.fetch_xml(tabLevel);
				}

				xmlStr += pfx +"</frame>";
			}

			pfx = SwfUtils.get_xml_indent_row(--tabLevel);
			xmlStr += pfx +"</rootTimeline>";
			pfx = SwfUtils.get_xml_indent_row(--tabLevel);

			xmlStr += pfx +"</movie>";

			return xmlStr;
		}
	}
}