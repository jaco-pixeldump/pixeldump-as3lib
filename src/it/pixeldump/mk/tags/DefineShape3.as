

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DefineShape3 extends DefineShape2 {

		public static const CLASS_NAME:String =  "DefineShape3";
		public static const CLASS_ID:uint = Constants.tagList["DefineShape3"];

		//public override function get CLASS_NAME():String{ return "DefineShape3"; }
		//public override function get CLASS_ID():uint { return Constants.tagList["DefineShape3"]; }

		// the constructor
		function DefineShape3(){
			shapeBounds = new Rect(0, 0, 0, 0);
		}
	}
}