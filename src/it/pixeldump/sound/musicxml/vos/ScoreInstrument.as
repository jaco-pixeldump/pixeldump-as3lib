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


	public class ScoreInstrument {

		public var id:String;
	  	public var instrumentName:String;

		function ScoreInstrument(id:String, instrumentName:String){

			this.id = id;
			this.instrumentName = instrumentName;
		}
	}
}
