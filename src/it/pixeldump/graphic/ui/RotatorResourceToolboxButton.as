package it.pixeldump.graphic.ui {

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class RotatorResourceToolboxButton extends BaseResourceToolboxButton {

		private var selectedState:Object;
		private var states:Vector.<Object> = new Vector.<Object>();
		private var overStates:Vector.<Object> = new Vector.<Object>();
		private var downStates:Vector.<Object> = new Vector.<Object>();

		public function set state(v:String):void {

			for each(var o:Object in states){

				if(o.name == v){
					selectedState = o;
					if(o.icon) o.icon.visible = true;
				}
				else if(o.icon) o.icon.visible = false;
			}
		}
		public function get state():String { return selectedState.name; }

		public function get nextState():String { return selectedState.next.name; }
		public function get backState():String { return selectedState.back.name; }

		/**
		 * the constructor
		 */
		public function RotatorResourceToolboxButton() {
			super();

			spot.addEventListener(MouseEvent.MOUSE_DOWN, onSpotDown);
			// spot.addEventListener(MouseEvent.MOUSE_UP, onSpotUp);
			spot.addEventListener(MouseEvent.MOUSE_OVER, onSpotOver);
			spot.addEventListener(MouseEvent.MOUSE_OUT, onSpotOut);
			spot.addEventListener(MouseEvent.CLICK, onSpotClick);
		}

		// -------------- privs

		private function setLowerIconIndex():void {

			var idx:int = 1000;
			var selectedState:Object = null;

			for each(var o:Object in states){

				if(o.index < idx){
					idx = o.index;
					selectedState = o;
				}
			}

			state = selectedState.name;
		}

		private function addState(xi:XML, stateGroup:Vector.<Object>):void {

			var o:Object = {};

			o.name = xi.@name;
			o.index = parseInt(xi.@index);
			o.icon = cacheBitmap ? createBitmapIconFromXml(xi) : createShapeIconFromXml(xi, true);
			o.icon.visible = false;
			stateGroup.push(o);
		}

		// -------------- listeners

		private function onSpotDown(evt:MouseEvent):void {

			var o:Object;

			for each(o in overStates) o.icon.visible = false;
			for each(o in downStates) {
				if(selectedState.name == o.name) {
					o.icon.visible = true;
					selectedState.icon.visible = false;
				}
				else o.icon.visible = false;
			}
		}

		private function onSpotUp(evt:MouseEvent):void {

			/*
			var o:Object;

			for each(o in overStates) o.icon.visible = false;
			for each(o in downStates) o.icon.visible = false;

			state = selectedState.name;
			*/
		}

		private function onSpotOver(evt:MouseEvent):void {

			var o:Object;

			for each(o in downStates) o.icon.visible = false;
			for each(o in overStates) {
				if(selectedState.name == o.name) {
					selectedState.icon.visible = false;
					o.icon.visible = true;
				}
				else o.icon.visible = false;
			}
		}

		private function onSpotOut(evt:MouseEvent):void {

			var o:Object;

			for each(o in overStates) o.icon.visible = false;
			for each(o in downStates) o.icon.visible = false;

			state = selectedState.name;
		}

		private function onSpotClick(evt:MouseEvent):void {

			var o:Object;

			for each(o in overStates) o.icon.visible = false;
			for each(o in downStates) o.icon.visible = false;

			selectNextState();
			dispatchEvent(new Event(Event.CHANGE));
		}

		// -------------- publics

		override public function clear():void {
			super.clear();

			states = new Vector.<Object>();
			overStates = new Vector.<Object>();
			downStates = new Vector.<Object>();
			selectedState = null;
		}

		override public function createFromXml(v:XML):void {

			if(v..skin[0].@componentTarget != "RotatorResourceToolboxButton") return;

			clear();
			skinXML = v;

			var o:Object = {};
			var xi:XML;

			for each(xi in v..attrib.(@name == "background")) createBackgroundFromXml(xi);
			for each(xi in v..attrib.(@name == "spotArea")) createSpotAreaFromXml(xi);
			for each(xi in v..upState[0]..state) addState(xi, states);

			if(v..overState.length()) for each(xi in v..overState[0]..state) addState(xi, overStates);
			if(v..downState.length()) for each(xi in v..downState[0]..state) addState(xi, downStates);

			var sLength:int = states.length;

			states[sLength - 1].next = states[0];
			states[0].back = states[sLength - 1];

			for(var i:int = 0, k:int = 1; i < sLength - 1; i++, k++)states[i].next = states[k];
			for(i = 1, k = 0; i < sLength; i++, k++) states[i].back = states[i - 1];

			setLowerIconIndex();
			updateSpotArea();
		}

		public function selectNextState():void { state = selectedState.next.name; }
		public function selectBackState():void { state = selectedState.back.name; }
	}
}