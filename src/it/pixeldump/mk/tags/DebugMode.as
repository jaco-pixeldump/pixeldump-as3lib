
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class DebugMode extends Tag {

		/* UNKNOWN TAG */

		// the constructor
		function DebugMode(){
		}


		public override function toByteArray():ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;

			/* TODO */

			return ba;
		}

		public override function fromByteArray(ba:ByteArray):void {

			/* TODO */
			super.fromByteArray(ba);

		}
	}
}
