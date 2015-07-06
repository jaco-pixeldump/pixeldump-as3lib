
/**
 * @author jaco
 *
 * created on 5/1/2011 3:48:29 PM
 */

package it.pixeldump.svg.text {

	import it.pixeldump.svg.font.SvgFont;
	import it.pixeldump.svg.font.SvgGlyph;
	import it.pixeldump.utils.StringUtil;

	/**
	 *
	 */
	 public class SvgTextUtils {

		public static const 	BREAK_CHARS:String = " \t-_,.:;?'\"^*()[]{}\\/!|%&";

		/**
		 * the constructor
		 */
		function SvgTextUtils(){ /* nop */	}

		public static function findUniqueChars(str:String):String {

			var uniqueChars:String = "";
			var sLength:int = str.length;

			for(var i:int = 0; i < sLength; i++){

				var ch:String = str.charAt(i);

				if(uniqueChars.indexOf(ch) == -1) uniqueChars += ch;
			}

			return uniqueChars;
		}

		public static function collectGlyphs(svgFont:SvgFont, str:String):Vector.<SvgGlyph> {

			var sLength:int = str.length;
			var glyphs:Vector.<SvgGlyph> = new Vector.<SvgGlyph>();

			for(var i:int = 0; i < sLength; i++){

				var ch:String = str.charAt(i);

				var sg:SvgGlyph = svgFont.getGlyphByUnicode(ch);

				glyphs.push(sg);
			}

			return glyphs;
		}

		public static function getGlyphsFromString(str:String, uChars:String, uGlyphs:Vector.<SvgGlyph>):Vector.<SvgGlyph> {

			var gl:Vector.<SvgGlyph> = new Vector.<SvgGlyph>();
			var sLength:uint = str.length;

			for(var i:int = 0; i < sLength; i++){

				var ch:String = str.charAt(i);
				var idx:int = uChars.indexOf(ch);
				gl.push(uGlyphs[idx]);
			}

			return gl;
		}

		public static function testBreakline(str:String, maxTextWidth:int, cursors:Array):Array {

			var totalTextWidth:Number = 0;
			var lines:Array = [];

			for each(var currentAdvanceX:Number in cursors) totalTextWidth += currentAdvanceX;

			// this may be NOT an effective value, but it's enough to evaluate multilines
			var numLines:int = Math.ceil(totalTextWidth / maxTextWidth);

			if(numLines == 1) {
				lines.push(str);
				return lines;
			}

			var tmpStr:String = str;
			var sLength:int = str.length;
			var bLength:int = SvgTextUtils.BREAK_CHARS.length;
			var idx:int = 0;
			var splitPoint:int = 0;

			var lineTextWidth:Number = 0;
			var line:String = "";
			var m:int = 0;

			for(var j:int = idx; j < sLength; j++){

				if(lineTextWidth + cursors[j] > maxTextWidth){

					line = str.substring(idx, j);

					for(var k:int = 0; k < bLength; k++){

						var ch:String = SvgTextUtils.BREAK_CHARS.charAt(k);
						var breakableIndex:int = line.lastIndexOf(ch);

						if(breakableIndex > -1){
							var oldLength:int = line.length;
							line = line.substring(0, breakableIndex);

							if(oldLength > line.length) j -= (oldLength - line.length);

							break;
						}
					}

					idx += line.length;
					lines.push(line);
					lineTextWidth = 0;
					line = "";
					m = 0;
					continue;
				}

				lineTextWidth += cursors[j];
				m++;
			}

			lines.push(str.substring(idx));
			numLines = lines.length;

			// trim all lines but the first
			for(j = 1; j < numLines; j++) lines[j] = StringUtil.trim(lines[j]);

			return lines;
		}
	} // end of class
} // end of pkg
