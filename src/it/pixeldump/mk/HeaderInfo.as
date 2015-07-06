/**
 * @author jaco
 */

package it.pixeldump.mk {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;


	public class HeaderInfo {

		public var fileName:String;
		public var fileSize:uint;
		public var version:uint;
		public var stageWidth:uint;
		public var stageHeight:uint;
		public var fps:uint;
		public var frameCount:uint;
		public var compressed:Boolean;
		public var headerTags:Array;

		public var byteLength:uint = 0;


		/**
		 *
		 */
		public function set backgroundColor(value:Color):void {

			for each(var iTag:ITaggable in headerTags) {
				if(iTag is SetBackgroundColor){
					SetBackgroundColor(iTag).color = value;
					return;
				}
			}

			var setBackgroundColor:SetBackgroundColor = new SetBackgroundColor();
			setBackgroundColor.color = value;
			headerTags.push(setBackgroundColor);
		}
		public function get backgroundColor():Color {

			if(!headerTags) return null;

			for each(var iTag:ITaggable in headerTags) {
				if(iTag is SetBackgroundColor){
					return SetBackgroundColor(iTag).color;
				}
			}

			return null;
		}


		/**
		 *
		 */
		public function set as3(as3Flag:Boolean):void {

			version = Math.max(version, 9);

			for each(var iTag:ITaggable in headerTags){

				if(iTag is FileAttributes){
					FileAttributes(iTag).containsAS3 = as3Flag;
					return;
				}
			}

			var fileAttributes:FileAttributes = new FileAttributes();
			fileAttributes.containsAS3 = as3Flag;

			headerTags.push(fileAttributes);
		}


		/**
		 * the constructor
		 */
		function HeaderInfo(fileName:String = "untitled.swf",
							version:uint = 7,
							stageWidth:uint = 550,
							stageHeight:uint = 450,
							fps:uint = 31,
							bgColor:String = "#FFFFFF",
							compressed:Boolean = false) {

			this.fileName = fileName;
			this.version = version;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			this.fps = fps;
			this.compressed = compressed;
			//this.backgroundColor = backgroundColor;

			headerTags = new Array();

			if(version >= 8){

				var fileAttributes:FileAttributes = new FileAttributes();
				//this.metadata = new MKMetadata();
				headerTags.push(fileAttributes);
			}

			var setBackgroundColor:SetBackgroundColor = new SetBackgroundColor();
			setBackgroundColor.fromString(bgColor);
			headerTags.push(setBackgroundColor);
		}

		/**
		 * NOTE: headerInfo is only a part of swf files
		 * it cannot give correct byteLength nor build compressed data
		 * since they depends on swf body
		 * byteArray built is EVER uncompressed
		 * be care to update byteLength and compress data from the caller
		 */
		public function toByteArray():ByteArray {

			if(!byteLength) byteLength = 0; // if not provided, be care to update when completing swf building process
			if(!frameCount) frameCount = 1; // be care to provide right frameCount!

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			var signature:String = compressed ? "CWS" : "FWS";
			ba.writeUTFBytes(signature);
			ba.writeByte(version);
			ba.writeUnsignedInt(byteLength);

			var stageSize:Rect = new Rect(0, stageWidth, 0, stageHeight);
			var ssBA:ByteArray = stageSize.toByteArray();

			ba.writeBytes(ssBA);
			ba.writeByte(0x0);
			ba.writeByte(fps);
			ba.writeShort(frameCount);

			var sb:SetBackgroundColor;

			for each(var i:* in headerTags){

				if(i as SetBackgroundColor is SetBackgroundColor) {
					sb = i;
					continue;
				}

				var htBA:ByteArray = i.toByteArray();
				ba.writeBytes(htBA);
			}

			// setBackGroundColor must be the last in headerTags;
			var sbBA:ByteArray = sb.toByteArray();
			ba.writeBytes(sbBA);

			return ba;
		}

		/**
		 *
		 */
		public function fromByteArray(ba:ByteArray):void {

			ba.position = 0;
			headerTags = new Array();

			var signature:String = ba.readUTFBytes(3);

			if(signature != "CWS" && signature != "FWS") {
				throw new Error("not a valid SWF");
			}

			if(signature.charAt(0) == "C") compressed = true;

			version = ba.readByte();

			fileSize = ba.readUnsignedInt();


			if(ba.length > 8){

				var chStr:String = SwfUtils.value2bin(ba.readUnsignedByte(), 8);
				var nBits:uint = parseInt(chStr.substr(0, 5), 2);
				var rectLength:uint = Math.ceil((5 + nBits * 4) / 8);

				var offset:uint = 8 + rectLength + 1;

			if(ba.length >= offset){

					var rba:ByteArray = new ByteArray();
					rba.writeBytes(ba, 8, Constants.MAX_RECT_LENGTH);

					var r:Rect = new Rect();
					r.fromByteArray(rba);

					var rectangle:Rectangle = r.rectangle;
					stageWidth = rectangle.width;
					stageHeight = rectangle.height;

					ba.position = offset;
				}

				if(ba.length - offset >= 4 ) {

					fps = ba.readUnsignedByte();
					frameCount = ba.readUnsignedByte();

					offset += 3;
				}


				var headerTagFound:Boolean = true;

				do{

					var sba:ByteArray = new ByteArray();
					sba.endian = Endian.LITTLE_ENDIAN;
					sba.writeBytes(ba, offset, 6);

					var th:TagHeader = new TagHeader();
					th.fromByteArray(sba);

					if(ba.length - offset < th.tagLength){
						throw new Error("headerInfo: not enough data do populate headerInfo, please provide more");
						return;
					}

					var thLength:uint = th.tagLength + (th.tagSL ? 6 : 2);
					sba = new ByteArray();
					sba.endian = Endian.LITTLE_ENDIAN;
					sba.writeBytes(ba, offset, thLength);

					if(th.tagID == Constants.tagList.SetBackgroundColor){

						var bg:SetBackgroundColor = new SetBackgroundColor();
						bg.fromByteArray(sba);
						headerTags.push(bg);
					}
					else if(th.tagID == Constants.tagList.FileAttributes){

						var fa:FileAttributes = new FileAttributes();
						fa.fromByteArray(sba);
						headerTags.push(fa);
					}
					else if(th.tagID == Constants.tagList.MetaData){

						var md:MetaData = new MetaData();
						md.fromByteArray(sba);
						headerTags.push(md);
					}
					else if(th.tagID == Constants.tagList.ScriptLimits){

						var sl:ScriptLimits = new ScriptLimits();
						sl.fromByteArray(sba);
						headerTags.push(sl);
					}
					else if(th.tagID == Constants.tagList.Protect){

						var p:Protect = new Protect();
						p.fromByteArray(sba);
						headerTags.push(p);
					}
					else if(th.tagID == Constants.tagList.EnableDebugger){

						var ed:EnableDebugger = new EnableDebugger();
						ed.fromByteArray(sba);
						headerTags.push(ed);
					}
					else if(th.tagID == Constants.tagList.EnableDebugger2){

						var ed2:EnableDebugger = new EnableDebugger();
						ed2.fromByteArray(sba);
						headerTags.push(ed2);
					}
					else if(th.tagID == Constants.tagList.ProductInfo){

						var pi:ProductInfo = new ProductInfo();
						pi.fromByteArray(sba);
						headerTags.push(pi);
					}
					else if(th.tagID == Constants.tagList.DebugMode){

						var dm:DebugMode = new DebugMode();
						dm.fromByteArray(sba);
						headerTags.push(dm);
					}
					else {

						byteLength = offset;
						break;
					}

					offset += thLength;

				} while (ba.length - offset >= 4);
			}
		}

		/**
		 *
		 */
		public function set_stageSize(stageWidth:uint = 550, stageHeight:uint = 400):void {
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
		}
	}
}
