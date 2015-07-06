package it.pixeldump.graphic.theme {

	import flash.display.GraphicsPath;
	import flash.geom.Point;

	import it.pixeldump.graphic.vos.TransformVO;
	import it.pixeldump.svg.SvgPath;
	import it.pixeldump.utils.geom.GeomUtil;
	import it.pixeldump.utils.StringUtil;

	public class GraphicResource {

		public static var pathRes:XML = XML(new Resource.PATH_RES());
		public static var graphicRes:XML = XML(new Resource.GRAPHIC_RES());

		public static var res:Vector.<XML> = new <XML>[pathRes];
		public static var gr:Vector.<XML> = new <XML>[graphicRes];

		// public function GraphicResource() { }

		// ----------------- privs

		private static function get p():XML { return pathRes; }

		private static function get g():XML { return graphicRes; }

		// ----------------- publics

		public static function addPathResource(v:XML):void { res.push(v); }
		public static function addGraphicResource(v:XML):void { gr.push(v); }

		public static function createGraphicsPath(svgPath:SvgPath,
												  x:Number = 0, y:Number = 0,
												  scaleX:Number = 1, scaleY:Number = 1,
												  rotation:Number = 0):GraphicsPath {

			var gp:GraphicsPath = new GraphicsPath();

			gp.commands = svgPath.graphicsPath.commands;
			gp.data = svgPath.graphicsPath.data;

			if(x != 0 || y != 0 || scaleX != 1 || scaleY != 1){
				gp.data = GeomUtil.scaleCoords(gp.data, scaleX, scaleY, x, y);
			}

			if(rotation != 0) gp.data = GeomUtil.rotateCoords(gp.data, new Point(x, y), rotation);

			return gp;
		}

		public static function getPathResourceById(pathID:String):XML{

			for each(var pr:XML in res) {
				for each(var xi:XML in pr..path){

					if(xi.@id == pathID) return xi;
				}
			}

			return null;
		}

		public static function getPathResourceByName(pathName:String):XML{

			for each(var pr:XML in res) {
				for each(var xi:XML in pr..path){

					if(xi.@name == pathName) return xi;
				}
			}

			return null;
		}

		public static function getGraphicsPathByPathResourceId(pathID:String, t:TransformVO):GraphicsPath {

			var sXml:XML = getPathResourceById(pathID);

			if(!sXml) return null;

			var svgPath:SvgPath = new SvgPath(sXml.@d, pathID, true, false);

			return createGraphicsPath(svgPath, t.x, t.y, t.scaleX, t.scaleY, t.rotation);
		}

		public static function getGraphicsPathByPathResourceName(pathName:String, t:TransformVO):GraphicsPath {

			var sXml:XML = getPathResourceByName(pathName);

			if(!sXml) return null;

			var svgPath:SvgPath = new SvgPath(sXml.@d, sXml.@id, true, false);

			svgPath.name = pathName;

			return createGraphicsPath(svgPath, t.x, t.y, t.scaleX, t.scaleY, t.rotation);
		}

		public static function getColorById(colorID:String):uint {

			var color:uint = 0x0;

			for each(var rg:XML in gr) {

				if(!rg..colorDefinition.length()) continue;

				var xi:XML = rg..colorDefinition[0];

				for each(var xj:XML in xi..color){
					if(xj.@id == colorID) return parseInt(xj.@value);
				}
			}

			return color;
		}

		public static function replaceReferencedColor(gx:XML):XML {

			var color:uint = 0;

			if(gx..graphicData[0].@fillColor.indexOf("@") > -1) {

				color = getColorById(gx..graphicData[0].@fillColor.substring(1));
				gx..graphicData[0].@fillColor = StringUtil.toColorString(color);
			}

			if(gx..graphicData[0].@strokeColor.indexOf("@") > -1) {
				color = getColorById(gx..graphicData[0].@strokeColor.substring(1));
				gx..graphicData[0].@strokeColor = StringUtil.toColorString(color);
			}

			return gx;
		}

		public static function getGraphicResourceById(graphicItemID:String):XML {

			for each(var rg:XML in gr) {
				for each(var xi:XML in rg..graphicItem){

					if(xi.@id == graphicItemID) {
						return replaceReferencedColor(xi);
					}
				}
			}

			return null;
		}

		public static function getGraphicResourceByName(graphicItemName:String):XML {

			for each(var rg:XML in gr) {
				for each(var xi:XML in rg..graphicItem){

					if(xi.@name == graphicItemName) return xi;
				}
			}

			return null;
		}
	} // end of class
} // end of pkg