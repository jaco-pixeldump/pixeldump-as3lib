package it.pixeldump.graphic.vos {

	import it.pixeldump.utils.StringUtil;

	public class GraphicDataVO {

		public static const DEFAULT_FILLCOLOR:uint = 0x0;
		public static const DEFAULT_STROKECOLOR:uint = 0x0;
		public static const DEFAULT_STROKEWIDTH:Number = -1;

		public static const DEFAULT_FILLALPHA:Number = -1;
		public static const DEFAULT_STROKEALPHA:Number = -1;

		private var _fillColor:uint = DEFAULT_FILLCOLOR;
		private var _strokeColor:uint = 0x0;
		private var _strokeWidth:Number = -1;

		private var _fillAlpha:Number = DEFAULT_FILLALPHA;
		private var _strokeAlpha:Number = DEFAULT_STROKEALPHA;

		public var clearGraphics:Boolean = true;
		public var startGraphics:Boolean = true;
		public var closeGraphics:Boolean = true;
		public var useFill:Boolean = false;
		public var useStroke:Boolean = false;

		public var transform:TransformVO = new TransformVO();

		public function set fillColor(v:uint):void {
			_fillColor = v;
			useFill = true;
		}
		public function get fillColor():uint { return _fillColor; }

		public function set strokeColor(v:uint):void {
			_strokeColor = v;

			if(_strokeAlpha <= 0) _strokeAlpha = 1;

			useStroke = true;
		}
		public function get strokeColor():uint { return _strokeColor; }

		public function set strokeWidth(v:Number):void {
			_strokeWidth =  v;
			useStroke = (v > 0 && _strokeAlpha > 0) ? true : false;
		}
		public function get strokeWidth():Number { return _strokeWidth; }

		public function set fillAlpha(v:Number):void {
			_fillAlpha =  v;
			useFill = v > 0 ? true : false;
		}
		public function get fillAlpha():Number { return _fillAlpha; }

		public function set strokeAlpha(v:Number):void {
			_strokeAlpha =  v;
			useStroke = (v > 0 && _strokeWidth > 0) ? true : false;
		}
		public function get strokeAlpha():Number { return _strokeAlpha; }

		public function get onlyFillSolid():Boolean {

			if(!useFill) return false;
			if(useStroke) return false;
			if(_fillAlpha > 0) return false;

			return true;
		}

		public function get fillTransparent():Boolean {

			if(!useFill) return false;
			if(_fillAlpha <= 0) return false;

			return true;
		}

		public function get onlyStrokeSolid():Boolean {

			if(!useStroke) return false;
			if(useFill) return false;
			if(_strokeAlpha > 0) return false;
			if(_strokeWidth <= 0) return false;

			return true;
		}

		public function get strokeTransparent():Boolean {
			if(!useStroke) return false;
			if(_strokeAlpha <= 0) return false;

			return true;
		}

		public function set xml(v:XML):void {
			_fillColor = StringUtil.fromColorString(v.@fillColor);
			_strokeColor = StringUtil.fromColorString(v.@strokeColor);
			_strokeWidth = parseFloat(v.@strokeWidth);
			_fillAlpha = parseFloat(v.@fillAlpha);
			_strokeAlpha = parseFloat(v.@strokeAlpha);

			if(v.hasOwnProperty("@startGraphics"))  startGraphics = v.@startGraphics == "true" ? true : false;

			clearGraphics = v.@clearGraphics == "true" ? true : false;
			closeGraphics = v.@closeGraphics == "true" ? true : false;
			useFill = v.@useFill == "true" ? true : false;
			useStroke = v.@useStroke == "true" ? true : false;

			transform = new TransformVO();

			if(v..transform.length()) transform.xml = v..transform[0];
		}

		/**
		 * the constructor
		 */
		public function GraphicDataVO(fColor:uint = 0, sColor:uint = 0) {

			if(fColor) fillColor = fColor;
			if(sColor) strokeColor = sColor;
		}

		// ------------ publics

		public function reset():void {
			_fillColor = DEFAULT_FILLCOLOR;
			_strokeColor = 0x0;

			_fillAlpha = DEFAULT_FILLALPHA;
			_strokeAlpha = DEFAULT_STROKEALPHA;

			useFill = false;
			useStroke = false;
			clearGraphics = true;
			closeGraphics = true;

			transform.reset();
		}

		public function toString():String {

			var str:String = "graphicDataVO:";

			str += "\n\tfillColor: "		+StringUtil.toColorString(fillColor);
			str += "\n\tstrokeColor: "		+StringUtil.toColorString(strokeColor);
			str += "\n\tstrokeWidth: "		+strokeWidth;
			str += "\n\tfillAlpha: "		+fillAlpha;
			str += "\n\tstrokeAlpha: "		+strokeAlpha;
			str += "\n\tclearGraphics: "	+clearGraphics;
			str += "\n\tstartGraphics: "	+startGraphics;
			str += "\n\tcloseGraphics: "	+closeGraphics;

			str += "\n\tuseFill: "			+useFill;
			str += "\n\tuseStroke: "		+useStroke;
			str += "\n\t"					+transform.toString();

			return str;
		}

		public function toXmlNodeString():String {

			var xmlStr:String = "<graphicData ";

			xmlStr += "fillColor=\""		+StringUtil.toColorString(fillColor) +"\" ";
			xmlStr += "strokeColor=\""		+StringUtil.toColorString(strokeColor) +"\" ";
			xmlStr += "strokeWidth=\""		+strokeWidth+"\" ";
			xmlStr += "fillAlpha=\""		+fillAlpha +"\" ";
			xmlStr += "strokeAlpha=\""		+strokeAlpha +"\" ";
			xmlStr += "clearGraphics=\""	+clearGraphics +"\" ";
			xmlStr += "startGraphics=\""	+startGraphics +"\" ";
			xmlStr += "closeGraphics=\""	+closeGraphics +"\" ";

			xmlStr += "useFill=\""			+useFill +"\" ";
			xmlStr += "useStroke=\""		+useStroke +"\" >";

			xmlStr += transform.toXmlNodeString();

			xmlStr += "</graphicData>";

			return xmlStr;
		}
	}
}