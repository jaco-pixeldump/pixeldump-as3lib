/**
 * @author jaco
 */
package it.pixeldump.svg.font {

	import it.pixeldump.svg.SvgPath;

	/**
	 * stores svg glyph data and translate to graphicPath
	 */
	public class SvgGlyph extends SvgPath{

		private var _glyphName:String = "";
		private var _unicode:String = "";
		private var _advance:int = 0;

		/**
		 *
		 */
		public function get unicode():String { return _unicode; }
		public function set unicode(v:String):void { _unicode = v; }

		/**
		 *
		 */
		public function get glyphName():String { return _glyphName; }

		/**
		 *
		 */
		public function get advance():int { return _advance; }

		/**
		 * the constructor
		 */
		function SvgGlyph(glyphName:String, unicode:String, d:String, id:String, advance:int) {

			if(!id.length) id = glyphName;

			super(d, id);

			_glyphName = glyphName;
			_unicode = unicode;
			_advance = advance;
		}

		/**
		 *
		 */
		public override function toString():String {

			var str:String = "svgGlpyh:";

			str += "\n\tglyphName: " +_glyphName;
			str += "\n\tunicode: "   +_unicode;
			str += "\n\td: " 		 +_d;
			str += "\n\tid: " 		 +_id;
			str += "\n\tadvance: "	 +_advance;
			str += "\n\tbounds: "	 +bounds.toString();

			return str;
		}
	}
}