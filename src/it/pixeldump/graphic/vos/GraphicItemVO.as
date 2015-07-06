package it.pixeldump.graphic.vos {

	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class GraphicItemVO {

		public var id:String = "";
		public var name:String = "";
		public var graphicData:GraphicDataVO = new GraphicDataVO();
		public var paths:Vector.<PathVO> = new Vector.<PathVO>();

		public function set xml(v:XML):void {
			id = v.@id;
			name = v.@name;

			graphicData = new GraphicDataVO();
			graphicData.xml = v..graphicData[0];

			paths = new Vector.<PathVO>();
		}

		/**
		 * the constructor
		 */
		public function GraphicItemVO() {
			id = "gi-" +getTimer() + "-" +Math.round(Math.random() * 9999);
		}

		public function addCircle(r:Number):PathVO {

			var p:PathVO = new PathVO();

			p.type = PathVO.TYPE_CIRCLE;
			p.radius = r;

			paths.push(p);

			return p;
		}

		public function addRect(wd:Number, hg:Number = NaN):PathVO {

			var p:PathVO = new PathVO();

			p.type = PathVO.TYPE_RECT;
			p.boundingBox.width = wd;
			p.boundingBox.height = isNaN(hg) ? wd : hg;

			paths.push(p);

			return p;
		}

		public function addRoundRect(wd:Number, hg:Number, r:Number = -1):PathVO {

			var p:PathVO = new PathVO();

			p.type = PathVO.TYPE_ROUNDRECT;
			p.boundingBox.width = wd;
			p.boundingBox.height = hg;
			p.radius = r > 0 ? r : hg;

			paths.push(p);

			return p;
		}

		public function clearPaths():void {
			paths = new Vector.<PathVO>();
		}

		public function getGlobalBoundingBox():Rectangle {

			var pLength:int = paths.length;

			if(!pLength) return new Rectangle();

			var r:Rectangle = paths[0].boundingBox.clone();

			for(var i:int = 1; i < pLength; i++) r = r.union(paths[i].boundingBox);

			return r;
		}

		public function toString():String {

			var str:String = "graphicItemVO:";

			str += "\n\tid: " +id;
			str += "\n\tname: " +name;
			str += "\n\t" +graphicData.toString();
			str += "\n\t\tpaths:";

			for each(var p:PathVO in paths) str += "\n\t\t" +p.toString();

			return str;
		}

		public function toXmlNodeString():String {

			var xmlStr:String = "<graphicItem ";

			xmlStr += "id=\"" +id +"\" ";
			xmlStr += "name=\"" +name +"\" >";
			xmlStr += graphicData.toXmlNodeString();
			xmlStr += "<paths>";

			for each(var p:PathVO in paths){
				xmlStr += p.toXmlNodeString();
			}

			xmlStr += "</paths>";
			xmlStr += "</graphicItem>";

			return xmlStr;
 		}
	}
}