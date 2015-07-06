/**
 * @package musicxml library
 * @author jaco_at_pixeldump
 * @description part of lib
 *
 * NOTE: this is a draft stage, much work has to be done
 * If you plan to use this stuff, don't strip this header!
 * released under gpl v.2 - http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */
package it.pixeldump.sound.musicxml.vos {

	import it.pixeldump.sound.musicxml.vos.*;

	public class Note {

		public static const TYPE_WHOLE:String = "whole";	 // semibreve
		public static const TYPE_HALF:String = "half";		 // minima
		public static const TYPE_QUARTER:String = "quarter"; // semiminima
		public static const TYPE_EIGTH:String = "eighth";	 // croma
		public static const TYPE_16TH:String = "16th";	 	 // semicroma
		public static const TYPE_32TH:String = "32th";	 	 // biscroma
		public static const TYPE_64TH:String = "64th";	 	 // semibiscroma

		public static const ACCIDENTAL_SHARP:String = "sharp";		// diesis
		public static const ACCIDENTAL_FLAT:String = "flat";		// bemolle
		public static const ACCIDENTAL_NATURAL:String = "natural";	// bequadro

		public static const STEM_UP:String = "up";
		public static const STEM_DOWN:String = "down";

		public var pitch:Pitch;
		public var duration:int;		//
		public var voice:int;			//
		public var type:String;			//
		public var accidental:String;	// optional
		public var stem:String;			// optional

		function Note(pitch:Pitch, duration:int, voice:int, type:String){
			this.pitch = pitch;
			this.duration = duration;
			this.voice = voice;
			this.type = type;
			this.accidental = accidental;
		}
	}
}

