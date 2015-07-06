/**
 * @author jaco
 */

package it.pixeldump.sound.vos {

	import it.pixeldump.sound.utils.SoundUtil;

	public class NoteInfoVO {

		public var sourceFileName:String;
		public var baseNote:String;
		public var lowerNote:String;
		public var upperNote:String;
		public var numChannels:uint = 0;
		public var soundRate:uint = 0;
		public var interpolationType:String = "";

		public function get noteRange():uint {
			return SoundUtil.getNoteRange(lowerNote, upperNote);
		}

		/**
		 *
		 */
		function NoteInfoVO(sourceFileName:String = "", baseNote:String = "", lowerNote:String = "", upperNote:String = "") {

			this.sourceFileName = sourceFileName;
			this.baseNote = baseNote;
			this.lowerNote = lowerNote;
			this.upperNote = upperNote;

			if(this.baseNote.length){
				if(!this.lowerNote.length) this.lowerNote = this.baseNote;
				if(!this.upperNote.length) this.upperNote = this.baseNote;
			}
		}

		public function fromXML(xmlNote:XML):void {

			sourceFileName = xmlNote.@fileName;
			baseNote = xmlNote.@baseNote.toUpperCase();
			lowerNote = xmlNote.@lowerNote.toUpperCase();
			upperNote = xmlNote.@upperNote.toUpperCase();
		}

		public function toString(tabLevel:int = 0):String {

			var pfx:String = "\n";

			for(var i:int = 0; i < tabLevel; i++) pfx += "\t";

			var str:String = "noteInfo:";
			str += pfx +"sourceFileName: " +sourceFileName;
			str += pfx +"baseNote: " +baseNote;
			str += pfx +"lowerNote: " +lowerNote;
			str += pfx +"upperNote: " +upperNote;

			return str;
		}
	}

}