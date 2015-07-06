
// ------------------- IEventDispatcher implementors -- dispatcher MUST be defined in relevant class

public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean = false):void {
	dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
}

public function dispatchEvent(event:Event):Boolean {
	return dispatcher.dispatchEvent(event);
}

public function hasEventListener(type:String):Boolean {
	return dispatcher.hasEventListener(type);
}

public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
	dispatcher.removeEventListener(type, listener, useCapture);
}

public function willTrigger(type:String):Boolean {
	return dispatcher.willTrigger(type);
}
