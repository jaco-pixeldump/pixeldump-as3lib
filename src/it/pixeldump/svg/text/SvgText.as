
/**
 * @author jaco
 *
 * created on 2/26/2010 10:33:53 PM
 */
package it.pixeldump.svg.text {

	import flash.text.TextFormatAlign;

	import it.pixeldump.svg.font.SvgFont;
	import it.pixeldump.svg.font.SvgGlyph;
	import it.pixeldump.svg.text.SvgTextUtils;

	/**
	 * collects minimal svgGlyphs and chars for a given text
	 */
	public class SvgText {

		protected var _text:String = "";
		protected var _fontSize:Number = 36;
		protected var _align:String = TextFormatAlign.LEFT;
		protected var _kerning:int = 0;
		protected var _tracking:Number = 0;
		protected var _svgFont:SvgFont;

		protected var _scaleFactor:Number = 1;
		protected var _kerningValue:Number = 0;

		// collection of unique characters and glyphs
		// e.g.: good morning -> god mrni
		private var _uniqueSvgGlyphs:Vector.<SvgGlyph>;
		private var _uniqueChars:String;

		/**
		 *
		 */
		public function get uniqueChars():String { return _uniqueChars; }

		/**
		 *
		 */
		public function get uniqueSvgGlyphs():Vector.<SvgGlyph> { return _uniqueSvgGlyphs; }

		/**
		 *
		 */
		public function get text():String { return _text; }
		public function set text(v:String):void {

			if(_text != v) {
				_text = v;
				collectSvgGlyphs();
			}
		}

		/**
		 *
		 */
		public function get align():String { return _align; }
		public function set align(v:String):void { _align = v; }

		/**
		 * unit: 1000 / unitsPerEm
		 */
		public function get kerning():Number { return _kerning; }
		public function set kerning(v:Number):void {
			_kerning = v;
			updateScaledValues();
		}

		/**
		 *
		 */
		public function get tracking():Number { return _tracking; }
		public function set tracking(v:Number):void {
			_tracking = v;
			updateScaledValues();
		}

		/**
		 *
		 */
		public function get fontSize():Number { return _fontSize; }
		public function set fontSize(v:Number):void {
			_fontSize = v;
			updateScaledValues();
		}

		/**
		 *
		 */
		public function get textWidth():Number {

			if(!_text.length) return 0;

			var currentAdvanceX:Number = 0;
			var gl:Vector.<SvgGlyph> = glyphs;

			updateScaledValues();

			for each(var sg:SvgGlyph in gl)
				currentAdvanceX += (sg.advance * _scaleFactor) + _kerningValue;

			return currentAdvanceX;
		}

		/**
		 *
		 */
		public function get cursors():Array {

			if(!_text.length) return [];

			var cursors:Array = [];
			var gl:Vector.<SvgGlyph> = glyphs;

			updateScaledValues();

			for each(var sg:SvgGlyph in gl)  cursors.push[(sg.advance + _kerningValue)];

			return cursors;
		}

		/**
		 * collect all glyphs per text
		 */
		public function get glyphs():Vector.<SvgGlyph> {

			return SvgTextUtils.getGlyphsFromString(_text, _uniqueChars, _uniqueSvgGlyphs);
		}


		/**
		 *
		 */
		public function get font():SvgFont {
			return _svgFont;
		}
		public function set font(v:SvgFont):void {

			if(!_svgFont || _svgFont.fontInfo.fontFamily != v.fontInfo.fontFamily){

				_svgFont = v;
				collectSvgGlyphs();
			}
		}


		/**
		 * the constructor
		 */
		function SvgText(){}

		/**
		 *
		 */
		private function collectSvgGlyphs():void {

			_uniqueChars = "";
			_uniqueSvgGlyphs = new Vector.<SvgGlyph>();

			if(_text.length) _uniqueChars = SvgTextUtils.findUniqueChars(_text);
			if(_svgFont) _uniqueSvgGlyphs = SvgTextUtils.collectGlyphs(_svgFont, _uniqueChars);
		}

		/**
		 *
		 */
		protected function updateScaledValues():void {
			_kerningValue = _kerning ? (1000 / _svgFont.fontInfo.unitsPerEm) * _kerning : 0;
			_scaleFactor = 1 / (_svgFont.fontInfo.unitsPerEm / _fontSize);
		}

		/**
		 *
		 */
		public function testCursors(str:String):Array {

			updateScaledValues();

			if(!_svgFont) return [];

			var cursors:Array = [];
			var uChars:String = SvgTextUtils.findUniqueChars(str);
			var uGlyphs:Vector.<SvgGlyph> = SvgTextUtils.collectGlyphs(_svgFont, uChars);
			var sGlyphs:Vector.<SvgGlyph> = SvgTextUtils.getGlyphsFromString(str, uChars, uGlyphs);

			for each(var sg:SvgGlyph in sGlyphs){
				var currentAdvanceX:Number = (sg.advance * _scaleFactor) + _kerningValue;
				cursors.push(currentAdvanceX);
			}

			return cursors;
		}

		public function testBreakline(str:String, maxTextWidth:int):Array {

			var cursors:Array = testCursors(str);

			return SvgTextUtils.testBreakline(str, maxTextWidth, cursors);
		}
	} // class
} // pkg
