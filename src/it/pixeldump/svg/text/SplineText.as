
/**
 * @author jaco
 *
 * created on 3/1/2010 11:53:19 AM
 */

package it.pixeldump.svg.text {

	import flash.display.GraphicsPath;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;

	import it.pixeldump.svg.font.SvgGlyph;
	import it.pixeldump.utils.geom.GeomUtil;
	import it.pixeldump.utils.geom.BezierCubic;

	/**
	 * text on a cubic spline
	 */
	public class SplineText extends SvgText {

		private static const SFX:Array = [TextFormatAlign.LEFT,
										  TextFormatAlign.CENTER,
										  TextFormatAlign.RIGHT,
										  TextFormatAlign.JUSTIFY];

		private var _spline:BezierCubic;
		private var _graphicsPaths:Vector.<GraphicsPath>;
		private var _offset:Number = 0;

		private var tStep:Number;
		private var scaleFactor:Number;

		private var spLength:Number;
		private var twScaled:Number;

		private var offsetResult:Object;
		private var offsetEnd:Object;
		private var glyphPositions:Object;

		/**
		 *
		 */
		public function get spline():BezierCubic {
			return _spline;
		}
		public function set spline(v:BezierCubic):void {
			_spline = v;
		}

		/**
		 *
		 */
		public function get graphicsPaths():Vector.<GraphicsPath> {

			return buildGraphicsPath();
		}

		/**
		 *
		 */
		public function get offset():Number {
			return _offset;
		}
		public function set offset(v:Number):void {
			_offset = v;
		}


		// ---------------------------------------

		/**
		 * the constructor
		 */
		function SplineText(spline:BezierCubic){
			_spline = spline;
		}

		/**
		 *
		 */
		private function buildGraphicsPath():Vector.<GraphicsPath> {

			if(SFX.indexOf(_align) == -1){
				throw new Error("no valid alignment given, please choose one from TextFormatAlign constants");
				return;
			}

			updateForDistributions(NaN);

			var functName:String = "charDistributions_" +_align;

			this["charDistributions_" +_align]();

			var gl:Vector.<SvgGlyph> = glyphs;
			var cCount:uint = gl.length;
			_graphicsPaths = new Vector.<GraphicsPath>();

			for(var i:int = 0; i < cCount; i++){

				var sg:SvgGlyph = gl[i];

				if(sg.glyphName == "space") continue;

				var p:Point = glyphPositions.points[i];
				var sa:Number = glyphPositions.angles[i];

				var gp:GraphicsPath = new GraphicsPath();
				gp.commands = sg.graphicsPath.commands;

				if(sa) gp.data = GeomUtil.rotateCoords(sg.graphicsPath.data, new Point(0, 0), sa);
				gp.data = GeomUtil.scaleCoords(gp.data, glyphPositions.scaleFactor, glyphPositions.scaleFactor, p.x, p.y);

				_graphicsPaths.push(gp);
			}

			return _graphicsPaths;
		}

		private function charDistributions_left():void {

			updateForDistributions(_offset, true);
			updateGlyphPositions();
		}

		private function charDistributions_right():void {

			var ofst:Number = spLength - twScaled - _offset;

			updateForDistributions(ofst);
			updateGlyphPositions();
		}

		private function charDistributions_center():void {

			var ofst:Number = (spLength - twScaled) / 2;

			updateForDistributions(ofst);
			updateGlyphPositions();
		}

		private function charDistributions_justify():void {

			updateForDistributions(0);
			updateGlyphPositions();
		}

		private function updateForDistributions(ofst:Number = NaN, forceLeft:Boolean = false):void {

			scaleFactor = 1 / (_svgFont.fontInfo.unitsPerEm / _fontSize);
			spLength = _spline.getBezierLength();
			twScaled = textWidth * scaleFactor;

			if(isNaN(ofst)) return;

			if(!ofst && !forceLeft){
				offsetResult = new Object();
				offsetResult.t = 0;

				offsetEnd = new Object();
				offsetEnd.t = 1;
			}
			else {
				offsetResult = _spline.getDataAtCubicBezierLength(ofst);
				offsetEnd = _spline.getDataAtCubicBezierLength(ofst + twScaled);
			}

			if(twScaled + ofst < spLength) tStep = (offsetEnd.t - offsetResult.t) / twScaled;
			else tStep = (1 - offsetResult.t) / twScaled;

			tStep *= scaleFactor;
		}

		private function updateGlyphPositions():void {

			var kerningValue:Number = (1000 / _svgFont.fontInfo.unitsPerEm) * _kerning;

			glyphPositions = new Object();
			glyphPositions.points = new Vector.<Point>();
			glyphPositions.angles = new Vector.<Number>();
			glyphPositions.scaleFactor = scaleFactor;

			var gl:Vector.<SvgGlyph> = glyphs;
			var cCount:uint = gl.length;
			var currentAdvanceX:Number = 0;

			for(var i:int = 0; i < cCount; i++){

				var sg:SvgGlyph = gl[i];
				var t:Number = offsetResult.t + currentAdvanceX * tStep;
				var p:Point = _spline.getPointAt(t);
				var angle:Number = -_spline.getSlope(t);

				glyphPositions.points.push(p);
				glyphPositions.angles.push(angle);

				currentAdvanceX += sg.advance + kerningValue;
			}
		}
	} // class
} // pkg
