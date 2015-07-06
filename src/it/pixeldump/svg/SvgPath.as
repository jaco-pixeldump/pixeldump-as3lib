/**
 * @author jaco
 *
 * created on 4/28/2011 9:28:14 PM
 */
package it.pixeldump.svg {

	import flash.display.GraphicsPath;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import it.pixeldump.utils.StringUtil;
	import it.pixeldump.utils.geom.BezierUtil;
	import it.pixeldump.utils.geom.GeomUtil;

	public class SvgPath {

		private static const supportedCommands:String = "MLHVQCSTZmlhvqcstz";

		private static const functNames:Object = {  M:"absMoveTo",
													L:"absLineTo",
													H:"absHorizontalLineTo",
													V:"absVerticalLineTo",
													Q:"absCurveTo",
													C:"absSplineTo",
													S:"absShortHandSplineTo",
													T:"absShortHandCurveTo",
													Z:"closePath",
													m:"relativeMoveTo",
													l:"relativeLineTo",
													h:"relativeHorizontalLineTo",
													v:"relativeVerticalLineTo",
													q:"relativeCurveTo",
													c:"relativeSplineTo",
													s:"relativeShortHandSplineTo",
													t:"relativeShortHandCurveTo",
													z:"closePath"};

		private var _flipY:int = -1;

		protected var currentX:Number = 0;
		protected var currentY:Number = 0;
		protected var initialX:Number = 0;
		protected var initialY:Number = 0;
		protected var lastAX:Number = 0;
		protected var lastAY:Number = 0;

		protected var lastBezierAX:Number = 0;
		protected var lastBezierAY:Number = 0;

		protected var _id:String = "";
		protected var _name:String = "";
		protected var _d:String = "";
		protected var _bounds:Rectangle;
		protected var _graphicsPath:GraphicsPath;

		// effective enclosing bounds
		protected var xmin:Number;
		protected var ymin:Number;
		protected var xmax:Number;
		protected var ymax:Number;

		protected var commands:Array = [];
		protected var commandIndex:int = 0;

		public function set flipVertical(v:Boolean):void { _flipY = v ? -1 : 1; }

		public function get d():String { return _d; }
		public function get id():String { return _id; }

		public function set name(v:String):void { _name = v; }
		public function get name():String { return _name; }

		public function get graphicsPath():GraphicsPath {

			if(!_graphicsPath) buildPath();

			return _graphicsPath;
		}

		public function get bounds():Rectangle {
			updateBounds();

			return new Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
		}

		/**
		 * the constructor
		 */
		function SvgPath(d:String, id:String = "", buildPath:Boolean = true, flipV:Boolean = true) {
			_d = d;
			_id = id;

			removeLineBreaks();

			flipVertical = flipV;

			if(buildPath) this.buildPath();
		}

		/**
		 *
		 */
		private function buildPath():void {
			_graphicsPath = new GraphicsPath();
			commands = new Array();
			commands.push(""),
			commandIndex = 0;

			xmin = ymin = 1000000;
			xmax = ymax = -1000000;

			if(!_d || !_d.length) {
				xmin = 0; xmax = 0;
				ymin = 0; ymax = 0;
				return; // no path to build
			}

			var cmds:Array = parseD();

			for each(var s:String in cmds) {

				if(!s.length) continue;

				var cmd:String = s.charAt(0);

				if(!cmd.length || supportedCommands.indexOf(cmd) == -1) continue; // ignore unsupported commands

				var args:Array = (s.substring(1).split(" "));

				for(var i:String in args) args[i] = parseFloat(args[i]);

				commands.push(cmd);
				commandIndex++;

				this[functNames[cmd]](args);
			}
		}

		private function removeLineBreaks():void {

			var re:RegExp;

			if(_d.indexOf("\r") > - 1){
				re = new RegExp("\r", "gi");
				_d = StringUtil.trim(_d).replace(re, "");
			}

			if(_d.indexOf("\n") > - 1) {
				re = new RegExp("\n", "gi");
				_d = _d.replace(re, " ");
			}
		}

		/**
		 *
		 */
		private function parseD():Array {

			var t:String;
			var re:RegExp;
			var str:String = _d;

			if(str.indexOf("e-") > -1){ // _d contains scientific notation

				var cmds:Array = [];
				var numeric:String = "0123456789-";
				var strNumber:String = "";

				re = /,/g;
				str = str.replace(re, " ");

				var tokens:Array = str.split(" ");

				for each(var token:String in tokens) {
					t = StringUtil.trim(token);

					if(supportedCommands.indexOf(t) > -1){
						cmds.push(t);
						continue;
					}

					var ch:String = t.charAt(0);
					var ofst:int = 0;

					if(numeric.indexOf(ch) == -1) {

						cmds.push(ch);
						ofst = 1;
					}

					var rawNumber:String = t.substring(ofst);

					if(rawNumber.indexOf("e-") > -1)
						strNumber = "" +((Math.round(parseFloat(t.substring(ofst)) * 100000000)) / 10000000);
					else strNumber = rawNumber;

					cmds.push(strNumber);
					str = cmds.join(" ");
				}
			}

			re = /[A-Za-z]/g;
			str = str.replace(re, "_$&#");
			re = /\s+_/g;
			str = str.replace(re, "_");
			re = /#\s+/g;
			str = str.replace(re, "");

			if(str.indexOf("#") > -1){
				re = /#/g;
				str = str.replace(re, "");
			}

			if(str.indexOf(",") > -1){
				re = /,/g;
				str = str.replace(re, " ");
			}

			return str.split("_");
		}

		// absolute MOVETO
		private function absMoveTo(args:Array):void {
			//trace("absMoveTo", args.toString());

			args[1] *= _flipY;

			currentX = initialX = lastAX = args[0];
			currentY = initialY = lastAY = args[1];

			_graphicsPath.moveTo(currentX, currentY);

			if(args.length > 2){
				args.shift();
				args.shift();
				absLineTo(args);
			}
		}

		// absolute LINETO
		private function absLineTo(args:Array):void {
			//trace("absLineTo", args.toString());

			if(args.length > 2){
				multiAbsLineTo(args);
				return;
			}

			args[1] *= _flipY;

			currentX = lastAX = args[0];
			currentY = lastAX = args[1];

			_graphicsPath.lineTo(currentX, currentY);
		}

		private function multiAbsLineTo(args:Array):void {
			//trace("multiAbsLineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 2){

				var coords:Array = [args[i], args[i + 1]];

				absLineTo(coords);
			}
		}

		// absolute horizontal LINETO
		private function absHorizontalLineTo(args:Array):void {
			//trace("absHorizontalLineTo", args.toString());

			if(args.length > 1){
				multiAbsHorizontalLineTo(args);
				return;
			}

			currentX = args[0];

			_graphicsPath.lineTo(currentX, currentY);
			reflectLastControlPoint();
		}

		private function multiAbsHorizontalLineTo(args:Array):void {
			//trace("multiAbsHorizontalLineTo", args.toString());

			for(var i:int = 0; i < args.length; i++){

				var coords:Array = [];

				coords.push(args[i]);
				absHorizontalLineTo(coords);
			}
		}

		// absolute vertical LINETO
		private function absVerticalLineTo(args:Array):void {
			//trace("absVerticalLineTo", args.toString());

			if(args.length > 1){
				multiAbsVerticalLineTo(args);
				return;
			}

			args[0] *= _flipY;
			currentY = args[0];

			_graphicsPath.lineTo(currentX, currentY);
			reflectLastControlPoint();
		}

		private function multiAbsVerticalLineTo(args:Array):void {
			//trace("multiAbsVerticalLineTo", args.toString());

			for(var i:int = 0; i < args.length; i++){

				var coords:Array = [];

				coords.push(args[i]);
				absVerticalLineTo(coords);
			}
		}

		// absolute CURVETO
		private function absCurveTo(args:Array):void {
			//trace("absCurveTo", args.toString());

			if(args.length > 4){
				multiAbsCurveTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;

			var ax:Number = args[0];
			var ay:Number = args[1];

			currentX = args[2];
			currentY = args[3];

			_graphicsPath.curveTo(ax, ay, currentX, currentY);
			reflectLastControlPoint(new Point(ax, ay));
		}

		private function multiAbsCurveTo(args:Array):void {
			//trace("multiAbsCurveTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){
				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];
				absCurveTo(coords);
			}
		}

		// absolute SPLINETO (translate do multiple abs CURVETO)
		private function absSplineTo(args:Array):void {
			//trace("absSplineTo", args.toString());

			if(args.length > 6){
				multiAbsSplineTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;
			args[5] *= _flipY;

			var p1:Point = new Point(currentX, currentY);
			var p2:Point = new Point(args[0], args[1]);
			var p3:Point = new Point(args[2], args[3]);
			var p4:Point = new Point(args[4], args[5]);

			var curves:Array = BezierUtil.getBezierCurves (p1, p2, p3, p4, .3);

			for each(var coords:Array in curves) absCurveTo(coords);

			reflectLastBezierControlPoint(p3);
		}

		private function multiAbsSplineTo(args:Array):void {
			//trace("multiAbsplineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 6){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3], args[i + 4], args[i + 5]];

				absSplineTo(coords);
			}
		}

		private function multiAbsShortHandSplineTo(args:Array):void {
			//trace("multiAbsShortHandSplineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];

				absSplineTo(coords);
			}
		}

		// shorthand SPLINETO (translate do multiple abs CURVETO)
		// NOT TESTED
		private function absShortHandSplineTo(args:Array):void {
			//trace("absShortHandSplineTo", args.toString());

			if(args.length > 4){
				multiAbsShortHandSplineTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;

			var p1:Point = new Point(currentX, currentY);
			var p2:Point = new Point(lastBezierAX, lastBezierAY);
			var p3:Point = new Point(args[0], args[1]);
			var p4:Point = new Point(args[2], args[3]);

			var curves:Array = BezierUtil.getBezierCurves (p1, p2, p3, p4, .3);

			for each(var coords:Array in curves) absCurveTo(coords);

			reflectLastBezierControlPoint(p3);
		}


		// absolute "shorthand" CURVETO
		private function absShortHandCurveTo(args:Array):void {
			//trace("absShortHandCurveTo", args.toString());

			if(args.length > 4){
				multiAbsShortHandCurveTo(args);
				return;
			}

			args[1] *= _flipY;

			currentX = args[0];
			currentY = args[1];

			_graphicsPath.curveTo(lastAX, lastAY, currentX, currentY);
			reflectLastControlPoint(new Point(lastAX, lastAY));
		}

		private function multiAbsShortHandCurveTo(args:Array):void {
			//trace("multiAbsShortHandCurveTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];

				absShortHandCurveTo(coords);
			}
		}


		// ----- relative commands

		// absolute MOVETO
		private function relativeMoveTo(args:Array):void {
			//trace("relativeMoveTo", args.toString());

			args[1] *= _flipY;

			currentX += args[0];
			currentY += args[1];

			initialX = currentX;
			initialY = currentY;

			_graphicsPath.moveTo(currentX, currentY);
			//reflectLastControlPoint();

			if(args.length > 2){
				args.shift();
				args.shift();
				relativeLineTo(args);
			}
		}

		// relative lineto
		private function relativeLineTo(args:Array):void {
			//trace("relativeLineTo", args.toString());

			if(args.length > 2){
				multiRelativeLineTo(args);
				return;
			}

			args[1] *= _flipY;

			currentX += args[0];
			currentY += args[1];

			_graphicsPath.lineTo(currentX, currentY);
			reflectLastControlPoint();
		}

		private function multiRelativeLineTo(args:Array):void {
			//trace("multiRelativeLineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 2){

				var coords:Array = [args[i], args[i + 1]];

				relativeLineTo(coords);
			}
		}

		// relative horizontal lineto
		private function relativeHorizontalLineTo(args:Array):void {
			//trace("relativeHorizontalLineTo", args.toString());

			if(args.length > 1){
				multiRelativeHorizontalLineTo(args);
				return;
			}

			currentX += args[0];

			_graphicsPath.lineTo(currentX, currentY);
			reflectLastControlPoint();
		}

		private function multiRelativeHorizontalLineTo(args:Array):void {
			//trace("multiRelativeHorizontalLineTo", args.toString());

			for(var i:int = 0; i < args.length; i++){
				var coords:Array = [];
				coords.push(args[i]);
				relativeHorizontalLineTo(coords);
			}
		}

		// relative vertical lineto
		private function relativeVerticalLineTo(args:Array):void {
			// trace("relativeVerticalLineTo", args.toString());

			if(args.length > 1){
				multiRelativeVerticalLineTo(args);
				return;
			}

			args[0] *= _flipY;
			currentY += args[0];

			_graphicsPath.lineTo(currentX, currentY);
			reflectLastControlPoint();
		}

		private function multiRelativeVerticalLineTo(args:Array):void {
			//trace("multiRelativeVerticalLineTo", args.toString());

			for(var i:int = 0; i < args.length; i++){
				var coords:Array = [];
				coords.push(args[i]);
				relativeVerticalLineTo(coords);
			}
		}

		// relative curveto
		private function relativeCurveTo(args:Array):void {
			//trace("relativeCurveTo", args.toString());

			if(args.length > 4){
				multiRelativeCurveTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;

			var ax:Number = currentX + args[0];
			var ay:Number = currentY + args[1];

			currentX += args[2];
			currentY += args[3];

			_graphicsPath.curveTo(ax, ay, currentX, currentY);
			reflectLastControlPoint(new Point(ax, ay));
		}

		private function multiRelativeCurveTo(args:Array):void {
			//trace("multiRelativeCurveTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];

				relativeCurveTo(coords);
			}
		}

		// relative splineto (translate to multiple quadratic splines)
		private function relativeSplineTo(args:Array):void {
			//trace("relativeSplineTo", args.toString());

			if(args.length > 6){
				multiRelativeSplineTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;
			args[5] *= _flipY;

			var ax:Number = currentX + args[0];
			var ay:Number = currentY + args[1];

			var bx:Number = currentX + args[2];
			var by:Number = currentY + args[3];

			var cx:Number = currentX + args[4];
			var cy:Number = currentY + args[5];

			var p1:Point = new Point(currentX, currentY);
			var p2:Point = new Point(ax, ay);
			var p3:Point = new Point(bx, by);
			var p4:Point = new Point(cx, cy);

			var curves:Array = BezierUtil.getBezierCurves (p1, p2, p3, p4, .3);

			currentX += args[4];
			currentY += args[5];

			for each(var coords:Array in curves) {
				ax = coords[0];
				ay = coords[1];

				currentX = coords[2];
				currentY = coords[3];

				_graphicsPath.curveTo(ax, ay, currentX, currentY);
				reflectLastControlPoint(new Point(ax, ay));
			}

			reflectLastBezierControlPoint(p3);
		}

		private function multiRelativeSplineTo(args:Array):void {
			//trace("multiRelativeSplineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 6){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3], args[i + 4], args[i + 5]];

				relativeSplineTo(coords);
			}
		}

		// relative "shorthand" curveto
		// NOT TESTED
		private function relativeShortHandSplineTo(args:Array):void {
			//trace("relativeShortHandSplineTo", args.toString());

			if(args.length > 4){
				multiRelativeShortHandSplineTo(args);
				return;
			}

			args[1] *= _flipY;
			args[3] *= _flipY;

			var p1:Point = new Point(currentX, currentY);
			var p2:Point = new Point(lastBezierAX, lastBezierAY);
			var p3:Point = new Point(currentX + args[0], currentY + args[1]);
			var p4:Point = new Point(currentX + args[2], currentY + args[3]);

			var curves:Array = BezierUtil.getBezierCurves (p1, p2, p3, p4, .3);

			currentX += args[2];
			currentY += args[3];

			for each(var coords:Array in curves) {

				var ax:Number = coords[0];
				var ay:Number = coords[1];

				currentX = coords[2];
				currentY = coords[3];

				_graphicsPath.curveTo(ax, ay, currentX, currentY);
				reflectLastControlPoint(new Point(ax, ay));
			}

			reflectLastBezierControlPoint(p3);
		}

		// multi
		private function multiRelativeShortHandSplineTo(args:Array):void {
			//trace("multiRelativeSplineTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){

				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];

				relativeSplineTo(coords);
			}
		}


		// relative "shorthand" curveto
		private function relativeShortHandCurveTo(args:Array):void {
			//trace("relativeShortHandCurveTo", args.toString());

			if(args.length > 4){
				multiRelativeShortHandCurveTo(args);
				return;
			}

			args[1] *= _flipY;

			currentX += args[0];
			currentY += args[1];

			_graphicsPath.curveTo(lastAX, lastAY, currentX, currentY);
			reflectLastControlPoint(new Point(lastAX, lastAY));
		}


		private function multiRelativeShortHandCurveTo(args:Array):void {
			//trace("multiRelativeShortHandCurveTo", args.toString());

			for(var i:int = 0; i < args.length; i += 4){
				var coords:Array = [args[i], args[i + 1], args[i + 2], args[i + 3]];
				relativeShortHandCurveTo(coords);
			}
		}

		// CLOSE/close path
		private function closePath(args:Array):void {
			//trace("closePath");

			currentX = lastAX = initialX;
			currentY = lastAX = initialY;

			_graphicsPath.lineTo(currentX, currentY);
		}

		private function reflectLastControlPoint(p:Point = null):void {
			lastAX = currentX;
			lastAY = currentY;

			if(!p) 	return;

			var p2:Point = new Point(currentX, currentY);
			var p1:Point = GeomUtil.rotatePointAroundAnother(p, p2, 180);

			lastAX = p1.x;
			lastAY = p1.y;
		}

		private function reflectLastBezierControlPoint(p:Point = null):void {
			lastBezierAX = currentX;
			lastBezierAY = currentY;

			if(!p) 	return;

			var p2:Point = new Point(currentX, currentY);
			var p1:Point = GeomUtil.rotatePointAroundAnother(p, p2, 180);

			lastBezierAX = p1.x;
			lastBezierAY = p1.y;
		}

		private function updateBounds():void {

			if(!_graphicsPath.data) return; // this svgpath is yet empty

			var cCount:int = _graphicsPath.data.length;

			for(var i:int = 0; i < cCount; i += 2){

				var cx:Number = _graphicsPath.data[i];
				var cy:Number = _graphicsPath.data[i + 1];

				xmin = Math.min(xmin, cx);
				xmax = Math.max(xmax, cx);

				ymin = Math.min(ymin, cy);
				ymax = Math.max(ymax, cy);
			}

			//trace("xmin, xmax, ymin, ymax", xmin, xmax, ymin, ymax);
		}

		/**
		 *
		 */
		public function toString():String {

			var str:String = "svgPath:";

			str += "\nid: " +_id;
			str += "\nd: "  +_d;

			return str;
		}
	}
}