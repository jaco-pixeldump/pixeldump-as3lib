package it.pixeldump.tween {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import it.pixeldump.tween.events.TweenEvent;

	import org.penner.Easing;

    public class SliderFX implements IEventDispatcher{

		private var _reason:String = "";
		private var _c:Number = 0;
		private var _b:Number = 0;

		private var _d:int = 0;
		private var _easingIn:String = "easeOutExpo";
		private var _easingOut:String = "easeInExpo";
		private var _value:Number = 0;

		private var dispatcher:EventDispatcher;
		private var cnt:MovieClip = new MovieClip();
		private var t:int = 0;

		public function set reason(v:String):void {
			_reason = v;
		}
		public function get reason():String {
			return _reason;
		}

		public function set b(v:Number):void { _b = v; }
		public function get b():Number { return _b; }

		public function set c(v:Number):void { _c = v; }
		public function get c():Number { return _c; }

		public function set duration(v:int):void {
			_d = v;
		}
		public function get duration():int { return _d; }

		public function set easingIn(v:String):void {
			_easingIn = v;
		}

		public function set easingOut(v:String):void {
			_easingOut = v;
		}

		public function get value():Number { return _value; }

		/**
		 * the constructor
		 */
        public function SliderFX() {
			dispatcher = new EventDispatcher(this);
        }

		// ------------ privs
		// ------------ listeners

		private function onCntEnterFrame(evt:Event):void {

			var evtData:Object = {
				reason: _reason,
				step:t,
				progress: t / _d,
				trend: (_b > _c),
				value: _value
			}

			if(t < _d){
				_value = Easing[_easingIn](t, _b, _c, _d);
				evtData.value = _value;
				dispatcher.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_PROGRESS, evtData));
				t++;
				return;
			}

			evtData.progress = 1;

			stopAnimate();
			dispatcher.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_COMPLETE, evtData));
		}

		// ------------ publics

		public function startAnimate():void {
			stopAnimate();
			cnt.addEventListener(Event.ENTER_FRAME, onCntEnterFrame);
		}

		public function stopAnimate():void {
			cnt.removeEventListener(Event.ENTER_FRAME, onCntEnterFrame);
			t = 0;
		}

		// --- interface implementors
		include "../includes/ieventdispatcher_implementors.as";

    } // end of class
} // end of pkg
