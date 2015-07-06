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

	public class DefineEditText extends Tag{

		public function get CLASS_NAME():String { return "DefineEditText"; }
		public function get CLASS_ID():uint { return Constants.tagList["DefineEditText"]; }


		public var bounds:Rect;						// RECT Rectangle that completely
													// encloses the text field
		private var _hasText:Boolean = false;		// UB[1] 0 = text field has no default text
													// 1 = text field initially displays the
													// string specified by InitialText
		public var wordWrap:Boolean = true;			// UB[1] 0 = text will not wrap and will
													// scroll sideways
													// 1 = text will wrap automatically
													// when the end of line is reached
		public var multiline:Boolean = false;		// UB[1] 0 = text field is one line only
													// 1 = text field is multi-line and will
													// scroll automatically
		public var password:Boolean = false;		// UB[1] 0 = characters are displayed as typed
													// 1 = all characters are displayed as an asterisk
		public var readOnly:Boolean = false;		// UB[1] 0 = text editing is enabled
													// 1 = text editing is disabled
		public var hasTextColor:Boolean = true;		// UB[1] 0 = use default color
													// 1 = use specified color (TextColor)
		public var hasMaxLength:Boolean = false;	// UB[1] 0 = length of text is unlimited
													// 1 = maximum length of string is
													// specified by MaxLength
		private var _hasFont:Boolean = false;			// UB[1] 0 = use default font
													// 1 = use specified font (FontID)
													// and height (FontHeight)
		public var hasFontClass:Boolean = false;	// UB[1] 1 = font class to load

		public var autoSize:Boolean = false;		// UB[1] 0 = fixed size
													// 1 = sizes to content (SWF 6 or later only)
		public var hasLayout:Boolean = true;		// UB[1] Layout information provided
		public var noSelect:Boolean = false;		// UB[1] Enables or disables interactive
													// text selection
		public var border:Boolean = false;			// UB[1] Causes a border to be drawn
													// around the text field

		public var wasStatic:Boolean = false;		// UB[1] authored as static or textfield

		public var html:Boolean = false;			// UB[1] 0 = plaintext content
													// 1 = HTML content (see below)
		public var useOutlines:Boolean = false;		// UB[1] 0 = use device font
													// 1 = use glyph font
		private var _fontID:uint = 1;				// If HasFont UI16 ID of font to use

		public var fontClassName:String;			// name of the font clas to load (>= swf9)

		private var _fontHeight:uint = 240;			// If HasFont UI16 Height of font in twips

		public var textColor:Color;					// If HasTextColor RGBA Color of text
		public var maxLength:uint;					// If HasMaxLength UI16 Text is restricted to this length

		public var align:uint = 0;					// If HasLayout UI8 0 = Left
													// 1 = Right
													// 2 = Center
													// 3 = Justify
		public var leftMargin:uint = 0;				// If HasLayout UI16 Left margin in twips
		public var rightMargin:uint = 0;			// If HasLayout UI16 Right margin in twips
		public var indent:uint = 0;					// If HasLayout UI16 Indent in twips
		public var leading:uint = 40;				// If HasLayout UI16 Leading in twips (vertical
													// distance between bottom of
													// descender of one line and top of
													// ascender of the next)
		public var variableName:String = "";		// STRING Name of the variable where the
													// contents of the text field are
													// stored. May be qualified with
													// dot syntax or slash syntax for
													// non-global variables.
		private var _initialText:String = "";		// If HasText STRING Text that is initially displayed

		//
		public function get x():int {
			return SwfUtils.fromTwip(bounds.xmin);
		}
		public function set x(value:int):void {
			bounds.xmin = SwfUtils.toTwip(value);
		}

		//
		public function get y():int {
			return SwfUtils.fromTwip(bounds.ymin);
		}
		public function set y(value:int):void {
			bounds.ymin = SwfUtils.toTwip(value);
		}

		//
		public function get width():int {
			return SwfUtils.fromTwip(bounds.xmax - bounds.xmin);
		}
		public function set width(value:int):void {
			bounds.xmax = bounds.xmin + SwfUtils.toTwip(value);
		}

		//
		public function get height():int {
			return SwfUtils.fromTwip(bounds.ymax - bounds.ymin);
		}
		public function set height(value:int):void {
			bounds.ymax = bounds.ymin + SwfUtils.toTwip(value);
		}

		//
		public function get fontHeight():Number {
			return SwfUtils.fromTwip(_fontHeight);
		}
		public function set fontHeight(value:Number):void {

			_hasFont = (value && _fontID) ? true : false;
			_fontHeight = SwfUtils.toTwip(value);
		}

		//
		public function get fontID():uint {
			return _fontID;
		}
		public function set fontID(value:uint):void {

			_hasFont = (value && _fontHeight) ? true : false;
			_fontID = value;
		}

		//
		public function get text():String {
			return _initialText;
		}
		public function set text(value:String):void {

			_hasText = value.length ? true : false;
			_initialText = value;
		}


		// the constructor
		function DefineEditText() {
			tagID = CLASS_ID;
			bounds = new Rect();
			textColor = new Color(0, 0, 0);
		}


		//
		public override function toByteArray():ByteArray{

			tagSL = true;
			tagLength = 5 + bounds.length;

			if(_fontID && _fontHeight) _hasFont = true;
			trace("_hasFont:", _hasFont);

			if(_hasFont) tagLength += 4;
			if(hasFontClass) tagLength += fontClassName.length + 1;
			if(hasTextColor) tagLength += 4;
			if(hasMaxLength) tagLength += 2;
			if(hasLayout) tagLength += 9;
			if(variableName.length) tagLength += variableName.length; // NIL chars is already included
			if(_hasText) tagLength += _initialText.length + 1;

			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba = super.toByteArray();
			ba.position = 6;
			ba.writeShort(itemID);

			var bBA:ByteArray = bounds.toByteArray();
			ba.writeBytes(bBA);

			var chStr:String = _hasText ? "1" : "0";
			chStr += wordWrap ? "1" : "0";
			chStr += multiline ? "1" : "0";
			chStr += password ? "1" : "0";
			chStr += readOnly ? "1" : "0";
			chStr += hasTextColor ? "1" : "0";
			chStr += hasMaxLength ? "1" : "0";
			chStr += _hasFont ? "1" : "0";

			ba.writeByte(parseInt(chStr, 2));

			chStr = hasFontClass ? "1" : "0";
			chStr += autoSize ? "1" : "0";
			chStr += hasLayout ? "1" : "0";
			chStr += noSelect ? "1" : "0";
			chStr += border ? "1" : "0";
			chStr += wasStatic ? "1" : "0";
			chStr += html ? "1" : "0";
			chStr += useOutlines ? "1" : "0";

			ba.writeByte(parseInt(chStr, 2));

			if(_hasFont){
				ba.writeShort(_fontID);
				ba.writeShort(_fontHeight);
			}

			if(hasFontClass){
				ba.writeUTFBytes(fontClassName);
				ba.writeByte(Constants.NIL);
			}

			if(hasTextColor){
				var tcBA:ByteArray = textColor.toRGBAByteArray();
				ba.writeBytes(tcBA);
			}

			if(hasMaxLength) ba.writeShort(maxLength);

			if(hasLayout) {
				ba.writeByte(align);
				ba.writeShort(leftMargin);
				ba.writeShort(rightMargin);
				ba.writeShort(indent);
				ba.writeShort(leading);
			}

			if(variableName.length) ba.writeUTFBytes(variableName);

			ba.writeByte(Constants.NIL);

			if(_hasText){
				ba.writeUTFBytes(_initialText);
				ba.writeByte(Constants.NIL);
			}

			ba.position = 0;

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void{

			ba.position = 0;
			super.fromByteArray(ba);
			var offset:uint = tagSL ? 6 : 2;
			ba.position = offset;
			itemID = ba.readUnsignedShort();
			offset += 2;

			var ch:uint = ba.readUnsignedShort();
			offset += 2;
			var chStr:String = SwfUtils.value2bin(ch, 16);

			_hasText 	 = chStr.charAt(0) == "1"  ? true : false;
			wordWrap 	 = chStr.charAt(1) == "1"  ? true : false;
			multiline 	 = chStr.charAt(2) == "1"  ? true : false;
			password 	 = chStr.charAt(3) == "1"  ? true : false;
			readOnly 	 = chStr.charAt(4) == "1"  ? true : false;
			hasTextColor = chStr.charAt(5) == "1"  ? true : false;
			hasMaxLength = chStr.charAt(6) == "1"  ? true : false;
			_hasFont 	 = chStr.charAt(7) == "1"  ? true : false;
			hasFontClass = chStr.charAt(8) == "1"  ? true : false;
			autoSize 	 = chStr.charAt(9) == "1"  ? true : false;
			hasLayout 	 = chStr.charAt(10) == "1" ? true : false;
			noSelect 	 = chStr.charAt(11) == "1" ? true : false;
			border 		 = chStr.charAt(12) == "1" ? true : false;
			wasStatic	 = chStr.charAt(13) == "1" ? true : false;
			html 		 = chStr.charAt(14) == "1" ? true : false;
			useOutlines  = chStr.charAt(15) == "1" ? true : false;

			bounds = new Rect();
			var baRect:ByteArray = new ByteArray();
			baRect.writeBytes(ba, offset, Constants.MAX_RECT_LENGTH);

			bounds.fromByteArray(baRect);
			offset += bounds.length;
			ba.position = offset;

			if(_hasFont){
				_fontID = ba.readUnsignedShort();
				_fontHeight = ba.readUnsignedShort();
				offset += 4;
			}

			var restBA:ByteArray = new ByteArray();

			if(hasFontClass){
				restBA = new ByteArray();
				restBA.writeBytes(ba, offset);
				fontClassName = SwfUtils.read_swfString(restBA);
				offset += fontClassName.length + 1;
			}

			if(hasTextColor){
				var tcBA:ByteArray = new ByteArray();
				tcBA.writeBytes(ba, offset, 4)
				textColor = new Color();
				textColor.fromByteArray(tcBA);
				offset += 4;
			}

			if(hasMaxLength) {
				maxLength = ba.readUnsignedShort();
				offset += 4;
			}

			if(hasLayout) {
				align = ba.readUnsignedByte();
				leftMargin = ba.readUnsignedShort();
				rightMargin = ba.readUnsignedShort();
				indent = ba.readUnsignedShort();
				leading = ba.readUnsignedShort();

				offset += 9;
			}

			ba.position = offset;
			ch = ba.readUnsignedByte();

			if(ch){
				restBA = new ByteArray();
				restBA.writeBytes(ba, offset);
				variableName = SwfUtils.read_swfString(restBA);
				offset += variableName.length + 1;
			}

			offset++;

			if(_hasText){
				restBA = new ByteArray();
				restBA.writeBytes(ba, offset);
				_initialText = SwfUtils.read_swfString(restBA);
			}
		}

		public override function fetch_xml(tabLevel:uint = 0, includeHeader:Boolean = false):String{

			var xmlStr:String = includeHeader ? Constants.XML_HEADER : "" ;
			var pfx:String = SwfUtils.get_xml_indent_row(++tabLevel);

			xmlStr += pfx +"<" +CLASS_NAME;

			xmlStr += " itemID=\"" +itemID +"\" ";
			xmlStr += " tagLength=\"" +tagLength +"\" ";

			if(fontClassName.length) xmlStr += "className=\"" +fontClassName +"\" ";
			if(variableName.length) xmlStr += "variableName=\"" +variableName +"\" ";

			if(wordWrap) xmlStr += "wordWrap=\"true\" ";
			if(multiline) xmlStr += "multiline=\"true\" ";
			if(password) xmlStr += "password=\"true\" ";
			if(readOnly) xmlStr += "readOnly=\"true\" ";
			if(hasTextColor) xmlStr += "textColor=\"" +textColor.toString() +"\" ";
			if(hasMaxLength) xmlStr += "maxLength=\"" +maxLength +"\" ";

			if(_hasFont) xmlStr += "hasFont=\"true\" ";
			if(autoSize) xmlStr += "autoSize=\"true\" ";
			if(noSelect) xmlStr += "noSelect=\"true\" ";
			if(border) xmlStr += "border=\"true\" ";
			if(wasStatic) xmlStr += "wasStatic=\"true\" ";
			if(html) xmlStr += "html=\"true\" ";
			if(useOutlines) xmlStr += "useOutlines=\"true\" ";

			xmlStr += "x=\"" +SwfUtils.fromTwip(bounds.xmin) +"\" ";
			xmlStr += "y=\"" +SwfUtils.fromTwip(bounds.ymin) +"\" ";
			xmlStr += "width=\"" +SwfUtils.fromTwip(bounds.xmax - bounds.xmin) +"\" ";
			xmlStr += "height=\"" +SwfUtils.fromTwip(bounds.ymax - bounds.ymin) +"\" >";

			pfx = SwfUtils.get_xml_indent_row(++tabLevel);

			if(_hasFont) {
				xmlStr += pfx +"<font ID=\"" +_fontID +"\" ";
				xmlStr += "height=\"" +SwfUtils.fromTwip(_fontHeight) +"px\" />";
			}

			if(hasLayout){

				xmlStr += pfx +"<layout ";
				xmlStr += "align=\"" +align +"\" ";
				xmlStr += "leftMargin=\"" +SwfUtils.fromTwip(leftMargin) +"\" ";
				xmlStr += "rightMargin=\"" +SwfUtils.fromTwip(rightMargin) +"\" ";
				xmlStr += "indent=\"" +SwfUtils.fromTwip(indent) +"\" ";
				xmlStr += "leading=\"" +SwfUtils.fromTwip(leading) +"\" />";
			}

			if(_hasText){
				xmlStr += pfx +"<text>";
				pfx = SwfUtils.get_xml_indent_row(++tabLevel);
				xmlStr += pfx +"<![CDATA[" +_initialText +"]]>";
				pfx = SwfUtils.get_xml_indent_row(--tabLevel);
				xmlStr += pfx +"</text>";
			}

			pfx = SwfUtils.get_xml_indent_row(--tabLevel);
			xmlStr += pfx +"</" +CLASS_NAME +">";

			return xmlStr;
		}

	}

}