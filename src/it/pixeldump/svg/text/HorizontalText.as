
/**
 * @author jaco
 *
 * created on 3/1/2010 11:53:19 AM
 */
package it.pixeldump.svg.text {

	import flash.display.GraphicsPath;

	import it.pixeldump.svg.font.SvgGlyph;
	import it.pixeldump.utils.geom.GeomUtil;

	/**
	 * a linear text
	 */
	public class HorizontalText extends SvgText {

		private var _graphicsPaths:Vector.<GraphicsPath>;

		/**
		 *
		 */
		public function get graphicsPaths():Vector.<GraphicsPath> {
			return buildGraphicsPath();
		}


		/**
		 * the constructor
		 */
		function HorizontalText(){ }


		/**
		 *
		 */
		private function buildGraphicsPath():Vector.<GraphicsPath> {

			var tLength:uint = _text.length;
			var currentAdvanceX:Number = 0;

			_graphicsPaths = new Vector.<GraphicsPath>();

			var gl:Vector.<SvgGlyph> = glyphs;

			for each(var sg:SvgGlyph in gl){

				if(sg.glyphName == "space") {
					currentAdvanceX += (sg.advance + _kerningValue) * _scaleFactor;
					continue;
				}

				var gp:GraphicsPath = new GraphicsPath();
				gp.commands = sg.graphicsPath.commands;
				gp.data = GeomUtil.scaleCoords(sg.graphicsPath.data, _scaleFactor, _scaleFactor, currentAdvanceX, 0);

				_graphicsPaths.push(gp);

				currentAdvanceX += (sg.advance + _kerningValue) * _scaleFactor;
			}

			return _graphicsPaths;
		}
	} // class
} // pkg