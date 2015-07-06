/**
 * @author jaco
 */


package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class Gradient {

		public var tagID:uint = Constants.SHAPE_ID;
		public var gradientType:uint;

		private var _lengthFromByteArray:uint = 0;

		public var spreadMode:uint = 0;			// UB[2] 0 = Pad mode
        										// 1 = Reflect mode
												// 2 = Repeat mode
        										// 3 = Reserved
		public var interpolationMode:uint = 0;	// UB[2] 0 = Normal RGB mode interpolation
        										// 1 = Linear RGB mode interpolation
        										// 2 and 3 = Reserved
		//public var numGradients:uint;			// UB[4] 1 to 15
		public var gradientRecords:Array;		//   GRADRECORD[nGrads] Gradient records

		public var focalPoint:Number;			// defineshape4 only,
												// FIXED8 Focal point location

		public function get numGradients():uint {
			return gradientRecords.length;
		}

		public function get length():uint {

			/* TODO */
			return 0;
		}

		public function get lengthFromByteArray():uint {
			return _lengthFromByteArray;
		}

		//
		function Gradient(gradientType:uint, tagID:uint = Constants.SHAPE_ID) {

			this.gradientType = gradientType;
			this.tagID = tagID;
			gradientRecords = new Array();
		}

		public function add_gradientRecord(gradientRecord:GradientRecord):void {
			gradientRecords.push(gradientRecord);
		}

		public function toByteArray():ByteArray {

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public function fromByteArray(ba:ByteArray, offset:uint = 0):uint {

			/* TODO test */
			var initialOffset:uint = offset;
			ba.position = offset;

			var chStr:String = SwfUtils.toBinString(ba, offset, 1);
			spreadMode = parseInt(chStr.substring(0, 2), 2);
			interpolationMode = parseInt(chStr.substring(2, 2), 2);

			offset++;
			var gCount:uint = parseInt(chStr.substring(4, 8), 2);

			for(var i:int = 0; i < gCount; i++){
				var gr:GradientRecord = new GradientRecord(tagID);
				gr.fromByteArray(ba, offset);
				gradientRecords.push(gr);
				offset += gr.length;
			}

			if(tagID >= Constants.SHAPE_ID4){
				chStr = SwfUtils.toBinString(ba, offset, 2);
				var fpStr:String = chStr.substring(8) + chStr.substring(0, 8);
				focalPoint = SwfUtils.fpBinStrToFloat(fpStr, 4, 8);
				offset += 2;
			}

			_lengthFromByteArray = offset - initialOffset;

			return _lengthFromByteArray;
		}
	}

}