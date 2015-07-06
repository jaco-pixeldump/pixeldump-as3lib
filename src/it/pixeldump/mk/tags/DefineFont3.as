/**
 * @author jaco
 */

package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.geom.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;


	public class DefineFont3 extends DefineFont2 {

		public override function get CLASS_NAME():String { return "DefineFont3"; }
		public override function get CLASS_ID():uint { return Constants.tagList["DefineFont3"]; }


		function DefineFont3() {

		}

		//public override function fromByteArray(ba:ByteArray):void{

		//	trace("font from byte array");
		//	ba.position = 0;
		//	super.fromByteArray(ba);
		//	ba.position = 6;

			/* TODO */
		//}

	}
}