package it.pixeldump.graphic.ui {

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import it.pixeldump.graphic.enums.GraphicLookups;
	import it.pixeldump.graphic.interfaces.IThemedUI;
	import it.pixeldump.graphic.resources.GraphicComposer;
	import it.pixeldump.graphic.vos.GraphicItemVO;
	import it.pixeldump.utils.StringUtil;

	public class BaseResourceToolboxButton extends Sprite implements IThemedUI {

		protected var background:Sprite = new Sprite();
		protected var backgroundCap:Sprite = new Sprite();
		protected var iconPlane:Sprite = new Sprite();
		protected var cap:Sprite = new Sprite();
		protected var spotShape:Shape = new Shape();
		protected var spot:SimpleButton = new SimpleButton();

		protected var skinXML:XML;
		protected var bounds:Rectangle = new Rectangle();
		protected var hasThemedSpotArea:Boolean = false;
		protected var cacheBitmap:Boolean = true;

		protected var _buttonWidth:Number = GraphicLookups.BUTTON_SIZE;
		protected var _buttonHeight:Number = GraphicLookups.BUTTON_SIZE;
		protected var _frameType:String = GraphicLookups.FRAME_CIRCLE;
		protected var _backgroundColor:uint = 0xffffff;
		protected var _backgroundCapColor:uint = 0x0;
		protected var _capColor:uint = 0xffffff;
		protected var _capOffset:Number = 0;
		protected var _frameColor:uint = 0x666666;
		protected var _frameWidth:Number = 2;

		protected var _enabled:Boolean = true;

		public function get buttonWidth():Number { return _buttonWidth; }
		public function get buttonHeight():Number { return _buttonHeight; }

		public function set enabled(v:Boolean):void {
			_enabled = v;
			spot.visible = v;
			backgroundCap.visible = false;
			cap.visible = !v;
		}
		public function get enabled():Boolean { return _enabled; }

		/**
		 * the constructor
		 */
		public function BaseResourceToolboxButton() {
			initUI();
		}

		// -------------- privs

		private function initUI():void {
			addChild(background);
			addChild(backgroundCap);
			addChild(iconPlane);
			addChild(cap);
			addChild(spot);

			cap.alpha = .5;
			cap.visible = false;

			backgroundCap.alpha = .2;
			backgroundCap.visible = false;

			spot.useHandCursor = false;
			spot.hitTestState = spotShape;

			// debug purpose
			//spotShape.alpha = .3;
			//spot.upState = spotShape;

			if(skinXML) createFromXml(skinXML);
		}

		protected function createSpotAreaFromXml(v:XML):void {

			var p:Object = {};

			p.refs = [];

			for each(var xi:XML in v..param){

				switch(xi.@name.toString()){
					case "width":
						p.width = parseFloat(xi.@value);
						break;

					case "height":
						p.height = parseFloat(xi.@value);
						break;

					case "frameType":
						p.frameType = xi.@value;
						break;
				}
			}

			for each(var xj:XML in v..graphicRes) {
				trace(xj);
				p.refs.push(xj.@id);
			}

			redrawThemedSpotArea(p);
		}

		protected function createBackgroundFromXml(v:XML):void {

			for each(var xi:XML in v..param){

				switch(xi.@name.toString()){

					case "width":
						_buttonWidth = parseFloat(xi.@value);
						bounds.width = _buttonWidth;
						break;
					case "height":
						_buttonHeight = parseFloat(xi.@value);
						bounds.height = _buttonHeight;
						break;
					case "visible":
						background.visible = xi.@value == "false" ? false : true;
						break;
					case "frameType":
						_frameType = xi.@value;
						break;
					case "color":
						_backgroundColor = StringUtil.fromColorString(xi.@value);
						break;
					case "backgroundCapColor":
						_backgroundCapColor = StringUtil.fromColorString(xi.@value);
						break;
					case "backgroundCapAlpha":
						backgroundCap.alpha = parseFloat(xi.@value);
						break;
					case "capColor":
						_capColor = StringUtil.fromColorString(xi.@value);
						break;
					case "capAlpha":
						cap.alpha = parseFloat(xi.@value);;
						break;
					case "capOffset":
						_capOffset = parseFloat(xi.@value);;
						break;
					case "frameColor":
						_frameColor = StringUtil.fromColorString(xi.@value);
						break;
					case "frameWidth":
						_frameWidth = parseFloat(xi.@value);
						break;
				}
			}

			redrawBackground();
		}

		protected function createShapeIconFromXml(v:XML, addToPlane:Boolean = false):Shape {
			var k:int = 0;
			var icon:Shape = new Shape();
			var ids:Array = [];

			for each(var xi:XML in v..graphicRes) ids.push(xi.@id);

			GraphicComposer.drawGraphicsByItemIds(icon.graphics, ids);

			if(addToPlane) iconPlane.addChild(icon);

			return icon;
		}

		protected function createBitmapIconFromXml(v:XML):Bitmap {

			var icon:Shape = createShapeIconFromXml(v);
			var bmpIcon:Bitmap = GraphicComposer.createBitmap(icon, bounds);

			iconPlane.addChild(bmpIcon);

			return bmpIcon;
		}

		protected function redrawThemedSpotArea(params:Object):void {
			hasThemedSpotArea = true;

			var p:Point = new Point();

			if(params.frameType == GraphicLookups.FRAME_RECT){
				p.x = _buttonWidth - params.width >> 1;
				p.y = _buttonHeight - params.height >> 1;
				GraphicComposer.drawRect(spotShape, params.width, params.height, 0x0, true, p);
			}
			else if(params.frameType == GraphicLookups.FRAME_CIRCLE){
				p.x = _buttonWidth >> 1;
				p.y = _buttonHeight >> 1;
				params.radius = params.width / 2;
				GraphicComposer.drawCircle(spotShape, params.radius, 0x0, true, p);
			}
			else if(params.frameType == GraphicLookups.FRAME_CUSTOM){
				GraphicComposer.drawGraphicsByItemIds(spotShape.graphics, params.refs);
			}
		}

		protected function redrawBackground():void {

			var p:Point = new Point();
			var spFrame:Shape = new Shape();
			var bSize:Number = Math.max(_buttonWidth, _buttonHeight);

			var bckContainer:Shape = new Shape();
			var bckCapContainer:Shape = new Shape();
			var capContainer:Shape = new Shape();

			var capSize:Number = bSize + (_capOffset * 2);

			if(_frameType == GraphicLookups.FRAME_RECT){

				var cOffset:Point = new Point(-_capOffset, -_capOffset);

				GraphicComposer.drawRect(bckCapContainer, capSize, capSize, _backgroundCapColor, true, cOffset);
				GraphicComposer.drawRect(capContainer, capSize, capSize, _capColor, true, cOffset);

				if(_frameWidth > 0){
					GraphicComposer.drawRect(bckContainer, bSize, bSize, _frameColor, false, p);
					p = new Point(_frameWidth, _frameWidth);
					bSize -= _frameWidth * 2;
				}

				GraphicComposer.drawRect(bckContainer, bSize, bSize, _backgroundColor, false, p);
			}
			else if(_frameType == GraphicLookups.FRAME_CIRCLE){
				p = new Point(bSize / 2, bSize / 2);
				capSize = bSize / 2 + _capOffset;
				GraphicComposer.drawCircle(bckCapContainer, capSize, _backgroundCapColor, true, p);
				GraphicComposer.drawCircle(capContainer, capSize, _capColor, true, p);

				if(_frameWidth > 0) {
					GraphicComposer.drawCircle(bckContainer, bSize / 2, _frameColor, false, p);
					bSize -= _frameWidth * 2;
				}

				GraphicComposer.drawCircle(bckContainer, bSize / 2, _backgroundColor, false, p);
			}
			else if(_frameType == GraphicLookups.FRAME_CUSTOM && skinXML) {

				var pxl:XMLList = skinXML..param.(@name == "frameType");

				if(pxl.length() && pxl[0]..graphicRes.length()) {

					for each(var xi:XML in pxl[0]..graphicRes){

						var gi:GraphicItemVO = GraphicComposer.createGraphicItemById(xi.@id);

						GraphicComposer.drawGraphicItem(bckContainer.graphics, gi);

						gi.graphicData.fillColor = _backgroundCapColor;
						GraphicComposer.drawGraphicItem(bckCapContainer.graphics, gi);

						gi.graphicData.fillColor = _capColor;
						GraphicComposer.drawGraphicItem(capContainer.graphics, gi);
					}
				}
			}

			if(cacheBitmap) {

				if(background.visible) GraphicComposer.cacheBitmap(background, bckContainer, bounds);

				GraphicComposer.cacheBitmap(backgroundCap, bckCapContainer, bounds);
				GraphicComposer.cacheBitmap(cap, capContainer, bounds);
			}
			else {

				if(background.visible) background.addChild(bckContainer);

				backgroundCap.addChild(bckCapContainer);
				cap.addChild(capContainer);
			}
		}

		protected function updateSpotArea():void {

			if(!hasThemedSpotArea) GraphicComposer.drawRect(spotShape, _buttonWidth, _buttonHeight);
		}

		// -------------- listeners
		// -------------- publics

		public function clear():void {
			iconPlane.removeChildren();
			background.graphics.clear();
			backgroundCap.graphics.clear();
			cap.graphics.clear();
			backgroundCap.visible = false;
			cap.visible = false;
			hasThemedSpotArea = false;
		}

		public function createFromXml(v:XML):void {
			// interface implementor, mandatory inheritance
		}
	}
}