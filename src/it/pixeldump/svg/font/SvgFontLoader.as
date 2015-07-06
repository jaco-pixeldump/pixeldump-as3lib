/**
 * @author jaco
 */
package it.pixeldump.svg.font {

	import flash.events.Event;

	import it.pixeldump.svg.SvgLoader;
	import it.pixeldump.svg.font.events.FontLoaderEvent;
	import it.pixeldump.svg.font.vos.KerningPair;
	import it.pixeldump.svg.font.vos.SvgFontInfo;

	/**
	 * load a converted svg font from fontforge or apache batik
	 * namespace will be [maybe] handled in the near future
	 */
	public class SvgFontLoader extends SvgLoader{

		private var _svgFont:SvgFont;

		public function get font():SvgFont { return _svgFont; }
		public function set font(v:SvgFont):void { _svgFont = v; }

		public function set xml(v:XML):void {

			if(v.namespace() == SVG_NAMESPACE) {
				default xml namespace = SVG_NAMESPACE;
			}

			var test:* = v.namespaceDeclarations();
			//trace(xml.namespace())
			var xmlFF:XML = v.descendants("font-face")[0];
			var svgFontInfo:SvgFontInfo = new SvgFontInfo(xmlFF);
			//trace(svgFontInfo.toString());
			var svgGlyphs:Vector.<SvgGlyph> = new Vector.<SvgGlyph>();

			for each(var x1:XML in v..glyph){

				var glyphName:String = x1.@["glyph-name"];
				var unicode:String = x1.@unicode;
				var d:String = x1.@d;
				var id:String = x1.@id;
				var advance:int = parseInt(x1.@["horiz-adv-x"]);
				var svgGlyph:SvgGlyph = new SvgGlyph(glyphName, unicode, d, id, advance);

				svgGlyphs.push(svgGlyph);
			}

			var hkerns:Vector.<KerningPair> = null;

			if(v..hkern.length()){
				hkerns = new Vector.<KerningPair>();

				for each(var x2:XML in v..hkern){

					var g1:String = x2.@g1;
					var g2:String = x2.@g2;
					var k:Number = parseFloat(x2.@k);
					var kerningPair:KerningPair = new KerningPair(g1, g2, k);

					hkerns.push(kerningPair);
				}
			}

			_svgFont = new SvgFont(svgFontInfo, svgGlyphs,hkerns);
			default xml namespace = null;
			dispatchEvent(new FontLoaderEvent(FontLoaderEvent.FONT_READY));
		}

		/**
		 * the constructor
		 */
		public function SvgFontLoader() {
			super();
		}

		protected override function onULComplete(evt:Event):void {
			xml = XML(ul.data);
		}

		public function loadFont(fontURL:String):void {
			loadData(fontURL);
		}
	}
}