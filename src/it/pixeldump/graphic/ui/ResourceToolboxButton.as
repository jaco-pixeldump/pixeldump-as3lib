package it.pixeldump.graphic.ui {
	import flash.events.MouseEvent;

	public class ResourceToolboxButton extends BaseResourceToolboxButton {

		private var _toggle:Boolean = false;

		private var selectedState:Object;

		private var states:Object = {
			upState: {name:"upState", enabled:false, toggleBackground:false},
			downState: {name:"downState", enabled:false, toggleBackground:false},
			overState: {name:"overState", enabled:false, toggleBackground:false},

			toggleUpState: {name:"toggleUpState", enabled:false, toggleBackground:false},
			toggleDownState: {name:"toggleDownState", enabled:false, toggleBackground:false},
			toggleOverState: {name:"toggleOverState", enabled:false, toggleBackground:false}
		};

		private var stateNames:Array = [
			"upState", "downState", "overState",
			"toggleUpState", "toggleDownState", "toggleOverState"
		];

		private function set state(v:String):void{

			for each(var o:Object in states) {
				if(o.icon) o.icon.visible = false;
			}

			if(states[v].icon) {
				states[v].icon.visible = true;
				selectedState = states[v];
				background.visible = !selectedState.toggleBackground;
			}
			else background.visible = true;
		}

		public function set toggle(v:Boolean):void {
			if(!isButtonToggle()) return;

			_toggle = v;
			state = v ? states.toggleUpState.name : states.upState.name;
		}
		public function get toggle():Boolean { return _toggle; }

		/**
		 * the constructor
		 */
		public function ResourceToolboxButton() {
			super();

			addListeners();
		}

		// -------------- privs

		private function addListeners():void {
			spot.addEventListener(MouseEvent.MOUSE_OVER, onSpotMouseOver);
			spot.addEventListener(MouseEvent.MOUSE_OUT, onSpotMouseOut);
			spot.addEventListener(MouseEvent.MOUSE_DOWN, onSpotMouseDown);
			spot.addEventListener(MouseEvent.MOUSE_UP, onSpotMouseUp);
		}

		// -------------- listeners

		private function onSpotMouseOver(evt:MouseEvent):void {
			if(_toggle && states.toggleOverState.enabled) state = states.toggleOverState.name;
			else if(states.overState.enabled) state = states.overState.name;
		}

		private function onSpotMouseOut(evt:MouseEvent):void {
			if(_toggle && states.toggleUpState.enabled) state = states.toggleUpState.name;
			else if(states.upState.enabled) state = states.upState.name;
		}

		private function onSpotMouseDown(evt:MouseEvent):void {
			if(_toggle && states.toggleDownState.enabled) state = states.toggleDownState.name;
			else if(states.downState.enabled) state = states.downState.name;
		}

		private function onSpotMouseUp(evt:MouseEvent):void {
			if(_toggle && states.toggleUpState.enabled) state = states.toggleUpState.name;
			else if(states.upState.enabled) state = states.upState.name;
		}

		// -------------- publics

		override public function createFromXml(v:XML):void {

			var xa:XML = v..skin[0];

			if(xa.@componentTarget != "ResourceToolboxButton") return;
			if(xa.hasOwnProperty("@cacheBitmap")) cacheBitmap = xa.@cacheBitmap == "true" ? true : false;

			clear();
			skinXML = v;

			var xi:XML;

			for each(xi in v..attrib.(@name == "background")) createBackgroundFromXml(xi);
			for each(xi in v..attrib.(@name == "spotArea")) createSpotAreaFromXml(xi);

			for each(xi in v..state){

				var sName:String = xi.@name.toString();

				if(stateNames.indexOf(sName) == -1) continue;

				states[sName].enabled = true;
				states[sName].icon = cacheBitmap ? createBitmapIconFromXml(xi) : createShapeIconFromXml(xi, true);

				if(xi.hasOwnProperty("@toggleBackground")) {
					states[sName].toggleBackground = xi.@toggleBackground == "true" ? true : false;
				}
			}

			updateSpotArea();

			if(states.upState.enabled) state = states.upState.name;
		}

		public function isButtonToggle():Boolean { return states.toggleUpState.enabled; }
	}
}