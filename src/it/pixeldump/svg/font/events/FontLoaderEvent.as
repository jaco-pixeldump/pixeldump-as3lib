
/**
 * @author jaco
 */

package it.pixeldump.svg.font.events {

	import flash.events.Event;

	public class FontLoaderEvent extends Event{

		// events constants
		public static const FONT_READY:String = "svgFontReady";


		function FontLoaderEvent (eventType:String, bubbles:Boolean = false, cancelable:Boolean = false) {

			super(eventType, true);
		}

		public override function clone():Event {

			return new FontLoaderEvent(type, bubbles, cancelable);

		}
	}
}