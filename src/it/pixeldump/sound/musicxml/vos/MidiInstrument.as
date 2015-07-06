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


	public class MidiInstrument {

		public var id:String;
	  	public var midiChannel:int;
  		public var midiProgram:int;

		function MidiInstrument(id:String, midiChannel:int, midiProgram:int){

			this.id = id;
			this.midiChannel = midiChannel;
			this.midiProgram = midiProgram;
		}
	}
}
