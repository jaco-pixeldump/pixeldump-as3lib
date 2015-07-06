

package it.pixeldump.mk {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.tags.*;
	import it.pixeldump.mk.struct.*;

	public class HeaderOverview {

		public var fileName:String = "";
		public var signature:String = "";
		public var fileSize:uint = 0;
		public var version:uint = 0;
		public var compressed:Boolean;

		public var stageWidth:uint = 0;
		public var stageHeight:uint = 0;
		public var frameRate:uint = 0;
		public var numFrames:uint = 1;

		public var bgColor:Color;

		public var swfHeaderBuf:ByteArray;


		function HeaderOverview(){
			trace("new HeaderOverview");
		}

		public function fromByteArray(ba:ByteArray):void {

			ba.position = 0;
			signature = ba.readUTFBytes(3);

			if(signature != "CWS" && signature != "FWS") {
				throw new Error("not a valid SWF");
			}

			if(signature.charAt(0) == "C") compressed = true;

			version = ba.readByte();

			fileSize = ba.readUnsignedInt();

			if(!compressed && ba.length > 8){

				var chStr:String = SwfUtils.value2bin(ba.readUnsignedByte(), 8);
				var nBits:uint = parseInt(chStr.substr(0, 5), 2);
				var rectLength:uint = Math.ceil((5 + nBits * 4) / 8);

				var offset:uint = 8 + rectLength;

			if(ba.length >= offset){

					var rba:ByteArray = new ByteArray();
					rba.writeBytes(ba, 8, Constants.MAX_RECT_LENGTH);

					var r:Rect = new Rect();
					r.fromByteArray(rba);

					var rectangle:Rectangle = r.rectangle;
					stageWidth = rectangle.width;
					stageHeight = rectangle.height;

					offset += 4;
				}

				if(ba.length >= offset){

					ba.position = offset - 3;
					frameRate = ba.readUnsignedByte();
					numFrames = ba.readUnsignedShort();
				}

				offset += 5;

				if(ba.length >= offset){
					var sbg:SetBackgroundColor = new SetBackgroundColor();
					var sba:ByteArray = new ByteArray();
					sba.writeBytes(ba, offset - 5, 5);
					sbg.fromByteArray(sba);

					bgColor = sbg.color;
				}
			}
		}
	}
}