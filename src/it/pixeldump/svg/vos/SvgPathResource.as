
/**
 * @author jaco
 *
 * created on 5/9/2011 2:30:13 PM
 */

package it.pixeldump.svg.vos {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.utils.*;

	import it.pixeldump.svg.SvgPath;

	/**
	 *
	 */
	 public class SvgPathResource{

		public var resourceName:String = "";
		public var svgPaths:Vector.<SvgPath>;

	 	public function set xml(v:XML):void {

			svgPaths = new Vector.<SvgPath>();
			resourceName = v.@resourceName ? v.@resourceName.toString() : "resid_" +getTimer();


			for each(var xi:XML in v..path){

				var svgPath:SvgPath = new SvgPath(xi.@d.toString(), xi.@id.toString());

				svgPaths.push(svgPath);
			}
	 	}

		public function get svgPathIDs():Array {

			var ids:Array = [];

			if(!svgPaths) return ids;

			for each(var svgPath:SvgPath in svgPaths) ids.push(svgPath.id);

			return ids;
		}

		/**
		 * the constructor
		 */
		function SvgPathResource(){ /* nop */ }


		// ---------------- public methods

		/**
		 *
		 */
		public function getSvgPathByID(id:String):SvgPath {

			for each(var svgPath:SvgPath in svgPaths){

				if(svgPath.id == id) return svgPath;
			}

			return null;
		}

		/**
		 *
		 */
		public function drawGraphicsByID(id:String, g:Graphics, drawAttributes:Object = null):void {

			var svgPath:SvgPath = getSvgPathByID(id);

			if(!svgPath) return;

			var gp:GraphicsPath = svgPath.graphicsPath;

			g.clear();
			g.beginFill(0x0);
			g.drawPath(gp.commands, gp.data);
			g.endFill();
		}

		/**
		 *
		 */
		public function toString():String {

			var str:String = "svgPathResource:";
			str += "\n\tresourceName: " +resourceName;
			str += "\n\tsvgPaths: ";

			for each(var svgPath:SvgPath in svgPaths) str += svgPath.toString();

			return str;
		}
	} // end of class
} // end of pkg
