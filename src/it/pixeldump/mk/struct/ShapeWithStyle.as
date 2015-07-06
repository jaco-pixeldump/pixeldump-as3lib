
package it.pixeldump.mk.struct {

	import flash.utils.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.tags.*;

	public class ShapeWithStyle {

		private var _tagID:uint = Constants.SHAPE_ID;

		public var fsArray:FillStyleArray;	// FILLSTYLEARRAY Array of fill styles.
		public var lsArray:LineStyleArray;	// LINESTYLEARRAY Array of line styles.

		public var fsBits:uint = 0;					// UB[4] Number of fill index bits.
		public var lsBits:uint = 0;					// UB[4] Number of line index bits.

		public var shapeRecords:Array;		// SHAPERECORD[one or more] Shape records (see following).

		public function get tagID():uint {
			return _tagID;
		}
		public function set tagID(value:uint):void {
			_tagID = value;
		}

		function ShapeWithStyle(tagID:uint = Constants.SHAPE_ID) {
			_tagID = tagID;

			trace("shapewithstyle, tagid:", _tagID);

			fsArray = new FillStyleArray(_tagID);
			lsArray = new LineStyleArray(_tagID);
			shapeRecords = new Array();
		}

		//
		public function toByteArray():ByteArray{

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public function fromByteArray(ba:ByteArray, offset:uint):void{

			ba.position = offset;

			fsArray = new FillStyleArray(_tagID);
			offset += fsArray.fromByteArray(ba, offset);

			lsArray = new LineStyleArray(_tagID);
			offset += lsArray.fromByteArray(ba, offset);

			var chStr:String = SwfUtils.toBinString(ba, offset, 1);
			offset++;

			fsBits = parseInt(chStr.substring(0, 4), 2);
			lsBits = parseInt(chStr.substring(4, 8), 2);

			trace("fsBits:", fsBits);
			trace("lsBits:", lsBits);

			var currentFsBits:uint = fsBits;
			var currentLsBits:uint = lsBits;

			var bitOffset:uint = 0;

			shapeRecords = new Array();

			var straightRecord:StraightEdgeRecord;
			var curveRecord:CurvedEdgeRecord;
			var styleRecord:StyleChangeRecord;

			/* FIX ME continue reading */
			//return;
			/* TODO shape records */

			while (offset < ba.length) {

				//trace("offset, bitOffset @while init:", offset, bitOffset);

				var shapeHeader:String = SwfUtils.toBitOffsetBinString(ba, offset, bitOffset, 6);

				if(SwfUtils.isEndShapeRecord(shapeHeader)){
					trace("END shape record");
					break;
				}

				if(shapeHeader.charAt(0) == "1"){ // draw something

					if(shapeHeader.charAt(1) == "1"){ // straight

						straightRecord = new StraightEdgeRecord();
						bitOffset += straightRecord.fromByteArray(ba, offset, bitOffset);

						shapeRecords.push(straightRecord);
					}
					else { // curve

						curveRecord = new CurvedEdgeRecord();
						bitOffset += curveRecord.fromByteArray(ba, offset, bitOffset);

						shapeRecords.push(curveRecord);
					}
				}
				else { // change style or end shape

					styleRecord = new StyleChangeRecord();
					bitOffset += styleRecord.fromByteArray(ba, offset, bitOffset, currentFsBits, currentLsBits);

					if(styleRecord.fsBits || styleRecord.lsBits){
						currentFsBits = styleRecord.fsBits;
						currentLsBits = styleRecord.lsBits;
					}

					shapeRecords.push(styleRecord);
				}

				offset += Math.floor(bitOffset / 8);
				bitOffset = bitOffset % 8;

				//trace("offset, bitOffset, remaining baLength:", offset, bitOffset, (ba.length - offset));
			}
		}

		public function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			/*
			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" />";
			*/

			return xmlStr;
		}
	}
}


