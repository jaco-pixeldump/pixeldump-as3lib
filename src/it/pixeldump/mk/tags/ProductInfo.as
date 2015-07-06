
package it.pixeldump.mk.tags {

	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	import it.pixeldump.mk.*;
	import it.pixeldump.mk.struct.*;

	public class ProductInfo extends Tag {

		public var product:uint;			// UI32	??	Macromedia Flex for J2EE
		public var edition:uint;			// UI32	??	Developer Edition
		public var version:uint;			// UI16		2.0
		public var build:uint;				// UI64	??	155542
		public var compileDate:uint;		// UI54		03/05/07 19.55

		// the constructor
		function ProductInfo(){
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
