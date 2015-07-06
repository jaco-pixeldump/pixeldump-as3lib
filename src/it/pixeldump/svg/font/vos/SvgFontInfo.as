/**
 * @author jaco
 */
package it.pixeldump.svg.font.vos {

	import flash.geom.Rectangle;

	/**
	 * contains svg font header info
	 */
	public class SvgFontInfo {

		private var _fontFamily:String;
		private var _fontWeight:String;
		private var _fontStretch:String;
		private var _unitsPerEm:uint;
		private var _ascent:int;
		private var _descent:int;
		private var _xHeight:uint;
		private var _capHeight:uint;
		private var _bbox:Rectangle;
		private var _underlinePosition:uint;
		private var _underlineThickness:uint;
		private var _unicodeRange:String;


		/**
		 *
		 */
		public function get fontFamily():String {
			return _fontFamily;
		}
		public function set fontFamily(v:String):void {
			_fontFamily = v;
		}

		/**
		 *
		 */
		public function get fontWeight():String {
			return _fontWeight;
		}
		public function set fontWeight(v:String):void {
			_fontWeight = v;
		}

		/**
		 *
		 */
		public function get fontStretch():String {
			return _fontStretch;
		}
		public function set fontStretch(v:String):void {
			_fontStretch = v;
		}

		/**
		 *
		 */
		public function get unitsPerEm():uint {
			return _unitsPerEm;
		}
		public function set unitsPerEm(v:uint):void {
			_unitsPerEm = v;
		}

		/**
		 *
		 */
		public function get ascent():int {
			return _ascent;
		}
		public function set ascent(v:int):void {
			_ascent = v;
		}

		/**
		 *
		 */
		public function get descent():int {
			return _descent;
		}
		public function set descent(v:int):void {
			_descent = v;
		}

		/**
		 *
		 */
		public function get xHeight():uint {
			return _xHeight;
		}
		public function set xHeight(v:uint):void {
			_xHeight = v;
		}

		/**
		 *
		 */
		public function get capHeight():uint {
			return _capHeight;
		}
		public function set capHeight(v:uint):void {
			_capHeight = v;
		}

		/**
		 *
		 */
		public function get bbox():Rectangle {
			return _bbox;
		}
		public function set bbox(v:Rectangle):void {
			_bbox = v;
		}

		/**
		 *
		 */
		public function get underlinePosition():uint {
			return _underlinePosition;
		}
		public function set underlinePosition(v:uint):void {
			_underlinePosition = v;
		}

		/**
		 *
		 */
		public function get underlineThickness():uint {
			return _underlineThickness;
		}
		public function set underlineThickness(v:uint):void {
			_underlineThickness = v;
		}

		/**
		 *
		 */
		public function get unicodeRange():String {
			return _unicodeRange;
		}
		public function set unicodeRange(v:String):void {
			_unicodeRange = v;
		}

		/**
		 *
		 */
		public function set data(v:XML):void {

			_fontFamily 		= v.@["font-family"];
			_fontWeight 		= v.@["font-weight"];
			_fontStretch 		= v.@["font-stretch"];
			_unitsPerEm 		= parseInt(v.@["units-per-em"]);
			_ascent 			= parseInt(v.@ascent);
			_descent 			= parseInt(v.@descent);
			_xHeight 			= parseInt(v.@["x-height"]);
			_capHeight 			= parseInt(v.@["cap-height"]);
			//_bbox = bbox
			_underlineThickness = parseInt(v.@["underline-thickness"]);
			_underlinePosition  = parseInt(v.@["underline-position"]);
			_unicodeRange 		= v.@["unicode-range"];
		}


		/**
		 * the constructor
		 */
		public function SvgFontInfo(xml:XML = null) {
			if(xml) data = xml;
		}

		public function toString():String {
			var str:String = "SvgFontInfo";
			str += "\n\tfont-family: " +_fontFamily;
			str += "\n\tfont-weight: " +_fontWeight;
			str += "\n\tfont-stretch: " +_fontStretch;
			str += "\n\t_units-per-em: " +_unitsPerEm;
			str += "\n\tascent: " +ascent;
			str += "\n\tdescent: " +descent;
			str += "\n\tx-height: " +_xHeight;
			str += "\n\tcap-height:" +_capHeight;
			//str += "\n\tbbox: " _bbox.toString();
			str += "\n\tunderline-thickness:" +_underlineThickness;
			str += "\n\tunderline-position: " +_underlinePosition;
			str += "\n\tunicode-range: " +_unicodeRange;

			return str;
		}

	}

}