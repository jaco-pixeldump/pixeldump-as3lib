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


	public class ScorePart {

		public var id:String;
	  	public var partName:String;
		public var scoreInstrument:ScoreInstrument;
		public var midiInstrument:MidiInstrument;

		function ScorePart(id:String, partName:String,
						   scoreInstruments:ScoreInstrument,
						   midiInstruments:MidiInstrument){

			this.id = id;
			this.partName = partName;
			this.scoreInstrument = scoreInstrument;
			this.midiInstrument = midiInstrument;
		}
	}
}
