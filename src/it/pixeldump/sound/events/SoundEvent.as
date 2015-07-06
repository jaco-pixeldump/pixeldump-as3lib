/**
 * @author jaco
 *
 * created on 7/3/2011 11:48:37 PM
 */

package it.pixeldump.sound.events {

	import flash.events.Event;

	public class SoundEvent extends Event {

		public static const SOUND_READY:String = "soundEventSoundReady";

		public var data:Object;

		function SoundEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {

			super(type);

			this.data = data;
		}

		public override function clone():Event {
			return new SoundEvent (type, data, bubbles, cancelable);
		}

	} // end of class
} // end of pkg
