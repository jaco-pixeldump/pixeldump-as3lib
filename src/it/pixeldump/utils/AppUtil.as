package it.pixeldump.utils {

	import flash.filesystem.File;
	import flash.text.TextField;

    public class AppUtil {

		private static var _fps:Number = 24;
		private static var _tf:TextField = new TextField();

		public static function set fps(v:Number):void {
			_fps = v;
		}
		public static function get fps():Number {
			return AppUtil._fps;
		}

		/**
		 * the constructor
		 */
        //public function AppUtil() {}

		public static function getTimeLabelInMinutes(numSeconds:int):String {

			var minutes:int = Math.floor(numSeconds / 60);
			var seconds:int = numSeconds - minutes * 60;
			var tm:String = StringUtil.strPad("" +minutes, "0", 2) +":" +StringUtil.strPad("" +seconds, "0", 2);

			return tm;
		}

		public static function getNumFramesFromDuration(v:Number):int {
			return Math.round((_fps / 1000) * v);
		}

		public static function getPlainText(v:String):String {
			_tf.htmlText = v;

			return _tf.text;
		}

		public static function getFileURLScheme(v:String = ".", baseDir:File = null):String {

			if(!baseDir) baseDir = File.applicationDirectory;

			var f:File = baseDir.resolvePath(v);
			var nu:String = f.nativePath;

			nu = nu.replace(/\\/g, "/");

			return "file:///" +encodeURI(nu);
		}

		public static function sanitizeFilePath(v:String):String {

			var invalidCStr:String = "<>:\"/|?*\t\n\r";
			var str:String = "";
			var sLength:int = v.length;

			for(var i:int = 0; i < sLength; i++){
				var ch:String = v.charAt(i);

				if(invalidCStr.indexOf(ch) > -1) ch = "";
				if(ch == " ") ch = "_";

				str += ch;
			}

			return str;
		}

	} // end of class
} // end of pkg
