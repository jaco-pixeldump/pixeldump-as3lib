package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class LineStyle2 extends LineStyle {

		private var _tagID:uint = Constants.SHAPE_ID4;

		// public var width:int; // value is stored in twips

		public var startCapStyle:uint = 0;			// UB[2] Start cap style:
													//	0 = Round cap
													//	1 = No cap
													//	2 = Square cap

		public var joinStyle:uint = 0;				// UB[2] Join style:
													//	0 = Round join
													//	1 = Bevel join
													//	2 = Miter join
		public var hasFillFlag:Boolean;				// UB[1] If 1, fill is defined in FillType.
													// If 0, uses Color field.
		public var noHScaleFlag:Boolean;			// UB[1] If 1, stroke thickness will not
													// scale if the object is scaled horizontally.
		public var noVScaleFlag:Boolean;			// UB[1] If 1, stroke thickness will not
													// scale if the object is scaled vertically.
		public var pixelHintingFlag:Boolean;		// UB[1] If 1, all anchors will be aligned
													// to full pixels.
		// Reserved UB[5] Must be 0.
		public var noClose:Boolean;					// UB[1] If 1, stroke will not be closed if
													// the stroke’s last point
													// matches its first point. Flash
													// Player will apply caps instead of a join.
		public var endCapStyle:uint = 0;			// UB[2] End cap style:
													//	0 = Round cap
													//	1 = No cap
													//	2 = Square cap
		public var miterLimitFactor:uint;			// If JoinStyle = 2, UI16 Miter limit factor is an 8.8
													// fixed-point value.
		//public var color:Color;						// If HasFillFlag = 0, RGBA Color value including alpha channel.
		public var fillType:FillStyle;				// If HasFillFlag = 1, FILLSTYLE Fill style for this stroke.

		// returns LINESTYLE bytes length
		public override function get length():uint{
			var lsLength:uint = 4;

			if(joinStyle == 2) lsLength += 2;

			if(!hasFillFlag) lsLength += 4;
			else lsLength += fillType.length;

			return lsLength;
		}


		// the constructor
		function LineStyle2(){
		}

		//
		public override function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;


			/* TODO */

			return ba;
		}

		// NOTE: provide correct tagID first
		public override function fromByteArray(ba:ByteArray, offset:uint = 0):uint{

			/* TODO test */

			var initialOffset:uint = offset;
			ba.position = offset;

			width = ba.readUnsignedShort();
			offset += 2;

			var chStr:String = SwfUtils.toBinString(ba, offset, 2);
			offset += 2;

			startCapStyle = parseInt(chStr.substr(0, 2), 2);
			joinStyle = parseInt(chStr.substr(2, 2), 2);
			hasFillFlag = chStr.charAt(4) == "1" ? true : false;
			noHScaleFlag = chStr.charAt(5) == "1" ? true : false;
			noVScaleFlag = chStr.charAt(6) == "1" ? true : false;
			pixelHintingFlag = chStr.charAt(7) == "1" ? true : false;

			noClose = chStr.charAt(12) == "1" ? true : false;
			endCapStyle = parseInt(chStr.substr(13, 2), 2);

			if(joinStyle == 2){
				chStr = SwfUtils.toBinString(ba, offset, 2);
				miterLimitFactor =  SwfUtils.fpBinStrToFloat(chStr, 4, 8);
				offset += 2;
			}

			if(!hasFillFlag){
				color = new Color();
				color.fromByteArray(ba, offset);
				offset += 4;
			}
			else {
				fillType = new FillStyle(Constants.SHAPE_ID4);
				offset += fillType.fromByteArray(ba, offset);
			}

			_lengthFromByteArray = offset - initialOffset;

			return _lengthFromByteArray;
		}

	}
}