/**
 * @author jaco
 */
package it.pixeldump.svg.font {

	import it.pixeldump.svg.font.vos.KerningPair;
	import it.pixeldump.svg.font.vos.SvgFontInfo;


	/**
	 * store svg font data: header, glyphs, kerning_pairs
	 */
	public class SvgFont{

		private var glyphNames:Array = [];

		private var _fontInfo:SvgFontInfo;
		private var _glyphsData:Vector.<SvgGlyph>;
		private var _kerningPairs:Vector.<KerningPair>;
		private var _notDefSubstitution:Boolean = true; // TODO implement notdef glyph substitution

		private var latin1CharacterEntities:Latin1CharacterEntities = new Latin1CharacterEntities();


		/**
		 *
		 */
		public function get fontInfo():SvgFontInfo {
			return _fontInfo;
		}

		/**
		 *
		 */
		public function get glyphsData():Vector.<SvgGlyph> {
			return _glyphsData;
		}

		/**
		 *
		 */
		public function get kerningPairs():Vector.<KerningPair> {
			return _kerningPairs;
		}


		/**
		 * the constructor
		 */
		public function SvgFont(svgFontInfo:SvgFontInfo, svgGlyphs:Vector.<SvgGlyph>, kerningPairs:Vector.<KerningPair> = null) {
			_fontInfo = svgFontInfo;
			_glyphsData = svgGlyphs;

			for each(var glyph:SvgGlyph in _glyphsData) glyphNames.push(glyph.glyphName);

			if(kerningPairs) _kerningPairs = kerningPairs;
		}

		public function getGlyphByUnicode(u:String):SvgGlyph {

			for each(var sg:SvgGlyph in _glyphsData) {

				if(sg.unicode == u) return sg;

				var he:Object = latin1CharacterEntities.getEntityByUTFChar(u);

				if(he && (sg.unicode.toUpperCase() == he.htmlHex.toUpperCase())){
					sg.unicode = u;
					return sg;
				}
			}

			if(_notDefSubstitution) return getGlyphByUnicode(" ");

			return null; // no glyph found
		}

		public function matchKerningPair(ch1:String, ch2:String):Number {

			if(!_kerningPairs) return 0;

			for each(var kp:KerningPair in _kerningPairs){
				var k:Number = kp.match(ch1, ch2);
				if(k) return k;
			}

			return 0;
		}

		public function getGlyphByName(gn:String, caseInsensitive:Boolean = false):SvgGlyph {

			if(caseInsensitive){
				var gtl:String = gn.toLowerCase();

				for each(var glyph:SvgGlyph in _glyphsData) {
					if(glyph.glyphName.toLowerCase() == gtl) return glyph;
				}

				return null;
			}

			var idx:int = glyphNames.indexOf(gn);

			if(idx < 0) return null;

			return _glyphsData[idx];
		}
	}
}