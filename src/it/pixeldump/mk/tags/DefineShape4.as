

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineShape4 extends DefineShape3 {

		public static const CLASS_NAME:String =  "DefineShape4";
		public static const CLASS_ID:uint = Constants.tagList["DefineShape4"];

		//public override function get CLASS_NAME():String{ return "DefineShape4"; }
		//public override function get CLASS_ID():uint { return Constants.tagList["DefineShape4"]; }


		public var edgeBounds:Rect;

		// var reserved:uint = 0;

		public var usesFillWindingRule:Boolean = false;		// UB[1] If 1, use fill winding rule.
															// Minimum file format version is SWF 10
		public var usesNonScalingStrokes:Boolean = false;	// UB[1] If 1, the shape contains at least
															// one non-scaling stroke.
		public var usesScalingStrokes:Boolean = false;		// UB[1] If 1, the shape contains at least
															// one scaling stroke.

		// the constructor
		function DefineShape4(){
			shapeBounds = new Rect();
			edgeBounds = new Rect();
		}

		public override function fromByteArray(ba:ByteArray):void{

			trace(CLASS_NAME + " from bytearray");

			ba.position = 0;
			super.fromByteArray(ba);

			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			offset += 2;

			trace("shapeBounds, offset:", offset);
			shapeBounds = new Rect();
			offset += shapeBounds.fromByteArray(ba, offset);

			trace("edgeBounds, offset:", offset);
			edgeBounds = new Rect();
			offset += edgeBounds.fromByteArray(ba, offset);

			var chStr:String = SwfUtils.toBinString(ba, offset, 1);
			offset++;

			trace("offset befor shapewithstyle:", offset);

			usesFillWindingRule = chStr.charAt(5) == "1" ? true : false;
			usesNonScalingStrokes = chStr.charAt(6) == "1" ? true : false;
			usesScalingStrokes = chStr.charAt(7) == "1" ? true : false;

			shapeWithStyle = new ShapeWithStyle(_tagID);

			/* FIXME complete shapeWithStyle reading */
			shapeWithStyle.fromByteArray(ba, offset);
		}


	}
}