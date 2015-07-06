

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineShape2 extends DefineShape {

		public static const CLASS_NAME:String =  "DefineShape2";
		public static const CLASS_ID:uint = Constants.tagList["DefineShape2"];

		// public override function get CLASS_NAME():String { return "DefineShape2"; }
		// public override function get CLASS_ID():uint { return Constants.tagList["DefineShape2"]; }

		// the constructor
		function DefineShape2(){
			shapeBounds = new Rect(0, 0, 0, 0);
		}
	}
}