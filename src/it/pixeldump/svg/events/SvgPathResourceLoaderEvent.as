
/**
 * @author jaco
 *
 * created on 5/9/2011 2:49:47 PM
 */

package it.pixeldump.svg.events {

	import flash.events.*;

	public class SvgPathResourceLoaderEvent extends Event {

		public static const RESOURCE_READY:String = "svgPathResourceLoaderResourceReady";

		public var data:Object;

		function SvgPathResourceLoaderEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {

			super(type);

			this.data = data;
		}

		public override function clone():Event {
			return new SvgPathResourceLoaderEvent (type, data, bubbles, cancelable);
		}

	} // end of class
} // end of pkg
