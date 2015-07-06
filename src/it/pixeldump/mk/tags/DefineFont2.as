/**
 * @author jaco
 */

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class DefineFont2 extends Tag {

		public function get CLASS_NAME():String { return "DefineFont2"; }
		public function get CLASS_ID():uint { return Constants.tagList["DefineFont2"]; }

		public var fontFlagsHasLayout:Boolean;			// UB[1] Has font metrics/layout information
		public var fontFlagsShiftJIS:Boolean;			// UB[1] ShiftJIS encoding
		public var fontFlagsSmallText:Boolean;			// UB[1] SWF 7 or later:
														// Font is small. Character glyphs
														// are aligned on pixel boundaries
														// for dynamic and input text.
		public var fontFlagsANSI:Boolean;				// UB[1] ANSI encoding
		public var fontFlagsWideOffsets:Boolean;		// UB[1] If 1, uses 32 bit offsets
		public var fontFlagsWideCodes:Boolean = true;	// UB[1] If 1, font uses 16-bit codes,
														// otherwise font uses 8 bit codes
		public var fontFlagsItalic:Boolean;				// UB[1] Italic Font
		public var fontFlagsBold:Boolean;				// UB[1] Bold Font
		public var languageCode:uint = 1;				// LANGCODE SWF 5 or earlier:
														// always 0
														// SWF 6 or later: language code
		public var fontNameLen:uint;					// UI8 Length of name
		public var fontName:String;						// UI8[FontNameLen] Name of font (see DefineFontInfo)

		public var numGlyphs:uint = 0;					// UI16 Count of glyphs in font
														// May be zero for device fonts
		public var offsetTable:Array;					// If FontFlagsWideOffsets UI32[NumGlyphs]
														// Otherwise UI16[NumGlyphs]
														// Same as in DefineFont
		public var codeTableOffset:uint;				// If FontFlagsWideOffsets UI32
														// Otherwise UI16
														// Byte count from start of
														// OffsetTable to start of CodeTable
		public var glyphShapeTable:Array;				// SHAPE[NumGlyphs] Same as in DefineFont
		public var codeTable:Array;						// If FontFlagsWideCodes UI16[NumGlyphs]
														// Otherwise UI8[NumGlyphs]
														// Sorted in ascending order
														// Always UCS-2 in SWF 6 or later
		public var fontAscent:int;						// If FontFlagsHasLayout SI16 Font ascender height
		public var fontDescent:int;						// If FontFlagsHasLayout SI16 Font descender height
		public var fontLeading:int;						// If FontFlagsHasLayout SI16 Font leading height (see below)
		public var fontAdvanceTable:Array;				// If FontFlagsHasLayout SI16[NumGlyphs]
														// Advance value to be used for
														// each glyph in dynamic glyph text
		public var fontBoundsTable:Array;				// If FontFlagsHasLayout
														// RECT[NumGlyphs]
														// Not used in Flash Player
														// through version 7 (but must be present)
		public var kerningCount:uint;					// If FontFlagsHasLayout UI16 Not used in Flash Player
														// through version 7 (always set to
														// 0 to save space)
		public var fontKerningTable:Array;				// If FontFlagsHasLayout
														// KERNINGRECORD [KerningCount]
														// Not used in Flash Player
														// through version 7 (omit with
														// KerningCount of 0)


		function DefineFont2() {

		}

		public override function fromByteArray(ba:ByteArray):void{

			trace("font from byte array");
			ba.position = 0;
			super.fromByteArray(ba);
			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;

			itemID = ba.readUnsignedShort();
			offset += 2;

			var ch:uint = ba.readUnsignedByte();
			var chStr:String = SwfUtils.value2bin(ch, 8);
			offset++;

			 fontFlagsHasLayout   = chStr.charAt(0) == "1" ? true : false;
			 fontFlagsShiftJIS 	  = chStr.charAt(1) == "1" ? true : false;
			 fontFlagsSmallText   = chStr.charAt(2) == "1" ? true : false;
			 fontFlagsANSI 		  = chStr.charAt(3) == "1" ? true : false;
			 fontFlagsWideOffsets = chStr.charAt(4) == "1" ? true : false;
			 fontFlagsWideCodes   = chStr.charAt(5) == "1" ? true : false;
			 fontFlagsItalic 	  = chStr.charAt(6) == "1" ? true : false;
			 fontFlagsBold 		  = chStr.charAt(7) == "1" ? true : false;

			 languageCode = ba.readUnsignedByte();
			 offset++;

			 fontNameLen = ba.readUnsignedByte();
			 offset++;

			 fontName = ba.readUTFBytes(fontNameLen);
			 offset += fontNameLen;
			 ba.position = offset;
			 numGlyphs = ba.readUnsignedShort();
			 offset += 2;

			 offsetTable = new Array();
			 var ot:uint;

			for(var i:int = 0; i < numGlyphs; i++){

				if(fontFlagsWideOffsets){
					ot = ba.readUnsignedInt();
				}
				else {
					ot = ba.readUnsignedShort();
				}

				offsetTable.push(ot);
			}

			var mul:uint = 2;

			if(fontFlagsWideOffsets){
				codeTableOffset = ba.readUnsignedInt();
				mul = 4;
		 	}
			else {
				codeTableOffset = ba.readUnsignedShort();
			}

			/* TODO glypshapes */

			offset += codeTableOffset;
			ba.position = offset;

			codeTable = new Array();

			for(i = 0; i < numGlyphs; i++){

				if(fontFlagsWideCodes){
					ch = ba.readUnsignedShort();
			 	}
				else {
					ch = ba.readUnsignedByte();
				}

				codeTable.push(ch);
			}

			 /* TODO complete the definefont reading process */
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;
			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" ";

			if(tagID == Constants.FONT3) xmlStr += "flashType=\"1\" ";

			if(fontFlagsShiftJIS)	 xmlStr += "ffShiftJIS=\"true\" ";
			if(fontFlagsSmallText)	 xmlStr += "smallText=\"true\" ";
			if(fontFlagsANSI)		 xmlStr += "ffANSI=\"true\" ";
			if(fontFlagsWideOffsets) xmlStr += "ffWideOffset=\"true\" ";
			if(fontFlagsWideCodes)	 xmlStr += "ffWideCodes=\"true\" ";
			if(fontFlagsItalic)		 xmlStr += "italic=\"true\" ";
			if(fontFlagsBold)		 xmlStr += "bold=\"true\" ";

			xmlStr += "langCode=\"" +languageCode +"\" ";
			xmlStr += "fontName=\"" +fontName +"\" ";
			if(!numGlyphs) xmlStr += "useDeviceFont=\"1\" ";
			else xmlStr += "glyphsUsed=\"" +numGlyphs +"\" ";
			xmlStr += " />";

			return xmlStr;
		}
	}

}