package it.pixeldump.graphic.resources {

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;

	import it.pixeldump.graphic.enums.GraphicLookups;

	public class BaseButtonComposer {

		public static const BUTTON_SIZE:Number = 32;

		protected var _backgroundColor:uint = 0xFFFFFF;
		protected var _frameColor:uint = 0x666666;
		protected var _frameWidth:Number = 1;
		protected var _button:SimpleButton;
		protected var _iconScale:Number = .75;
		protected var _toggle:Boolean = false;

		protected var frameType:String = GraphicLookups.FRAME_RECT;

		protected var sp:Sprite = new Sprite();
		protected var spBase:Sprite = new Sprite();
		protected var spIcon:Sprite = new Sprite();
		protected var spToggle:Sprite = new Sprite();

		public function set backgroundColor(v:uint):void {
			_backgroundColor = v;
			redrawBackground();
		}
		public function get backgroundColor():uint { return _backgroundColor; }

		public function set frameColor(v:uint):void {
			_frameColor = v;
			redrawBackground();
		}
		public function get frameColor():uint { return _frameColor; }

		public function set frameWidth(v:Number):void {
			_frameWidth = v;
			redrawBackground();
		}
		public function get frameWidth():Number { return _frameWidth; }

		public function set iconScale(v:Number):void {
			_iconScale = v;
			spIcon.scaleX = spIcon.scaleY = v;
			spToggle.scaleX = spToggle.scaleY = v;

			var ofst:Number = (BUTTON_SIZE - (_iconScale * BUTTON_SIZE)) / 2;

			spIcon.x = spIcon.y = ofst;
			spToggle.x = spToggle.y = ofst;
		}
		public function get iconScale():Number { return _iconScale; }

		public function set toggle(v:Boolean):void {
			_toggle = v;
			spIcon.visible = !v;
			spToggle.visible = v;
		}
		public function get toggle():Boolean { return _toggle; }

		public function set enabled(v:Boolean):void {
			_button.enabled = v;
		}
		public function get enabled():Boolean { return _button.enabled; }

		/**
		 * the constructor
		 */
		public function BaseButtonComposer() {
		}

		protected function initUI():void {

			var spHit:Shape = new Shape();

			GraphicComposer.drawRect(spHit, BUTTON_SIZE, BUTTON_SIZE);

			_button.hitTestState = spHit;

			redrawBackground();

			sp.addChild(spBase);
			sp.addChild(spIcon);
			sp.addChild(spToggle);

			spToggle.visible = false;
			iconScale = _iconScale;

			_button.upState = sp;
			_button.overState = sp;
			_button.downState = sp;

			_button.addEventListener(MouseEvent.MOUSE_OVER,
				function():void {
					_button.alpha = .5;
				});

			_button.addEventListener(MouseEvent.MOUSE_OUT,
				function():void {
					_button.alpha = 1;
				});

			_button.addEventListener(MouseEvent.MOUSE_UP,
				function():void {
					_button.alpha = 1;
				});
		}

		protected function redrawBackground():void {

			var p:Point = new Point();
			var spFrame:Shape = new Shape();
			var bSize:Number = BUTTON_SIZE;

			spBase.removeChildren();
			spBase.addChild(spFrame);

			if(frameType == GraphicLookups.FRAME_RECT){

				if(_frameWidth > 0){
					GraphicComposer.drawRect(spFrame, bSize, bSize, _frameColor, false, p);
					p = new Point(_frameWidth, _frameWidth);
					bSize -= _frameWidth * 2;
				}

				GraphicComposer.drawRect(spFrame, bSize, bSize, _backgroundColor, false, p);
			}
			else if(frameType == GraphicLookups.FRAME_CIRCLE){
				p = new Point(bSize / 2, bSize / 2);

				if(_frameWidth > 0) {
					GraphicComposer.drawCircle(spFrame, bSize / 2, _frameColor, false, p);
					bSize -= _frameWidth * 2;
				}

				GraphicComposer.drawCircle(spFrame, bSize / 2, _backgroundColor, false, p);
			}
		}

		protected function setIcons():void {
			trace("base class: override this");
		}

		// --------------- publics

		public function createCustomBaseGraphics(g:Graphics):void {
			frameType = GraphicLookups.FRAME_CUSTOM;
			_frameWidth = 0;

			var spFrame:Shape = new Shape();

			spBase.removeChildren();
			spBase.addChild(spFrame);
			spFrame.graphics.copyFrom(g);
		}
	}
}