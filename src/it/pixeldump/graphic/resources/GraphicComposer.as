package it.pixeldump.graphic.resources {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import it.pixeldump.graphic.theme.GraphicResource;
	import it.pixeldump.graphic.vos.GraphicDataVO;
	import it.pixeldump.graphic.vos.GraphicItemVO;
	import it.pixeldump.graphic.vos.PathVO;
	import it.pixeldump.graphic.vos.TransformVO;
	import it.pixeldump.svg.SvgPath;

	public class GraphicComposer {

		private static var g:Graphics;
		private static var gp:GraphicsPath;
		private static var sp:Shape;

		public static var symbolCache:Vector.<Object> = new Vector.<Object>();

		//public function GraphicComposer() {}

		public static function cacheSymbol(giIds:Array, symbolName:String):void {
			var sp:Shape = new Shape();

			GraphicComposer.drawGraphicsByItemIds(sp.graphics, giIds);

			var o:Object = { symbolName: symbolName, graphics: sp.graphics};

			symbolCache.push(o);
		}

		public static function getSymbolByName(symbolName:String):Graphics {

			var sLength:int = symbolCache.length;

			for(var i:int = 0; i < sLength; i++){
				if(symbolCache[i].symbolName == symbolName) return symbolCache[i].graphics;
			}

			return null;
		}

		public static function prepareGraphics(g:Graphics, gd:GraphicDataVO):void {

			if(gd.clearGraphics) g.clear();

			if(gd.startGraphics) {
				if(gd.fillTransparent) g.beginFill(gd.fillColor, gd.fillAlpha);
				else if(gd.useFill) g.beginFill(gd.fillColor);
			}

			if(gd.onlyStrokeSolid) g.lineStyle(gd.strokeWidth, gd.strokeColor);
			else if(gd.strokeTransparent) g.lineStyle(gd.strokeWidth, gd.strokeColor, gd.strokeAlpha);
		}

		public static function drawLine(g:Graphics, relPoint:Point, coordStart:Point = null):void {

			if(coordStart) g.moveTo(coordStart.x, coordStart.y);

			g.lineTo(relPoint.x, relPoint.y);
		}

		public static function drawGraphicsRect(g:Graphics, wd:Number, hg:Number, color:uint = 0x0, clear:Boolean = true, pOffset:Point = null, fill:Boolean = true):void {

			if(clear) g.clear();
			if(!pOffset) pOffset = new Point();
			if(fill) g.beginFill(color);

			g.drawRect(pOffset.x, pOffset.y, wd, hg);

			if(fill) g.endFill();
		}

		public static function drawGraphicsCircle(g:Graphics, radius:Number, color:uint = 0x0, clear:Boolean = true, pOffset:Point = null, fill:Boolean = true):void {

			if(clear) g.clear();
			if(!pOffset) pOffset = new Point();
			if(fill) g.beginFill(color);

			g.drawCircle(pOffset.x, pOffset.y, radius);

			if(fill) g.endFill();
		}

		public static function drawGraphicsByPathResourceId(g:Graphics, pathID:String, gd:GraphicDataVO):void {
			GraphicComposer.prepareGraphics(g, gd);
			gp = GraphicResource.getGraphicsPathByPathResourceId(pathID, gd.transform);
			g.drawPath(gp.commands, gp.data);

			if(gd.closeGraphics) g.endFill();
		}

		public static function drawGraphicsByPathResourceName(g:Graphics, pathName:String, gd:GraphicDataVO):void {
			GraphicComposer.prepareGraphics(g, gd);
			gp = GraphicResource.getGraphicsPathByPathResourceName(pathName, gd.transform);
			g.drawPath(gp.commands, gp.data);

			if(gd.closeGraphics) g.endFill();
		}

		public static function drawRect(sp:Shape, wd:Number, hg:Number, color:uint = 0x0, clear:Boolean = true, pOffset:Point = null, fill:Boolean = true):void {
			GraphicComposer.drawGraphicsRect(sp.graphics, wd, hg, color, clear, pOffset, fill);
		}

		public static function drawCircle(sp:Shape, radius:Number, color:uint = 0x0, clear:Boolean = true, pOffset:Point = null, fill:Boolean = true):void {
			GraphicComposer.drawGraphicsCircle(sp.graphics, radius, color, clear, pOffset, fill);
		}

		public static function drawPieSlice(sp:Shape, start:Number, end:Number, radius:Number, gd:GraphicDataVO):void {
			prepareGraphics(sp.graphics, gd);

			sp.graphics.moveTo(gd.transform.x, gd.transform.y);
			GraphicComposer.drawArc(sp.graphics, new Point(gd.transform.x, gd.transform.y), start, end, radius, 1, 1, false);
			sp.graphics.lineTo(gd.transform.x, gd.transform.y);
			sp.graphics.endFill();
		}

		/**
		 * Draw a segment of a circle
		 * @param g		        the graphics object to draw into
		 * @param center        the center of the circle
		 * @param start         start angle (radians)
		 * @param end           end angle (radians)
		 * @param r             radius of the circle
		 * @param h_ratio       horizontal scaling factor
		 * @param v_ratio       vertical scaling factor
		 * @param onCircle   if true, uses a moveTo call to start drawing at the start point of the circle; else continues drawing using only lineTo and curveTo
		 * note: code comes from stackOverflow, yet another slice drawing method, easy to find out
 		 */
		public static function drawArc(g:Graphics, center:Point, start:Number, end:Number, r:Number, h_ratio:Number = 1, v_ratio:Number = 1, onCircle:Boolean = true):void {

			var x:Number = center.x;
			var y:Number = center.y;

			// draw the circle in segments
			var segments:int = Math.ceil(Math.abs(end - start) / (Math.PI / 4));

			// first point of the circle segment
			if(onCircle) g.moveTo(x + Math.cos(start) * r * h_ratio, y + Math.sin(start) * r * v_ratio);
			else g.lineTo(x + Math.cos(start) * r * h_ratio, y + Math.sin(start) * r * v_ratio);


			var theta:Number = (end - start) / segments;
			var angle:Number = start; // start drawing at angle ...
			var ctrlRadius:Number = r / Math.cos(theta / 2); // this gets the radius of the control point

			for (var i:int = 0; i < segments; i++) {

				// increment the angle
				angle += theta;

				var angleMid:Number = angle - (theta / 2);

				// calculate our control point
				var cx:Number = x + Math.cos(angleMid) * (ctrlRadius * h_ratio);
				var cy:Number = y + Math.sin(angleMid) * (ctrlRadius * v_ratio);

				// calculate our end point
				var px:Number = x + Math.cos(angle) * r * h_ratio;
				var py:Number = y + Math.sin(angle) * r * v_ratio;

				// draw the circle segment
				g.curveTo(cx, cy, px, py);
			}
		}

		public static function createPathById(pathID:String):PathVO {
			var p:PathVO = new PathVO();

			p.xml = GraphicResource.getPathResourceById(pathID);

			return p;
		}

		public static function createGraphicItemById(graphicItemID:String):GraphicItemVO {

			var gr:XML = GraphicResource.getGraphicResourceById(graphicItemID);

			if(!gr) return null;

			var gi:GraphicItemVO = new GraphicItemVO();

			gi.xml = gr;

			for each(var xi:XML in gr..pathRef){

				var p:PathVO = new PathVO();

				p.xml = GraphicResource.getPathResourceById(xi.@id);
				gi.paths.push(p);
			}

			return gi;
		}

		public static function drawGraphicsByItemIds(g:Graphics, ids:Array):void {

			var iLength:int = ids.length;

			for(var i:int = 0; i < iLength; i++){

				var giID:String = ids[i];
				var gi:GraphicItemVO = GraphicComposer.createGraphicItemById(giID);

				if(i) gi.graphicData.clearGraphics = false;

				GraphicComposer.drawGraphicItem(g, gi);
			}
		}

		public static function drawGraphicItem(g:Graphics, gi:GraphicItemVO):void {

			var gd:GraphicDataVO = gi.graphicData;
			var t:TransformVO = gd.transform;

			prepareGraphics(g, gd);

			for each(var p:PathVO in gi.paths) {

				if(p.type == PathVO.TYPE_CUSTOM && p.d.length > 0) {

					var svgPath:SvgPath = new SvgPath(p.d, p.id, true, false);
					var gp:GraphicsPath = GraphicResource.createGraphicsPath(svgPath, t.x, t.y, t.scaleX, t.scaleY, t.rotation);

					g.drawPath(gp.commands, gp.data);
				}
				else if(p.type == PathVO.TYPE_CIRCLE && p.radius > 0) {
					g.drawCircle(t.x, t.y, p.radius * t.scaleX);
				}
				else if(p.type == PathVO.TYPE_RECT && p.boundingBox.width > 0 && p.boundingBox.height > 0) {
					g.drawRect(t.x, t.y, p.boundingBox.width * t.scaleX, p.boundingBox.height * t.scaleY);
				}
				else if(p.type == PathVO.TYPE_ROUNDRECT && p.radius > 0 && p.boundingBox.width > 0 && p.boundingBox.height > 0) {

					var rScaled:Number = p.radius * ((t.scaleX + t.scaleY) / 2);

					g.drawRoundRect(t.x, t.y, p.boundingBox.width * t.scaleX, p.boundingBox.height * t.scaleY, rScaled, rScaled);
				}
			}

			if(gd.closeGraphics) g.endFill();
		}

		public static function createBitmap(sp:Shape, bounds:Rectangle = null):Bitmap {

			if(!bounds) bounds = sp.getBounds(sp);

			var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
			var bd:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x0);

			bd.draw(sp, m, null, null, null, true);

			var bmpIcon:Bitmap = new Bitmap(bd, "auto", true);

			return bmpIcon;
		}

		public static function cacheBitmap(container:DisplayObjectContainer, sp:Shape, bounds:Rectangle = null, clear:Boolean = true):void {
			var bmp:Bitmap = GraphicComposer.createBitmap(sp, bounds);

			if(clear) container.removeChildren();

			container.addChild(bmp);
		}


		/**
		 * Scales r-g-b channels by 'scale' factor, having the r-g-b proportions saved
		 * @param    color:uint        color to be scaled (i.e. lighten or darken)
		 * @param    scale:Number    the scale factor (values -1 to 1) -1 = absolute dark; 1 = absolute light;
		 * @return   uint            scaled color
		 * @credit: http://wonderfl.net/c/rU4n
		 */
		public static function scaleColor(color:uint, scale:Number):uint {

			var r:int = (color & 0xFF0000) >> 16;
			var g:int = (color & 0x00FF00) >> 8;
			var b:int = color & 0x0000FF;

			r += (255 * scale) * (r / (r + g + b));
			r = (r > 255) ? 255 : r;
			r = (r < 0) ? 0 : r;

			g += (255 * scale) * (g / (r + g + b));
			g = (g > 255) ? 255 : g;
			g = (g < 0) ? 0 : g;

			b += (255 * scale) * (b / (r + g + b));
			b = (b > 255) ? 255 : b;
			b = (b < 0) ? 0 : b;

			return (r << 16 & 0xFF0000) + (g << 8 & 0x00FF00) + (b & 0x0000FF);
		}
	}
}
