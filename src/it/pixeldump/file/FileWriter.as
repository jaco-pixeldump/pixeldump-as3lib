package it.pixeldump.file {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;


	public class FileWriter implements IEventDispatcher {

		public static const APP_DIR:String = "applicationDirectory";
		public static const APP_STORAGE_DIR:String = "applicationStorageDirectory";
		public static const USER_DIR:String = "userDirectory";
		public static const DESKTOP_DIR:String = "desktopDirectory";
		public static const DOCS_DIR:String = "documentsDirectory";

		public static const DEFAULT_FILEEXTENSION:String = "txt";

		private var _f:File;

		private var dispatcher:EventDispatcher;

		public function get file():File { return _f; }
		public function set file(v:File):void { _f = v; }

		public var fileExtension:String = DEFAULT_FILEEXTENSION;
		public var textContent:String = "";
		public var saveLabel:String = "save";

		public function set selectedPath(v:String):void {
			_f = File.documentsDirectory.resolvePath(v);
		}
		public function get selectedPath():String { return _f.nativePath; }

		public function get selectedFileExtension():String {
			return _f.extension;
		}

		/**
		 * the constructor
		 */
		public function FileWriter(ext:String) {
			dispatcher = new EventDispatcher(this);
			fileExtension = ext;
		}

		// ---------------- privs

		private function initPath(contentFileName:String):void {

			var cItems:Array = contentFileName.split(".");

			if(cItems[cItems.length - 1].toLowerCase() != fileExtension.toLowerCase()){
				contentFileName += "." +fileExtension;
			}

			_f = File.desktopDirectory.resolvePath("./" +contentFileName);

			if(!_f.hasEventListener(Event.SELECT)) _f.addEventListener(Event.SELECT, onContentFileSaveSelect);
		}

		// --------------- privates listeners
		private function onContentFileSaveSelect(evt:Event):void {
			dispatcher.dispatchEvent(new Event(Event.SELECT));

			//_f.removeEventListener(Event.SELECT, onContentFileSaveSelect);
			//writeTextContent(textContent);
		}

		// --------------- publics

		public function browseForSave(contentFileName:String):void {
			initPath(contentFileName);

			if(!saveLabel.length) saveLabel = "save " +fileExtension.toUpperCase() +" file:";

			_f.browseForSave(saveLabel);
		}

		// NOTE: let the filename without extension, set your preferred file extension before
		public function createFromPath(filePath:String, checkOverwrite:Boolean = true, basePath:String = APP_STORAGE_DIR):void {

			if(!fileExtension.length) fileExtension = DEFAULT_FILEEXTENSION;

			var fn:String = filePath +"." +fileExtension;

			if(basePath == APP_STORAGE_DIR) _f = File.applicationStorageDirectory.resolvePath(fn);
			else if(basePath == USER_DIR) _f = File.userDirectory.resolvePath(fn);
			else if(basePath == DESKTOP_DIR) _f = File.desktopDirectory.resolvePath(fn);
			else if(basePath == DOCS_DIR) _f = File.documentsDirectory.resolvePath(fn);

			//_f = File.applicationStorageDirectory.resolvePath(filePath +"." +fileExtension);

			if(_f.exists && checkOverwrite) return;
		}

		public function writeTextContent(txt:String = ""):void {

			if(!txt.length) txt = textContent;
			else textContent = txt;

			if(!textContent.length) return;

			var fs:FileStream = new FileStream();

			fs.open(_f, FileMode.WRITE);
			fs.writeUTFBytes(txt);
			fs.close();
		}

		public function writeBinaryContent(ba:ByteArray):void {

			var fs:FileStream = new FileStream();

			ba.position = 0;
			fs.open(_f, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
		}

		include "../includes/ieventdispatcher_implementors.as";

	} // end of class
} // end of pkg