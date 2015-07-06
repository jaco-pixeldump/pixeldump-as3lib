package it.pixeldump.tween.events {

	import flash.events.Event;

	public class TweenEvent extends Event {

		public static const TWEEN_PROGRESS:String = "tweenProgress";
		public static const TWEEN_COMPLETE:String = "tweenComplete";

		public var data:*;

		/**
		 * the constructor
		 */
		public function TweenEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}

		public override function clone():Event {
			return new TweenEvent (type, data, bubbles, cancelable);
		}
	}
}