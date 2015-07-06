/**
 * @author jaco
 */
package it.pixeldump.svg {

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	/**
	 * load a converted svg font from fontforge or apache batik
	 * note: to load batik font please replace strip svg namespace
	 * namespace will be handled in the near future
	 */
	public class SvgLoader implements IEventDispatcher{

		public static const SVG_NAMESPACE:Namespace = new Namespace("http://www.w3.org/2000/svg");

		protected var resURL:String = "";
		protected var ul:URLLoader;
		protected var dispatcher:EventDispatcher;

		protected var _urlCache:Boolean = true;

		/**
		 * if set, appends a random queryString to ensure fresh data loading
		 */
		public function get urlCache():Boolean { return _urlCache; }
		public function set urlCache(v:Boolean):void { _urlCache = v; }


		/**
		 * the constructor
		 */
		public function SvgLoader() {

			ul = new URLLoader();
			ul.addEventListener(Event.COMPLETE, onULComplete);

			dispatcher = new EventDispatcher(this);
		}

		protected function loadData(resURL:String):void {

			this.resURL = resURL;

			var rnd:String = "";

			if(_urlCache){

				var pfx:String = resURL.indexOf("?") > -1 ? "" : "?";
				rnd = pfx +"a=" +getTimer() +Math.random();
				rnd = rnd.replace(/\./g, "");
			}

			var ur:URLRequest = new URLRequest(resURL +rnd);

			ul.load(ur);
		}

		protected function onULComplete(evt:Event):void {

			// override me

			dispatchEvent(new Event(Event.COMPLETE));
		}


		// interface implementor
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
	        dispatcher.addEventListener(type, listener, useCapture, priority);
	    }

	    public function dispatchEvent(evt:Event):Boolean{
	        return dispatcher.dispatchEvent(evt);
	    }

	    public function hasEventListener(type:String):Boolean{
	        return dispatcher.hasEventListener(type);
	    }

	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }

	    public function willTrigger(type:String):Boolean {
	        return dispatcher.willTrigger(type);
	    }
	}
}