package it.pixeldump.file {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	public class FileLoader implements IEventDispatcher {

		public static const APP_DIR:String = "applicationDirectory";
		public static const APP_STORAGE_DIR:String = "applicationStorageDirectory";
		public static const USER_DIR:String = "userDirectory";
		public static const DESKTOP_DIR:String = "desktopDirectory";
		public static const DOCS_DIR:String = "documentsDirectory";

		public var openLabel:String = "Open";
		public var fileFilterLabel:String = "supported files";

		private var dispatcher:EventDispatcher;
		private var f:File;

		private var onlyForSelection:Boolean = false;
		private var fileTypes:Array = new Array();
		private var binaryFileTypes:Array = new Array();
		private var _data:ByteArray;
		private var _text:String = "";

		public function get fileExtension():String {
			if(!f.nativePath || !f.nativePath.length) return "";

			return f.nativePath.substring(f.nativePath.lastIndexOf(".") + 1);
		}

		public function get text():String { return _text; }
		public function get data():ByteArray { return _data; }

		public function get fileName():String {

			if(!f) return "";

			return f.url.substring(f.url.lastIndexOf("/") + 1);
		}

		public function get nativePath():String { return f ? f.nativePath : ""; }
		public function get url():String { return f.url; }

		public function FileLoader() {
			dispatcher = new EventDispatcher(this);
		}


		private function getCurrentFile(filePath:String, basePath:String = "applicationDirectory"):File {

			if(basePath == APP_DIR) f = File.applicationDirectory.resolvePath(filePath);
			else if(basePath == APP_STORAGE_DIR) f = File.applicationStorageDirectory.resolvePath(filePath);
			else if(basePath == USER_DIR) f = File.userDirectory.resolvePath(filePath);
			else if(basePath == DESKTOP_DIR) f = File.desktopDirectory.resolvePath(filePath);
			else if(basePath == DOCS_DIR) f = File.documentsDirectory.resolvePath(filePath);

			return f;
		}

		// --------------- events

		private function onFileLoaded(evt:Event):void {
			_data = new ByteArray();

			var fs:FileStream = evt.currentTarget as FileStream;

			if(binaryFileTypes.indexOf(f.extension) > -1) {
				fs.readBytes(_data);
			}
			else {
				_text = fs.readUTFBytes(fs.bytesAvailable);
			}

			fs.close();
			_data.position = 0;

			if(hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onFileSelected(evt:Event):void {

			evt.currentTarget.addEventListener(Event.SELECT, onFileSelected);

			if(onlyForSelection) {
				dispatchEvent(new Event(Event.SELECT));
				return;
			}

			evt.currentTarget.removeEventListener(Event.SELECT, onFileSelected);

			var fs:FileStream = new FileStream();

			fs.addEventListener(Event.COMPLETE, onFileLoaded);
			fs.openAsync(f, FileMode.READ);
		}
		// --------------- public methods

		public function checkPath(filePath:String, basePath:String = "applicationDirectory"):Boolean {
			var f:File = getCurrentFile(filePath, basePath);

			return f.exists;
		}

		public function resetFileTypes():void {
			fileTypes = new Array();
			binaryFileTypes = new Array();
		}

		public function addFileType(v:String, bin:Boolean = false):void {
			v = v.toLowerCase();

			if(fileTypes.indexOf(v) == -1) {
				fileTypes.push(v);

				if(bin) binaryFileTypes.push(v);
			}
		}

		public function addExtensionByPath(filePath:String, bin:Boolean = false):void {
			var ext:String = filePath.substring(filePath.lastIndexOf(".") + 1);
			addFileType(ext, bin);
		}

		public function getFileContent(filePath:String, basePath:String = "applicationDirectory"):void {

			var f:File = getCurrentFile(filePath, basePath);

			if(!f.exists){
				trace("ERROR: invalid path:", f.nativePath);
				return;
			}

			var fs:FileStream = new FileStream();

			fs.addEventListener(Event.COMPLETE, onFileLoaded);
			fs.openAsync(f, FileMode.READ);
		}

		public function browseForOpen(onlyForSelection:Boolean = false):void {

			this.onlyForSelection = onlyForSelection;

			var ft:String = "";

			if(!fileTypes.length) {
				if(!onlyForSelection) return; // no file to browse

				ft = "*." +s +";";
			}
			else {
				for each(var s:String in fileTypes) ft += "*." +s +";";

				ft = ft.substring(0, ft.length - 1);
			}

			var ff:FileFilter = new FileFilter(fileFilterLabel +":", ft);

			f = new File();
			f.browseForOpen(openLabel, [ff]);

			f.addEventListener(Event.SELECT, onFileSelected);
		}

		include "../includes/ieventdispatcher_implementors.as";
	} // end of class
} // end of pkg