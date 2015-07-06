package it.pixeldump.graphic.vos {

	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class PathVO {

		public static var TYPE_CIRCLE:String = "circle";
		public static var TYPE_RECT:String = "rectangle";
		public static var TYPE_ROUNDRECT:String = "roundedRectangle";
		public static var TYPE_CUSTOM:String = "custom";

		private var _d:String = "";
		private var _type:String = TYPE_CUSTOM;

		public var id:String = "";
		public var radius:Number = 0;
		public var boundingBox:Rectangle = new Rectangle();
		public var transform:TransformVO = new TransformVO();
		public var description:String = "";

		public function set type(v:String):void { _type = v; }
		public function get type():String { return _type; }

		public function set d(v:String):void {
			_d = v;
			_type = TYPE_CUSTOM;
		}
		public function get d():String { return _d; }

		public function set xml(v:XML):void {
			id = v.@id;
			boundingBox = new Rectangle();

			var tmpType:String = v.hasOwnProperty("@type") ? v.@type : TYPE_CUSTOM;
			var b:Array = v.@boundingBox.split(",");

			boundingBox.x = parseFloat(b[0]);
			boundingBox.y = parseFloat(b[1]);
			boundingBox.width = parseFloat(b[2]);
			boundingBox.height = parseFloat(b[3]);

			transform = new TransformVO();

			if(v..transform.length()) transform.xml = v..transform[0];
			if(v..description.length()) description = v..description[0].text();

			if(v.hasOwnProperty("@d"))	d = v.@d;
			else if(tmpType == TYPE_CIRCLE && v.hasOwnProperty("@radius")){
				radius = parseFloat(v.@radius);
			}
			else if(tmpType == TYPE_ROUNDRECT && v.hasOwnProperty("@radius")){
				radius = parseFloat(v.@radius);
			}

			type = tmpType;
		}

		/**
		 * the constructor
		 */
		public function PathVO() {
			id = "pr-" +getTimer() + "-" +Math.round(Math.random() * 9999);
		}

		public function clone():PathVO {

			var p:PathVO = new PathVO();
			p.d = _d;
			p.type = _type;
			p.radius = radius;
			p.boundingBox = boundingBox.clone();
			p.transform = transform.clone();
			p.description = description;

			return p;
		}

		public function toString():String {

			var str:String = "pathVO:";

			str += "\n\tid: " +id;
			str += "\n\tboundingBox: " +boundingBox.toString();

			if(_type == TYPE_CUSTOM) str += "\n\td: " +d;
			else if(_type == TYPE_CIRCLE || _type == TYPE_ROUNDRECT){
				str += "\n\tradius: " +radius;
			}

			str += "\n\tdescription: " +description;

			return str;
		}

		public function toXmlNodeString():String {

			var xmlStr:String = "<path ";

			xmlStr += "id=\"" +id + "\" ";
			xmlStr += "boundingBox=\"" +boundingBox.toString() + "\" ";

			if(_type == TYPE_CUSTOM) xmlStr += "d=\"" +d + "\"";
			else if (_type == TYPE_CIRCLE || _type == TYPE_ROUNDRECT){
				xmlStr += "radius=\"" +radius + "\"";
			}
			xmlStr += ">";
			xmlStr += transform.toXmlNodeString();

			if(description.length){
				xmlStr += ">";
				xmlStr += "<description><[!CDATA[";
				xmlStr += description;
				xmlStr += "]]></description>";
			}

			xmlStr += "</path>";

			return xmlStr;
		}
	}
}
