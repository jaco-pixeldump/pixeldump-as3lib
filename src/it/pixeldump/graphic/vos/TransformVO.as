package it.pixeldump.graphic.vos {

	public class TransformVO {

		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;

		public function set xml(v:XML):void {

			scaleX = parseFloat(v.@scaleX);
			scaleY = parseFloat(v.@scaleY);
			rotation = parseFloat(v.@rotation);
			x = parseFloat(v.@x);
			y = parseFloat(v.@y);
		}

		/**
		 * the constructor
		 */
		public function TransformVO(){
		}

		public function reset():void {
			x = 0; y = 0;
			rotation = 0;
			scaleX = 1; scaleY = 1;
		}

		public function clone():TransformVO {

			var t:TransformVO = new TransformVO();
			t.scaleX = scaleX;
			t.scaleY = scaleY;
			t.rotation = t.rotation;
			t.x = x;
			t.y = y;

			return t;
		}

		public function toString():String {

			var str:String = "transformVO:";

			str += "\n\tx: "				+x;
			str += "\n\ty: "				+y;
			str += "\n\trotation: "			+rotation;
			str += "\n\tscaleX: "			+scaleX;
			str += "\n\tscaleY: "			+scaleY;

			return str;
		}

		public function toXmlNodeString():String {

			var xmlStr:String = "<transform ";

			xmlStr += "x=\""				+x +"\" ";
			xmlStr += "y=\""				+y +"\" ";
			xmlStr += "scaleX=\""			+scaleX +"\" ";
			xmlStr += "scaleY=\""			+scaleY +"\" ";
			xmlStr += "rotation=\""			+rotation +"\" ";

			xmlStr += "/>";

			return xmlStr;
		}
	}
}