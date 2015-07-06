
/**
 * @author jaco
 *
 * created on 3/7/2012 5:01:59 PM
 */

package it.pixeldump.graphic.vos {

	import flash.geom.Rectangle;

	/**
	 *
	 */
	public class GlyphEntryVO {

		public var id:String = "";
		public var name:String = "";
		public var unicode:String = "";
		public var bounds:Rectangle;
		public var posX:Number = 0;
		public var posY:Number = 0;
		public var relPosX:Number = 0;
		public var relPosY:Number = 0;
		public var relScale:Number = 1;

		public function set xml(v:XML):void {

			id = v.@id.toString();
			name = v.@name.toString();
			unicode = v.@unicode.toString();

			if(v..bounds.length()) {
				var yi:XML = v..bounds[0];

				bounds.x = parseFloat(yi.@x);
				bounds.y = parseFloat(yi.@y);
				bounds.width = parseFloat(yi.@w);
				bounds.height = parseFloat(yi.@h);
			}

			if(v..transform.length()) {

				yi = v..transform[0];

				posX = parseFloat(yi.@posX);
				posY = parseFloat(yi.@posY);

				if(yi.@relPosX.toString().length) relPosX = parseFloat(yi.@relPosX);
				if(yi.@relPosY.toString().length) relPosY = parseFloat(yi.@relPosY);
				if(yi.@relScale.toString().length) relScale = parseFloat(yi.@relScale);
			}
		}

		/**
		 * the constructor
		 */
		function GlyphEntryVO(){
			reset();
		}

		// ---------------- private methods
		// ---------------- private events
		// ---------------- public methods

		public function reset():void {
			id = "";
			name = "";
			unicode = "";
			bounds = new Rectangle();
			posX = 0;
			posY = 0;
			relPosX = 0;
			relPosY = 0;
			relScale = 1;
		}

		public function toString():String {

			var str:String = "glyphEntryVO:";
			str += "\n\tid: " +id;
			str += "\n\tname: " +name;
			str += "\n\tunicode: " +unicode;
			str += "\n\tbounds: " +bounds.toString();
			str += "\n\tposX: " +posX;
			str += "\n\tposY: " +posY;
			str += "\n\trelPosX: " +relPosX;
			str += "\n\trelPosY: " +relPosY;
			str += "\n\trelScale: " +relScale;

			return str;
		}

		public function toXmlNodeString():String {

			var xmlStr:String = "<glyphEntry ";

			xmlStr += " id=\"" +id;
			xmlStr += "\" unicode=\"" +unicode;
			xmlStr += "\" name=\"" +name +"\">";

			xmlStr += "<transform ";
			xmlStr += " posX=\"" +posX;
			xmlStr += "\" posY=\"" +posY;
			xmlStr += "\" relPosX=\"" +relPosX;
			xmlStr += "\" relPosY=\"" +relPosY;
			xmlStr += "\" relScale=\"" +relScale;
			xmlStr += "\" />";

			xmlStr += "<bounds ";
			xmlStr += " x=\"" +bounds.x;
			xmlStr += "\" y=\"" +bounds.y;
			xmlStr += "\" w=\"" +bounds.width;
			xmlStr += "\" h=\"" +bounds.height;
			xmlStr += "\" />";

			xmlStr += "</glyphEntry>\n";

			return xmlStr;
		}

	} // end of class
} // end of pkg
