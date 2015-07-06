
/**
 * @author jaco
 *
 * created on 1/18/2013 12:18:16 PM
 */

package it.pixeldump.svg.utils {

	import it.pixeldump.svg.font.SvgGlyph;
	
	/**
	 *
	 */
	public class SvgGlyphExporter {

		public static const SVG_HEADER:String = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>";
		public static const SVG_NS:String = "\n\txmlns:svg=\"http://www.w3.org/2000/svg\"\n\txmlns=\"http://www.w3.org/2000/svg\"";

		// ---------------- private methods
		// ---------------- private events
		// ---------------- public methods

		public static function export(glyph:SvgGlyph):String {
			
			var str:String = SVG_HEADER;
			str +="\n<svg";
			str += SVG_NS +"\n>";
			str += "<path id=\"" +glyph.id +"\"";
			str += " d=\"" +glyph.d +"\"";
			str +=" style=\"fill:#000000;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1\"";
			str +="/>";
			str +="\n</svg>";
			
			return str;
		}

	} // end of class
} // end of pkg
